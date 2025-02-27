import sys
from bot_commands import char_search    
import warnings
warnings.filterwarnings("ignore")

param1 = "Mezzaroo"

response_json = char_search(param1)

print (response_json)