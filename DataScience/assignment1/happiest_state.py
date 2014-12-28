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
    
    ## get data
    d_data = {}
    tweet_file = open(sys.argv[2])
    for line in tweet_file:
        d_tweet =  json.loads(line)
        
        if 'place' in d_tweet and d_tweet['place'] <> None:
            if d_tweet['place']['country_code'] == 'US' and d_tweet['place']['full_name'] >= 2:
                state = re.search('(..)$', d_tweet['place']['full_name']).group(1)
                sentiment = 0
                
                if 'text' in d_tweet:
                    for key, value in d_sent.iteritems():
                        sc = len(d_regex[key].findall(d_tweet['text']))
                        if sc <> 0:
                            sentiment = sentiment + ( sc * value )
                            
                if state in d_data:
                    d_data[state] += sentiment
                else:
                    d_data[state] = sentiment


    # print happiest
    for state in sorted(d_data, key=lambda key: d_data[key], reverse=True):
        print state
        break
    
   

if __name__ == '__main__':
    main()
