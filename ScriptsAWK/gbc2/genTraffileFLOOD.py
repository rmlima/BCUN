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

    if (len(sys.argv) != 3):
            print "ERROR: genTraffileFLOOD.py <nodes> <iter>"
            sys.exit(1)

    CEN = int(sys.argv[1])
    ITE = int(sys.argv[2])
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
    with open("./traffile", "w") as fc:
        for i in range(0, NMAX):
	    for k in range(1, NMAX+1):
		if (i+1!=k):
		    qid+=1
		    fc.writelines("$ns_ at %d \"$gbc_(%d) floodsearch %d %d 1000 1\"\n" % (qid*10,i,qid,k))
    fc.close()


if __name__ == "__main__":
    print main()
