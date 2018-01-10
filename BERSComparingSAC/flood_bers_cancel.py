# -*- coding: utf-8 -*-
import scipy as sp
import numpy as np
import networkx as nx
import random as rnd
import mapi
import display
import bar
import os
import time
from datetime import date
#import redestipicas

start_time = time.clock()

#GENERAL DEFINITIONS
LOG = False             #Show log data
ITERATIONS=20      #Number of Iterations
NMAX=100                 #Number of nodes
raio=0.16              #Distance to connect nodes in RandomGeo
MIN_Resource_Ratio=1    #Resources ratio distribution
MAX_Resource_Ratio=85 
m=2                     #Barabasi
delay=10
HOPS=9

flood_hops_latency=[]
flood_hops_overhead=[]
bers_hops_latency=[]
bers_hops_overhead=[]
bers2_hops_latency=[]
bers2_hops_overhead=[]
bcir_hops_overhead=[]
bcir2_hops_overhead=[]
for i in range(HOPS):
        flood_hops_latency.append([])
        flood_hops_overhead.append([])
        bers_hops_latency.append([])
        bers_hops_overhead.append([])
        bers2_hops_latency.append([])
        bers2_hops_overhead.append([])
        bcir_hops_overhead.append([])
        bcir2_hops_overhead.append([])




RMIN=1
RMAX=int(round(MAX_Resource_Ratio*NMAX/100,0))

#Progress Simulation Bar
prog = bar.progressBar(RMIN, RMAX, 77)

#Data graph collector for the same parameter in several iterations
flood_avg_overhead = []
ers_avg_overhead = []
ers_ttl_avg_overhead = []
bers_avg_overhead = []
bers2_avg_overhead = []
cancel2htarget_avg_overhead = []
canceltarget_avg_overhead = []
flood_std_overhead = []
ers_std_overhead = []
ers_ttl_std_overhead = []
bers_std_overhead = []
bers2_std_overhead = []
cancel2htarget_std_overhead = []
canceltarget_std_overhead = []



flood_avg_latency = []
ers_avg_latency = []
ers_ttl_avg_latency = []
bers_avg_latency = []
bers2_avg_latency = []
cancel2htarget_avg_latency = []
canceltarget_avg_latency = []
flood_std_latency = []
ers_std_latency = []
ers_ttl_std_latency = []
bers_std_latency = []
bers2_std_latency = []
cancel2htarget_std_latency = []
canceltarget_std_latency = []


normalizado_avg_overhead=[]
normalizado_std_overhead=[]

# Number of resources in the network for simulation
for resources in range(RMIN,RMAX):

        prog.updateAmount(resources)
        print prog,"\r",
        # Number of times simulation is executed
        #  Network with the same number of nodes
        #Data structure for each simulation
        floodgraph_overhead = []
        ersgraph_overhead = []
        ers_ttlgraph_overhead = []
        bersgraph_overhead = []
        bers2graph_overhead = []
        cancel2htargetgraph_overhead = []
        canceltargetgraph_overhead = []
        
        floodgraph_latency = []
        ersgraph_latency = []
        ers_ttlgraph_latency = []
        bersgraph_latency = []
        bers2graph_latency = []
        cancel2htargetgraph_latency = []
        canceltargetgraph_latency = []

        normalizado_arr=[]
        
        # Several iterations for the same number of resources
        for iteraction in range(0,ITERATIONS):
                #Initializations for each simulation
                resourcenodes = []      #Nodes with resource targets
                all=[]                  #List of all nodes
                #Simulation result lists - Clear previous results
                flood_result=[]
                ers_result=[]
                ers_ttl_result=[]
                bers_result=[]
                bers2_result=[]
                cancel_result=[]
                cancel2h_result=[]
                diam=0
                m=2
                
                # Graph generator
                G=nx.random_geometric_graph(NMAX,raio,dim=2)
                #G=nx.barabasi_albert_graph(NMAX,m)
                while not nx.is_connected(G):
                        G=nx.random_geometric_graph(NMAX,raio)
                        if LOG: print "Graph in not full connected - Generate a new one"

                #pos=G.pos
                #Generate a list of all nodes
                for node in G:
                        all.append(node)    

                #Generate sample resource nodes
                #resources=int(round(NMAX*resourcesRatio/100, 0))
                resourcenodes = rnd.sample(all, resources)
                #resourcenodes = [NMAX-1]
                #resourcenodes.append(4)
                #resourcenodes = [4]
                if LOG: print "Resources:",resourcenodes

                #Generate de initiator node
                initiator=rnd.randint(0,NMAX-1)
                #initiator=0                
                if LOG: print "Initiator node:",initiator
                #Generate another initiator if it has the resource
                while initiator in resourcenodes :
                        initiator=rnd.randint(0,NMAX-1)
                        if LOG: print "Initiator Node has Target - Generate a new one"   

                if LOG: print "Depois do While"  
                #Simultion modules
                flood_result = mapi.flood(G,initiator,resourcenodes)

                # Diameter - Obtain after flood
                diam=flood_result[5]
                
                ers_result = mapi.ers(G,initiator,resourcenodes)
                if LOG: print "Depois 1" 
                ers_ttl_result = mapi.ers_ttl(G,initiator,resourcenodes,NMAX-1)
                if LOG: print "Depois 2" 
                bers_result = mapi.bers(G,initiator,resourcenodes)
                if LOG: print "Depois 3" 
                bers2_result = mapi.bers2(G,initiator,resourcenodes)
                if LOG: print "Depois 4" 
                cancel2h_result = mapi.cancel2htarget(G,initiator,resourcenodes)
                if LOG: print "Depois 5" 
                cancel_result = mapi.canceltarget(G,initiator,resourcenodes)
                

                #Simulation LOG
                if LOG: print "**** Result from FLOOD: ****"
                if LOG: print "Time until source receive the answer   - Latency  :",flood_result[0]
                if LOG: print "Total transmissions until stop process - Overhead :",flood_result[1]
                if LOG: print "Number of HOPs until found ........... - HOPS     :",flood_result[2]
                if LOG: print "Time until all stop .................. - Total    :",flood_result[3]
                if LOG: print "Transmitions until found ............. - Trans    :",flood_result[4]
                if LOG: print "Network Diameter ..................... - Diameter :",flood_result[5]

                if LOG: print "**** Result from ERS: ****"
                if LOG: print "Time until source receive the answer   - Latency  :",ers_result[0]
                if LOG: print "Total transmissions until stop process - Overhead :",ers_result[1]
                if LOG: print "Number of HOPs until found ........... - HOPS     :",ers_result[2]
                if LOG: print "Time until all stop .................. - Total    :",ers_result[3]
                if LOG: print "Transmitions until found ............. - Trans    :",ers_result[4]

                if LOG: print "**** Result from ERS-TTL: ****"
                if LOG: print "Time until source receive the answer   - Latency  :",ers_ttl_result[0]
                if LOG: print "Total transmissions until stop process - Overhead :",ers_ttl_result[1]
                if LOG: print "Number of HOPs until found ........... - HOPS     :",ers_ttl_result[2]
                if LOG: print "Previous Transmitions ................ - P Trans  :",ers_ttl_result[3]
                if LOG: print "Transmitions until found ............. - Trans    :",ers_ttl_result[4]

                if LOG: print "**** Result from BERS: ****"
                if LOG: print "Time until source receive the answer   - Latency  :",bers_result[0]
                if LOG: print "Total transmissions until stop process - Overhead :",bers_result[1]
                if LOG: print "Number of HOPs until found ........... - HOPS     :",bers_result[2]
                if LOG: print "Time until all stop .................. - Total    :",bers_result[3]
                if LOG: print "Transmitions until found ............. - Trans    :",bers_result[4]

                if LOG: print "**** Result from BERS*: ****"
                if LOG: print "Time until source receive the answer   - Latency  :",bers2_result[0]
                if LOG: print "Total transmissions until stop process - Overhead :",bers2_result[1]
                if LOG: print "Number of HOPs until found ........... - HOPS     :",bers2_result[2]
                if LOG: print "Time until all stop .................. - Total    :",bers2_result[3]
                if LOG: print "Transmitions until found ............. - Trans    :",bers2_result[4]

                if LOG: print "**** Result from BROADCAST CANCELLATION: ****"
                if LOG: print "Time until source receive the answer   - Latency  :",cancel_result[0]
                if LOG: print "Total transmissions until stop process - Overhead :",cancel_result[1]
                if LOG: print "Number of HOPs until found ........... - HOPS     :",cancel_result[2]
                if LOG: print "Time until all stop .................. - Total    :",cancel_result[3]
                if LOG: print "Transmitions until found ............. - Trans    :",cancel_result[4]

                if LOG: print "Number of Nodes: ",NMAX," Iteration = ",iteraction
                
                #Store each iteration result in a list
                # floodgraph.append(flood_result[3]) #Contar mesgs ate ao iniciador

                floodgraph_latency.append(flood_result[0])
                ersgraph_latency.append(ers_result[0])
                ers_ttlgraph_latency.append(ers_ttl_result[0])
                bersgraph_latency.append(bers_result[0])
                bers2graph_latency.append(bers2_result[0])
                cancel2htargetgraph_latency.append(cancel2h_result[0])
                canceltargetgraph_latency.append(cancel_result[0])
                
                floodgraph_overhead.append(flood_result[1])
                ersgraph_overhead.append(ers_result[1])
                ers_ttlgraph_overhead.append(ers_ttl_result[1])
                bersgraph_overhead.append(bers_result[1])
                bers2graph_overhead.append(bers2_result[1])
                cancel2htargetgraph_overhead.append(cancel2h_result[1])
                canceltargetgraph_overhead.append(cancel_result[1])

                if flood_result[2] < HOPS :
                        flood_hops_latency[flood_result[2]].append(flood_result[0])
                        flood_hops_overhead[flood_result[2]].append(flood_result[1])
                if bers_result[2] < HOPS :
                        bers_hops_latency[bers_result[2]].append(bers_result[0])
                        bers_hops_overhead[bers_result[2]].append(bers_result[1])
                if bers2_result[2] < HOPS :
                        bers2_hops_latency[bers2_result[2]].append(bers2_result[0])
                        bers2_hops_overhead[bers2_result[2]].append(bers2_result[1])
                if cancel2h_result[2] < HOPS :
                        bcir_hops_overhead[cancel2h_result[2]].append(cancel2h_result[1])
                if cancel_result[2] < HOPS :
                        bcir2_hops_overhead[cancel_result[2]].append(cancel_result[1])

                

        #Store average of the OVERHEAD results for each network
        arr=sp.array(floodgraph_overhead)
        flood_avg_overhead.append(arr.mean())
        flood_std_overhead.append(arr.std())
        
        arr=sp.array(ersgraph_overhead)
        ers_avg_overhead.append(arr.mean())
        ers_std_overhead.append(arr.std())
        
        arr=sp.array(ers_ttlgraph_overhead)
        ers_ttl_avg_overhead.append(arr.mean())
        ers_ttl_std_overhead.append(arr.std())
        
        arr=sp.array(bersgraph_overhead)
        bers_avg_overhead.append(arr.mean())
        bers_std_overhead.append(arr.std())
        
        arr=sp.array(bers2graph_overhead)
        bers2_avg_overhead.append(arr.mean())
        bers2_std_overhead.append(arr.std())
        
        arr=sp.array(cancel2htargetgraph_overhead)
        cancel2htarget_avg_overhead.append(arr.mean())
        cancel2htarget_std_overhead.append(arr.std())
        
        arr=sp.array(canceltargetgraph_overhead)
        canceltarget_avg_overhead.append(arr.mean())
        canceltarget_std_overhead.append(arr.std())
        

        #Store LATENCY average results for each network
        arr=sp.array(floodgraph_latency)
        flood_avg_latency.append(arr.mean())
        flood_std_latency.append(arr.std())

        arr=sp.array(ersgraph_latency)
        ers_avg_latency.append(arr.mean())
        ers_std_latency.append(arr.std())
        
        arr=sp.array(ers_ttlgraph_latency)
        ers_ttl_avg_latency.append(arr.mean())
        ers_ttl_std_latency.append(arr.std())
        
        arr=sp.array(bersgraph_latency)
        bers_avg_latency.append(arr.mean())
        bers_std_latency.append(arr.std())
        
        arr=sp.array(bers2graph_latency)
        bers2_avg_latency.append(arr.mean())
        bers2_std_latency.append(arr.std())
        
        arr=sp.array(cancel2htargetgraph_latency)
        cancel2htarget_avg_latency.append(arr.mean())
        cancel2htarget_std_latency.append(arr.std())
        
        arr=sp.array(canceltargetgraph_latency)
        canceltarget_avg_latency.append(arr.mean())
        canceltarget_std_latency.append(arr.std())


        
        
        for elem in range(0,ITERATIONS):
                normalizado_arr.append(cancel2htargetgraph_overhead[elem]/NMAX)

        arr=sp.array(normalizado_arr)
        normalizado_avg_overhead.append(arr.mean())
        normalizado_std_overhead.append(arr.std())
 

        
#END OF SIMULATION
        
x=range(RMIN,RMAX)
DataOut_BERS = np.column_stack((x,bers_avg_overhead,bers_std_overhead))

DATAFILE_BERS='./results/outputBERS.dat'
PLOTFILE_BERS='./results/graficoBERS.png'
np.savetxt(DATAFILE_BERS, DataOut_BERS)

#DataOut_BC = np.column_stack((x,normalizado_avg_overhead,normalizado_std_overhead))
DataOut_BC = np.column_stack((x,cancel2htarget_avg_overhead,cancel2htarget_std_overhead))
DATAFILE_BC='./results/outputBC.dat'
PLOTFILE_BC='./results/graficoBC.png'
np.savetxt(DATAFILE_BC, DataOut_BC)


#LOWER=35
#UPPER=36.5

f=os.popen('gnuplot' ,'w')
print >>f, "set xlabel 'Densidade de Recursos (%)'; set ylabel 'Taxas de Retransmissão'"
print >>f, "plot '%s' using 1:2:3 with yerrorbars title 'BCIR' lw 3" % DATAFILE_BC
print >>f, "set terminal png enhanced font 'Vera,14'"
print >>f, "set out '%s'" % PLOTFILE_BC
print >>f, "pause 2; replot"
f.flush()

f=os.popen('gnuplot' ,'w')
print >>f, "set xlabel 'Densidade de Recursos (%)'; set ylabel 'Taxas de Retransmissão'"
print >>f, "plot '%s' using 1:2:3 with yerrorbars title 'BERS' lw 3" % DATAFILE_BERS
print >>f, "set terminal png enhanced font 'Vera,14'"
print >>f, "set out '%s'" % PLOTFILE_BERS
print >>f, "pause 2; replot"
f.flush()

display.latency(RMIN, RMAX, flood_avg_latency,
                ers_avg_latency, ers_ttl_avg_latency, bers_avg_latency,
                bers2_avg_latency, cancel2htarget_avg_latency, canceltarget_avg_latency)

display.latency2(RMIN, RMAX, flood_avg_latency,
                ers_avg_latency, ers_ttl_avg_latency, bers_avg_latency,
                bers2_avg_latency, cancel2htarget_avg_latency, canceltarget_avg_latency)


display.overhead(RMIN, RMAX, flood_avg_overhead,
                 ers_avg_overhead, ers_ttl_avg_overhead, bers_avg_overhead,
                bers2_avg_overhead, cancel2htarget_avg_overhead, canceltarget_avg_overhead,NMAX)

display.overhead2(RMIN, RMAX, bers_avg_overhead, cancel2htarget_avg_overhead, bers2_avg_overhead, canceltarget_avg_overhead,NMAX)

display.ratio(RMIN, RMAX, bers_avg_latency,
                bers2_avg_latency, bers_avg_overhead, bers2_avg_overhead, cancel2htarget_avg_latency,
                canceltarget_avg_latency, cancel2htarget_avg_overhead, canceltarget_avg_overhead )

display.latency3(RMIN, RMAX, flood_avg_latency, bers_avg_latency, bers2_avg_latency)

display.overhead3(RMIN, RMAX, flood_avg_overhead, bers_avg_overhead, cancel2htarget_avg_overhead,
              bers2_avg_overhead, canceltarget_avg_overhead, NMAX)


display.hops(flood_hops_latency, flood_hops_overhead, bers_hops_latency, bers_hops_overhead,
             bers2_hops_latency, bers2_hops_overhead, bcir_hops_overhead, bcir2_hops_overhead, HOPS, NMAX)

#Write LOG File
# Open a file
fo = open("./results/log.txt", "wb")
today = str(date.today())
fo.write( "Simulation Log ##### Date: ")
fo.write( today)
fo.write( "\n");
fo.write( "Random Geometric:\n");
fo.write( "NMAX=")
fo.write( str(NMAX))
fo.write( "\n");
fo.write( "m=")
fo.write( str(m))
fo.write( "\n");
fo.write( "\nSimulation:\n");
fo.write( "ITERATIONS=")
fo.write( str(ITERATIONS))
fo.write( "\n");
fo.write( "Duration=")
duration = int(time.clock() - start_time)
fo.write( str(duration) )
fo.write( "seconds\n");
# Close opend file
fo.close()

#Display the last network used
display.network(G,initiator,resourcenodes)

#END
