loans = read.csv(file="C:/Users/Matt Rock/Documents/Data Science/DS 705/Project/loans50k.csv", na.strings = " ")
library(dplyr)
library(ggplot2)
library(gridExtra)
library(GGally)

loans$loanID <- NULL #Unique identifier, randomly chosen.
loans$employment <- NULL #21401 unique identifiers - can't work with that data.
loans$state <- NULL #50 states, would not expect to be useful
loans$totalPaid <- NULL #Specifically told not to include this.

loans <- loans[loans$status %in% c('Charged Off','Fully Paid','Default'), ] #Reducing data to relevant sets
loans <- loans %>% mutate(result = case_when(status == 'Fully Paid' ~ 'Good', TRUE ~ 'Bad') )
loans$result <- as.factor(loans$result)
loans$status <- NULL
loans$rate <- NULL
loans$grade <- NULL

loans$del <- NULL
loans$delinq2yr <- NULL
loans$length <- NULL
loans$pubRec <- NULL
loans$inq6mth <- NULL

loans$totalAcc <- NULL
loans$totalIlLim <- NULL

summary(loans)

pairs(loans[c(22,2,3,4)])
pairs(loans[c(22,1,5,6,7)])
pairs(loans[c(22,8,9,10)])
pairs(loans[c(22,11,12,13,14)])
pairs(loans[c(22,15,16,17,18)])

loans.result.grade.table <- table(loans$result, loans$reason, loans$home)  

loans.result.grade.table

round(loans.result.grade.table/sum(loans.result.grade.table)*100, 2)

loans <- loans %>% mutate(delinq2yr = case_when(delinq2yr == '0' ~ 'None', TRUE ~ 'OneOrMore') )

loans.scratch.table <- table(loans$reason,loans$result)  
addmargins(loans.scratch.table)
addmargins(round(loans.scratch.table/sum(loans.scratch.table)*100, 2))

loans.full.model <- glm(result ~ amount + term + payment + home + income + verified + 
                          debtIncRat + openAcc + revolRatio + totalBal + totalRevLim + 
                          accOpen24 + totalLim + totalRevBal + creditcard + 
                          amount:term + term:payment + payment:verified + openAcc:accOpen24 + 
                          payment:totalRevBal + totalRevBal:creditcard + payment:creditcard + 
                          openAcc:totalRevBal + payment:revolRatio + payment:openAcc + 
                          verified:totalRevBal + debtIncRat:totalRevLim + 
                          payment:income + amount:payment + verified:openAcc + term:home + 
                          debtIncRat:revolRatio + 
                          debtIncRat:openAcc + income:totalRevLim + payment:totalLim + 
                          amount:totalLim + amount:openAcc + payment:accOpen24 + term:openAcc + 
                          totalBal:bcRatio, data=loans.testset, family = "binomial")

loans.initial.model.subsets <- regsubsets(result ~ . , nvmax=10, data=loans)
summary(loans.initial.model.subsets)
