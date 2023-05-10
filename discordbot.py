import discord
import pyodbc
import asyncio
import nest_asyncio
import pandas as pd
from discord.ext import commands
from tabulate import tabulate
intents = discord.Intents.all()
intents.message_content = True
from bot_commands import who_command,char_search,get_realm_rank


bot = commands.Bot(command_prefix='/',intents=intents)
connection = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=daoctracking;Trusted_Connection=yes;')


@bot.hybrid_command()
async def who(ctx, p1): 
    s = who_command(p1)
    print(s)
    await ctx.send(s)

@bot.hybrid_command()
async def realmrank(ctx, p1, p2): 
    s = get_realm_rank(char_search(p1),p2)
    print(s)
    await ctx.send(s)

@bot.hybrid_command()
async def nextrank(ctx, p1): 
    s = get_realm_rank(char_search(p1))
    print(s)
    await ctx.send(s)    





@bot.hybrid_command()
async def watchlist(ctx):
    list = []
    cmd = "select firstname from characters  c join characterrealmstats crs on c.character_web_id = crs.character_web_id and crs.lastrecordflag = 1 where watchlistflag = 1 order by crs.realmpoints desc"
    print(cmd)       
    df = pd.read_sql(cmd, connection)
    for firstname in df['firstname']:
        list.append(get_realm_rank(char_search(firstname)))

    formated = pd.DataFrame(list, columns=["Realm Point Watch List"])
    s = "```" + tabulate(formated, headers = 'keys', tablefmt = 'psql', showindex =False) + "```"
    print(s)
    await ctx.send(s) 

@bot.hybrid_command()
async def watchlisthib(ctx):
    list = []
    cmd = "select firstname from characters  c join characterrealmstats crs on c.character_web_id = crs.character_web_id and crs.lastrecordflag = 1 where watchlistflag = 1 and realm = 3 order by crs.realmpoints desc"
    print(cmd)       
    df = pd.read_sql(cmd, connection)
    for firstname in df['firstname']:
        list.append(get_realm_rank(char_search(firstname)))

    formated = pd.DataFrame(list, columns=["Realm Point Watch List"])
    s = "```" + tabulate(formated, headers = 'keys', tablefmt = 'psql', showindex =False) + "```"
    print(s)
    await ctx.send(s) 

@bot.hybrid_command()
async def watchlistalb(ctx):
    list = []
    cmd = "select firstname from characters  c join characterrealmstats crs on c.character_web_id = crs.character_web_id and crs.lastrecordflag = 1 where watchlistflag = 1 and realm = 1 order by crs.realmpoints desc"
    print(cmd)       
    df = pd.read_sql(cmd, connection)
    for firstname in df['firstname']:
        list.append(get_realm_rank(char_search(firstname)))

    formated = pd.DataFrame(list, columns=["Realm Point Watch List"])
    s = "```" + tabulate(formated, headers = 'keys', tablefmt = 'psql', showindex =False) + "```"
    print(s)
    await ctx.send(s) 

@bot.hybrid_command()
async def watchlistmid(ctx):
    list = []
    cmd = "select firstname from characters  c join characterrealmstats crs on c.character_web_id = crs.character_web_id and crs.lastrecordflag = 1 where watchlistflag = 1 and realm = 2 order by crs.realmpoints desc"
    print(cmd)       
    df = pd.read_sql(cmd, connection)
    for firstname in df['firstname']:
        list.append(get_realm_rank(char_search(firstname)))

    formated = pd.DataFrame(list, columns=["Realm Point Watch List"])
    s = "```" + tabulate(formated, headers = 'keys', tablefmt = 'psql', showindex =False) + "```"
    print(s)
    await ctx.send(s) 


@bot.hybrid_command()
async def top10(ctx):
    cmd = "execute dbo.TopRealmPoints " 
    print(cmd)   
    df = pd.read_sql(cmd, connection)
    print(tabulate(df, headers = 'keys', tablefmt = 'psql'))    
    s = "```" + tabulate(df, headers = 'keys', tablefmt = 'psql') + "```"
    await ctx.send(s)

@bot.hybrid_command()
async def class10(ctx, p1):
    cmd = "execute dbo.TopRealmPoints '" + p1 + "'"
    print(cmd)   
    df = pd.read_sql(cmd, connection)
    print(tabulate(df, headers = 'keys', tablefmt = 'psql'))
    s = "```" + tabulate(df, headers = 'keys', tablefmt = 'psql') + "```"
    await ctx.send(s)

@bot.hybrid_command()
async def leaderboard(ctx,p1, p2):
    if p1 == None:
        top = 20
    elif int(p1) > 100:
        top = 100
    else:
        top = p1

    realm = ''
    if p2.lower() == 'alb':
        realm = ' and realm = 1'
    elif p2.lower() == 'mid':
        realm = ' and realm = 2'
    elif p2.lower() =='hib':
        realm = ' and realm = 3'

    select = 'select top ' + top + " c.name, class_name, case c.realm when 1 then 'Alb' when 2 then 'Mid' when 3 then 'Hib' end as Realm, max(crs.realmpoints) - min(crs.realmpoints) as [RPsEarned]"
    join = ' from characters c join characterrealmstats crs on c.character_web_id = crs.character_web_id'
    where =' where crs.importdate between dateadd(day,-8,getdate()) and getdate()' + realm
    groupby = ' group by c.name, class_name,c.realm order by 4 desc'
    cmd = select + join + where + groupby
    print(cmd)       
    df = pd.read_sql(cmd, connection)
   

    s = "```" + tabulate(df, headers = 'keys', tablefmt = 'psql', showindex =False) + "```"
    print(s)
    await ctx.send(s) 

@bot.event
async def on_ready():
    id = discord.Client(intents=discord.Intents.all())    
    #print(id)    
    #await print('Connected!')

async def timerjob():    
    while True:
         
                  
         cmd = "execute dbo.GetAnnouncements"
         cursor=connection.cursor()
         cursor.execute(cmd)
         row = cursor.fetchone()        
         cursor.close()
       
         if row is not None :            
                 
             channel = bot.get_channel(row[4])
             s = str(row[1]).replace(row[7],"&" + row[5])
             await channel.send(s)


         await asyncio.sleep(60)


@bot.hybrid_command()
async def pm(ctx, p1: discord.Member):
    if not ctx.author.voice:
        await ctx.send("You need to be in a voice channel to use this command.")
        return

    voice_channel = ctx.author.voice.channel
    members = voice_channel.members

    for member in members:
        if member == ctx.author or member == p1:
            continue

        await member.edit(mute=True, deafen=True)

@bot.hybrid_command()
async def fin(ctx):
    if not ctx.author.voice:
        await ctx.send("You need to be in a voice channel to use this command.")
        return

    voice_channel = ctx.author.voice.channel
    members = voice_channel.members

    for member in members:
        await member.edit(mute=False, deafen=False)
         
async def startbot():   
    await bot.run('MTAyMjY5MDkxMTQwODM2OTczNA.GoOQGY.Xc1Az3OryXF-hIGpB5CbvldLoiU3_8XKMsmcI0')

 
async def main():

    f1 = loop.create_task(startbot())
    f2 = loop.create_task(timerjob())
    await asyncio.wait([f1, f2])
  
# to run the above function we'll 
# use Event Loops these are low 
# level functions to run async functions

nest_asyncio.apply()
loop = asyncio.get_event_loop()
loop.run_until_complete(main())
loop.close()
