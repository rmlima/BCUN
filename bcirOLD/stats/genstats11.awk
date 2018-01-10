#! /usr/bin/awk -f
#
# Parse a ns2 wireless trace file and generate the following stats:
# - number of flows (senders)
# - time of simulation run
# - number of packets sent (at the Application)
# - number of packets received (at the Application)
# - number of packets dropped (at the Application)
# - number of collisions (802.11)
# - average delay
# - average throughput
# - average traffic rate (measured)
# - and more....
#
# Author: ?   - I don't remember where I found the first version of this script :-(
#
# Modified by Julian Monteiro <jm@ime.usp.br>
# Last updated: Nov, 10 2006  
# version 6: new trace format
# version 7: corrected bug in min function, tput and rate changed to bps (*8)
# version 8: problemas com DROPs contabilizados em excesso 
# version 9: trying to normalize end-to-end delay... give SIM_TIME to dropped nodes

#------------------------------------------------------------------------------
function average (array) {
    sum = 0;
    items = 0;
    for (i in array) {
	sum += array[i];
	items++;
    }
    if (sum == 0 || items == 0)
	return 0;
    else
	return sum / items;
}

#------------------------------------------------------------------------------
function max( array ) {
    begin=1;
    for (i in array) {
	if (begin || array[i] > largest){
	    largest = array[i];
	    begin = 0;
	}
    }
    return largest;
}
#------------------------------------------------------------------------------
function min(array) {
    begin=1;
    for (i in array){
	if (begin || array[i] < smallest) {
	    smallest = array[i];
	    begin = 0;
	}
    }
    return smallest;
}
#------------------------------------------------------------------------------
function std_deviation(array, avg) {
    total = 0;
    items = 0;
    for (i in array) {
	delta = array[i] - avg;
	#print("i="i" array[i]="array[i]" delta="delta);
	total += delta*delta;
	items++;
    }
    if (total == 0 || items == 0)
	return 0;
    else
	return sqrt(total/(items-1));
}
#------------------------------------------------------------------------------



##=============================================================================
##
BEGIN {
    if (!NEWTRACE) NEWTRACE="true";
    if (!PKTSIZE) PKTSIZE = 1000;
    if (!NODE_INITIAL_ENERGY) NODE_INITIAL_ENERGY = 100.0;
    
    total_packets_sent = 0;
    total_packets_received = 0;
    total_packets_dropped = 0;
    first_packet_sent = 0;
    last_packet_sent = 0;
    last_packet_received = 0;
    
# del files
    printf("") > "stats-summary.dat"; 
    printf("") > "stats-dropped.dat"; #summary of dropped kts
    printf("") > "stats-throughput.dat"; #throughput - pkts received
    printf("") > "stats-rate.dat"; #rate - pkts sent
    printf("") > "stats-delay.dat"; #delay to each pkt
    printf("") > "stats-numhops.dat"; #
    printf("") > "stats-energy.dat";
    printf("") > "stats-pkt_rcvd_per_time.dat";
    printf("") > "stats-pkt_dropped_per_time.dat";  
    
}
#
# =============================================================================
#
{
    
    if (NEWTRACE == "true") {
#Example of new trace format
#1 2  3           4   5 6   7  8  9  10  11      12   13      14  15  16  17         18  19  20 21   
#s -t 1.142046604 -Hs 0 -Hd -2 -Ni 0 -Nx 1186.47 -Ny 1093.76 -Nz 0.00 -Ne 100.000000 -Nl AGT -Nw --- 
#
#22 23 24 25 26 27 28 29 30 31  32  33   34  35   36  37  38  39 40 41 42 43 44 45   46 47 48 49 50 51
#Ma 0 -Md 0 -Ms 0 -Mt 0 -Is 0.0 -Id 40.0 -It cbr -Il 512 -If 0 -Ii 3 -Iv 32 -Pn cbr -Pi 1 -Pf 0 -Po 16777215
	event = $1;
	time = $3;
	node = $5;
	type = $19;
	reason = $21;
	packetid = $41; 
	packettype = $35;
	src = $31;
	dst = $33;
	cbr_packetid = $47; #NEW: para monitorar o delay pkt a pkt
	numhops = $49;
	opt_numhops = $51;
	energy  = $17;

# strip  trailing .0 or :0 from src and dst
	sub(/\.0$/, "", src);
	sub(/\.0$/, "", dst);
	
    } else {
#Example of old format
#1 2           3   4    5   6 7   8   9   10 11 12  13      14  15   16 17 18 19 20
#r 2.112017031 _5_ AGT  --- 7 cbr 532 [13a 5 4 800] ------- [1:0 5:0 30 5] [1] 2 2
	event = $1;
	time = $2;
	node = $3;
	type = $4;
	reason = $5;
	packetid = $6;
	packettype = $7;
	src = $14;
	dst = $15;
	cbr_packetid = $6; #ESTA ERRADO! :-(
	numhops = $19;
	opt_numhops = $20;
	
# strip leading and trailing _ from node
	sub(/^_*/, "", node); 
	sub(/_*$/, "", node);
	sub(/^\[/, "", src);
	sub(/\:0$/, "", src);
	sub(/\:0$/, "", dst);
	
    }
    
  #print(event" -t "time" -Hs "node" -Hd "type" "reason" "packetid" "packettype" "src" "dst" "energy" -Pf "numhops" -Po "opt_numhops);
    
    if ( time < simulation_start || simulation_start == 0 )
	simulation_start = time;
    
    if ( time > simulation_end )
	simulation_end = time;
    
#DISABLED: node initial energy
# if (event == "s" || event == "r" || event == "d" || event == "f") {
#    if (!node_initial_energy[node]) {
#      printf("node: "node" energy"energy"\n");
#      node_initial_energy[node] = energy;
#    }
#  }
    
    #-------------------
    #---   APLICACAO   ---
    #-------------------
    if ( type == "AGT" ) {
	nodes[node] = node; # to count number of nodes
	
	flow = src"-"dst;
	flows[flow] = flow; # to count number of flows
	#printf("found flow %s\n",flow);

	cbr_flow_packetid = flow" "cbr_packetid; #used to calc end-to-end delay

	if ( time < node_start_time[node] || node_start_time[node] == 0)
	    node_start_time[node] = time;
	
	if ( time > node_end_time[node] )
	    node_end_time[node] = time;
	
	if ( time < flow_start_time[flow] || flow_start_time[flow] == 0) {
	    flow_start_time[flow] = time;
	    #print("flow_start_time["flow"]="time"\n");
	}
    
	if ( time > flow_end_time[flow] ) {
	    flow_end_time[flow] = time;
	    #print("flow_end_time["flow"]="time"\n");
	}
	
	#--- 
	#--- SEND
	#--- 
	if ( event == "s" ) {
	    
	    if ( time < first_packet_sent || first_packet_sent == 0 )
		first_packet_sent = time;
	    if ( time > last_packet_sent )
		last_packet_sent = time;
# rate
	    packets_sent[node]++;
	    total_packets_sent++;
	    packets_sent_flow[flow]++;
	    
# delay
	    pkt_start_time[cbr_flow_packetid] = time;
	    ####TESTE @INRIA pkt_start_node[packetid] = node;
	    
	}
	
	#--- 
	#--- RECEIVE
	#--- 
	else if ( event == "r" ) {
	    if ( time > last_packet_received )
		last_packet_received = time;
# throughput
	    packets_received[node]++;
	    total_packets_received++;
	    packets_received_flow[flow]++;      
#    printf("r  %d %d at %f %f\n",node,packets_received[node]++, time, last_packet_received);
	    
	    pkt_received_per_time[ int(time/10) ]++;
# end-to-end delay
	    pkt_end_time[cbr_flow_packetid] = time;
	    ###TESTE @INRIA pkt_end_node[cbr_packetid" "flow] = node;
	    
# num hops
	    if (opt_numhops < 16777215) {
		packet_hops[packetid]     = numhops;
		opt_packet_hops[packetid] = opt_numhops;
	    } else {
		num_opt_packets_unrech++;
	    }
	    
	}
	
	#new trace format
	node_final_energy[node] = energy;
	
    }
    
    #------------- 
    #--- DROP
    #-------------
    if ( event == "d" || event == "D") {
	
	if(packettype == "cbr" || packettype == "tcp") {

	    if (type == "IFQ" && reason == "ARP") {
		packets_dropped["ARP"]++;
	    } 
	    else if (type != "MAC" || (type == "MAC" && reason == "RET")) {
		packets_dropped[type]++;	
	    }
	    
	    packets_dropped2[type" "reason" "packettype]++;
	    
	    if ( reason == "COL" )
		total_collisions++;
	    else if ( type != "MAC" || (type == "MAC" && reason == "RET") ) {
		total_packets_dropped++;
		pkt_dropped_per_time[ int(time/10) ]++;
	    }
	    
	    
	}else {
	    packets_dropped2[type" "reason" "packettype]++;
	    if ( reason == "COL" )
		total_collisions++;
	}
    }
    

    #-------------
    #--- ENERGY
    #------------
    #EXAMPLE: N -t 600.000100 -n 49 -e 8.719321
    if (NEWTRACE != "true" &&  event == "N" ) { # ENERGY stuff
	    #    printf("%s %s %f %s %d %s %f\n",$1,$2,$3,$4,$5,$6,$7);
	    node_final_energy[$5] = $7;
    }
    
}
##
##===============================================================

##===============================================================
##
END {
    
    number_flows = 0;
    
# ===== TOTAL RUNTIME =====
    total_runtime = last_packet_sent - first_packet_sent;
    
# ===== OFFERED LOAD ==== (TODO: revise here)
    if ( total_runtime > 0 && total_packets_sent > 0)
	load = ((total_packets_sent * PKTSIZE)/total_runtime) / 2000000; # no overhead
    
# ===== FLOWS, RATE and THROUGHPUT  =====
    for (f in flows) {
	number_flows++;
	flowend = flow_end_time[f];
	flowstart = flow_start_time[f];
	flowtime = flowend - flowstart;      
	if ( flowtime > 1 ) { #jm 27/10/2005, changed from > 0. Due to big values...       
	    throughput[f] = packets_received_flow[f]*PKTSIZE*8 / flowtime;
	    rate[f] = (packets_sent_flow[f]*PKTSIZE*8) / flowtime;
	    printf("%s %f %f %f %f\n", f, flowstart, flowend, rate[f], throughput[f]) >> "stats-throughput.dat";
#printf("f: %d sent: %d rcvd: %d flowtime: %f \n", f, packets_sent_flow[f], packets_received_flow[f], flowtime);
	}
    }
    
    
# ==== DROPPED ====
    for ( typereason in packets_dropped2) {
	printf("D %s = %d\n",typereason, packets_dropped2[typereason]) >> "stats-dropped.dat";
    }
    
    
# ===== END-TO-END DELAY ==== 
    for ( flow_pkt in pkt_end_time) { #TODO: trocar para start para mudar estilo do end-to-end delay
	start = pkt_start_time[flow_pkt];
	end = pkt_end_time[flow_pkt];
        ##DISABLED @INRIA: node_start = pkt_start_node[flow_pkt];
	##DISABLED @INRIA: node_end = pkt_end_node[flow_pkt];

	delta = end - start;
	if ( delta > 0 ) {
	    delay[flow_pkt] = delta;
	    printf("%f %s %f %f\n", start, flow_pkt, end, delta) > "stats-delay.dat";
	}
    }
    
# ===== ENERGY STUFF =====
    printf("#node initial final delta\n")> "stats-energy.dat";
    for ( node in node_final_energy) {
	initial = NODE_INITIAL_ENERGY;  #node_initial_enrgy[node];   #GAMBI: arrumar pra ler do ns2.tr
	final = node_final_energy[node];      
	
	delta = initial - final;
	delta_energy[node] = delta;
	printf("%d %f %f %f\n", node, initial, final, delta) > "stats-energy.dat";
	
    }
    min_node_usedenergy  = min(delta_energy);
    max_node_usedenergy  = max(delta_energy);
    avg_node_usedenergy  = average(delta_energy);
    printf("# usedenergy: avg=%8.4f,  min=%8.4f, max=%8.4f\n",avg_node_usedenergy,min_node_usedenergy,max_node_usedenergy) > "stats-energy.dat";
    
    
# ===== NUMBER OF HOPS ====
    for ( pkt in packet_hops) {
	numhops = packet_hops[pkt];
	opt_numhops = opt_packet_hops[pkt];
	diff = numhops - opt_numhops;
	printf("%d %f %f %s\n", pkt,  numhops, opt_numhops,diff) > "stats-numhops.dat";
    }
    min_packet_hops  = min(packet_hops);
    max_packet_hops  = max(packet_hops);
    avg_packet_hops  = average(packet_hops);
    avg_opt_packet_hops  = average(opt_packet_hops);
    printf("#    avg=%8.4f min=%8.4f max=%8.4f\n", 
	   avg_packet_hops, min_packet_hops, max_packet_hops) > "stats-numhops.dat";
    printf("#opt avg=%8.4f min=%8.4f max=%8.4f\n", 
	   avg_opt_packet_hops, min(opt_packet_hops), max(opt_packet_hops)) > "stats-numhops.dat";
    printf("#Num opt packets unreacheble=%8.4f/%8.4f\n",
	   num_opt_packets_unrech, total_packets_received) > "stats-numhops.dat";
    
    
# ==== RCVD and DROPPED HISTOGRAM ====  
    num_blocks = int(total_runtime/10);
    for ( b = 0; b <= num_blocks; b++) {
	sum_rcvd += pkt_received_per_time[b];
	# pkt received per time block
	printf("%d %d %d\n", b*10, pkt_received_per_time[b], sum_rcvd) > "stats-pkt_rcvd_per_time.dat";
	sum_drop += pkt_received_per_time[b];
	# pkt dropped per time block
	printf("%d %d %d\n", b*10, pkt_dropped_per_time[b], sum_drop) > "stats-pkt_dropped_per_time.dat";
    }
    
    
# ==== experimental stuff.... :-) =====
    if (avg_opt_packet_hops > 0) {
	rel_packet_hops = avg_packet_hops/avg_opt_packet_hops;
    }
    
    
# ===============
#      OUTPUT
# ===============
    printf("\
#      RUN    OFFRD   #PKTS  PKTS  PKTS |PKTS  PKTS  PKTS  PKTS |         AVG        MAX      MIN      AVERAGE    AVERAGE     AVERAGE    .MAX   MIN   PATH      AVG       MAX        MIN      \
#FLOWS TIME   LOAD    #SENT  RCVD  DROP |D.IFQ D.ARP D.MAC D.RTR|COLL     DELAY(s)   DELAY(s) DELAY(s) TPUT (b/s) RATE(b/s)   HOPS       .HOPS  HOPS  OPTMLITY  ENERGY    ENERGY     ENERGY   \
#----- ------ --------#----- ----- -----|----- ----- ----- -----|-------- ---------- -------- -------- ---------- ----------- -----------.----- ----- --------- --------- ---------- ---------\n");
    
    printf("%5d %6.1f %7.6f %5d %5d %5d %5d %5d %5d %5d %5d  %8.6f %8.6f  %8.6f  %8.6f  %8.6f %8.6f  %5d %5d %8.7f  %8.4f %8.6f %8.6f\n",
	   number_flows,
	   total_runtime,
	   load,
	   total_packets_sent,
	   total_packets_received,
	   total_packets_dropped,
	   packets_dropped["IFQ"],
	   packets_dropped["ARP"],
	   packets_dropped["MAC"],
	   packets_dropped["RTR"],
	   total_collisions,
	   average(delay),
	   max(delay),
	   min(delay),
	   average(throughput),
	   average(rate),
	   average(packet_hops), 
	   max_packet_hops, 
	   min_packet_hops,
	   rel_packet_hops,
	   avg_node_usedenergy,
	   max_node_usedenergy,
	   min_node_usedenergy) >> "stats-summary.dat";
    
   system("cat stats-summary.dat");
}
