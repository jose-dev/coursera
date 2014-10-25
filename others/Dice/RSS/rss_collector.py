#
# RSS obtained from http://www.allagents.co.uk/rss/
#
# python docs:
#   - http://www.pythonforbeginners.com/feedparser/using-feedparser-in-python
#
#

import re
import feedparser
from datetime import datetime

BASEURL = 'http://www.allagents.co.uk/rss/{agency}/'
agencies = ['choices',
            'manning-stainton',
            'reeds-rains',
            'bradleys-estate-agents']


def extract_date(title):
    p = re.compile("(\d+/\d+/\d+)")
    m = p.search(title)
    if not m:
        return None
    else:
        dt = datetime.strptime(m.group(1), "%d/%m/%Y")
        return datetime.strftime(dt, "%Y-%m-%d")


def extract_rating(title):
    p = re.compile("(\d) star")
    m = p.search(title) 
    if not m:
        return None
    else:
        return m.group(1)


def extract_reviewer(title):
    p = re.compile("\d+/\d+/\d+ - (.+) rated")
    m = p.search(title) 
    if not m:
        return None
    else:
        return m.group(1)


if __name__ == '__main__':
    
    # print header
    print "\t".join(['agent', 'date', 'rating', 'reviewer', 'summary'])
    
    ## print formatted rss data
    for agent in agencies:
        url = BASEURL.format(agency=agent)
        d = feedparser.parse(url)
    
        for post in d.entries:
            title    = post.title
            summary  = post.summary.replace('\n', ' ').replace('\r', '')
            rating   = extract_rating(title)
            reviewer = extract_reviewer(title)
            dt       = extract_date(title)
            if not rating or not reviewer or not dt:
                continue
            else:    
                try:
                    print "\t".join([str(val) for val in [agent, dt, rating, reviewer, summary]])
                except Exception:
                    pass

