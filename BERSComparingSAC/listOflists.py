# -*- coding: utf-8 -*-
import scipy as sp
import numpy as np
import networkx as nx
import random as rnd
import os
import time
hops=[]

for i in range(3):
        hops.append([])

#hops.append([1,2])
#hops.append([3,4,5])

hops[0].append(6)

hops[2].append(2)
hops[2].append(4)

arr1=sp.array(hops[2])
print arr1.mean()


print hops

#END
