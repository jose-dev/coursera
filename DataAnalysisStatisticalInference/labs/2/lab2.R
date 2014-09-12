#
# https://www.datacamp.com/courses/data-analysis-and-statistical-inference_mine-cetinkaya-rundel-by-datacamp/lab-2-probability-3?ex=1
#


## load data from URL
load(url("http://s3.amazonaws.com/assets.datacamp.com/course/dasi/kobe.RData"))
head(kobe)


## get first 9 basket
kobe$basket[1:9]


# The 'kobe' data frame is already loaded into the workspace.  Assign Kobe's
# streak lengths:
kobe_streak = calc_streak(kobe$basket)
barplot(table(kobe_streak))


# simulating data one event at the time
outcomes = c("heads", "tails")

sample(outcomes, size = 1, replace = TRUE)
sample(outcomes, size = 1, replace = TRUE)
sample(outcomes, size = 1, replace = TRUE)


# fair coin with 100 flips
outcomes = c("heads", "tails")
sim_fair_coin = sample(outcomes, size = 100, replace = TRUE)
sim_fair_coin
table(sim_fair_coin)






