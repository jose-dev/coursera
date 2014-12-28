""" Writing my first randomforest code.
Author : AstroDave
Date : 23rd September, 2012
please see packages.python.org/milk/randomforests.html for more

""" 

import numpy as np
import csv as csv
from sklearn.ensemble import RandomForestClassifier

# import train data set
csv_file_object = csv.reader(open('./train.csv', 'rb')) 
header = csv_file_object.next() 
train_data=[] 
for row in csv_file_object: 
    train_data.append(row) 
train_data = np.array(train_data) 

# import test data set
test_file_object = csv.reader(open('./test.csv', 'rb')) 
header = test_file_object.next() 
test_data=[] 
for row in test_file_object: 
    test_data.append(row)
test_data = np.array(test_data) 

# training
print 'Training '
forest = RandomForestClassifier(n_estimators=100)
forest = forest.fit(train_data[0::,1::], train_data[0::,0])

# predicting
print 'Predicting'
output = forest.predict(test_data)

# printing
open_file_object = csv.writer(open("./predicted_male.csv", "wb"))
test_file_object = csv.reader(open('./test.csv', 'rb'))
test_file_object.next()
i = 0
for row in test_file_object:
    row.insert(0,output[i].astype(np.uint8))
    open_file_object.writerow(row)
    i += 1
 
