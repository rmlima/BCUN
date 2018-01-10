# -*- coding: utf-8 -*-
def latency(MIN_Resource_Ratio, MAX_Resource_Ratio, flood_avg_latency, 
            bers_avg_latency, bers2_avg_latency):
    import os
    import numpy as np
    
    LOG = False

    NMAX=1
    flood_avg_latency_norm=[]
    bers_avg_latency_norm=[]
    bers2_avg_latency_norm=[]

    for elem in range(MIN_Resource_Ratio, MAX_Resource_Ratio):
        flood_avg_latency_norm.append(flood_avg_latency[elem-1]/NMAX)
        bers_avg_latency_norm.append(bers_avg_latency[elem-1]/NMAX)
        bers2_avg_latency_norm.append(bers2_avg_latency[elem-1]/NMAX)

    #horgraph = range(MIN_Resource_Ratio,MAX_Resource_Ratio)
    horgraph = range(MIN_Resource_Ratio,MAX_Resource_Ratio)

    DataOut_LAT = np.column_stack((horgraph,flood_avg_latency_norm, 
            bers_avg_latency_norm, bers2_avg_latency_norm))

    DATAFILE_LAT='./results/latency3.dat'
    PLOTFILE_LAT='./results/latency3.png'
    np.savetxt(DATAFILE_LAT, DataOut_LAT)

    if LOG: print "X=",horgraph
    if LOG: print "Flooding=",flood_avg_latency_norm
    if LOG: print "Blocking ERS =",bers_avg_latency_norm
    if LOG: print "Enhanced BERS=",bers2_avg_latency_norm

    #Display Latency
##    f=os.popen('gnuplot' ,'w')
##    print >>f, "set xrange [0:40]"
##    print >>f, "set border 3 back ls 11"
##    print >>f, "set style line 11 lc rgb '#808080' lt 1"
##    print >>f, "set border 3 back ls 11"
##    print >>f, "set tics nomirror"
##    print >>f, "set style data linespoints"
##    print >>f, "set style line 12 lc rgb '#808080' lt 0 lw 1"
##    print >>f, "set grid back ls 12"
##    print >>f, "set style line 1 lc rgb '#8b1a0e' pt 1 ps 2 lt 1 lw 2"
##    print >>f, "set style line 2 lc rgb '#5e9c36' pt 6 ps 2 lt 1 lw 2"
##    print >>f, "set style line 3 lc rgb '#191970' pt 4 ps 2 lt 1 lw 2"
##    print >>f, "set key top right"
##    print >>f, "set xlabel 'Resource Density (%)'; set ylabel 'Latency (#slots)'"
##    print >>f, "plot \"latency3.dat\" using 1:3 ti \"BERS \; BCIR\" w lp ls 1, \"latency3.dat\" using 1:4 ti \"BERS* ; BCIR*\" w lp ls 2, \"latency3.dat\" using 1:2 ti \"Flooding\" w lp ls 3"
##    print >>f, "set terminal png enhanced font 'Verdana,14'"
##    print >>f, "set out '%s'" % PLOTFILE_LAT
##    print >>f, "pause 2; replot"
##    f.flush()
##        
    return True




def overhead(MIN_Resource_Ratio, MAX_Resource_Ratio, flood_avg_overhead,
              bers_avg_overhead, cancel2htarget_avg_overhead,
              bers2_avg_overhead, canceltarget_avg_overhead, NMAX):

    import os
    import numpy as np
    
    LOG = False

    flood_avg_overhead_norm=[]
    bers_avg_overhead_norm=[]
    bers2_avg_overhead_norm=[]
    cancel2htarget_avg_overhead_norm=[]
    canceltarget_avg_overhead_norm=[]


    horgraph = range(MIN_Resource_Ratio,MAX_Resource_Ratio)

    if LOG: print "X=",horgraph
    if LOG: print "Blocking ERS =",bers_avg_overhead
    if LOG: print "Blocking ERS*=",bers2_avg_overhead
    
    for elem in range(MIN_Resource_Ratio, MAX_Resource_Ratio):
        flood_avg_overhead_norm.append(flood_avg_overhead[elem-1]/NMAX)
        bers_avg_overhead_norm.append(bers_avg_overhead[elem-1]/NMAX)
        bers2_avg_overhead_norm.append(bers2_avg_overhead[elem-1]/NMAX)
        cancel2htarget_avg_overhead_norm.append(cancel2htarget_avg_overhead[elem-1]/(NMAX+10))
        canceltarget_avg_overhead_norm.append(canceltarget_avg_overhead[elem-1]/NMAX)

    horgraph = range(MIN_Resource_Ratio,MAX_Resource_Ratio)

    DataOut = np.column_stack((horgraph,flood_avg_overhead_norm, 
            bers_avg_overhead_norm, bers2_avg_overhead_norm,
            cancel2htarget_avg_overhead_norm, canceltarget_avg_overhead_norm))

    DATAFILE='./results/overhead3.dat'
    PLOTFILE='./results/overhead3.png'
    np.savetxt(DATAFILE, DataOut)

    return True


def hops(flood_hops_latency, flood_hops_overhead, bers_hops_latency, bers_hops_overhead,
             bers2_hops_latency, bers2_hops_overhead, bcir_hops_overhead,
             bcir2_hops_overhead, HOPS, NMAX):
    import Gnuplot
    import scipy as sp
    import numpy as np
    import os

    result_flood_hops_latency=[]
    result_flood_hops_overhead=[]
    result_bers_hops_latency=[]
    result_bers_hops_overhead=[]
    result_bers2_hops_latency=[]
    result_bers2_hops_overhead=[]
    result_bcir_hops_overhead=[]
    result_bcir2_hops_overhead=[]
    result_bcir2_hops_overhead_std=[]


    LOG = False
    horgraph = range(1,HOPS)

    if LOG: print "X=",horgraph

    if LOG: print flood_hops_latency, flood_hops_overhead
    
    flood_hops_latency[0]=[0]
    flood_hops_overhead[0]=[NMAX]
    bers_hops_latency[0]=[0]
    bers_hops_overhead[0]=[0]
    bers2_hops_latency[0]=[0]
    bers2_hops_overhead[0]=[0]
    bcir_hops_overhead[0]=[0]
    bcir2_hops_overhead[0]=[0]

    for i in range(1,HOPS):
        arr1=sp.array(flood_hops_latency[i])
        result_flood_hops_latency.append(arr1.mean())

        arr2=sp.array(flood_hops_overhead[i])
        result_flood_hops_overhead.append(arr2.mean()/NMAX)

        arr3=sp.array(bers_hops_latency[i])
        result_bers_hops_latency.append(arr3.mean())

        arr4=sp.array(bers_hops_overhead[i])
        result_bers_hops_overhead.append(arr4.mean()/NMAX)

        arr5=sp.array(bers2_hops_latency[i])
        result_bers2_hops_latency.append(arr5.mean())

        arr6=sp.array(bers2_hops_overhead[i])
        result_bers2_hops_overhead.append(arr6.mean()/NMAX)
        
        arr7=sp.array(bcir_hops_overhead[i])
        result_bcir_hops_overhead.append(arr7.mean()/NMAX)
        
        arr8=sp.array(bcir2_hops_overhead[i])
        result_bcir2_hops_overhead.append(arr8.mean()/NMAX)
        result_bcir2_hops_overhead_std.append(arr8.std()/NMAX)

   
    if LOG: print result_flood_hops_overhead
    
    #Display Comunication Overhead
    g5 = Gnuplot.Gnuplot()
    g5('set style data lines')
    #g5('set data smooth bezier')
    g5('set pointsize 1')
    #g5('set key at 90,1')
    g5('set xrange [1:HOPS-1]')

    o_flood_lat = Gnuplot.Data(horgraph,result_flood_hops_latency,title='Flooding')
    o_bers_lat = Gnuplot.Data(horgraph,result_bers_hops_latency,title='BERS / BCIR')
    o_bers2_lat = Gnuplot.Data(horgraph,result_bers2_hops_latency,title='BERS* / BCIR*')

    g5('set grid')
    #g5('set log y')
    g5('set xlabel "Resource found at hop (H)"')
    g5('set ylabel "Latency (T)"')
    g5('set term png enhanced font "Vera,14"')
    g5('set output "./results/latency_hops.png"')
    g5.plot(o_flood_lat, o_bers_lat, o_bers2_lat)
    #g5.plot(tf2,tr2,td2)
    #raw_input('Please press return to continue...\n')

    #Display Comunication Overhead
    g6 = Gnuplot.Gnuplot()
    g6('set style data lines')
    #g6('set data smooth bezier')
    g6('set pointsize 1')
    g6('set key left top')
    
    g6('set xrange [1:HOPS-1]')

    o_flood_over = Gnuplot.Data(horgraph,result_flood_hops_overhead,title='Flooding')
    o_bers_over = Gnuplot.Data(horgraph,result_bers_hops_overhead,title='BERS')
    o_bers2_over = Gnuplot.Data(horgraph,result_bers2_hops_overhead,title='BERS*')
    o_bcir_over = Gnuplot.Data(horgraph,result_bcir_hops_overhead,title='BCIR')
    o_bcir2_over = Gnuplot.Data(horgraph,result_bcir2_hops_overhead,title='BCIR*')

    g6('set grid')
    #g6('set log y')
    g6('set xlabel "Resource found at hop (H)"')
    g6('set ylabel "Retransmission Ratio (R)"')
    g6('set term png enhanced font "Vera,14"')
    g6('set output "./results/overhead_hops.png"')
    g6.plot(o_flood_over, o_bers_over, o_bers2_over, o_bcir_over, o_bcir2_over)
    #g6.plot(tf2,tr2,td2)
    #raw_input('Please press return to continue...\n')

    g5.reset()
    g6.reset()


    DataOut_BCIR = np.column_stack((horgraph,result_bcir2_hops_overhead,result_bcir2_hops_overhead_std))

    DATAFILE_BCIR='./results/outputBCIR.dat'
    PLOTFILE_BCIR='./results/graficoBCIR.png'
    np.savetxt(DATAFILE_BCIR, DataOut_BCIR)


    f=os.popen('gnuplot' ,'w')
    print >>f, "set xlabel 'Resource found at hop (H)'; set ylabel 'Retransmission Ratio (R)'"
    print >>f, "plot '%s' using 1:2:3 with errorbars title 'BCIR' lw 3" % DATAFILE_BCIR
    print >>f, "set terminal png enhanced font 'Vera,14'"
    print >>f, "set out '%s'" % PLOTFILE_BCIR
    print >>f, "pause 2; replot"
    f.flush()




    
    return True



def ratio(MIN_Resource_Ratio, MAX_Resource_Ratio, bers_avg_latency,
                bers2_avg_latency, bers_avg_overhead, bers2_avg_overhead, cancel2htarget_avg_latency,
                canceltarget_avg_latency, cancel2htarget_avg_overhead, canceltarget_avg_overhead):
    import Gnuplot

    LOG = False
    bers_data=[]
    bers2_data=[]
    cancel2h_data=[]
    cancel_data=[]
    
    horgraph = range(MIN_Resource_Ratio,MAX_Resource_Ratio)

    if LOG: print "X=",horgraph
    if LOG: print "BERS =",bers_avg_latency/bers_avg_overhead
    if LOG: print "BERS*=",bers2_avg_latency/bers2_avg_overhead


    #Display Comunication Overhead
    g4 = Gnuplot.Gnuplot()
    g4('set style data linespoints')
    #g4('set data smooth bezier')
    g4('set pointsize 1')
    #g4('set yrange [0:1]')

    for elem in range(MIN_Resource_Ratio, MAX_Resource_Ratio):
        bers_data.append(bers_avg_latency[elem-1]/bers_avg_overhead[elem-1])
        bers2_data.append(bers2_avg_latency[elem-1]/bers2_avg_overhead[elem-1])
        cancel2h_data.append(cancel2htarget_avg_latency[elem-1]/cancel2htarget_avg_overhead[elem-1])
        cancel_data.append(canceltarget_avg_latency[elem-1]/canceltarget_avg_overhead[elem-1])
        

    o_bers = Gnuplot.Data(horgraph,bers_data,title='BERS')
    o_bers2 = Gnuplot.Data(horgraph,bers2_data,title='BERS*')
    o_cancel = Gnuplot.Data(horgraph,cancel2h_data,title='BCIR')
    o_cancel2 = Gnuplot.Data(horgraph,cancel_data,title='BCIR*')

    g4('set grid')
    #g4('set log y')
    #g4('set title "Topology: Random Geometric"')
    g4('set xlabel "Resource Density (%)"')
    g4('set ylabel "Ratio Latency/transmitions"')
    g4('set term png enhanced font "Vera,14"')
    g4('set output "./results/ratio.png"')
    g4.plot(o_bers,o_bers2,o_cancel,o_cancel2)
    #g3.plot(tf2,tr2,td2)
    #raw_input('Please press return to continue...\n')
    g4.reset()
    return True


def network_rand(G):
    import networkx as nx
    import matplotlib.pyplot as plt
    #import numpy as plt
    
    LOG = False

    #pos = G.pos
    pos = nx.random_layout(G)

    
    # Display Graph
    nx.draw_networkx_nodes(G,pos,node_color='#FFFF00')        

    nx.draw_networkx_edges(G,pos)
    nx.draw_networkx_labels(G,pos)

    plt.axis('off')
    plt.show()
    #END

    return True

def network(G,lerinicial,lerfinal):
    import networkx as nx
    import matplotlib.pyplot as plt
    #import numpy as plt

    plt.clf()
    LOG = False
    #pos = nx.graphviz_layout(G)
    pos = nx.spring_layout(G)
    nx.draw_networkx_nodes(G,pos,node_color='#FFFF00')
    nx.draw_networkx_nodes(G,pos,nodelist=[lerinicial],node_color='g')
    for i in range(0,len(lerfinal)):
        nx.draw_networkx_nodes(G,pos,nodelist=[lerfinal[i]],node_color='r')
    
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
    
    plt.savefig("./results/network.png")
    
    plt.show()
    #END

    return True
