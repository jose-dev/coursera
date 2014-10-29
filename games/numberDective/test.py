
import random
#from random import randint

Y_LIM = 50
EQUATION = [ 'x', 'y', 'out' ]
#EQUATION = [ 'x', 'op', 'y', 'out' ]
OPERATIONS = [ 'sum', 'substract' ]
SIGNS = { 'sum': '+', 'multiply': 'X', 'substract': '-', 'divide': '/' }
#OPERATIONS = [ 'sum', 'multiply', 'substract', 'divide' ]

def choose_operation(ops=OPERATIONS):
    return random.choice(ops)

def choose_number(higher=Y_LIM, smaller=1):
    return random.randint(smaller,higher)

def choose_x(higher=Y_LIM, smaller=1):
    return choose_number(higher=higher, smaller=smaller)

def choose_y(higher=Y_LIM, smaller=1, x=1, op=None):
    if op == 'divide':
        pass
    else:
        if op == 'substract':
            higher = x
        return choose_number(higher=higher, smaller=smaller)

def calculate_output(x=None, y=None, op=None):
    if op == 'sum':
        return x + y
    elif op == 'substract':
        return x - y
    elif op == 'multiply':
        return x * y
    else:
        return None

def what_to_hide():
    return random.choice(EQUATION)

def question_string(params=None):
    x   = '?' if params['hide'] == 'x' else params['x'] 
    y   = '?' if params['hide'] == 'y' else params['y'] 
    op  = '?' if params['hide'] == 'op' else SIGNS[params['op']] 
    out = '?' if params['hide'] == 'out' else params['out'] 
    
    ques = "{x} {op} {y} = {out}"
    return ques.format(x=x, op=op, y=y, out=out)
    
def question_params():
    op   = choose_operation()
    x    = choose_x()
    y    = choose_y(x=x, op=op)
    out  = calculate_output(x=x, y=y, op=op)
    hide = what_to_hide()
    ques = question_string(params={'x': x,
                                   'y': y,
                                   'op': op,
                                   'out': out,
                                   'hide': hide})
    
    return {'x': x,
            'y': y,
            'op': op,
            'out': out,
            'hide': hide,
            'ques': ques}





op = choose_operation()
for i in range(10):
    print("\n")
    mistery = question_params()
    #print mistery
    answer = raw_input("what is missing here? {} \n".format(mistery['ques']))
    count = 0
    while True:
        if int(answer) == mistery[mistery['hide']]:
            print("well done!")
            break
        else:
            count += 1
            if count < 3:
                answer = raw_input("please try again:")
            else:
                print("you are hopeless...better luck next time. The right answer was {}".format(mistery[mistery['hide']]))
                break
        
    #print choose_x()



