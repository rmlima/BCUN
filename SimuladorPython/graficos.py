# -*- coding: utf-8 -*-

def results(vector,tipo):
    import Gnuplot
    import time

    #muf=1 cc=2 tc=3 th=4 huf=5
    
    if tipo==1:
        str='Messages until found'
    if tipo==2:
        str='Communication Complexity'
    if tipo==3:
        str='Time Complexity'
    if tipo==4:
        str='Total HOPs'    
    if tipo==5:
        str='HOP until Found'
        
        
    g1 = Gnuplot.Gnuplot(persist = 1)
    g1('set pointsize 1')
    recursos= range(0,len(vector))
    media=int((sum(vector)) / len(vector))
    vectormedia=[]
    for i in range(0,len(vector)):
        vectormedia.append(media)
         
    tf1 = Gnuplot.Data(recursos,vector,title="Valor")
    tf2 = Gnuplot.Data(recursos,vectormedia, with_="lines", title="Media")    
    g1('set grid')
    #g1('set log y')
    
    g1.xlabel('Iteration')
    g1.ylabel(str)
    #g2('set term jpeg color')
    #g2('set output "flood_ring_gnuplot.pdf"')
    g1.plot(tf1,tf2)
    #time.sleep(5)
    #g2.plot(tf2,tr2,td2)
    #raw_input('Please press return to continue...\n')
    
    return True

def results2v(vectorx,vectory,tipo,ordem,legenda):
    import Gnuplot
    import time

    #muf=1 cc=2 tc=3 th=4 huf=5
    #ordem=f,r==1 ordem=f,p==2 ordem=r,p==3 
    
    if tipo==1:
        str='Messages until found'
    if tipo==2:
        str='Communication Complexity'
    if tipo==3:
        str='Time Complexity'
    if tipo==4:
        str='Total HOPs'    
    if tipo==5:
        str='HOP until Found'
    
    if ordem==1:

        legenda2="Average Flood"

        legenda4="Average Ring"
    if ordem==2:

        legenda2="Average Flood"

        legenda4="Average Pers."
    if ordem==3:

        legenda2="Average Ring"

        legenda4="Average Pers."
        
    g1 = Gnuplot.Gnuplot(persist = 1)
    g1('set pointsize 1')
         
    tf1 = Gnuplot.Data(vectorx,vectory, with_="lines", title="")
    
    g1('set grid')
    #g1('set log y')
    
    if legenda==1:
        legendax="Nodes"
    if legenda==2:
        legendax="Resources"
    
    
    g1.xlabel(legendax)
    g1.ylabel(str)
    #g2('set term jpeg color')
    #g2('set output "flood_ring_gnuplot.pdf"')
    g1.plot(tf1)
    #time.sleep(5)
    #g2.plot(tf2,tr2,td2)
    #raw_input('Please press return to continue...\n')
    
    return True

def results3v(vectorx,vectory1,vectory2,tipo,legenda):
    import Gnuplot
    import time

    #muf=1 cc=2 tc=3 th=4 huf=5
    
    if tipo==1:
        str='Messages until found'
    if tipo==2:
        str='Communication Complexity'
    if tipo==3:
        str='Time Complexity'
    if tipo==4:
        str='Total HOPs'    
    if tipo==5:
        str='HOP until Found'
        
        
    g1 = Gnuplot.Gnuplot(persist = 1)
    g1('set pointsize 1')    

    tf1 = Gnuplot.Data(vectorx,vectory1, with_="lines", title="Average Flood")    

    tf2 = Gnuplot.Data(vectorx,vectory2, with_="lines", title="Average Ring")

        
    g1('set grid')
    #g1('set log y')
    
    if legenda==1:
        legendax="Nodes"
    if legenda==2:
        legendax="Resources"
    
    g1.xlabel(legendax)
    g1.ylabel(str)
    #g2('set term jpeg color')
    #g2('set output "flood_ring_gnuplot.pdf"')
    g1.plot(tf1,tf2)
    #time.sleep(5)
    #g2.plot(tf2,tr2,td2)
    #raw_input('Please press return to continue...\n')
    
    return True

def results4v(vectorx,vectory1,vectory2,vectory3,tipo,legenda):
    import Gnuplot
    import time

    #muf=1 cc=2 tc=3 th=4 huf=5
    
    if tipo==1:
        str='Messages until found'
    if tipo==2:
        str='Communication Complexity'
    if tipo==3:
        str='Time Complexity'
    if tipo==4:
        str='Total HOPs'    
    if tipo==5:
        str='HOP until Found'
        
        
    g1 = Gnuplot.Gnuplot(persist = 1)
    g1('set pointsize 1')    

    tf1 = Gnuplot.Data(vectorx,vectory1, with_="lines", title="Average Flood")   

    tf2 = Gnuplot.Data(vectorx,vectory2, with_="lines", title="Average Ring")

    tf3 = Gnuplot.Data(vectorx,vectory3, with_="lines", title="Average Pers.")
        
    g1('set grid')
    #g1('set log y')
    
    if legenda==1:
        legendax="Nodes"
    if legenda==2:
        legendax="Resources"
    
    g1.xlabel(legendax)
    g1.ylabel(str)
    #g2('set term jpeg color')
    #g2('set output "flood_ring_gnuplot.pdf"')
    g1.plot(tf1,tf2,tf3)
    #time.sleep(5)
    #g2.plot(tf2,tr2,td2)
    #raw_input('Please press return to continue...\n')
    
    return True

def ligar(G,numnodos):
    import gtk
    #print "Ligacoes"
    resultados=[]
    nextround=[]
    history=[]
    result=[]

    
    initiator=0
    vs = G.neighbors(initiator)
    nextround = vs
    
    ligacoes1=[]
    ligacoes2=[]
    
    contador=0
    
    for i in range(0,numnodos):
        for j in G.neighbors(i):
            ligacoes1.append(i)
            ligacoes2.append(j)
    
    #print ligacoes1
    #print ligacoes2
    
    comparador1=[]
    comparador2=[]
    
    tamanho=len(ligacoes1)
    #print "Tamanho",tamanho
    i=0

    while i<tamanho:   
        if i<tamanho-1:
            a=ligacoes1[i]
            b=ligacoes2[i]
            i+=1;
            
            for j in range(0,tamanho):            
                #print "j",j
                if a==ligacoes2[j] and b==ligacoes1[j]:
                    ligacoes1.pop(j)
                    ligacoes2.pop(j)
                    #print ligacoes1
                    #print ligacoes2                
                    #print "Tamanho",tamanho
                    break
                tamanho=len(ligacoes1)
        else:
            i+=1
    #print ligacoes1
    #print ligacoes2
    resultados.append(ligacoes1)
    resultados.append(ligacoes2)
    
    return resultados
    
def guardar(pos,numnodos,tipo,links):
    import os
    
    links1=links[0]
    links2=links[1]
    
    nlinks=len(links1)
    
    ns=""
    ns+="set ns [new Simulator]\n"
    ns+="set nf [open out.nam w]\n"
    ns+="$ns namtrace-all $nf\n"
    ns+="proc finish {} {\n"
    ns+="global ns nf\n"
    ns+="$ns flush-trace\n"
    ns+="close $nf\n"
    ns+="exec nam out.nam &\n"
    ns+="exit 0\n"
    ns+="}\n"
    
    ns+="for {set i 0} {$i < "+str(numnodos)+" } {incr i} {set node_($i) [$ns node]}\n"
    
    '''if tipo==1:
    
        for i, j in pos.iteritems():                   
            
            ns+="$node_("+str(i)+") set X_ "+str(150*float(j[0]))+"\n"
            ns+="$node_("+str(i)+") set Y_ "+str(150*float(j[1]))+"\n"
            ns+="$node_("+str(i)+") set Z_ 0\n"
    if tipo==2 or tipo==3:
        for i, j in pos.iteritems():                   
            
            ns+="$node_("+str(i)+") set X_ "+str(float(j[0]))+"\n"
            ns+="$node_("+str(i)+") set Y_ "+str(float(j[1]))+"\n"
            ns+="$node_("+str(i)+") set Z_ 0\n"'''
    
    for i in range(0,nlinks):
        ns+="$ns duplex-link $node_("+str(links1[i])+") $node_("+str(links2[i])+") 10Mb 10ms DropTail\n"
 
    ns+='$ns at 5.0 "finish"\n'
    
    ns+="$ns run\n"
    
    print ns
    
    postxt = open("pos.txt","w")
    postxt.write(str(ns))
    postxt.close()
    
    os.system("ns ./pos.txt")

def network_rand(G,lerinicial,lerfinal):
    import networkx as nx
    import matplotlib.pyplot as plt

    #print lerinicial
    #print lerfinal

    plt.clf()
    LOG = False

    #pos = G.pos
    pos = nx.spring_layout(G)
    #pos = nx.graphviz_layout(G)
    #pos = nx.random_layout(G)
    
    #GRAVA NUM FICHEIRO TXT
    #postxt = open("pos.txt","w")
    #postxt.write(str(pos))
    #postxt.close()
    
    # Display Graph
    nx.draw_networkx_nodes(G,pos,node_color='#FFFF00')
    nx.draw_networkx_nodes(G,pos,nodelist=[lerinicial],node_color='g')
    for i in range(0,len(lerfinal)):
        nx.draw_networkx_nodes(G,pos,nodelist=[lerfinal[i]],node_color='r')    
    nx.draw_networkx_edges(G,pos)
    nx.draw_networkx_labels(G,pos)       
    plt.axis('off')
    plt.savefig('grafico.png',dpi=50)
    #plt.show()

    return True
    #END
def network_redesenhar(G,lerinicial,lerfinal,pos):
    import networkx as nx
    import matplotlib.pyplot as plt

    plt.clf()
    LOG = False

    #pos = nx.random_layout(G)
    
    #GRAVA NUM FICHEIRO TXT
    #postxt = open("pos.txt","w")
    #postxt.write(str(pos))
    #postxt.close()
    
    # Display Graph
    nx.draw_networkx_nodes(G,pos,node_color='#FFFF00')
    nx.draw_networkx_nodes(G,pos,nodelist=[lerinicial],node_color='g')
    for i in range(0,len(lerfinal)):
        nx.draw_networkx_nodes(G,pos,nodelist=[lerfinal[i]],node_color='r')
    nx.draw_networkx_edges(G,pos)
    nx.draw_networkx_labels(G,pos)       
    plt.axis('off')
    plt.savefig('grafico.png',dpi=50)
    #plt.show()

    return True

def network_erdos(G,lerinicial,lerfinal):
    import networkx as nx
    import matplotlib.pyplot as plt
    
    
    plt.clf()
    LOG = False
    pos = nx.graphviz_layout(G)
    nx.draw_networkx_nodes(G,pos,node_color='#FFFF00')
    nx.draw_networkx_nodes(G,pos,nodelist=[lerinicial],node_color='g')
    for i in range(0,len(lerfinal)):
        nx.draw_networkx_nodes(G,pos,nodelist=[lerfinal[i]],node_color='r')
    
    nx.draw_networkx_edges(G,pos)
    nx.draw_networkx_labels(G,pos)
    plt.axis('off')
    plt.savefig('grafico.png',dpi=50)   
    
    
def network_barabasi (G,lerinicial,lerfinal):
    import networkx as nx
    import matplotlib.pyplot as plt
    
    plt.clf()
    pos = nx.graphviz_layout(G)
    nx.draw_networkx_nodes(G,pos,node_color='#FFFF00')
    nx.draw_networkx_nodes(G,pos,nodelist=[lerinicial],node_color='g')
    for i in range(0,len(lerfinal)):
        nx.draw_networkx_nodes(G,pos,nodelist=[lerfinal[i]],node_color='r')
    nx.draw_networkx_edges(G,pos)
    nx.draw_networkx_labels(G,pos)
    plt.axis('off')
    plt.savefig('grafico.png',dpi=50)
    #plt.show()
    
def network_path (G,lerinicial,lerfinal):
    import networkx as nx
    import matplotlib.pyplot as plt
    
    plt.clf()
    pos = nx.graphviz_layout(G)
    nx.draw_networkx_nodes(G,pos,node_color='#FFFF00')
    nx.draw_networkx_nodes(G,pos,nodelist=[lerinicial],node_color='g')
    for i in range(0,len(lerfinal)):
        nx.draw_networkx_nodes(G,pos,nodelist=[lerfinal[i]],node_color='r')
    nx.draw_networkx_edges(G,pos)
    nx.draw_networkx_labels(G,pos)
    plt.axis('off')
    plt.savefig('grafico.png',dpi=50)
    #plt.show()
    
def view(G,lerinicial,lerfinal,pos):
    import networkx as nx
    import matplotlib.pyplot as plt

    plt.clf()
    LOG = False
    
    # Display Graph
    nx.draw_networkx_nodes(G,pos,node_color='#FFFF00')
    nx.draw_networkx_nodes(G,pos,nodelist=[lerinicial],node_color='g')
    for i in range(0,len(lerfinal)):
        nx.draw_networkx_nodes(G,pos,nodelist=[lerfinal[i]],node_color='r')
    nx.draw_networkx_edges(G,pos)
    nx.draw_networkx_labels(G,pos)       
    plt.axis('off')
    #plt.savefig('grafico.png',dpi=50)
    plt.show()
