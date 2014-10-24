#
# RSS obtained from http://www.allagents.co.uk/r/
#
# python docs:
#   - http://www.pythonforbeginners.com/feedparser/using-feedparser-in-python
#
#
# content analysis:
#   - ideas:
#       - split reviews according to ratings (analyse them separetely)
#   - resourses:
#       - http://tedunderwood.com/2012/08/14/where-to-start-with-text-mining/
#       - "http://www.wordle.net/" 
#
#
# other insights:
#   - compare agents overall and over time 
#

import re
import feedparser
from datetime import datetime

BASEURL = 'http://www.allagents.co.uk/rss/{agency}/'
#agencies = ['richard-worth', 'redlet', 'reed-residential', 'choices']
agencies = ['redlet']
#agencies = ['choices']


def extract_date(title):
    p = re.compile("(\d+/\d+/\d+)")
    m = p.search(title) 
    dt = datetime.strptime(m.group(1), "%d/%m/%Y")
    return datetime.strftime(dt, "%Y-%m-%d")

def extract_rating(title):
    p = re.compile("(\d) star")
    m = p.search(title) 
    return m.group(1)

def extract_reviewer(title):
    p = re.compile("\d+/\d+/\d+ - (.+) rated")
    m = p.search(title) 
    return m.group(1)


for agent in agencies:
    url = BASEURL.format(agency=agent)
    d = feedparser.parse(url)
    #print d
    #print len(d['entries'])
    
    ## ## the whole record
    ## for post in d.entries:
    ##     print post
    ##     print "------------------------------------------------------------------------------"
    
    
    ## ## to get the date and rating
    ## for post in d.entries:
    ##     print post.title
    ##     print "------------------------------------------------------------------------------"
    
    
    ## ## to get the date and rating
    ## for post in d.entries:
    ##     print post.summary
    ##     print "------------------------------------------------------------------------------"
    
    ## to get the date and rating
    for post in d.entries:
        title    = post.title
        summary  = post.summary
        rating   = extract_rating(title)
        reviewer = extract_reviewer(title)
        dt       = extract_date(title)
        print "|".join([str(val) for val in [agent, dt, rating, reviewer, summary]])
        #print "------------------------------------------------------------------------------"

