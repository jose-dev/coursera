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


# simulating: fair coin with 100 flips
outcomes = c("heads", "tails")
sim_fair_coin = sample(outcomes, size = 100, replace = TRUE)
sim_fair_coin
table(sim_fair_coin)


# simulating: unfair coin with 100 flips
outcomes = c("heads", "tails")
sim_unfair_coin = sample(outcomes, size = 100, replace = TRUE, prob = c(0.2, 0.8))
sim_unfair_coin
table(sim_unfair_coin)


# simulating: indepedent shooter
outcomes = c("H", "M")
sim_basket = sample(outcomes, size = 133, replace = TRUE, prob = c(0.45, 0.55))
sim_basket
table(sim_basket)


## Comparing simulated versus Kobe
kobe_streak = calc_streak(kobe$basket)
sim_streak = calc_streak(sim_basket)

summary(kobe_streak)
summary(sim_streak)

kobe_table = table(kobe_streak)
sim_table = table(sim_streak)

par(mfrow = c(1,2))
barplot(kobe_table, main="Kobe")
barplot(sim_table, main="Simulated")


