import sys
import json
import re

#def hw():
#    print 'Hello, world!'

#def lines(fp):
#    print str(len(fp.readlines()))

def parse_sent( filein ):
    sent_file = open( filein )
    d_scores = {} 
    for line in sent_file:
        term, score  = line.split("\t")  
        d_scores[term] = int(score)
    return d_scores

def create_regex( d_in ):
    d_out = {}
    for key, value in d_in.iteritems():
        d_out[key] = re.compile(r'\b%s\b' % key, flags=re.IGNORECASE)
    return d_out
    

def main():
    d_sent = parse_sent( sys.argv[1] )
    d_regex =  create_regex( d_sent )
    
    tweet_file = open(sys.argv[2])
    for line in tweet_file:
        d_tweet =  json.loads(line)
        
        sentiment = 0
        if 'text' in d_tweet:
            for key, value in d_sent.iteritems():
                sc = len(d_regex[key].findall(d_tweet['text']))
                if sc <> 0:
                    sentiment = sentiment + ( sc * value )
        print float(sentiment)                 
   

if __name__ == '__main__':
    main()
