#-*-coding: utf8-*-
import math

def personalizado(G,initiator,mostrar,resourcenodes):
    LOG = mostrar
    nextround=[]
    history=[]
    result=[]
    found=0
    transmitions = 0    #Power consumption (total number messages in the process)
    msg_p2p = 0         #Number of messages peer_to_peer
    msg_found = 0       #Number of messages to find resource
    hop=1
    hop_found = 0
      
    
    if LOG: print "################################"
    if LOG: print "###  Start Flood Simulation  ###"
    if LOG: print "################################"
    
    #Simulation FLOOD Start
    if LOG: print "Nodes",len(G)
    if LOG: print "Initiator",initiator
    if LOG: print "Resources",resourcenodes
    
    # First Node
    history.append(initiator)
    vs = G.neighbors(initiator)
    nextround = vs
    transmitions+=1
    for v in vs:
            msg_p2p+= 1
            if LOG: print "Message sent to node:",v
            for i in range(0,len(resourcenodes)):
                a=resourcenodes[i]
                if int(v) == a and found==0:
                    msg_found=msg_p2p
                    found=1
                    hop_found=1
                    break
    if LOG: print "Trans",transmitions
    if LOG: print "Messages",msg_p2p
    if LOG: print "####################################"
    
    # Next Round
    while len(nextround)>0 :
            actualround=nextround
            nextround=[]
            hop+=1
            for node in actualround:
                vs_next=G.neighbors(node)
                transmitions+=1
                if LOG: print "Trans:",transmitions
                for v in vs_next:
                    if ( v not in history):
                        msg_p2p+=1
                        if LOG: print "Messages",msg_p2p
                        #history.append(v) #Atencao duplicados
                        if (v not in actualround):
                            if (v not in nextround): nextround.append(v)
                        if LOG: print "Message sent to node:",v
                        for i in range(0,len(resourcenodes)):
                            a=resourcenodes[i]
                            if int(v) == a and found==0:
                                msg_found=msg_p2p
                                hop_found=hop
                                found=1
                                break
                            if LOG: print "Encontrado"
            for node in actualround:
                history.append(node)
            # Display Log
            if LOG: print "Visited FLOOD:",history
            if LOG: print "Next Round:",nextround
            if LOG: print "####################################"
            
    #End of Simulation FLOOD
    if LOG: print "Messages:",msg_p2p+hop_found,msg_found
    if LOG: print "Total Trans:",transmitions+hop_found
    if LOG: print "Number of HOPs:",hop-1
    if LOG: print "**** End of Simulation FLOOD ****"

    result.append(transmitions+hop_found)   #Time Complexity
    result.append(msg_p2p+hop_found)        #Communication Complexity
    result.append(msg_found)        	    #Messages until found
    result.append(hop-1)                    #Number of HOPs to reach the most distant node
    result.append(hop_found)		    #Latency - Until find resource
    result.append(initiator)
    result.append(resourcenodes)
    if LOG: print "##############################"
    if LOG: print "###  END Flood Simulation  ###"
    if LOG: print "##############################"

    return result
