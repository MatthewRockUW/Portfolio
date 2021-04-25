#!/usr/bin/env python
 
import sys
 
#Variables that keep track of the keys.
current_key_being_processed = None
next_key_found = None

thecount = 0

for line in sys.stdin:
  line = line.strip()
  next_key_found, value = line.split('\t', 1)
  if current_key_being_processed == next_key_found:
    thecount += 1

  else:
    if current_key_being_processed:
        if current_key_being_processed == "|":
        #Changing the pipe to blank.
            current_key_being_processed = ''
        print(current_key_being_processed + ":" + str(thecount))
      
    thecount = 1
    current_key_being_processed = next_key_found

  #for loop ends here

if current_key_being_processed == next_key_found:
    if current_key_being_processed == "|":
        current_key_being_processed = ''
    print(current_key_being_processed + ":" + str(thecount))
