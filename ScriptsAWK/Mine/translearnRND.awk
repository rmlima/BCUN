#!/usr/bin/awk -f
BEGIN{
	inicio=0;
	fim=0;
	Qid=1;
}

{
	if ($3<100) {
	if ($1=="e" && $15=="START") {
		Qid=$5;
		Qel[Qid]=$7;
		trans[Qid]=0;
	};


	if ($1=="s") {
		trans[Qid]++;
	};

	if ($1=="e" && $25=="Initiator") {
                Hop[Qid]=$13;
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
