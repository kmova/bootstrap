import sys

def swap ( a, b):
  return b, a

if __name__ == "__main__":
  if len(sys.argv) < 3:
    print "Need atleast two arguements"
    sys.exit(1)
  print swap(sys.argv[1], sys.argv[2])
