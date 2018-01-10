#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- coding: utf-8 -*-
import scipy as sp
import numpy as np
import networkx as nx
import random as rnd
import matplotlib.pyplot as plt
import math
import sys

def printf(fmt, *varargs):
    sys.stdout.write(fmt % varargs)

def transmission_range():
#    return 350
    return 245

def network(G,lerinicial,lerfinal,pos):
    import networkx as nx
    import matplotlib.pyplot as plt
    #import numpy as plt

    plt.clf()
    LOG = False

    nx.draw_networkx_nodes(G,pos,node_color='#FFFF00')
    nx.draw_networkx_nodes(G,pos,nodelist=[lerinicial],node_color='g')
    #for i in range(0,len(lerfinal)):
    #    nx.draw_networkx_nodes(G,pos,nodelist=[lerfinal[i]],node_color='r')
    nx.draw_networkx_nodes(G,pos,nodelist=[lerfinal],node_color='r')    

    nx.draw_networkx_edges(G,pos)
    nx.draw_networkx_labels(G,pos)
    plt.axis('off')

    
    #pos = nx.random_layout(G)
    #pos = nx.spring_layout(G)
    # Display Graph
    #nx.draw_networkx_nodes(G,node_color='#FFFF00')        
    #nx.draw_networkx_edges(G,pos)
    #nx.draw_networkx_labels(G,pos)
    #nx.draw(G,node_color='#FFFF00')
    
    plt.savefig("./network.png")
    
#    plt.show()
    #END

    return True


def main():
    LOG = False

    if (len(sys.argv) != 2):
            print "ERROR: genRandomGeo <nodes>"
            sys.exit(1)

    NMAX = int(sys.argv[1])
    SIDE=0
    # To get CONNECTIVITY
    raio=math.sqrt(math.log(NMAX)/(math.pi*NMAX))

    G=nx.random_geometric_graph(NMAX,raio,2)

    while not nx.is_connected(G):
         raio=raio+.005
         G=nx.random_geometric_graph(NMAX,raio,2)
         if LOG: print "Graph is not full connected"

    if LOG: print "Graph is not full connected"
    SIDE=int(transmission_range()/raio)
    if LOG: print "SIDE=",SIDE
    if LOG: print "Radius=",raio

    resourcenodes = []      #Nodes with resource targets
    all =[]                  #List of all nodes

    #pos = nx.graphviz_layout(G)
    pos = nx.spring_layout(G)
    #pos = nx.fruchterman_reingold_layout(G)

    #print pos
    if LOG: print "Diameter = ",nx.diameter(G)

    with open("cenario", "w") as fc:
        for i in range(0, NMAX):
                fc.writelines("$node_(%d) set X_ %d\n" % (i,pos[i][0]*SIDE))
                fc.writelines("$node_(%d) set Y_ %d\n" % (i,pos[i][1]*SIDE))
                fc.writelines("$node_(%d) set Z_ 0.0\n" % i)
    fc.close()

    network(G,0,NMAX-1,pos)

    return SIDE

if __name__ == "__main__":
    print main()
