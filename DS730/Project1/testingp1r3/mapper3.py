#!/usr/bin/env python

import sys

line = sys.stdin.readline()
while line:
    # I want to send two kinds of values for each key - one is the current 
    # network a person has. I need that to know what values to leave out
    # of my final answer, and I'll use 'network' to help ID this kind.
    # It's a small change to make the initial line this key-value
    currentnetwork = line.replace(' :', '\t network').rstrip()
    print(currentnetwork)
    splitline = line.rstrip().split(' ')

    
    #I also want to send each person's potential matches. I'll use the same key
    #of a person, with a value of potential contact. I can find those matches 
    #from someone else's network that knows both the key person & value person.
    for x in range(2, len(splitline)):
        for y in range(x+1, len(splitline)):
            print(splitline[x] + '\t' + splitline[y])
            print(splitline[y] + '\t' + splitline[x])

    line = sys.stdin.readline()
