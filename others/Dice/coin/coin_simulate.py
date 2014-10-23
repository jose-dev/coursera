#
# http://docs.scipy.org/doc/numpy/reference/routines.statistics.html
#

from random import randrange
import math
import numpy as np


def toss_coin():
    return randrange(2)
    #return (randrange(10) + 1) % 2

def play_game():
    win = 0
    ser = ''
    while True:
        t = toss_coin()
        ser += str(t)
        if t == 1:
            win += 1
        else:
            if win > 0:
                win = math.pow(2, win-1)
            return win
            #return [ win, ser ]
            


for j in range(20):
    wins = []
    for i in range(100000):
        wins.append(play_game())
    mean   = np.mean(wins)
    median = np.median(wins)
    std    = np.std(wins)
    perc   = np.percentile(wins, 95)
    print "mean: {}, median: {}, std: {}, percentile: {}".format(str(mean), str(median), str(std), str(perc))
    