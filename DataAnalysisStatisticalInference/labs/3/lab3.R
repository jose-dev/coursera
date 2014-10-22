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

