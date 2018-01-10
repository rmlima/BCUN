#!/usr/bin/awk -f
BEGIN{
	delay=0;
	count=0;
}

{
	if ($1=="t" && $12=="-delay") {
		delay+=$13
		count++
	};

}

END{
	print "Avg  Delay: ",delay/count;
}

