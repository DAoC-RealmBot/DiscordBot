import discord
import time
import pyodbc
import os
import multiprocessing
import asyncio
import functools
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
async def testwho(ctx, p1): 
    s = who_command(p1)
    print(s)
    await ctx.send(s)

@bot.hybrid_command()
async def testrealmrank(ctx, p1, p2): 
    s = get_realm_rank(char_search(p1),p2)
    print(s)
    await ctx.send(s)


@bot.hybrid_command()
async def nextrank(ctx, p1):
    cmd = "execute dbo.GetNextRealmDing '" + p1 + "'"
    cursor=connection.cursor()
    cursor.execute(cmd)
    row = cursor.fetchone()
    s = str(row)
    cursor.close()
    await ctx.send(s[2:-4])

@bot.hybrid_command()
async def who(ctx, p1):
    cmd = "execute dbo.GetCharacterInfo '" + p1 + "'"
    print(cmd)
    cursor=connection.cursor()
    cursor.execute(cmd)
    row = cursor.fetchall()
    cursor.commit()
    cursor.close()
    s1 = str(row[0])
    
    s2 = str(row[1])
    s3 = str(row[2])
    s4 = str(row[3])
    s5 = str(row[4])
    s6 = str(row[5])
    s7 = str(row[6])
    s8 = str(row[7])
    s = s1[2:-4] + '\n' + s2[2:-4] + '\n' + s3[2:-4] + '\n' + s4[2:-4] + '\n' + s5[2:-4] + '\n' + s6[2:-4]

    if s7 != '(None, )':
        s = s + '\n' + s7[2:-4] + '\n' + s8[2:-4]
    
    
    if s1 == '(None, )':
        s = 'Character not found!'    
   
    await ctx.send(s)

@bot.hybrid_command()
async def watchlist(ctx):
    cmd = "execute dbo.WatchListReport"
    print(cmd)       
    df = pd.read_sql(cmd, connection)
    print(tabulate(df, headers = 'keys', tablefmt = 'psql'))    
    s = "```" + tabulate(df, headers = 'keys', tablefmt = 'psql', showindex =False) + "```"
    await ctx.send(s)

@bot.hybrid_command()
async def watchlisthib(ctx):
    cmd = "execute dbo.WatchListReport 'hib'"
    print(cmd)       
    df = pd.read_sql(cmd, connection)
    print(tabulate(df, headers = 'keys', tablefmt = 'psql'))    
    s = "```" + tabulate(df, headers = 'keys', tablefmt = 'psql', showindex =False) + "```"
    await ctx.send(s)

@bot.hybrid_command()
async def watchlistalb(ctx):
    cmd = "execute dbo.WatchListReport 'alb'"
    print(cmd)       
    df = pd.read_sql(cmd, connection)
    print(tabulate(df, headers = 'keys', tablefmt = 'psql'))    
    s = "```" + tabulate(df, headers = 'keys', tablefmt = 'psql', showindex =False) + "```"
    await ctx.send(s)

@bot.hybrid_command()
async def watchlistmid(ctx):
    cmd = "execute dbo.WatchListReport 'mid'"
    print(cmd)       
    df = pd.read_sql(cmd, connection)
    print(tabulate(df, headers = 'keys', tablefmt = 'psql'))    
    s = "```" + tabulate(df, headers = 'keys', tablefmt = 'psql', showindex =False) + "```"
    await ctx.send(s)

@bot.hybrid_command()
async def realmrank(ctx, p1, p2):
    cmd = "execute dbo.GetNextRealmDing '" + p1 + "', '" + p2 + "'"
    cursor=connection.cursor()
    cursor.execute(cmd)
    row = cursor.fetchone()
    s = str(row)
    cursor.close()
    await ctx.send(s[2:-4])


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
