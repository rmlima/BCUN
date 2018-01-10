# -*- coding: utf-8 -*-
import math
def canceltrans(hop,delay):

    # x=x0+vt

    LOG = False
    ida_volta=2*hop        #Tempo de ida_e_volta
    if ida_volta<=delay:
	return hop
    else:
        #t=(z0-x0)/(vx-zx)
        #t=(2*hop/delay)/(1-(1/delay))
        hop_stop=int(hop+(2*hop/delay))
        cancel=hop
        while cancel<hop_stop :
            for j in range(1,delay):
                cancel=cancel+1
            hop_stop=hop_stop+1
            
        if LOG: print"Stop at",hop,"hops."
        return hop_stop-1

#Definition of the TTL sequence
def ttl_generator_geo(first,cratio,n):
        return first*math.pow(cratio,n)

def ttl_generator_ari(first,dist,n):
        return first+(n-1)*dist


def flood(G,initiator,resourcenodes):
    LOG = False
    transmitions=0
    hop=0
    firstfound=0
    found=0
    hop_found=0
    trans_found=0
    actualround=[]
    nextround=[]
    history=[]
    result=[]
    candidates=[]
    actualround.append(initiator)

  

    if LOG: print "################################"
    if LOG: print "###  START Flood Simulation  ###"
    if LOG: print "################################"


    while (len(actualround)>0) :
        nextround=[]
        hop+=1
        if LOG: print "HOP=",hop
        for v in actualround :        
            history.append(v)
            candidates=G.neighbors(v)
            transmitions+=1
            for temp in candidates :
                if ((temp not in history) and (temp not in nextround) and (temp not in actualround)) :
                    nextround.append(temp)
                if ( temp in resourcenodes and found==0):
                    found=1
        if (found==1 and firstfound==0):
            trans_found=transmitions
            hop_found=hop
            firstfound=1
            if LOG: print "Trans Found=",trans_found
            if LOG: print "Hops Found=",hop_found
        actualround=nextround
        if LOG: print "Transmitions=",transmitions
        if LOG: print "History=",history
        if LOG: print "Next Round=",nextround

    #Metrics
    result.append(2*hop_found)	            #Latency - Until find resource - Até saber que o recurso existe
    result.append(transmitions+hop_found)   #Communication Complexity = Todas Transmissões + informar
    result.append(hop_found)                #Number of HOPs until found
    result.append(hop+hop_found)            #Time Complexity = Tempo até parar
    result.append(trans_found)        	    #Transmitions until found 
    result.append(hop)                      #Diametro da Rede


    if LOG: print "**** Results from FLOOD: ****"
    if LOG: print "Time until source receive the answer   - Latency  :",result[0]
    if LOG: print "Total transmissions until stop process - Overhead :",result[1]
    if LOG: print "Number of HOPs until found ........... - HOPS     :",result[2]
    if LOG: print "Time until all stop .................. - Total    :",result[3]
    if LOG: print "Transmitions until found ............. - Trans    :",result[4]
    if LOG: print "Network Diameter ..................... - Diameter :",result[5]
    
    if LOG: print "##############################"
    if LOG: print "###  END Flood Simulation  ###"
    if LOG: print "##############################"

    if found==0 : print "ERROR: FLOOD no resource"

    return result



def ers(G,initiator,resourcenodes):
    LOG = False
    transmitions=0
    hop=0
    found=0
    firstfound=0
    actualround=[]
    nextround=[]
    history=[]
    result=[]
    candidates=[]
    trans_prev_ring=[]
    
    actualround.append(initiator)

    while (len(actualround)>0 and (found==0)) :
        nextround=[]
        hop+=1
        transmitions=0
        for v in actualround :
            history.append(v)
            candidates=G.neighbors(v)
            transmitions+=1
            for temp in candidates :
                if ((temp not in history) and (temp not in nextround) and (temp not in actualround)and (temp not in resourcenodes)) :
                    nextround.append(temp)
                if ( temp in resourcenodes and found==0):
                            found=1
        if (found==1 and firstfound==0):
            trans_found=transmitions
            hop_found=hop
            firstfound=1
        actualround=nextround
        trans_prev_ring.append(transmitions)

    overhead=0
    count=0
    for trans in trans_prev_ring:
        overhead+=trans*(len(trans_prev_ring)-count)
        count=count+1

    latency=0
    count=0
    for trans in trans_prev_ring:
        count=count+1
        latency+=1*count
    latency*=2


    result.append(latency)
    result.append(overhead+hop_found)
    result.append(hop_found)
    result.append(0)
    result.append(trans_found)

    if found==0 : print "ERROR: FLOOD no resource"

    if LOG: print "**** Results from ERS: ****"
    if LOG: print "Time until source receive the answer   - Latency  :",result[0]
    if LOG: print "Total transmissions until stop process - Overhead :",result[1]
    if LOG: print "Number of HOPs until found ........... - HOPS     :",result[2]
    if LOG: print "Time until all stop .................. - Total    :",result[3]
    if LOG: print "Transmitions until found ............. - Trans    :",result[4]
    

    if LOG: print "#############################"
    if LOG: print "####  END ERS Simulation  ###"
    if LOG: print "#############################"
    return result 


def ers_ttl(G,initiator,resourcenodes,maxhop):
    LOG = False
    transmitions=0
    hop=0
    found=0
    firstfound=0
    actualround=[]
    nextround=[]
    history=[]
    result=[]
    candidates=[]
    trans_prev_ring=[]
    trans_prev_hop=[]
    #mesg_prev_ring=[]
    ttl_list=[]
    
    #TTL list
    ttl_list.append(1)
    if ((maxhop+1)/2 > 1): ttl_list.append(int(round((maxhop+1)/2,0)))
    ttl_list.append(maxhop)
    if LOG: print "Lista de TTLs",ttl_list

    #First Broadcast
    actualround.append(initiator)
    history.append(initiator)
    nextround = G.neighbors(initiator)
    if LOG: print "Interation 1"
    transmitions+=1
    hop+=1
    for v in nextround:
            #msg_p2p+= 1
            if LOG: print "Message sent to node:",v
            if ( v in resourcenodes and found==0) :
                trans_found=1
                found=1
		hop_found=1
    if (found==1):
        if LOG: print "Messages:",trans_found,trans_found+hop_found,transmitions+hop_found
        if LOG: print "Total Trans:",transmitions+hop_found
        if LOG: print "Number of HOPs until find:",hop_found
        if LOG: print "**** End of Simulation ERS-TTL ****"

        result.append(hop+hop_found)            #Time Complexity = Tempo até parar
        result.append(transmitions+hop_found)   #Communication Complexity = Todas Transmissões + informar
        result.append(trans_found)              #Transmitions until found 
        result.append(hop_found)                #Number of HOPs until found
        result.append(2*hop_found)              #Latency - Until find resource - Até saber que o recurso existe
    else:
        trans_prev_ring.append(transmitions)

        # Second Broadcast until D/2
        if LOG: print "####################################"
        if LOG: print "Interation 2"
        transmitions=0
        hop=0
        actualround=[]
        history=[]
        actualround.append(initiator)
        
        while hop<ttl_list[1]:
            if LOG: print "------------HOP",ttl_list[1]
            nextround=[]
            hop+=1
            for v in actualround :        
                candidates=G.neighbors(v)
                transmitions+=1
                history.append(v)
                for temp in candidates :
                    if ((temp not in history) and (temp not in nextround) and (temp not in actualround) and (temp not in resourcenodes)) :
                        nextround.append(temp)
                    if ( temp in resourcenodes and found==0):
                            found=1
            if (found==1 and firstfound==0):
                trans_found=transmitions
                hop_found=hop
                firstfound=1
            actualround=nextround
        if (found==1):
            if LOG: print "Messages:",trans_found+1,trans_found+hop_found+1,transmitions+hop_found+1
            if LOG: print "Total Trans:",transmitions+hop_found+1
            if LOG: print "Number of HOPs until find:",hop_found+1
            if LOG: print "**** End of Simulation ERS-TTL ****"

            result.append(2*hop_found+2)          #Time Complexity = Tempo até parar
            result.append(transmitions+hop_found+1) #Communication Complexity = Todas Transmissões + informar
            result.append(trans_found+1)            #Transmitions until found 
            result.append(hop_found+1)              #Number of HOPs until found
            result.append(2*hop_found+2)            #Latency - Until find resource - Até saber que o recurso existe
        else:
            trans_prev_ring.append(transmitions)
            if LOG: print "Previous Transmissions: ",trans_prev_ring
            # Third Broadcast until D
            if LOG: print "####################################"
            if LOG: print "Interation 3"
            transmitions=0
            hop=0
            actualround=[]
            history=[]
            actualround.append(initiator)
            history.append(initiator)
            nextround = G.neighbors(initiator)
            while hop<ttl_list[2]:
                if LOG: print "------------HOP",ttl_list[2]
                nextround=[]
                hop+=1
                for v in actualround :        
                    candidates=G.neighbors(v)
                    transmitions+=1
                    history.append(v)
                    for temp in candidates :
                        if ((temp not in history) and (temp not in nextround) and (temp not in actualround) and (temp not in resourcenodes)) :
                            nextround.append(temp)
                        if ( temp in resourcenodes and found==0):
                                    found=1
                if (found==1 and firstfound==0):
                    trans_found=transmitions
                    hop_found=hop
                    firstfound=1
                actualround=nextround
            trans_prev_ring.append(transmitions)
            if (found==1):
                result.append(2+(ttl_list[1]*2)+(2*hop_found))
                result.append(trans_prev_ring[0]+trans_prev_ring[1]+trans_prev_ring[2]+hop_found)
                result.append(hop_found+ttl_list[0]+ttl_list[1])
                result.append(trans_prev_ring)
                result.append(trans_found+trans_prev_ring[0]+trans_prev_ring[1])
                if LOG: print "**** Results from ERS-TTL: ****"
                if LOG: print "Time until source receive the answer   - Latency  :",result[0]
                if LOG: print "Total transmissions until stop process - Overhead :",result[1]
                if LOG: print "Number of HOPs until found ........... - HOPS     :",result[2]
                if LOG: print "Previous Transmitions ................ - P Trans  :",result[3]
                if LOG: print "Transmitions until found ............. - Trans    :",result[4]

            else:
                print "ERRO: ERS-TTL Não há recursos"


    if LOG: print "################################"
    if LOG: print "###  END ERS-TTL Simulation  ###"
    if LOG: print "################################"
    return result


def bers(G,initiator,resourcenodes):

    LOG = False
    transmitions=0
    hop=0
    found=0
    firstfound=0
    actualround=[]
    nextround=[]
    history=[]
    result=[]
    candidates=[]
    actualround.append(initiator)

    if LOG: print "###############################"
    if LOG: print "###  START BERS Simulation  ###"
    if LOG: print "###############################"

    while (len(actualround)>0 and found==0) :
        nextround=[]
        hop+=1
        for v in actualround :        
            history.append(v)
            candidates=G.neighbors(v)
            transmitions+=1
            for temp in candidates :
                if ((temp not in history) and (temp not in nextround) and (temp not in actualround) and (temp not in resourcenodes)) :
                    nextround.append(temp)
                if ( temp in resourcenodes and found==0):
                    found=1               
        if (found==1 and firstfound==0):
            trans_found=transmitions
            hop_found=hop
            firstfound=1
        actualround=nextround
        if LOG: print "Next Round=",nextround
            

    if LOG: print "Messages:",trans_found,trans_found+hop_found,2*trans_found+hop_found
    if LOG: print "Total Trans:",2*transmitions+hop_found
    if LOG: print "Number of HOPs until find:",hop_found


    latency=0
    latency=hop_found*hop_found+hop_found
    #count=0
    #for count in range(1,hop_found+1):
        #latency+=(count+1)
    
    #Recursos encontrados no ultimo round
    recursos=0
    for node in actualround :        
            if node in resourcenodes : recursos=recursos+1
    

    
    result.append(latency)
    result.append(2*transmitions+hop_found*recursos)
    result.append(hop_found)
    result.append(latency+hop_found)
    result.append(trans_found)
    	            

    if LOG: print "**** Results from BERS: ****"
    if LOG: print "Time until source receive the answer   - Latency  :",result[0]
    if LOG: print "Total transmissions until stop process - Overhead :",result[1]
    if LOG: print "Number of HOPs until found ........... - HOPS     :",result[2]
    if LOG: print "Time until all stop .................. - Total    :",result[3]
    if LOG: print "Transmitions until found ............. - Trans    :",result[4]

    if LOG: print "#####################################"
    if LOG: print "######  END BERS Simulation  ########"
    if LOG: print "#####################################"
    return result 


def bers2(G,initiator,resourcenodes):

    LOG = False
    transmitions=0
    trans_found=0
    hop=0
    found=0
    hop_found=0
    firstfound=0
    actualround=[]
    nextround=[]
    history=[]
    result=[]
    candidates=[]
    actualround.append(initiator)

    if LOG: print "################################"
    if LOG: print "###  START BERS* Simulation  ###"
    if LOG: print "################################"

    while (len(actualround)>0 and found==0) :
        nextround=[]
        hop+=1
        for v in actualround :        
            history.append(v)
            candidates=G.neighbors(v)
            transmitions+=1
            if LOG: print "Transmission node =",v
            for temp in candidates :
                if ((temp not in history) and (temp not in nextround) and (temp not in actualround) and (temp not in resourcenodes)) :
                    nextround.append(temp)
                if ( temp in resourcenodes and firstfound==0):
                    found=1               
        if (found==1 and firstfound==0):
            trans_found=transmitions
            hop_found=hop
            firstfound=1
            recursos1=0
            for node in actualround :        
                if node in resourcenodes : recursos1=recursos1+1
            if LOG: print "Trans Found=",trans_found
            if LOG: print "Hops Found=",hop_found
        actualround=nextround
        if LOG: print "Transmitions=",transmitions
        if LOG: print "History=",history
        if LOG: print "Next Round=",nextround

    recursos2=0
    for node in actualround :        
            if node in resourcenodes : recursos2=recursos2+1


    # Aditional HOP
    for v in actualround :        
            if (v not in resourcenodes):
                transmitions+=1
            
    latency=0
    count=0
    for count in range(1,hop_found+1):
        latency+=(count+1)

    result.append(latency)
    result.append(2*transmitions+hop_found*recursos1+(hop_found+1)*recursos2)
    result.append(hop_found)
    result.append(2*hop_found)
    result.append(trans_found)

    if LOG: print "**** Result from BERS*: ****"
    if LOG: print "Time until source receive the answer   - Latency  :",result[0]
    if LOG: print "Total transmissions until stop process - Overhead :",result[1]
    if LOG: print "Number of HOPs until found ........... - HOPS     :",result[2]
    if LOG: print "Time until all stop .................. - Total    :",result[3]
    if LOG: print "Transmitions until found ............. - Trans    :",result[4]


    if LOG: print "######################################"
    if LOG: print "######  END BERS* Simulation  ########"
    if LOG: print "######################################"
    return result 



def cancel2htarget(G,initiator,resourcenodes):
    LOG = False
    transmitions=0
    hop=0
    found=0
    firstfound=0
    actualround=[]
    nextround=[]
    history=[]
    result=[]
    candidates=[]
    actualround.append(initiator)
    
    cancel_actualround=[]
    cancel_nextround=[]
    cancel_history=[]
    hop_cancel=0


    if LOG: print "#######################################################"
    if LOG: print "###  START Cancel target Simulation  Delay = 2*HOP  ###"
    if LOG: print "#######################################################"


    while (len(actualround)>0 and found==0) :
        nextround=[]
        hop+=1
        for v in actualround :        
            history.append(v)
            candidates=G.neighbors(v)
            transmitions+=1
            if LOG: print "Transmission node =",v
            for temp in candidates :
                if ((temp not in history) and (temp not in nextround) and (temp not in actualround) and (temp not in resourcenodes)) :
                    nextround.append(temp)
                if ( (temp in resourcenodes) and (temp not in cancel_actualround)):
                    found=1
                    cancel_actualround.append(temp)
        if (found==1 and firstfound==0):
            trans_found=transmitions
            hop_found=hop
            firstfound=1
            if LOG: print "Trans Found=",trans_found
            if LOG: print "Hops Found=",hop_found
        actualround=nextround
        if LOG: print "Transmitions=",transmitions
        if LOG: print "History=",history
        if LOG: print "Next Round=",nextround



    if found :
              
        if LOG: print "Start Cancel Nodes=",cancel_actualround
        
        #while (len(cancel_nextround)>0 and hop_cancel<2*hop_found) :
        while (len(cancel_actualround)>0) :
            cancel_nextround=[]
            hop_cancel+=1
            for v in cancel_actualround :
                cancel_history.append(v)
                candidates=G.neighbors(v)
                transmitions+=1
                if LOG: print "Cancel Transmission node =",v
                for temp in candidates :
                    if ((temp in history) and (temp not in cancel_history) and (temp not in cancel_nextround) and (temp not in cancel_actualround)):
                        cancel_nextround.append(temp)
            #cancel_nextround=list(set(cancel_nextround))  #remove duplicates        
            cancel_actualround=cancel_nextround
            if LOG: print "Transmitions=",transmitions
            if LOG: print "Cancel History=",cancel_history
            if LOG: print "Cancel Next Round=",cancel_nextround
    else:
        print "ERROR: No resource found"

    
    

    #Metrics
    result.append(hop_found*hop_found+hop_found)        #Latency - Until find resource - Até saber que o recurso existe
    result.append(transmitions)                         #Communication Complexity = Todas Transmissões + informar
    result.append(hop_found)                            #Number of HOPs until found
    result.append(3*hop_found)                          #Time Complexity = Tempo até parar
    result.append(trans_found)        	                #Transmitions until found 



    if LOG: print "**** Results from Broadcast Cancelation with 2HopsDelay: ****"
    if LOG: print "Time until source receive the answer   - Latency  :",result[0]
    if LOG: print "Total transmissions until stop process - Overhead :",result[1]
    if LOG: print "Number of HOPs until found ........... - HOPS     :",result[2]
    if LOG: print "Time until all stop .................. - Total    :",result[3]
    if LOG: print "Transmitions until found ............. - Trans    :",result[4]



    if LOG: print "####################################################"
    if LOG: print "###  END Cancel Delay Simulation  Delay = 2*HOP  ###"
    if LOG: print "####################################################"
    return result 


def canceltarget(G,initiator,resourcenodes):
    LOG = False
    transmitions=0
    hop=0
    found=0
    firstfound=0
    actualround=[]
    nextround=[]
    history=[]
    result=[]
    candidates=[]
    actualround.append(initiator)

    cancel_actualround=[]
    cancel_nextround=[]
    cancel_history=[]
    hop_cancel=0

    if LOG: print "##############################################"
    if LOG: print "###  START Cancel target Simulation  D=Hop ###"
    if LOG: print "##############################################"


    while (len(actualround)>0 and found==0) :
        nextround=[]
        hop+=1
        for v in actualround :        
            history.append(v)
            candidates=G.neighbors(v)
            transmitions+=1
            if LOG: print "Transmission node =",v
            for temp in candidates :
                if ((temp not in history) and (temp not in nextround) and (temp not in actualround) and (temp not in resourcenodes)) :
                    nextround.append(temp)
                if ( (temp in resourcenodes) and (temp not in cancel_actualround)):
                    found=1
                    cancel_actualround.append(temp) #Select cancellation initial nodes if multiple
        if (found==1 and firstfound==0):
            trans_found=transmitions
            hop_found=hop
            firstfound=1
            if LOG: print "Trans Found=",trans_found
            if LOG: print "Hops Found=",hop_found
        actualround=nextround
        if LOG: print "Transmitions=",transmitions
        if LOG: print "History=",history
        if LOG: print "Next Round=",nextround

    if found :
                
        if LOG: print "Start Cancel Nodes=",cancel_actualround
        
        #while (len(cancel_nextround)>0 and hop_cancel<2*hop_found) :
        while (len(cancel_actualround)>0) :
            cancel_nextround=[]
            hop_cancel+=1
            for v in cancel_actualround :
                cancel_history.append(v)
                candidates=G.neighbors(v)
                transmitions+=1
                if LOG: print "Cancel Transmission node =",v
                for temp in candidates :
                    if ((temp in actualround) and (hop_cancel<=hop_found)): actualround.remove(temp) # Remove from hop+1 that are already cancellated
                    if ((temp in history) and (temp not in cancel_history) and (temp not in cancel_nextround) and (temp not in cancel_actualround)):
                        cancel_nextround.append(temp)
                if LOG: print "Actual Round=",actualround
            #cancel_nextround=list(set(cancel_nextround))  #remove duplicates        
            cancel_actualround=cancel_nextround
            if LOG: print "Transmitions=",transmitions
            if LOG: print "Cancel History=",cancel_history
            if LOG: print "Cancel Next Round=",cancel_nextround
            if LOG: print "Cancel Hop=",hop_cancel
    else:
        print "ERROR: No resource found"

    latency=0
    count=0
    for count in range(1,hop_found+1):
        latency+=(count+1)
        

    #Metrics
    result.append(latency) #Latency - Until find resource - Até saber que o recurso existe
    result.append(transmitions+2*len(actualround))             #Communication Complexity
    result.append(hop_found)                #Number of HOPs until found
    result.append(3*hop_found)              #Time Complexity = Tempo até parar
    result.append(trans_found)        	    #Transmitions until found 



    if LOG: print "**** Results from CANCEL 1*HOP: ****"
    if LOG: print "Time until source receive the answer   - Latency  :",result[0]
    if LOG: print "Total transmissions until stop process - Overhead :",result[1]
    if LOG: print "Number of HOPs until found ........... - HOPS     :",result[2]
    if LOG: print "Time until all stop .................. - Total    :",result[3]
    if LOG: print "Transmitions until found ............. - Trans    :",result[4]



    if LOG: print "#################################################"
    if LOG: print "###  END Cancel target Simulation Delay=1*HOP ###"
    if LOG: print "#################################################"
    
    return result 



def canceltargetM(G,initiator,resourcenodes,M):
    LOG = False
    transmitions=0
    hop=0
    found=0
    delay=2*hop/M
    actualround=[]
    nextround=[]
    history=[]
    result=[]
    candidates=[]
    actualround.append(initiator)
    history.append(initiator)
    nextround = G.neighbors(initiator) #pode sair !

    cancel_initiator=0
    cancel_actual=[]
    cancel_next=[]
    cancel_history=[]
    

    if LOG: print "#############################################"
    if LOG: print "###  START Cancel from Target Simulation  ###"
    if LOG: print "#############################################"
    
    while len(nextround)>0 :
        nextround=[]
        hop+=1
        if LOG: print "HOP=",hop
        for v in actualround :        
            candidates=G.neighbors(v)
            transmitions+=1
            if LOG: print "Transmitions=",transmitions
            if LOG: print "Candidates=",candidates
            for temp in candidates :
                if (temp not in history) :
                    history.append(temp)
                    nextround.append(temp)
                    if ( temp in resourcenodes and found==0):
                            trans_found=transmitions
                            hop_found=hop
                            if LOG: print "Trans Found=",trans_found
                            if LOG: print "Hops Found=",hop_found
                            found=1
                            #Cancel Start
                            cancel_initiator=temp
                            cancel_actual.append(cancel_initiator)
                            cancel_history.append(cancel_initiator)
                            cancel_next = G.neighbors(cancel_initiator)
                            while len(nextround)>0 :
                                nextround=[]
                                hop+=1
                                if LOG: print "HOP=",hop
                                for v in actualround :        
                                    candidates=G.neighbors(v)
                                    transmitions+=1
                                    if LOG: print "Transmitions=",transmitions
                                    if LOG: print "Candidates=",candidates
                                    for temp in candidates :
                                        if (temp not in history) :
                                            history.append(temp)
                                            nextround.append(temp)
                                            if ( temp in resourcenodes and found==0):
                                                    trans_found=transmitions
                                                    hop_found=hop
                                                    if LOG: print "Trans Found=",trans_found
                                                    if LOG: print "Hops Found=",hop_found
                                                    found=1




                            
        actualround=nextround
        if LOG: print "Next Round=",nextround

    #Metrics
    result.append(hop_found*hop_found+hop_found)    #Latency - Until find resource - Até saber que o recurso existe
    result.append(transmitions+hop_found)   #Communication Complexity = Todas Transmissões + informar
    result.append(hop_found)                #Number of HOPs until found
    result.append(hop+hop_found)            #Time Complexity = Tempo até parar
    result.append(trans_found)        	    #Transmitions until found 
    result.append(hop)                      #Diametro da Rede


    if LOG: print "**** Results from FLOOD: ****"
    if LOG: print "Time until source receive the answer   - Latency  :",result[0]
    if LOG: print "Total transmissions until stop process - Overhead :",result[1]
    if LOG: print "Number of HOPs until found ........... - HOPS     :",result[2]
    if LOG: print "Time until all stop .................. - Total    :",result[3]
    if LOG: print "Transmitions until found ............. - Trans    :",result[4]
    if LOG: print "Network Diameter ..................... - Diameter :",result[5]
    

    if LOG: print "#########################################"
    if LOG: print "###  END Cancel Initiated from Target ###"
    if LOG: print "#########################################"

    if found==0 : print "ERROR: CancelTarget no resource"
    return result 
