#!/usr/bin/awk -f
{
	if ($3 >=100) {

		if ($1=="i") {
			trans[$5]++; #49 Qid
		};
	
	}
}

END{
for (Qid in trans) {
        	print Qid,"\t",trans[Qid];
		}
}
