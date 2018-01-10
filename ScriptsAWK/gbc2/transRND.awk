#!/usr/bin/awk -f
{
	if ($3 >=1000) {

		if ($1=="s") {
			trans[$49]++;
		};
	
		if ($1=="e" && $25=="Initiator") {
	                Hop[$5]=$13;
	                Qel[$5]=$7;
	        };
	}
}

END{
for (Qid in trans) {
	if ( Hop[Qid] ) {
        	print Qid," ",trans[Qid]," ",Hop[Qid]," ",Qel[Qid];
		}
        }
}
