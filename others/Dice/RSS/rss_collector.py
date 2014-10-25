"""
    extract rss data from http://www.allagents.co.uk/rss/
"""

import re
import feedparser
from datetime import datetime

BASEURL  = 'http://www.allagents.co.uk/rss/{agency}/'
AGENCIES = ['choices',
            'manning-stainton',
            'reeds-rains',
            'bradleys-estate-agents']


def extract_date(title):
    """
    it extracts the date from the review title as YYYY-MM-DD
    """
    p = re.compile("(\d+/\d+/\d+)")
    m = p.search(title)
    if not m:
        return None
    else:
        dt = datetime.strptime(m.group(1), "%d/%m/%Y")
        return datetime.strftime(dt, "%Y-%m-%d")


def extract_rating(title):
    """
    it extracts the ration score from the review title (interger from 1 to 5)
    """
    p = re.compile("(\d) star")
    m = p.search(title) 
    if not m:
        return None
    else:
        return m.group(1)


def extract_reviewer(title):
    """
    it extracts the reviewer name from the review title
    """
    p = re.compile("\d+/\d+/\d+ - (.+) rated")
    m = p.search(title) 
    if not m:
        return None
    else:
        return m.group(1)


if __name__ == '__main__':
    
    # print header
    print "\t".join(['agent', 'date', 'rating', 'reviewer', 'summary'])
    
    ## extract and print rss entries containing all the desired
    ## information
    for agent in AGENCIES:
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

