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
import shutil

def nodeMaxDegree(G):
    degree=0
    for n in G.nodes():
        if nx.degree(G,n)> degree :
            degree=nx.degree(G,n)
            node=n
    return node

def nodeSolo(G,n):
    solo=False
    for test in G.neighbors(n):
        if nx.degree(G,test)==1 :
            solo=True
    return solo

def nodeNear(G,delta):
    f=10000
    pos=nx.get_node_attributes(G,'pos')
    for n in pos:
        x1,y1=pos[n]
        for i in G.neighbors(n):
            x2,y2=pos[i]
            d=(x1-x2)**2+(y1-y2)**2
            if d<delta:
                f=n #f=i
                return f
    return f
        

def network(G,pos,seq):
    plt.clf()
    nx.draw_networkx_nodes(G,pos,node_size=50,node_color='#FFFF00') 
    nx.draw_networkx_edges(G,pos)
#    nx.draw_networkx_labels(G,pos)
    plt.axis('off')
    plt.savefig("./network.pdf", dpi = 300)
    #plt.show()
    return True


def main():
    LOG = False

    if (len(sys.argv) != 5):
            print "ERROR: genMina.py <nodes> <radius> <delta> <maxdegree>"
            sys.exit(1)

    NMAX = int(sys.argv[1])
    RAIO = float(sys.argv[2])
    delta = float(sys.argv[3])
    degree = float(sys.argv[4])
    #NMAX=40
    #RAIO=0.1
    ALCANCE=250
    c=0
    run=True
    first=True
    while run:
        c+=1
        G=nx.random_geometric_graph(NMAX,RAIO,2)

        while not nx.is_connected(G):
            if first:
                RAIO=RAIO+.005
            G=nx.random_geometric_graph(NMAX,RAIO,2)
            if LOG: print c,"- Radius: Graph is not full connected R=",RAIO
        first=False
	pos=nx.get_node_attributes(G,'pos')
	network(G,pos,5)
        shutil.copy2('./network.pdf', './networkA.pdf')

        #Remove vizinhos que estejam demasiado pertoc
        candidate=nodeNear(G,delta)
        
        while not candidate==10000 :
                G.remove_node(candidate)
                candidate=nodeNear(G,delta)
        if nx.is_connected(G):
            #Remove no que tem mais vizinhos
            candidate=nodeMaxDegree(G)
            while nx.degree(G,candidate)> degree :
                    G.remove_node(candidate)
                    candidate=nodeMaxDegree(G)    
            if nx.is_connected(G):
                run=False
            else:
                if LOG: print c,"- MaxDegree: Split Graph"
        else:
            if LOG: print c,"- nodeNear: Split Graph"

    G=nx.convert_node_labels_to_integers(G)

    pos=nx.get_node_attributes(G,'pos')
    network(G,pos,5)
    shutil.copy2('./network.pdf', './networkB.pdf')
    print "Radius Final:",RAIO
    print "Mine Nodes:",G.number_of_nodes()

    #return int(np.ceil(ZOOM/1000)*1000)
    return True

if __name__ == "__main__":
    print main()
