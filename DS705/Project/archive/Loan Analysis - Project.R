#Setup
loans = read.csv(file="C:/Users/Matt Rock/Documents/Data Science/DS 705/Project/loans50k.csv")
library(dplyr)

loans$loanID <- NULL #Unique identifier, randomly chosen.
loans$employment <- NULL #21401 unique identifiers - can't work with that data.
loans$state <- NULL #50 states, would not expect to be useful
loans$totalPaid <- NULL #Specifically told not to include this.

loans <- loans[loans$status %in% c('Charged Off','Fully Paid','Default'), ] #Reducing data to relevant sets
