import pandas as pd
import xlrd
import math
import xlwt
import re

workbook = xlrd.open_workbook('mens indoor track.xlsx')
worksheet = workbook.sheet_by_name('bigtenmeets')

fullresults = pd.DataFrame(columns = ['Team', 'Score', 'Year', 'Rank'])
teamscore = re.compile('[a-zA-Z]+ [0-9]+')

cells = 0

while cells < 4:
    sportshistory = worksheet.cell_value(cells,0)
    year = int(sportshistory[0:4])
    
    while str(year) in sportshistory:
        sportshistory = sportshistory.replace(" State", "State")
        try:
            currentyearresults = sportshistory[sportshistory.index(str(year)):sportshistory.index(str(year+1))]
        except ValueError:
            currentyearresults = sportshistory[sportshistory.index(str(year)):]
            print(currentyearresults)
        try:
            currentyearresults = currentyearresults[currentyearresults.index("1."):]
            teamstandings = re.findall(teamscore, currentyearresults)
            
            teamresults = [i.split() for i in teamstandings ]
            
            df = pd.DataFrame(teamresults, columns = ['Team', 'Score'])
            df['Score'] = df['Score'].astype(int)
            df['Year'] = year
            df['Rank'] = df['Score'].rank(ascending=False)
            df['Rank'] = df['Rank'].apply(lambda x: math.floor(x))
            fullresults = pd.concat([fullresults, df])
        except ValueError:
            pass
        year += 1
    cells += 1

fullresults.to_excel('mens indoor track results.xlsx', sheet_name = 'bigtenresults', index=False)
