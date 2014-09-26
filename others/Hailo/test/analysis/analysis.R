
mydata <- read.csv("cleaned_data.csv", row.names = 1)

mydata$temp_code <- 'Mild'
mydata$temp_code[mydata$temperature > 20] <- 'Warm' 
mydata$temp_code[mydata$temperature < 5]  <- 'Cold' 

mydata$quater <- 'q2'
mydata$quarter[mydata$month <= 3]  <- 'q1' 
mydata$quarter[mydata$month >= 4 & mydata$month <= 6] <- 'q2' 
mydata$quarter[mydata$month >= 7 & mydata$month <= 9] <- 'q3' 
mydata$quarter[mydata$month >= 10] <- 'q4' 


nrow(mydata)
names(mydata)
###  [1] "jobs"        "rainfall"    "temperature" "day_of_week" "week"       
###  [6] "week_year"   "month"       "rain_code"   "temp_code"   "quater"     
### [11] "quarter"    



summary(mydata$jobs)
##  Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
## 10580   26380   36380   49120   57970  232800 


hist(mydata$jobs)
hist(mydata$jobs, breaks=50)


#################################################################
#################################################################
#################################################################

table(mydata$rainfall, mydata$month)
            
##              1  2  3  4  5  6  7  8  9 10 11 12
##  Dry        22 24 27 20 20 19 22 25 21 25 24 20
##  Heavy Rain  2  0  3  1  1  1  2  1  1  1  0  0
##  Light Rain  6  4  1  9 10  9  6  5  8  5  6 11

dry <- subset(mydata, mydata$rainfall=="Dry")
wet <- subset(mydata, mydata$rainfall!="Dry")

first <- subset(mydata, mydata$month <= 6)
second <- subset(mydata, mydata$month >= 7)

q1 <- subset(mydata, mydata$month <= 3)
q2 <- subset(mydata, mydata$month >= 4 & mydata$month <= 6)
q3 <- subset(mydata, mydata$month >= 7 & mydata$month <= 9)
q4 <- subset(mydata, mydata$month >= 10)


dry_q1 <- subset(dry, dry$month <= 3)
dry_q2 <- subset(dry, dry$month >= 4 & dry$month <= 6)
dry_q3 <- subset(dry, dry$month >= 7 & dry$month <= 9)
dry_q4 <- subset(dry, dry$month >= 10)

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
##
##boxplot(jobs~week,  data=mydata, xlab="Week",  ylab="Number Jobs", main="Week" )
par(mfrow=c(1,3))
boxplot(jobs~month, data=mydata, xlab="Month", ylab="Number Jobs", main="Jobs By Month" )
boxplot(jobs~month, data=dry,    xlab="Month", ylab="Number Jobs", main="Jobs By Month (only dry days)" )



#################################################################
#################################################################
#################################################################

##
## there is also a much weaker difference based on 
## day of week in which the weekend, especially
## Sundays has a smaller number of jobs
##
## this difference is present in all quarters. We have only considered
## dry days to remove effect of rainy days. 
##
## The proportion of dry/wet rains is relatively uniform across months
## and it does not acccount for the differences between months. 
##

## 
## par(mfrow=c(1,2))
## boxplot(jobs~day_of_week, data=mydata, xlab="Day of Week", ylab="Number Jobs", main="By Day of Week (All)" )
## boxplot(jobs~day_of_week, data=dry,    xlab="Day of Week", ylab="Number Jobs", main="By Day of Week (only dry days)" )
## 

## par(mfrow=c(1,4))
## boxplot(jobs~day_of_week, data=q1, xlab="Day Of Week", ylab="Number Jobs", main="Quarter 1")
## boxplot(jobs~day_of_week, data=q2, xlab="Day Of Week", ylab="Number Jobs", main="Quarter 2")
## boxplot(jobs~day_of_week, data=q3, xlab="Day Of Week", ylab="Number Jobs", main="Quarter 3")
## boxplot(jobs~day_of_week, data=q4, xlab="Day Of Week", ylab="Number Jobs", main="Quarter 4")

par(mfrow=c(1,4))
boxplot(jobs~day_of_week, data=dry_q1, ylim=c(0,150000), xlab="Day Of Week", ylab="Number Jobs", main="Quarter 1 - only dry days")
boxplot(jobs~day_of_week, data=dry_q2, ylim=c(0,150000), xlab="Day Of Week", ylab="Number Jobs", main="Quarter 2 - only dry days")
boxplot(jobs~day_of_week, data=dry_q3, ylim=c(0,150000), xlab="Day Of Week", ylab="Number Jobs", main="Quarter 3 - only dry days")
boxplot(jobs~day_of_week, data=dry_q4, ylim=c(0,150000), xlab="Day Of Week", ylab="Number Jobs", main="Quarter 4 - only dry days")


par(mfrow=c(1,1))
barplot(table(mydata$rain_code, mydata$month), xlab="Months", col=c("yellow","cyan", "darkblue"), main="Dry vs Wet Days Pe Month") 



#################################################################
#################################################################
#################################################################

## there is a difference based on rain
## number of jobs: dry < ligh rain << heavy rain
## 
boxplot(jobs~rainfall, data=mydata, xlab="Rain Fall", ylab="Number Jobs", main="Rain Fall" )

par(mfrow=c(1,2))
boxplot(jobs~rain_code, data=first,  xlab="Rain Fall", ylab="Number Jobs", main="First Half of Year" )
boxplot(jobs~rain_code, data=second, xlab="Rain Fall", ylab="Number Jobs", main="Second Half of Year" )

par(mfrow=c(1,4))
boxplot(jobs~rain_code, data=q1, ylim=c(0,250000), xlab="Rain Fall", ylab="Number Jobs", main="Quarter 1")
boxplot(jobs~rain_code, data=q2, ylim=c(0,250000), xlab="Rain Fall", ylab="Number Jobs", main="Quarter 2")
boxplot(jobs~rain_code, data=q3, ylim=c(0,250000), xlab="Rain Fall", ylab="Number Jobs", main="Quarter 3")
boxplot(jobs~rain_code, data=q4, ylim=c(0,250000), xlab="Rain Fall", ylab="Number Jobs", main="Quarter 4")




#################################################################
#################################################################
#################################################################


##
## However, the temperature data seems to aggreee with seasonal temperature
## for a year
##
par(mfrow=c(1,1))
boxplot(temperature~month, data=mydata, xlab="Month", ylab="Temperature", main="Temperature per Month" )

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

## 
## par(mfrow=c(1,4))
## boxplot(jobs~temp_code, data=q1, xlab="Temperature (range)", ylab="Number Jobs", main="Quarter 1")
## boxplot(jobs~temp_code, data=q2, xlab="Temperature (range)", ylab="Number Jobs", main="Quarter 2")
## boxplot(jobs~temp_code, data=q3, xlab="Temperature (range)", ylab="Number Jobs", main="Quarter 3")
## boxplot(jobs~temp_code, data=q4, xlab="Temperature (range)", ylab="Number Jobs", main="Quarter 4")
## 

par(mfrow=c(1,4))
boxplot(jobs~temp_code, data=dry_q1, ylim=c(0,150000), xlab="Temperature (range)", ylab="Number Jobs", main="Quarter 1 - only dry days")
boxplot(jobs~temp_code, data=dry_q2, ylim=c(0,150000), xlab="Temperature (range)", ylab="Number Jobs", main="Quarter 2 - only dry days")
boxplot(jobs~temp_code, data=dry_q3, ylim=c(0,150000), xlab="Temperature (range)", ylab="Number Jobs", main="Quarter 3 - only dry days")
boxplot(jobs~temp_code, data=dry_q4, ylim=c(0,150000), xlab="Temperature (range)", ylab="Number Jobs", main="Quarter 4 - only dry days")





