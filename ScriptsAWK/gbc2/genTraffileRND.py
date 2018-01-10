#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- coding: utf-8 -*-
import scipy as sp
import numpy as np
import networkx as nx
import random as rnd
import os
import matplotlib.pyplot as plt
import math
import sys

def printf(fmt, *varargs):
    sys.stdout.write(fmt % varargs)


def main():
    LOG = False

    if (len(sys.argv) != 4):
            print "ERROR: genTraffile.py <nodes> <iter> <simtime>"
            sys.exit(1)

    CEN = int(sys.argv[1])
    ITE = int(sys.argv[2])
    SIM = int(sys.argv[3])
    
    if (ITE < 0):
            print "ERROR: At least select one iteration"
            sys.exit(1)

    filename='/home/rml/work/dataset/'+str(CEN)+'nodes/topo'+str(ITE)+'.ini'
    if ( not os.path.exists(filename) ):
            print "ERROR: No scenario available"
            sys.exit(1)

    firstLine = next(open(filename, 'r'))
    parts = firstLine.split()
    NMAX=int(parts[1])
    print "NMAX=",NMAX
    qid=0
    fgbc=open("./traffileGBCtmp", "w")
    fbcir=open("./traffileBCIRtmp", "w")
    fflood=open("./traffileFLOODtmp", "w")
    for i in range(1, 6):
            qid+=1
            inicio=rnd.randrange(20,900)
            fgbc.writelines("$ns_ at %d \"$gbc_(%d) gbcsearch %d %d 1000 1\"\n" % (inicio,i,qid,i+2))
#    for i in range(0, NMAX):
    i=0
    for k in range(0, 200):
            qid+=1
            time=rnd.randrange(1000,SIM)
            source=rnd.randrange(0,NMAX-1)
            resource=rnd.randrange(1,NMAX)
            if (source+1!=resource):
                fgbc.writelines("$ns_ at %d \"$gbc_(%d) gbcsearch %d %d 1000 1\"\n" % (time,source,qid,resource))
                fbcir.writelines("$ns_ at %d \"$gbc_(%d) bcirsearch %d %d 1000 1\"\n" % (time,source,qid,resource))
                fflood.writelines("$ns_ at %d \"$gbc_(%d) floodsearch %d %d 1000 1\"\n" % (time,source,qid,resource))
    fgbc.close()
    fbcir.close()
    fflood.close()
    
    return 0


if __name__ == "__main__":
    print main()
