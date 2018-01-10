# -*- coding: utf-8 -*-

#import redestipicas
def simulador(G,iniciador,terminal,mostrar,mecanismo):
        import networkx as nx
        import random as rnd
        import simflood
        import simring
        import graficos
        import default
        #mecanismo=1 flood
        #mecanismo=2 ring

        LOG = mostrar          
        
        result=[]
        
        resourcenodes=[]
        resourcenodes.append(terminal)
        maxhop=2
        
        if mecanismo==1:
                result = simflood.flood(G,iniciador,LOG,terminal)
        elif mecanismo==2:
                maxhop = maximohop(G,iniciador)                
                result = simring.ring(G,iniciador,resourcenodes,maxhop,LOG)
        elif mecanismo==3:
                reload(default) 
                result = default.personalizado(G,iniciador,LOG,terminal)
                
                #Simulation LOG
        if LOG: print "**** Result from FLOOD: ****"
        if LOG: print "Messages until found: ",result[2]
        if LOG: print "Comunication Complexity: ",result[1]
        if LOG: print "Time Complexity: ",result[0]      

        return result
        

def maximohop(G,initiator):

    nextround=[]
    history=[]
    hop=1    
    history.append(initiator)
    vs = G.neighbors(initiator)
    nextround = vs

    while len(nextround)>0 :
            actualround=nextround
            nextround=[]
            hop+=1
            for node in actualround:
                vs_next=G.neighbors(node)

                for v in vs_next:
                    if ( v not in history): 
                        if (v not in actualround):
                            if (v not in nextround): nextround.append(v)

            for node in actualround:
                history.append(node)
                
    return hop-1