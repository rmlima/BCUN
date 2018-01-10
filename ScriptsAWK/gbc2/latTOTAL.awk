#!/usr/bin/awk -f
BEGIN{
	inicio=0;
	fim=0;
}

{
	if ($1=="e" && $15=="START") {
		inicio=$3;
	};

	if ($1=="e" && $25=="Initiator") {
		fim=$3;
		Qid=$5;
		print Qid " " fim-inicio " " $13;
	};
}

