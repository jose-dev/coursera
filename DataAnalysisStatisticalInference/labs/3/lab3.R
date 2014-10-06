#
# https://www.datacamp.com/courses/data-analysis-and-statistical-inference_mine-cetinkaya-rundel-by-datacamp/lab-3a-foundations-for-inference-sampling-distributions?ex=1
#

# Load the 'ames' data frame:
load(url("http://s3.amazonaws.com/assets.datacamp.com/course/dasi/ames.RData"))

# Make some preliminary inspections:
names(ames)
head(ames)
tail(ames)


# Assign the variables:
area = ames$Gr.Liv.Area
price = ames$SalePrice

# Calculate the summary and draw a histogram of 'area'
summary(area)
hist(area)



# Create the samples:
samp0 = sample(area, 50)
samp1 = sample(area, 50)

# Draw the histograms:
par(mfrow = c(1,2))
hist(samp0)
hist(samp1)


# Set up an empty vector of 5000 NAs to store sample means:
sample_means50 = rep(NA, 5000)

# Take 5000 samples of size 50 of 'area' and store all of them in 'sample_means50'.
for (i in 1:5000) {
    samp = sample(area, 50)
    sample_means50[i] = mean(samp)
    #print(i)	
}

# View the result. If you want, you can increase the bin width to show more detail by changing the 'breaks' argument.
hist(sample_means50, breaks = 13)




# Initialize the sample distributions:
sample_means10 = rep(NA, 5000)
sample_means100 = rep(NA, 5000)

# Run the for loop:
for (i in 1:5000) {
    samp = sample(area, 10)
    sample_means10[i] = mean(samp)
    samp = sample(area, 100)
    sample_means100[i] = mean(samp)
}

# Take a look at the results:
head(sample_means10)
head(sample_means50) # was already loaded
head(sample_means100)



# Define the limits for the x-axis:
xlimits = range(sample_means10)

# Draw the histograms:
par(mfrow = c(3, 1))
hist(sample_means10, breaks = 20, xlim = xlimits)
hist(sample_means50, breaks = 20, xlim = xlimits)
hist(sample_means100, breaks = 20, xlim = xlimits)



# Take a sample of size 50 from 'price':
sample_50 = sample(price, 50)

# Print the mean:
mean(sample_50)


## large sample of price means
sample_means50 = rep(NA, 5000)
for (i in 1:5000) {

    sample_means50[i] = mean(sample(price, 50)) 
}
head(sample_means50)


## large sample of price means but with samples of size 150
sample_means150 = rep(NA, 5000)
for (i in 1:5000) {

    sample_means150[i] = mean(sample(price, 150)) 
}
head(sample_means150)


