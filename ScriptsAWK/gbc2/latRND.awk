#!/usr/bin/awk -f
BEGIN{
	inicio=0;
	fim=0;
}

{
	if ($3 >= 1000 ) {

	if ($1=="e" && $15=="START") {
		inicio=$3;
		Qid=$5;
	};

	if ($1=="e" && $25=="Initiator" && $5==Qid) {
		fim=$3;
		print Qid " " fim-inicio " " $13;
	};
	}
}

