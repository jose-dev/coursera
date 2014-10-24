"""
[
    {parent: 'London',     child: 'Brixton'},
    {parent: 'UK',         child: 'England'},
    {parent: 'Shoreditch', child: 'Telephone House'},
    {parent: 'UK',         child: 'Scotland'},
    {parent: 'London',     child: 'Shoreditch'},
    {parent: 'England',    child: 'London'}
]

...you return an object with the following structure:

{ name: 'UK', children: [
    { name: 'Scotland'},
    { name: 'England', children: [
        { name: 'London', children: [
            { name: 'Shoreditch': children: [
                { name: 'Telephone House' }
            ]},
            { name: 'Brixton'}
        ]
    }
    }]
}
"""

import json
import pprint

class node():
    def __init__(self, value):
        self.name     = value
        self.children = []

    def add_child(self, obj):
        self.children.append(obj)
        
    def __str__(self):
        from pprint import pprint
        return str((vars(self)))
    

def jdefault(o):
    return o.__dict__


def find_tree_root(edges):
    """Given a list of edges [child, parent], return trees. """
    medges = []
    for edge in edges:
        child = edge['child']
        parent = edge['parent']
        medges.append([child, parent])

    children, parents = zip(*medges)
    root = set(parents).difference(children)

    return list(root)[0]



if __name__ == '__main__':
    edges = [
        {'parent': 'London',     'child': 'Brixton'},
        {'parent': 'UK',         'child': 'England'},
        {'parent': 'Shoreditch', 'child': 'Telephone House'},
        {'parent': 'UK',         'child': 'Scotland'},
        {'parent': 'London',     'child': 'Shoreditch'},
        {'parent': 'England',    'child': 'London'}
    ]

    # get all node names
    nodes = {}
    for edge in edges:
        nodes[edge['child']]  = 1
        nodes[edge['parent']] = 1

    # create an object for each node and add all their children
    o_nodes = dict((n, node(n)) for n in nodes.keys())
    for edge in edges:
        o_nodes[edge['parent']].add_child(o_nodes[edge['child']])
    
    # select just the tree which first element is the main root 
    tree = o_nodes[find_tree_root(edges)]
    
    ## print data structure
    print(json.dumps(tree, default=jdefault, indent=4))
    

