#!/usr/bin/env python

import sys


current_key_being_processed = None
next_key_found = None

bestcustomer = [] #array to help adjust for possible ties
currentcustomer = ''
highesttotal = 0
currenttotal = 0

for line in sys.stdin:
    line = line.strip()
    next_key_found, value = line.split('\t', 1)
    valuecust, valueamt = value.split('|')
    
    if current_key_being_processed == next_key_found:
        #Either the customer has another line to add to their total
        if currentcustomer == valuecust:
            currenttotal = float(valueamt) + currenttotal
        else:
        #Or a new customer is found, and we check to see if the old
        #customer has the highest total for this month and country.
            if currenttotal == highesttotal:
                bestcustomer.append(currentcustomer)
            elif currenttotal > highesttotal:
                bestcustomer = [currentcustomer]
                highesttotal = currenttotal
            currentcustomer = valuecust
            currenttotal = float(valueamt)

    else:
        if current_key_being_processed:
            if currenttotal == highesttotal:
                bestcustomer.append(currentcustomer)
            elif currenttotal > highesttotal:
                bestcustomer = [currentcustomer]
                highesttotal = currenttotal
            bestcustomer.sort() #in case there were ties for best customer
            #Key is already formatted for month/country. Printing either single 
            #best customer, or multiple customers joined by a comma
            print(current_key_being_processed + ':' + ','.join(bestcustomer))
        bestcustomer = []
        currentcustomer = valuecust
        highesttotal = 0
        currenttotal = float(valueamt)
        current_key_being_processed = next_key_found

if current_key_being_processed == next_key_found:
    bestcustomer.sort()
    print(current_key_being_processed + ':' + ','.join(bestcustomer))

