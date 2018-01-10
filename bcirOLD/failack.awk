#!/usr/bin/awk -f
BEGIN{
	inicio=0;
	fim=0;
}

{
	if ($1=="e" && $13=="START") {
		inicio=$3
	};

	if ($1=="e" && $17=="Initiator") {
		fim=$3
		exit #Only the first discovery
	};

}

END{
	if (fim==0)
		print -1;
	else
		print fim-inicio;
}

