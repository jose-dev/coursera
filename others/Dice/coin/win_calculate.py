"""
    
    http://math.ucr.edu/home/baez/games/games_11.html
    http://en.wikipedia.org/wiki/St._Petersburg_paradox
    
"""

import math

for n in range(10):
    i    = n + 1
    win  = math.pow(2, n)
    prob = 1 / math.pow(2, i)
    exp  = win * prob
    print "heads: {}, win: {}, probability: {}, expected win: {}".format(str(n), str(win), str(prob), str(exp))
    