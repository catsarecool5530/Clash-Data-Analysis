import requests
import json
import os
import pandas
from dotenv import load_dotenv
load_dotenv()

seenCards = set()

players = pandas.read_csv('battle_data.csv')
playerData = pandas.DataFrame(columns=['PlayerID', 'Trophies', 'Wins', 'Losses', 'TotalGames'])

API_KEY = os.getenv("API_KEY")
URL = r"https://api.clashroyale.com/v1/players/%23"
headers = {
    "Authorization": "Bearer " + API_KEY
}
for index, row in players.iterrows():
    if (index % 100 == 0):
        print(f"Processing player {index}/{len(players)}")
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
            playerData[card['name']] = int(0)
        playerData.at[index, card['name']] = card['level']
    playerData.loc[index] = playerData.loc[index].fillna(0)

print(playerData.head())


playerData.to_csv('player_data.csv', index=False)
