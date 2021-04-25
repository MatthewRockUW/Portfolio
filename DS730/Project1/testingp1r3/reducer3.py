#!/usr/bin/env python
 
import sys
 
#Variables that keep track of the keys.
current_key_being_processed = None
next_key_found = None

#Function to sort my list of strings as ints, then convert back to strings.
def sortasints(myarray):
    myarray = list(map(int, myarray))
    myarray.sort()
    myarray = list(map(str, myarray))
    return(myarray)

#Using a dictionary to count each person to recommend that comes through the
#friend of a friend key-value pairing. 
networking = {}
currentnetwork = []
maybes = []
probablys = []

for line in sys.stdin:
    line = line.strip()
    next_key_found, value = line.split('\t', 1)
    if current_key_being_processed == next_key_found:
        #Key-value type 1: the key person's current network
        if value.find('network') > 0:
            currentnetwork = value.split(' ')[2:]
        #Key-value type 2: maybe create a dictionary entry for this person,
        #and then add 1 to that dictionary. 
        else:
            networking.setdefault(value, 0)
            networking[value] += 1
    else:
        if current_key_being_processed:
            for x in networking:
            #Iterating through all the possible matches for the key, deciding if they're maybe or probably a match.
                if x not in currentnetwork:
                    if 2 <= networking[x] <= 3:
                        maybes.append(x)
                    elif networking[x] >= 4:
                        probablys.append(x)
            #Starting the printed result string. No matter what, this is printed.
            results = current_key_being_processed + ":"
            
            maybes = sortasints(maybes)
            probablys = sortasints(probablys)
            
            if len(maybes) > 0:
                results += "Might(" + ','.join(maybes) + ')'
            #ensuring both maybe and probably have entries before adding a space
            if len(maybes) * len(probablys) > 0:
                results += ' '
            if len(probablys) > 0:
                results += "Probably(" + ','.join(probablys) + ')'
            print(results)            
        networking = {}
        networking.setdefault(value, 0)
        networking[value] += 1
        currentnetwork = []
        maybes = []
        probablys = []
        if value.find('network'):
            currentnetwork = value.split(' ')[2:]
            
        else:
            networking.setdefault(value, 0)
            networking[value] += networking[value]


        current_key_being_processed = next_key_found


if current_key_being_processed == next_key_found:
    for x in networking:
        if x not in currentnetwork:
            if 2 <= networking[x] <= 3:
                maybes.append(x)
            elif networking[x] >= 4:
                probablys.append(x)
    results = current_key_being_processed + ":"
    maybes = sortasints(maybes)
    probablys = sortasints(probablys)
    if len(maybes) > 0:
        results += "Might(" + ','.join(maybes) + ')'
        if len(maybes) * len(probablys) > 0:
            results += ' '
        if len(probablys) > 0:
            results += "Probably(" + ','.join(probablys) + ')'
    print(results)     