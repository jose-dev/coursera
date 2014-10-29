
import random

OPERATIONS = [ 'sum', 'multiply', 'substract', 'divide' ]

def choose_operation(ops=OPERATIONS):
    #from random import randint
    #i = randint(1,len(ops)) - 1
    #return ops[i]
    return random.choice(ops)


op = choose_operation()
for i in range(10):
    print choose_operation()



