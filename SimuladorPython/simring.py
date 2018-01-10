def ring(G,initiator,resources,maxhop,LOG):
    
    resourcenodes=resources[0]
    
    if LOG: print "MAXHOP",maxhop

    if LOG: print "###############################"
    if LOG: print "###  START Ring Simulation  ###"
    if LOG: print "###############################"

    trans_prev_ring=[]
    mesg_prev_ring=[]
    trans_prev_hope=[]
    ttl_list=[]


    #TTL list
    ttl_list.append(1)
    if ((maxhop+1)/2 > 1): ttl_list.append(int(round((maxhop+1)/2,0)))
    #print maxhop    
    ttl_list.append(maxhop)
    #print ttl_list
    if LOG: print "Lista de TTLs",ttl_list

    ring = 0
    found = 0
    msg_found = 0       #Number of messages to find resource
    hop = 0
    hop_found = 0
    
    totalhops=0
    
    hopr=0
    
    hopregresso=0

    for ttl in ttl_list:
        nextround = []
        history=[]
        result=[]
        transmitions = 0    #Power consumption
        msg_p2p = 0         #Number of messages
        
        hop_count = 0
        
        hopr=0
        
        if found==0 :
            ring+=1
            if LOG: print "Nodes:",len(G)
            if LOG: print "Initiator:",initiator
            if LOG: print "Resources:",resourcenodes
            if LOG: print "RING:",ring
            

        if (ttl==1):
            history.append(initiator)
            vs = G.neighbors(initiator)
            nextround = vs
            transmitions+=1
            hop+=1
                        
            totalhops+=1
            
            for v in vs:
                msg_p2p+=1
                
                for i in range(0,len(resourcenodes)):
                    a=resourcenodes[i]
                    if int(v) == a and found==0:
                        msg_found=msg_p2p
                        found=1
                        if LOG: print "Encontrado"
                        hop_found=1
                        hopr=1
                        break
                
                

            if (found==1) :
                mesg_prev_ring.append(msg_p2p+1)
                trans_prev_ring.append(transmitions+1)
            else:
                mesg_prev_ring.append(msg_p2p)
                trans_prev_ring.append(transmitions)

            if len(vs)==0:
                mesg_prev_ring.apend(0)
                trans_prev_ring.append(0)

            if LOG: print "Trans:",transmitions
            if LOG: print "Messages:",msg_p2p
            if LOG: print "Next Round:",nextround
            if LOG: print "Visited Nodes:",history
            if LOG: print "####################################"
        elif (found==0):
            if LOG: print "TTL:",ttl
            history.append(initiator)
            vs = G.neighbors(initiator)
            nextround = vs
            transmitions=1            
            hop+=1
            hopr+=1
            
            totalhops+=1
            
            for v in vs:
                msg_p2p+=1
                if LOG: print "Message sent to node:",v
                for i in range(0,len(resourcenodes)):
                    a=resourcenodes[i]
                    if int(v) == a and found==0:
                        msg_found=msg_p2p
                        found=1
                        hop_found=hop
                        hopregresso=hopr
                        if LOG: print "Encontrado"
                        break
            
            if len(vs)==0:
                mesg_prev_ring.apend(0)
                trans_prev_ring.append(0)

            if LOG: print "Trans:",transmitions
            if LOG: print "Messages:",msg_p2p
            if LOG: print "Next Round:",nextround
            if LOG: print "Visited Nodes:",history
            if LOG: print "####################################"

            ttl-=1

             # Next HOP
            while (len(nextround)>0 and ttl>0):
                if LOG: print "RING:",ring
                if LOG: print "TTL:",ttl
                actualround=nextround
                nextround=[]
                hop_count+=1
                hop+=1
                hopr+=1
                
                for node in actualround:
                    vs_next=G.neighbors(node)
                    transmitions+=1

                    if LOG: print "Trans:",transmitions
                    for v in vs_next:
                        if ( v not in history):
                            msg_p2p+=1
                            if LOG: print "Messages:",msg_p2p
                            #history.append(v) #Atencao duplicados
                            if (v not in actualround):
                                if (v not in nextround): 
                                    nextround.append(v)
                            if LOG: print "Message sent to node:",v

                            for i in range(0,len(resourcenodes)):
                                a=resourcenodes[i]
                                if int(v) == a and found==0:
                                    msg_found=sum(mesg_prev_ring)+msg_p2p
                                    hop_found=hop
                                    found=1
                                    hopregresso=hopr
                                    if LOG: print "Encontrado"
                                    break
                ttl-=1
                for node in actualround:
                    history.append(node)
                
                for node in actualround:
                    vs_next=G.neighbors(node)            
                    for n in vs_next:
                            if (n not in history):
                                totalhops+=1
                                break
                if LOG: print "Emissao=",totalhops

                # Display Log
                if LOG: print "Next Round:",nextround
                if LOG: print "Visited Nodes:",history
                if LOG: print "#############################"

            mesg_prev_ring.append(msg_p2p)
            trans_prev_ring.append(transmitions)
            trans_prev_hope.append(hop_count)

    if LOG: print "Transmitions:",trans_prev_ring
    msg_p2p=sum(mesg_prev_ring)
    transmitions=sum(trans_prev_ring)
    hop_count=sum(trans_prev_hope)
    timecomplexity=0
    
    if ring==1:
        timecomplexity=ttl_list[0]
    if ring==2:
        timecomplexity=ttl_list[0]+ttl_list[1]
    if ring==3:
        timecomplexity=ttl_list[0]+ttl_list[1]+ttl_list[2]

    if hopregresso ==0:
        hopregresso=1

    result.append(timecomplexity)
    result.append(msg_p2p+hopregresso-1)
    result.append(msg_found)
    result.append(totalhops+hopregresso)
    result.append(hop_found)    
    
        
    if LOG: print "Total HOPS=", totalhops+hopregresso
    
    if LOG: print "HOPS Regresso=", hopregresso
    
    if LOG: print "**** Result from RING: ****"
    if LOG: print "Messages until found: ",result[2]
    if LOG: print "Communication Complexity: ",result[1]
    if LOG: print "Time Complexity: ",result[0]
    if LOG: print "Total Hops: ",result[3]    
    if LOG: print "Hop Until Found ",result[4]

    if LOG: print "#############################"
    if LOG: print "###  END Ring Simulation  ###"
    if LOG: print "#############################"

    return result
    
