import MapReduce
import sys


mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # key: table
    # value: row info
    oid = record[1]
    mr.emit_intermediate(oid,record)

def reducer(key, list_of_values):
    # key: word
    # value: list of occurrence counts
    orders = []
    items  = []
    for v in list_of_values:
        if v[0] == 'order':
            orders.append( v )
        else:
            items.append( v )
    
    for order in orders:
        for item in items:
            mr.emit( order + item )


# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
