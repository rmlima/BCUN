#!/usr/bin/awk -f
BEGIN{
	inicio=0;
	fim=0;
	Limit=5
}

{
	if ($1=="e" && $15=="START" && $5 > Limit) {
		inicio=$3;
	};

	if ($1=="e" && $25=="Initiator" && $5 > Limit) {
		fim=$3;
		Qid=$5;
		print Qid " " fim-inicio " " $13;
	};
}

