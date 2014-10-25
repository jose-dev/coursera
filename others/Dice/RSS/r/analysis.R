
mydata <- read.csv("rss_data_r.csv")
mydata_avg <- read.csv("rss_data_r_avrg.csv")

mydata$agent_name <- 'choices'
mydata$agent_name[mydata$agent == 'bradleys-estate-agents'] <- 'bradleys'
mydata$agent_name[mydata$agent == 'manning-stainton']       <- 'manning'
mydata$agent_name[mydata$agent == 'reeds-rains']            <- 'reeds'

mydata_avg$agent_name <- 'choices'
mydata_avg$agent_name[mydata_avg$agent == 'bradleys-estate-agents'] <- 'bradleys'
mydata_avg$agent_name[mydata_avg$agent == 'manning-stainton']       <- 'manning'
mydata_avg$agent_name[mydata_avg$agent == 'reeds-rains']            <- 'reeds'



## table with ratings per agent
table(mydata$agent, mydata$rating)
                        
###                            1    2    3    4    5
###  bradleys-estate-agents   15    1    3  187 1711
###  choices                  65    6   13  390 2106
###  manning-stainton          8    0    2   62  850
###  reeds-rains              96    5    5   70  512




#################################################################
#################################################################
#################################################################

par(mfrow=c(1,2))

##
## distribution of ratings
##

barplot(table(mydata$rating), xlab="Rating Score", ylab="Number of Reviews", col=c("red", "orange", "yellow", "cyan", "green"), main="Distribution Of Rating Scores")

##
## reviews per agent
##

barplot(table(mydata$rating, mydata$agent_name), xlab="Agent", ylab="Number Of Reviews", col=c("red", "orange", "yellow", "cyan", "green"), main="Rating Scores By Agent")




#################################################################
#################################################################
#################################################################

par(mfrow=c(1,2))


##
## distribution of rating over time
##

barplot(table(mydata$rating, mydata$yyyy), xlab="year", ylab="Number of Reviews", col=c("red", "orange", "yellow", "cyan", "green"), main="Rating Scores per Year")


##
## distribution of monthly average rating per year (from 2012)
##

boxplot(avg_rating~yyyy, data=mydata_avg, col="grey", xlab="Year", ylab="Monthly Average Rating", main="Monthly Average Ratings per Year" )




