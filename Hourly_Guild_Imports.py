import pyodbc
import pandas as pd
from bot_commands import import_alliance_guilds

list = []
connection = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=34.27.112.54;DATABASE=daoctracking;UID=RealmBotSvc;PWD=Password1')
cmd = "select guild_web_id from guilds where importedflag = 0"

df = pd.read_sql(cmd, connection)
print(df)

#for guild_web_id in df['guild_web_id']:
#    import_alliance_guilds(guild_web_id)

#df2 = pd.read_sql(cmd, connection)

#for guild_web_id in df2['guild_web_id']:
    #import_alliance_guilds(guild_web_id)
    #Need to write function to import guild roster from stored proc