#!/usr/bin/env python

import sys

line = sys.stdin.readline()
while line:
    splitline = line.split(',')
    if len(splitline[6]) > 0:
        if splitline[0][0] not in ('I', 'C'):
            monthstring = splitline[4][:2]
            total = str(round(float(splitline[5])*float(splitline[3]), 2))
            if monthstring[1] == "/":
                monthstring = "0" + monthstring[0]
            #Sending the country & month as the key, with the customer and total $ of the line as the value
            #The key is pre-formatted for the required answer
            print(monthstring + "," + splitline[7].rstrip() + "\t" + splitline[6] + "|" + total)
    line = sys.stdin.readline()