#!/usr/bin/awk -f
{
	if ($3 >=100) {

		if ($1=="s") {
			trans[$49]++; #49 Qid
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
        	print Qid,"\t",trans[Qid],"\t",Hop[Qid],"\t",Qel[Qid];
		}
        }
}
