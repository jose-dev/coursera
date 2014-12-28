import sys
import json
import re


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
    
    myre = '[aeiouAEIOU]'
    
    ## get data
    i = 0
    d_data = { 'score': {}, 'count': {} }
    tweet_file = open(sys.argv[2])
    for line in tweet_file:
        d_tweet =  json.loads(line)
        
        sentiment = 0
        if 'text' in d_tweet:
            for key, value in d_sent.iteritems():
                sc = len(d_regex[key].findall(d_tweet['text']))
                if sc <> 0:
                    sentiment = sentiment + ( sc * value )
            
            #sentiment = float(sentiment)

            #print tweet
            tweet = re.sub('[^0-9a-zA-Z]+', ' ', d_tweet['text'].lower() )
            a_words = tweet.split()
            for wd in a_words:
                if len(wd) == 1: continue
                if re.search(myre,wd):
                    wd = wd.encode('utf-8')
                    if wd in d_data['score']:
                        d_data['score'][wd] += sentiment
                        d_data['count'][wd] += 1
                    else:
                        d_data['score'][wd] = sentiment
                        d_data['count'][wd] = 1
    
    # compute sentiment
    for wd, sc in d_data['score'].iteritems():
        pred_sent = float(sc) / d_data['count'][wd]
        print "%s   %s" % ( wd, pred_sent )
    
   

if __name__ == '__main__':
    main()
