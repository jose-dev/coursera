import sys
import json


def main():
    ## get data
    d_data = {}
    tweet_file = open(sys.argv[1])
    for line in tweet_file:
        d_tweet =  json.loads(line)
        a_hashtags = []
        if 'entities' in d_tweet:
            if 'hashtags' in d_tweet['entities']:
                a_hashtags = d_tweet['entities']['hashtags']
        
        if len(a_hashtags) == 0 : continue
        for d_hashtag in a_hashtags :
            hastag = d_hashtag['text']
            if hastag in d_data:
                d_data[hastag] += 1
            else:
                d_data[hastag] = 1
    
    # print top ten
    count = 0;
    for hashtag in sorted(d_data, key=lambda key: d_data[key], reverse=True):
        count += 1
        print "%s   %s" % ( hashtag, float(d_data[hashtag]) )
        if count >= 10: break
    
   

if __name__ == '__main__':
    main()
