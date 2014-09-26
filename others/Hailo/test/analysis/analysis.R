
mydata <- read.csv("cleaned_data.csv", row.names = 1)

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
### [1] "jobs"        "rainfall"    "temperature" "day_of_week" "week"       
### [6] "week_year"   "month"       "quarter"     "rain_code"   "temp_code"  



summary(mydata$jobs)
##  Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
## 10580   26380   36380   49120   57970  232800 


hist(mydata$jobs)
hist(mydata$jobs, breaks=50)

hist(mydata$temperature)
hist(mydata$temperature, breaks=40)


table(mydata$rainfall, mydata$month)
            
##              1  2  3  4  5  6  7  8  9 10 11 12
##  Dry        22 24 27 20 20 19 22 25 21 25 24 20
##  Heavy Rain  2  0  3  1  1  1  2  1  1  1  0  0
##  Light Rain  6  4  1  9 10  9  6  5  8  5  6 11

dry <- subset(mydata, mydata$rainfall=="Dry")
wet <- subset(mydata, mydata$rainfall!="Dry")

q1 <- subset(mydata, mydata$quarter == 1)
q2 <- subset(mydata, mydata$quarter == 2)
q3 <- subset(mydata, mydata$quarter == 3)
q4 <- subset(mydata, mydata$quarter == 4)


dry_q1 <- subset(dry, dry$quarter == 1)
dry_q2 <- subset(dry, dry$quarter == 2)
dry_q3 <- subset(dry, dry$quarter == 3)
dry_q4 <- subset(dry, dry$quarter == 4)




#################################################################
#################################################################
#################################################################


##
##
## there is a difference based on month
## from october onwards there was a gradual 
## increase of number of jobs per month.
##
## this difference in the last quarter is already visible 
## even if we take into account only dry days. This 
## increase seems unrelated to the data we have 
## (neither temperature or rainfall)
##

par(mfrow=c(1,1))
plot(mydata$jobs, type="l", col="blue", xlab="Date", ylab="Number Jobs", main="Jobs By Day")


par(mfrow=c(1,2))
boxplot(jobs~month,   data=mydata, col="grey", xlab="Month",   ylab="Number Jobs", main="Jobs By Month" )
boxplot(jobs~quarter, data=mydata, col="grey", xlab="Quarter", ylab="Number Jobs", main="Jobs By Quarter" )

par(mfrow=c(1,2))
boxplot(jobs~month,   data=dry, col="grey",   xlab="Month",   ylab="Number Jobs", main="Jobs By Month (only dry days)" )
boxplot(jobs~quarter, data=dry, col="grey",   xlab="Quarter", ylab="Number Jobs", main="Jobs By Quarter (only dry days)" )


par(mfrow=c(1,1))
barplot(table(mydata$rain_code, mydata$month), xlab="Months", col=c("yellow","cyan", "darkblue"), main="Dry vs Wet Days Per Month") 

par(mfrow=c(1,1))
barplot(table(mydata$rain_code, mydata$quarter), xlab="Quarters", col=c("yellow","cyan", "darkblue"), main="Dry vs Wet Days Per Quarter") 




#################################################################
#################################################################
#################################################################

##
## there is a difference based on rain
## number of jobs: dry < ligh rain << heavy rain
## 
## 
## The proportion of dry/wet rains is relatively uniform across months
## and it does not acccount for the differences between months. 
##

##
## boxplot(jobs~rainfall, data=mydata, xlab="Rain Fall", ylab="Number Jobs", main="Rain Fall" )
##

par(mfrow=c(1,1))
barplot(table(mydata$rain_code, mydata$quarter), xlab="Quarters", col=c("yellow","cyan", "darkblue"), main="Dry vs Wet Days By Quarter") 


par(mfrow=c(1,4))
boxplot(jobs~rain_code, data=q1, col="grey", ylim=c(0,250000), xlab="Rain Fall", ylab="Number Jobs", main="Quarter 1")
boxplot(jobs~rain_code, data=q2, col="grey", ylim=c(0,250000), xlab="Rain Fall", ylab="Number Jobs", main="Quarter 2")
boxplot(jobs~rain_code, data=q3, col="grey", ylim=c(0,250000), xlab="Rain Fall", ylab="Number Jobs", main="Quarter 3")
boxplot(jobs~rain_code, data=q4, col="grey", ylim=c(0,250000), xlab="Rain Fall", ylab="Number Jobs", main="Quarter 4")



#################################################################
#################################################################
#################################################################

##
## there is also a much weaker difference based on 
## day of week in which the weekend, especially
## Sundays has a smaller number of jobs
##
## this difference is present in all quarters. We have only considered
## dry days to remove effect of rainy days but trend is the same. 
##

## 
## par(mfrow=c(1,2))
## boxplot(jobs~day_of_week, data=mydata, xlab="Day of Week", ylab="Number Jobs", main="By Day of Week (All)" )
## boxplot(jobs~day_of_week, data=dry,    xlab="Day of Week", ylab="Number Jobs", main="By Day of Week (only dry days)" )
## 

par(mfrow=c(1,4))
boxplot(jobs~day_of_week, data=q1, col="grey", ylim=c(0,250000), xlab="Day Of Week", ylab="Number Jobs", main="Quarter 1")
boxplot(jobs~day_of_week, data=q2, col="grey", ylim=c(0,250000), xlab="Day Of Week", ylab="Number Jobs", main="Quarter 2")
boxplot(jobs~day_of_week, data=q3, col="grey", ylim=c(0,250000), xlab="Day Of Week", ylab="Number Jobs", main="Quarter 3")
boxplot(jobs~day_of_week, data=q4, col="grey", ylim=c(0,250000), xlab="Day Of Week", ylab="Number Jobs", main="Quarter 4")

par(mfrow=c(1,4))
boxplot(jobs~day_of_week, data=dry_q1, col="grey", ylim=c(0,150000), xlab="Day Of Week", ylab="Number Jobs", main="Quarter 1 - only dry days")
boxplot(jobs~day_of_week, data=dry_q2, col="grey", ylim=c(0,150000), xlab="Day Of Week", ylab="Number Jobs", main="Quarter 2 - only dry days")
boxplot(jobs~day_of_week, data=dry_q3, col="grey", ylim=c(0,150000), xlab="Day Of Week", ylab="Number Jobs", main="Quarter 3 - only dry days")
boxplot(jobs~day_of_week, data=dry_q4, col="grey", ylim=c(0,150000), xlab="Day Of Week", ylab="Number Jobs", main="Quarter 4 - only dry days")




#################################################################
#################################################################
#################################################################

##
## there are some dates with temperatures below zero. Some of them
## next to values that are relatively higher. It is difficult
## to find out whether these values are spurious but we do not remove
## them as their number of jobs seems correct.
##
 subset(mydata, mydata$temperature < 0 )

###              jobs   rainfall temperature day_of_week week week_year month
### 2013-01-10  36934 Light Rain          -1           4    2      2013     1
### 2013-01-13  10580        Dry          -1           7    2      2013     1
### 2013-01-23  24060        Dry          -1           3    4      2013     1
### 2013-01-30  27659        Dry          -2           3    5      2013     1
### 2013-02-15  30754        Dry          -3           5    7      2013     2
### 2013-10-28  50241        Dry          -1           1   44      2013    10
### 2013-12-26 145414        Dry          -1           4   52      2013    12
### 2013-12-27 119145        Dry          -1           5   52      2013    12
###            quarter rain_code temp_code
### 2013-01-10       1         2      Cold
### 2013-01-13       1         1      Cold
### 2013-01-23       1         1      Cold
### 2013-01-30       1         1      Cold
### 2013-02-15       1         1      Cold
### 2013-10-28       4         1      Cold
### 2013-12-26       4         1      Cold
### 2013-12-27       4         1      Cold



##
## However, the temperature data seems to aggreee with seasonal temperature
## for a year
##

par(mfrow=c(1,1))
plot(mydata$temperature, type="l", col="blue", xlab="Date", ylab="Temperature", main="Temperature By Day")


par(mfrow=c(1,1))
boxplot(temperature~month, data=mydata, col="grey", xlab="Month", ylab="Temperature", main="Temperature per Month" )

##
## In the last quarter of the year there was a slight increase in the number
## of jobs while temperature were dropping. However, the same trend was
## not seen at the begining of the year when the temperature was rasing.
##
## This indicates that the correlation temparature-number jobs in the last
## quarter of the year may not be relevant and that the increase of business
## was not caused by the decrease on temperature.
##
## We report the results based on dry days but the trend is similar including
## them
##


par(mfrow=c(1,4))
boxplot(jobs~temp_code, data=q1, col="grey", ylim=c(0,250000), xlab="Temperature (range)", ylab="Number Jobs", main="Quarter 1")
boxplot(jobs~temp_code, data=q2, col="grey", ylim=c(0,250000), xlab="Temperature (range)", ylab="Number Jobs", main="Quarter 2")
boxplot(jobs~temp_code, data=q3, col="grey", ylim=c(0,250000), xlab="Temperature (range)", ylab="Number Jobs", main="Quarter 3")
boxplot(jobs~temp_code, data=q4, col="grey", ylim=c(0,250000), xlab="Temperature (range)", ylab="Number Jobs", main="Quarter 4")


par(mfrow=c(1,4))
boxplot(jobs~temp_code, data=dry_q1, col="grey", ylim=c(0,150000), xlab="Temperature (range)", ylab="Number Jobs", main="Quarter 1 - only dry days")
boxplot(jobs~temp_code, data=dry_q2, col="grey", ylim=c(0,150000), xlab="Temperature (range)", ylab="Number Jobs", main="Quarter 2 - only dry days")
boxplot(jobs~temp_code, data=dry_q3, col="grey", ylim=c(0,150000), xlab="Temperature (range)", ylab="Number Jobs", main="Quarter 3 - only dry days")
boxplot(jobs~temp_code, data=dry_q4, col="grey", ylim=c(0,150000), xlab="Temperature (range)", ylab="Number Jobs", main="Quarter 4 - only dry days")





