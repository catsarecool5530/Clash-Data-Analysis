import requests
import json
import os
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv("API_KEY")
URL = r"https://api.clashroyale.com/v1/players/%23JJJUR0YUU"
headers = {
    "Authorization": "Bearer " + API_KEY
}
res = requests.get(r"https://api.clashroyale.com/v1/players/%23JJJUR0YUU", headers=headers)

data = res.json()

# Save to JSON file for viewing
with open('player_data.json', 'w') as f:
    json.dump(data, f, indent=2)

print(data["tag"])