"""
    
    http://docs.scipy.org/doc/numpy/reference/routines.statistics.html
    
    
    percentile (when NUMBER_GAMES = 100000):
    - at 95% = 8.0
    - at 99% = 32.0
    
    
    
"""



from random import randrange
import math
import numpy as np

NUMBER_GAMES = 100000
NUMBER_EXP   = 20

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
            


for j in range(NUMBER_EXP):
    wins = []
    for i in range(NUMBER_GAMES):
        wins.append(play_game())
    N      = np.mean(wins)
    mean   = np.mean(wins)
    median = np.median(wins)
    std    = np.std(wins)
    perc   = np.percentile(wins, 99)
    print "games: {}, mean: {}, median: {}, std: {}, percentile: {}".format(str(N), str(mean), str(median), str(std), str(perc))
    