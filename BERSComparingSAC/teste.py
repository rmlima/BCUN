
for hop_found in range(1,10):

	latency=0
	count=0

	for count in range(1,hop_found+1):
     		latency+=(count+1)

	print "Hop_found=",hop_found," Latency=",latency
