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

import feedparser

baseurl = 'http://www.allagents.co.uk/rss/{agency}/'
#agencies = ['richard-worth', 'redlet', 'reed-residential']
agencies = ['redlet']


for agent in agencies:
    url = baseurl.format(agency=agent)
    d = feedparser.parse(url)
    #print d
    #print len(d['entries'])
    
    ## ## to get the date and rating
    ## for post in d.entries:
    ##     #print post
    ##     print post.title
    ##     print "------------------------------------------------------------------------------"
    

    
    ## ## to get the date and rating
    ## for post in d.entries:
    ##     #print post
    ##     print post.summary
    ##     print "------------------------------------------------------------------------------"
    

