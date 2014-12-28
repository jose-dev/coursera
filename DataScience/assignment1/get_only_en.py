import sys
import json
  

def main():
    tweet_file = open(sys.argv[1])
    for line in tweet_file:
        d_tweet =  json.loads(line)
        
        if 'lang' in d_tweet and d_tweet['lang'] == 'en':
            print line.rstrip( '\n' )
    

if __name__ == '__main__':
    main()
