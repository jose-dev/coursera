import sys
import json
import re


def main():
    myre = '[aeiouAEIOU]'
    
    ## get data
    i = 0
    d_data = { 'count': {}, 'total': 0 }
    tweet_file = open(sys.argv[1])
    for line in tweet_file:
        d_tweet =  json.loads(line)
        
        if 'text' in d_tweet:
            tweet = re.sub('[^0-9a-zA-Z]+', ' ', d_tweet['text'].lower() )
            a_words = tweet.split()
            for wd in a_words:
                if len(wd) == 1: continue
                d_data['total'] += 1
                if re.search(myre,wd):
                    wd = wd.encode('utf-8')
                    if wd in d_data['count']:
                        d_data['count'][wd] += 1
                    else:
                        d_data['count'][wd] = 1
    
    # compute frequency
    for wd, sc in d_data['count'].iteritems():
        freq = float(sc) / d_data['total']
        print "%s   %s" % ( wd, freq )
    
   

if __name__ == '__main__':
    main()
