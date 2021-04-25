import pandas as pd
import xlrd
import math
import xlwt
import re

workbook = xlrd.open_workbook('women soccer results.xlsx')
worksheet = workbook.sheet_by_name('wisconsingameresults')

fullresults = pd.DataFrame(columns = ['Team', 'Score', 'Year', 'Rank'])
opponentreg = re.compile('[a-zA-Z.()& -’]+[a-zA-Z]')
gamenotes = ['# Club team;', '% Ithaca, N.Y.', '@ Umbro Invitational', '^ Wisconsin Invitational', 
             '! NCAA First Round', '* Big Ten ', '& Portland Invitational', '*Big Ten Conference',
             '! Big Ten Tournament', '$ Exhibition Match']


fullresults = []

cells = 0

while cells < 7:
    sportshistory = worksheet.cell_value(cells,0)
    year = int(sportshistory[0:4])
    
    while str(year) in sportshistory:
        sportshistory = sportshistory.replace(" State", "State")
        try:
            currentyearresults = sportshistory[sportshistory.index(str(year)):sportshistory.index(str(year+1))]
        except ValueError:
            currentyearresults = sportshistory[sportshistory.index(str(year)):]
        endofschedule = len(currentyearresults)
        for gamenote in gamenotes:
            try:
                endofschedule = min(endofschedule, currentyearresults.index(gamenote))
            except ValueError:
                pass
        currentyearresults = currentyearresults[currentyearresults.index("Head Coach:")+10:endofschedule]
        yearstuff = re.split(r'([0-9]+/[0-9]+)', currentyearresults)
        i = 1
        while i < len(yearstuff):
            day = yearstuff[i]
            game = yearstuff[i+1].split(maxsplit = 2)
            result = game[0]
            badgerscore = game[1].split('-')[0]
            opponentscore = game[1].split('-')[1]
            opponent = game[2]
            opmatch = re.search(opponentreg, opponent)
            i+= 2
            fullresults.append([year, day, result, badgerscore, opponentscore, opmatch[0].title()])
        year += 1
        gameresults = pd.DataFrame(fullresults, columns=['Year', 'Day', 'Result','WisconsinScore','OpponentScore', 'Opponent'])
        gameresults.to_excel('womenssoccer.xlsx', sheet_name = 'womenssoccer', index=False)
    cells += 1


