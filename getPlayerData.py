import requests
import json
import os
import pandas
from dotenv import load_dotenv
import time
load_dotenv()

seenCards = set()

players = pandas.read_csv('battle_data.csv')
playerData = pandas.DataFrame(columns=['PlayerID', 'Trophies', 'Wins', 'Losses', 'TotalGames'])



API_KEY = os.getenv("API_KEY")
URL = r"https://api.clashroyale.com/v1/players/%23"
headers = {
    "Authorization": "Bearer " + API_KEY
}
resCards = requests.get("https://api.clashroyale.com/v1/cards", headers=headers)
dataCards = resCards.json()
for card in dataCards['items']:
    playerData[card['name']] = int(0)

playerData = playerData.reindex(range(len(players)))

start_time = time.time()



for index, row in players.iterrows():
    if (index % 50 == 0):
        elapsed = time.time() - start_time
        rate = index / elapsed if elapsed > 0 else 0
        remaining = len(players) - index
        eta_seconds = remaining / rate if rate > 0 else 0
        eta_minutes = eta_seconds / 60
        print(f"Processing player {index}/{len(players)} - ETA: {eta_minutes:.1f} minutes")
    res = requests.get(URL + row['RedID'], headers=headers)
    data = res.json()
    playerData.loc[index] = {
        'PlayerID': row['RedID'],
        'Trophies': data.get('trophies', None),
        'Wins': data.get('wins', None),
        'Losses': data.get('losses', None),
        'TotalGames': data.get('battleCount', None)
    }
    # cards
    for card in data.get('currentDeck', []):
        if (card['name'] not in seenCards):
            seenCards.add(card['name'])
            print(f"New card found: {card['name']}")
        playerData.at[index, card['name']] = card['level']
    for card in data.get('currentDeckSupportCards', []):
        if (card['name'] not in seenCards):
            seenCards.add(card['name'])
            print(f"New card found: {card['name']}")
        playerData.at[index, card['name']] = card['level']
    playerData.loc[index] = playerData.loc[index].fillna(0)

print(playerData.head())


# my id
res = requests.get(URL + os.getenv("MY_PLAYER_ID"), headers=headers)
data = res.json()
playerData.loc[0] = {
        'PlayerID': os.getenv("MY_PLAYER_ID"),
        'Trophies': data.get('trophies', None),
        'Wins': data.get('wins', None),
        'Losses': data.get('losses', None),
        'TotalGames': data.get('battleCount', None)
}
for card in data.get('currentDeck', []):
    seenCards.add(card['name'])
    playerData.at[0, card['name']] = card['level']
playerData.loc[0] = playerData.loc[0].fillna(0)
playerData.to_csv('player_data.csv', index=False)
