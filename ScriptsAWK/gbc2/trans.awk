#!/usr/bin/awk -f
BEGIN{
	Limit=5
}
{
		if ($1=="s" && $49>Limit) {
			trans[$49]++;
		};
	
		if ($1=="e" && $25=="Initiator" && $5>Limit) {
	                Hop[$5]=$13;
	                Qel[$5]=$7;
	        };
}

END{
for (Qid in trans) {
	if ( Hop[Qid] ) {
        	print Qid,"\t",trans[Qid],"\t",Hop[Qid],"\t",Qel[Qid];
		}
        }
}
