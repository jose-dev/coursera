mydata <- read.csv("cleaned_data.csv", row.names = 1)

nrow(mydata)
names(mydata)
## [1] "jobs"        "rainfall"    "temperature" "day_of_week" "week"       
## [6] "week_year"   "month"       "rain_code"  



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

##
##
## there is a difference based on month
## from september onwards there was a gradual 
## increase of number of jobs per month
##
## this difference is already visible for
## even if we take into account only dry
## days. This increase seems unrelated to
## the data we have (neither temperature
## or rainfall)
##
##boxplot(jobs~week,  data=mydata, xlab="Week",  ylab="Number Jobs", main="Week" )
par(mfrow=c(1,2))
boxplot(jobs~month, data=mydata, xlab="Month", ylab="Number Jobs", main="Jobs By Month" )
boxplot(jobs~month, data=dry,    xlab="Month", ylab="Number Jobs", main="Jobs By Month (only dry days)" )


##
## there is also a much weaker difference based on 
## day of week in which the weekend, especially
## Sundays has a smaller number of jobs
##
## this difference is accentuated when 
## take into account only dry days. 
##
par(mfrow=c(1,2))
boxplot(jobs~day_of_week, data=mydata, xlab="Day of Week", ylab="Number Jobs", main="By Day of Week (All)" )
boxplot(jobs~day_of_week, data=dry,    xlab="Day of Week", ylab="Number Jobs", main="By Day of Week (only dry days)" )


#################################################################
#################################################################
#################################################################

## there is a difference based on rain
## number of jobs: dry < ligh rain << heavy rain
boxplot(jobs~rainfall, data=mydata, xlab="Rain Fall", ylab="Number Jobs", main="Rain Fall" )


##
## The relation number of jobs to temperature seems very random 
## so it is likely not to be relevant
##
## However, the temperature data seems to aggreee with seasonal temperature
## for a year
##
par(mfrow=c(1,2))
boxplot(jobs~temperature, data=mydata, xlab="Temperature", ylab="Number Jobs", main="Temperature" )
boxplot(temperature~month, data=mydata, xlab="Month", ylab="Temperature", main="Temperature per Month" )




