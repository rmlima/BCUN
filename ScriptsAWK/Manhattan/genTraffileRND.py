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

    if (len(sys.argv) != 2):
        print "ERROR: genTraffileRND.py <events>"
        sys.exit(1)

    NMAX = 250
    EVENTS = int(sys.argv[1])
	
    SIM=100+(EVENTS+1)*10
    
    qid=0
    fgbc=open("./traffileGBCtmp", "w")
    fbcir=open("./traffileBCIRtmp", "w")
    fbcir2=open("./traffileBCIR2tmp", "w")
    fflood=open("./traffileFLOODtmp", "w")
    for i in range(1, 6):
            qid+=1
            time=i*10
            initiator=rnd.randrange(0,NMAX)
            resource=rnd.randrange(0,NMAX)
            while (resource==initiator+1):
                    resource=rnd.randrange(0,NMAX)
            fgbc.writelines("$ns_ at %d \"$gbc_(%d) gbcsearch %d %d 1000 1\"\n" % (time,initiator,qid,resource))
    for i in range(0, EVENTS):
            qid+=1
            time=100+(i*10)
            initiator=rnd.randrange(0,NMAX-1)
            resource=rnd.randrange(1,NMAX)
            while (resource==initiator+1):
                    resource=rnd.randrange(0,NMAX-1)
            fgbc.writelines("$ns_ at %d \"$gbc_(%d) gbcsearch %d %d 1000 1\"\n" % (time,initiator,qid,resource))
            fbcir2.writelines("$ns_ at %d \"$gbc_(%d) bcir2search %d %d 1000 1\"\n" % (time,initiator,qid,resource))
            fbcir.writelines("$ns_ at %d \"$gbc_(%d) bcirsearch %d %d 1000 1\"\n" % (time,initiator,qid,resource))
            fflood.writelines("$ns_ at %d \"$gbc_(%d) floodsearch %d %d 1000 1\"\n" % (time,initiator,qid,resource))
    fgbc.close()
    fbcir.close()
    fbcir2.close()
    fflood.close()
    return 0

if __name__ == "__main__":
    print main()
