import pyodbc
import requests
import json
import pandas as pd

connection_string = "DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=daoctracking;trusted_connection=yes"
conn = pyodbc.connect(connection_string)
rank_query = 'select * from realmranks'
realmrank_table = pd.read_sql(rank_query, conn)

def who_command(charname):
   
    url = f'https://api.camelotherald.com/character/search?cluster=Ywain&name={charname}'
    response = requests.get(url)
    response_text = response.text
    response_json = json.loads(response_text)

    character_info = response_json['results'][0]
    char_id = character_info['character_web_id']
    char_name = character_info['name']
    realm_points = character_info['realm_points']

    guild_info = character_info['guild_info']
    guild_id = guild_info['guild_web_id']
    guild_rank = guild_info['guild_rank']
    guild_name = guild_info['guild_name']
    
    line1 = 'Name: ' + character_info['name']
    line2 = 'Race: ' + character_info['race']
    line3 = 'Class: ' + character_info['class_name']
    line4 = 'Level: ' + str(character_info['level'])

    filtered_table = realmrank_table[realmrank_table['realmpoints'] <= realm_points]
    sorted_table = filtered_table.sort_values(by='realmpoints', ascending=False)
    first_row = sorted_table.iloc[0]

    line5 = 'Realm Rank: ' + first_row['realmrank']

    line6 = 'Unguilded'
    if guild_rank != 0:
        line6 = 'Rank ' + guild_rank + ' member of ' + guild_name
    if guild_rank == 0 :
        line6 = 'Guild Master of ' + guild_name

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

    if result:
        lifetime_irs = result.lifetime
        daily_irs = result.daily

    line7 = 'Lifetime IRS: ' + str(lifetime_irs)
    line8 = 'Daily IRS: ' + str(daily_irs)
    combined_string = '\n'.join([line1, line2, line3, line4, line5, line6, line7, line8])
    print(combined_string)

    #importACharacter
    #ImportGuild
    #ImportAllianceGuild

    
    

who_command('Mezzaroo')