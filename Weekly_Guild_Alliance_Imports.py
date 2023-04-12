import pyodbc
import pandas as pd
from bot_commands import import_alliance_guilds

list = []
connection = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=daoctracking;Trusted_Connection=yes;')
cmd = "select guild_web_id from guilds"

df = pd.read_sql(cmd, connection)

for guild_web_id in df['guild_web_id']:
    import_alliance_guilds(guild_web_id)

#Import all guild rosters