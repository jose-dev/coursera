
mydata <- read.csv("rss_data_r.csv")

## 
## mydata$temp_code <- 'Mild'
## mydata$temp_code[mydata$temperature > 20] <- 'Warm' 
## mydata$temp_code[mydata$temperature < 5]  <- 'Cold' 
## 
## mydata$quarter <- 'q2'
## mydata$quarter[mydata$month <= 3]  <- 'q1' 
## mydata$quarter[mydata$month >= 7 & mydata$month <= 9] <- 'q3' 
## mydata$quarter[mydata$month >= 10] <- 'q4' 
##


nrow(mydata)
names(mydata)
###[1] "agent"  "date"   "rating" "yyyymm"


## table with ratings per agent
table(mydata$agent, mydata$rating)
                        
###                            1    2    3    4    5
###  big-move-estate-agents    0    1    0    2   11
###  bradleys-estate-agents   15    1    3  187 1711
###  choices                  65    6   13  390 2106
###  manning-stainton          8    0    2   62  850
###  reeds-rains              96    5    5   70  512


choices <- subset(mydata, mydata$agent == "choices")
bradley <- subset(mydata, mydata$agent == "bradleys-estate-agents")
manning <- subset(mydata, mydata$agent == "manning-stainton")
reeds   <- subset(mydata, mydata$agent == "reeds-rains")





#################################################################
#################################################################
#################################################################


##
## distribution of ratings
##

hist(mydata$rating, xlab="ratings", ylab="Number of Reviews", breaks=20, col="red")



#################################################################
#################################################################
#################################################################


##
## distribution of rating over time
##

par(mfrow=c(1,1))
barplot(table(mydata$rating, mydata$yyyymm), xlab="year-month", ylab="ratings", col=c("red", "orange", "yellow", "cyan", "green"), main="Rating Distribution By Year-Month")



#################################################################
#################################################################
#################################################################

##
## reviews per agent
##

par(mfrow=c(1,1))
barplot(table(mydata$rating, mydata$agent), xlab="agent", ylab="ratings", col=c("red", "orange", "yellow", "cyan", "green"), main="Rating Distribution By Agent")



