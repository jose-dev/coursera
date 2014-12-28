import MapReduce
import sys

mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    key = record[0]
    i = record[1]
    j = record[2]
    value = record[3]
    for k in range(10):
      if key == 'a':
        mr.emit_intermediate((i,k), ( j, value ))
      else:
        mr.emit_intermediate((k,j), ( i, value ))



def reducer(key, list_of_values):
    d_val = {}
    for v in list_of_values:
        if v[0] in d_val:
            d_val[v[0]].append(v[1])
        else:
            d_val[v[0]] = [ v[1]]
    total = 0
    for i in d_val:
        if len( d_val[i] ) == 1:
            continue
        elif ( len( d_val[i] ) == 2 ):
            total += d_val[i][0] * d_val[i][1]
        else:
            print "it should never reach here"
            continue
    
    if total != 0:
        mr.emit((key[0], key[1], total))



# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
