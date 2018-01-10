#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- coding: utf-8 -*-
import sys


def main():
    LOG = False

    if (len(sys.argv) != 2):
            print "ERROR: genGrid.py <Lnodes> , for LxL grid"
            sys.exit(1)

    L = int(sys.argv[1])
    DISTN=200 #Minimal Node Distance (Square Grid)
    NMAX=L*L  #Square
    i=0
    if LOG: print "NODES=",NMAX
    with open("./cenario", "w") as fc:
        for n in range(0,L):
            for m in range(0,L):
                fc.writelines("$node_(%d) set X_ %d\n" % (i,DISTN*(n+1)))
                fc.writelines("$node_(%d) set Y_ %d\n" % (i,DISTN*(m+1)))
                fc.writelines("$node_(%d) set Z_ 0.0\n" % i)
                i+=1
    fc.close()
    return True

if __name__ == "__main__":
    print main()
