#!/usr/bin/env python

import sys
import re

pattern = re.compile("[^\s]+") #Regular Expression for finding words
line = sys.stdin.readline()
allvowels = ['a', 'e', 'i', 'o', 'u']

while line:
    for word in pattern.findall(line):
        letters = [char for char in word.lower()]
        #Since casing doesn't matter, making everything lowercase.
        vowels = []
        for letter in letters:
            if letter in allvowels:
                vowels.append(letter)
        vowels.sort()
        #Safety measure - I'll convert the pipe to nothing in the reducer
        if len(vowels) == 0:
            vowels.append('|')
        #Key is the vowels ordered, value is a dummy 1
        print(''.join(vowels) + "\t"+"1")
    line = sys.stdin.readline()
