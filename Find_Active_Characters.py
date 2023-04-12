#Weekly Job to update last on status
import pyodbc
import pandas as pd
from bot_commands import character_info
from tqdm.contrib.concurrent import process_map
import concurrent.futures

list = []
connection = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=daoctracking;Trusted_Connection=yes;')
cmd = "select character_web_id from characters"
c = 1     
df = pd.read_sql(cmd, connection)
num_records = df.shape[0]
print(num_records) 
#for character_web_id in df['character_web_id']:
def process_row(row):
    json_data = character_info(row[0])
    laston = str(json_data["last_on_range"]) if "last_on_range" in json_data else None

    if laston is not None:
        update_query = 'update characters set last_on_range = ' + laston + ', lastupdated = getdate() where character_web_id = ' + str(row[0])
        # cursor=connection.cursor()
        # cursor.execute(update_query)
        # cursor.commit()
        # cursor.close()
        print(update_query)

# Replace 4 with the number of worker threads you want to use
with concurrent.futures.ThreadPoolExecutor(max_workers=12) as executor:
    list(executor.map(process_row, df.values), total=len(df))

