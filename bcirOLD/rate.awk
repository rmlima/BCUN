#! /usr/bin/awk -f
BEGIN {
total_packets_sent = 0;
total_packets_received = 0;
total_packets_dropped = 0;
first_packet_sent = 0;
last_packet_sent = 0;
last_packet_received = 0;

NODE_INITIAL_ENERGY = 100.0;
PKTSIZE = 1000; #Bytes

# del files
    printf("") > "packets.dat";

}

{
event = $1;
time = $3;
node = $5;
packetid = $6;
energy=$17;
numhops = $49;
opt_numhops = $51;

if ( event == "s" ) {

            if ( time < first_packet_sent || first_packet_sent == 0 )
                first_packet_sent = time;
            if ( time > last_packet_sent )
                last_packet_sent = time;
# rate
            packets_sent[node]++;
            total_packets_sent++;

# delay
#            pkt_start_time[cbr_flow_packetid] = time;
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
#            packets_received_flow[flow]++;      
#    printf("r  %d %d at %f %f\n",node,packets_received[node]++, time, last_packet_received);

#            pkt_received_per_time[ int(time/10) ]++;

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



END {

  number_flows = 0;

# ===== TOTAL RUNTIME =====
    total_runtime = last_packet_sent - first_packet_sent;

if ( total_runtime > 0 && total_packets_sent > 0) {
# ===== OFFERED LOAD ==== (TODO: revise here)
        load = ((total_packets_sent * PKTSIZE * 8 / 1024 )/total_runtime); # no overhead
# ===== THROUGHPUT =====
	throughput = (total_packets_received*PKTSIZE*8/1024)/total_runtime;
}



#printf("%s %f %f %f %f\n", f, flowstart, flowend, rate[f], throughput[f]) >> "stats-throughput.dat";

printf ("############# STATS - Last Network - Last Search #################\n");
printf("Run Time = \t\t%f s\n",total_runtime);
printf("Packets Sent = \t\t%d\n",total_packets_sent);
printf("Packets Received = \t%d\n",total_packets_received);
printf("Load = \t\t\t%f Kbps\n",load);
printf("Throughput = \t\t%f Kbps\n",throughput);
printf("Run Time = \t\t%f s\n",total_runtime);
printf ("##################################################################\n");
# ==== DATA ====
    for ( nodes in packets_sent ) {
        printf("%d\t%d\t%d\n",nodes,packets_sent[nodes],packets_received[nodes]) >> "packets.dat";
    }

}
