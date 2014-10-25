"""
construct a tree from a given set of pairwise relations

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


class node():
    """
    Defines a node with a name and a list of all its children.
    """
    def __init__(self, value):
        self.name     = value
        self.children = []

    def add_child(self, obj):
        self.children.append(obj)
    

def jdefault(o):
    return o.__dict__


def find_tree_root(edges):
    """
    Given a list of edges [child, parent], return the root of
    the tree. It assumes that there is only one root/tree.
    """
    children = []
    parents  = []
    for edge in edges:
        children.append(edge['child'])
        parents.append(edge['parent'])

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
    
    # select the root node as its list of children contains the tree 
    tree = o_nodes[find_tree_root(edges)]
    
    ## print data structure to confirm that it gives the expected output
    print(json.dumps(tree, default=jdefault, indent=4))
    

