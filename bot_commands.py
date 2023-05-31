import pyodbc
import requests
import json
import pandas as pd
import asyncio
import time
from tabulate import tabulate
from sqlalchemy import create_engine, text

connection_string = "DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=daoctracking;trusted_connection=yes"
conn = pyodbc.connect(connection_string)
rank_query = 'select * from realmranks'
realmrank_table = pd.read_sql(rank_query, conn)

server = 'localhost'
database = 'daoctracking'
username = 'RealmBotSvc'
password = 'Password1'

def char_search(charname):
    url = f'https://api.camelotherald.com/character/search?cluster=Ywain&name={charname}'
    response = requests.get(url)
    response_text = response.text
    response_json = json.loads(response_text)
    return response_json

def character_info(char_id):
    url = f'https://api.camelotherald.com/character/info/{char_id}'
    response = requests.get(url)
    response_text = response.text
    response_json = json.loads(response_text)
    return response_json

def guild_info(guild_id):
    url = f'https://api.camelotherald.com/guild/info/{guild_id}'
    response = requests.get(url)
    response_text = response.text
    response_json = json.loads(response_text)
    return response_json

async def import_character(char_id):
    json_data =character_info(char_id)
    cursor  = conn.cursor()

    # Extract relevant fields from JSON data
    character_web_id = json_data["character_web_id"]
    name = json_data["name"]
    firstname = name.split(" ")[0]
    server_name = json_data["server_name"]
    archived = json_data["archived"]
    realm = json_data["realm"]
    race = json_data["race"]
    class_name = json_data["class_name"]
    level = json_data["level"]
    last_on_range = json_data["last_on_range"]
    realm_points = json_data["realm_war_stats"]["current"]["realm_points"]
    guild_rank = json_data["guild_info"]["guild_rank"] if "guild_info" in json_data else None
    guild_web_id = json_data["guild_info"]["guild_web_id"] if "guild_info" in json_data else None
    guild_name = json_data["guild_info"]["guild_name"] if "guild_info" in json_data else None
    watchlistflag = 0
    # Insert data into the table
    cursor.execute("EXEC [dbo].[CreateCharacter] @character_web_id =?, @name =?, @firstname =?, @server_name =?, @archived =?, @realm =?, @race =?, @class_name =?, @level =?, @last_on_range =?, @realm_points =?, @guild_rank =?, @guild_web_id =?, @watchlistflag =?", character_web_id, name, firstname, server_name, archived, realm, race, class_name, level, last_on_range, realm_points, guild_rank, guild_web_id, watchlistflag)

    conn.commit()

    # Close the connection
    cursor.close()

def get_realm_rank(json_data, realm_rank=None):
    character_info = json_data['results'][0]
    #char_id = character_info['character_web_id']
    char_name = character_info['name']
    realm_points = character_info['realm_points']

    if realm_rank is None:        
        
        filtered_table = realmrank_table[realmrank_table['realmpoints'] > realm_points]
        first_row = filtered_table.iloc[0]
        realm_points_needed = first_row['realmpoints']
        realm_rank = first_row['realmrank']
        formated_rps = format(realm_points_needed - realm_points, ",")
        s = char_name + ' needs ' + formated_rps + ' realm points for ' + realm_rank

    else:
        filtered_table = realmrank_table[realmrank_table['realmrank'] == str(realm_rank).upper()]
        first_row = filtered_table.iloc[0]
        
        realm_points_needed = first_row['realmpoints']
        formated_rps = format(realm_points_needed - realm_points, ",")
        s = char_name + ' needs ' + formated_rps + ' realm points for ' + realm_rank
    
    return s
    

async def import_guild(guild_web_id, guild_name):

    cursor  = conn.cursor()
    importedflag = 0

    # Insert data into the table
    cursor.execute("EXEC [dbo].[CreateGuild] @guild_web_id=?, @guildname=?, @importedflag=?", guild_web_id, guild_name, importedflag)
    conn.commit()
    
    # Close the connection
    cursor.close()
    

async def import_alliance_guilds(guild_web_id):

    json_data = guild_info(guild_web_id)
    
    if "alliance" in json_data:
        guild_web_id = json_data['alliance']['alliance_leader']['guild_web_id']
        guild_name = json_data['alliance']['alliance_leader']['name']
        await import_guild(guild_web_id, guild_name)

        guild_web_id = ''
        guild_name = ''
    
        alliance_members = json_data['alliance']['alliance_members']

        for member in alliance_members:
            guild_web_id = member['guild_web_id']
            guild_name = member['name']
            await import_guild(guild_web_id, guild_name)

async def run_imports(char_id,guild_web_id,guild_name):
    char_import = asyncio.create_task(import_character(char_id))
    guild_import = asyncio.create_task(import_guild(guild_web_id, guild_name))
    alliance_import = asyncio.create_task(import_alliance_guilds(guild_web_id))    
    await asyncio.gather(char_import, guild_import,alliance_import)

def link_character(char_table):  

    json_data = char_table.to_json(orient='records')    
    
    cursor = conn.cursor()
    cursor.execute("EXEC [dbo].[CreateCharacterLink] @json_data=?", json_data)
    conn.commit()

def who_command(charname): 
    
    response_json = char_search(charname)

    character_info = response_json['results'][0]
    char_id = character_info['character_web_id']
    char_name = character_info['name']
    realm_points = character_info['realm_points']
    guild_web_id = ''
    guild_name= ''
    
    
    line1 = 'Name: ' + character_info['name']
    line2 = 'Race: ' + character_info['race']
    line3 = 'Class: ' + character_info['class_name']
    line4 = 'Level: ' + str(character_info['level'])

    filtered_table = realmrank_table[realmrank_table['realmpoints'] <= realm_points]
    sorted_table = filtered_table.sort_values(by='realmpoints', ascending=False)
    first_row = sorted_table.iloc[0]

    line5 = 'Realm Rank: ' + first_row['realmrank']
    line6 = 'Unguilded'
    if 'guild_info' in character_info:
        guild_info = character_info['guild_info']
        guild_web_id = guild_info['guild_web_id']
        guild_rank = guild_info['guild_rank']
        guild_name = guild_info['guild_name']

        if guild_rank != 0:
            line6 = 'Rank ' + str(guild_rank) + ' member of ' + guild_name
        if guild_rank == 0 :
            line6 = 'Guild Master of ' + guild_name

    if character_info['last_on_range'] == 0:
        last_on = 'Recently'
    elif character_info['last_on_range'] == 1:
        last_on = 'Within 7 Days'
    elif character_info['last_on_range'] == 2:
        last_on = 'Within 30 Days'
    elif character_info['last_on_range'] == 3:
        last_on = 'Within 90 Days'
    elif character_info['last_on_range'] == 4:
        last_on = 'Inactive'
    else:
        last_on = 'Unknown'

    line7 = 'Last On: ' + last_on
    connection_string = "DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=daoctracking;trusted_connection=yes"
    conn = pyodbc.connect(connection_string)
    cursor = conn.cursor()

    
    irsquery = '''
    SELECT
        CONCAT('Lifetime IRS: ', CAST(rs.lifetimeIRS AS decimal(15, 2))) AS lifetime,
        CONCAT('Daily IRS: ', CAST(rs.dailyIRS AS decimal(15, 2))) AS daily
    FROM
        characters c
        JOIN characterrealmstats rs ON rs.character_web_id = c.character_web_id
    WHERE
        c.name = ? AND rs.lastrecordflag = 1
    '''

    cursor.execute(irsquery, char_name)
    result = cursor.fetchone()
    lifetime_irs = 'Lifetime IRS: '
    daily_irs = 'Daily IRS: '
    if result:
        lifetime_irs = result.lifetime
        daily_irs = result.daily

    line8 = str(lifetime_irs)
    line9 = str(daily_irs)
    combined_string = '\n'.join([line1, line2, line3, line4, line5, line6, line7, line8, line9])

    asyncio.run(run_imports(char_id,guild_web_id,guild_name))    

    return combined_string

    #ImportAllianceGuild

def get_stats(charname):
    response_json = char_search(charname)['results'][0]     
    char_id = response_json['character_web_id']
    char_name = response_json['name']
    char_info = character_info(char_id)
    realm_war_stats = char_info['realm_war_stats']['current']
    total_realm_points = realm_war_stats['realm_points']
    total_bounty_points = realm_war_stats['bounty_points']
    total_player_kills = realm_war_stats['player_kills']['total']['kills']
    total_deaths = realm_war_stats['player_kills']['total']['deaths']
    total_death_blows = realm_war_stats['player_kills']['total']['death_blows']
    total_player_solo_kills = realm_war_stats['player_kills']['total']['solo_kills']
    stats=realm_war_stats['player_kills']

    guild_web_id = ''
    guild_name= ''
    if 'guild_info' in char_info:
        guild_info = char_info['guild_info']
        guild_web_id = guild_info['guild_web_id']
        guild_name = guild_info['guild_name']
    
    headers = [char_name + ' - ' + str(format(total_realm_points,',') + ' RPs '), "Kills", "Deaths", "Death Blows", "Solo Kills"]

    # Create a list of data rows for the table
    rows = [
        ["Total", total_player_kills, total_deaths, total_death_blows, total_player_solo_kills]
    ]


    if 'midgard' in stats:
        mid_player_kills = realm_war_stats['player_kills']['midgard']['kills']
        mid_deaths = None
        mid_death_blows = realm_war_stats['player_kills']['midgard']['death_blows']
        mid_player_solo_kills = realm_war_stats['player_kills']['midgard']['solo_kills']
        rows.append(["Midgard", mid_player_kills, mid_deaths, mid_death_blows, mid_player_solo_kills])

    if 'hibernia' in stats:
        hib_player_kills = realm_war_stats['player_kills']['hibernia']['kills']
        hib_deaths = None
        hib_death_blows = realm_war_stats['player_kills']['hibernia']['death_blows']
        hib_player_solo_kills = realm_war_stats['player_kills']['hibernia']['solo_kills']
        rows.append(["Hibernia", hib_player_kills, hib_deaths, hib_death_blows, hib_player_solo_kills])

    if 'albion' in stats:
        alb_player_kills = realm_war_stats['player_kills']['albion']['kills']
        alb_deaths = None
        alb_death_blows = realm_war_stats['player_kills']['albion']['death_blows']
        alb_player_solo_kills = realm_war_stats['player_kills']['albion']['solo_kills']  
        rows.append(["Albion", alb_player_kills, alb_deaths, alb_death_blows, alb_player_solo_kills])

    table = tabulate(rows, headers=headers, tablefmt="presto")
    formatted_table = f"```\n{table}\n```"

    asyncio.run(run_imports(char_id,guild_web_id,guild_name))
    return (formatted_table)



#import_alliance_guilds('oAPLSWv4wHg')
#print(char_search('vicksterr'))
#import_character('pyAiFzGbRE0')