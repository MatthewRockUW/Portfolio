# -*- coding: utf-8 -*-
"""
Created on Wed Oct  7 19:44:59 2020

@author: Matt Rock
"""

import re
import pandas as pd
import requests
from bs4 import BeautifulSoup


url = 'https://www.eliteprospects.com/league/ncaa/standings/2005-2006'
page = requests.get(url, headers={'User-Agent': 'Custom'})
soup = BeautifulSoup(page.text, 'html.parser')
standings = soup.find('table', attrs={'class': 'table standings table-sortable'})
tablehead = standings.find('thead').find_all('th')

headers = []
for line in tablehead:
    headers.append(line.string)
print(headers[1:])
    
conferencesandteams = standings.find_all('tr')

for line in conferencesandteams[1:]:
    if len(line) == 3:
        conf = line.find('td').string.strip()
    else:
        team = line.find('a').string.strip()
        lineclass = line.find_all('td')
        teamstats = [team]
        for element in lineclass:
            if element.string:
                teamstats.append(element.string.strip())
        del teamstats[1]
