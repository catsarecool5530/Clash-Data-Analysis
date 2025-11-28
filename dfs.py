import requests
import json
import os
import pandas
from dotenv import load_dotenv
load_dotenv()
seenNames = set(); # setty set set!

allyID = []
enemyID = []
stack = [os.getenv("MY_PLAYER_ID")]
win = []

API_KEY = os.getenv("API_KEY")
URL = r"https://api.clashroyale.com/v1/players/%23"
headers = {
    "Authorization": "Bearer " + API_KEY
}
blueElixirLeaked = []
redElixirLeaked = []
while len(allyID) < 10000:
    curID = stack.pop()
    res = requests.get(URL + curID + "/battlelog", headers=headers)
    data = res.json();
    for game in data:
        if game["opponent"][0]["tag"] in seenNames:
            continue
        blueElixirLeaked.append(game["team"][0]["elixirLeaked"])
        redElixirLeaked.append(game["opponent"][0]["elixirLeaked"])
        allyID.append(curID)
        oppID = game["opponent"][0]["tag"]
        oppID = oppID[1:]
        enemyID.append(oppID)
        seenNames.add(oppID)
        stack.append(oppID)
        if game["team"][0]["crowns"] > game["opponent"][0]["crowns"]:
            win.append(1)
        else:
            win.append(0)


df = pandas.DataFrame({
    'BlueID': allyID,
    'RedID': enemyID,
    'Blue_Elixir_Leaked': blueElixirLeaked,
    'Red_Elixir_Leaked': redElixirLeaked,
    'Win': win
})

df.to_csv('battle_data.csv', index=False)
