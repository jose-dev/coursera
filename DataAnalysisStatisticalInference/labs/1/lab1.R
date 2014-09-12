#
# https://www.datacamp.com/courses/data-analysis-and-statistical-inference_mine-cetinkaya-rundel-by-datacamp/lab-1-introduction-to-data-2?ex=34
#


## load data from URL
load(url("http://s3.amazonaws.com/assets.datacamp.com/course/dasi/cdc.Rdata"))
head(cdc)

## see variable names
names(cdc)

## number of rows
nrow(cdc)

## having a peek at the data
head(cdc)
tail(cdc)

## summary statistics
mean(cdc$weight)
var(cdc$weight)
median(cdc$weight)
summary(cdc)

## summarising categorigal data into tables
table(cdc$genhlth)
table(cdc$genhlth) / nrow(cdc)
table(cdc$genhlth) / nrow(cdc) * 100

## barplots plots 
barplot( table( cdc$genhlth ) )
barplot( table( cdc$genhlth ) / nrow(cdc) * 100 )

## mosaic plots 
gender_smokers = table(cdc$gender, cdc$smoke100)
mosaicplot(gender_smokers)
mosaicplot(table(cdc$gender, cdc$smoke100))

## extracting rows/columns
cdc[1,1]
cdc[1,]
cdc[,2]
cdc[1:10,6]
cdc[1:10.1:5]

## subset
subset(cdc, cdc$gender == "f")
subset(cdc, cdc$gender == "f" & cdc$age > 30)
subset(cdc, cdc$gender == "f" | cdc$age > 30)

## boxplot
boxplot(cdc$height)
boxplot(cdc$weight ~ cdc$smoke100)
boxplot(cdc$height ~ cdc$gender)

## BMI versus general health
bmi = (cdc$weight/cdc$height^2) * 703
boxplot(bmi ~ cdc$genhlth)

## histograms
hist(cdc$age)
hist(cdc$age, breaks=100)
hist(bmi)
hist(bmi, breaks= 50)

## scatterplot
plot(cdc$weight, cdc$wtdesire)




