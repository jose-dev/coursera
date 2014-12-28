import MapReduce
import sys

mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    key = record[0]
    value = record[1]
    mr.emit_intermediate( ( value, key ), 1 )
    mr.emit_intermediate( ( key, value ), 1 )


def reducer(key, list_of_values):
    if len(list_of_values) == 1:
        mr.emit(key)


# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
