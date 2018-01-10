#!/usr/bin/awk -f
BEGIN{
	i=0;
}

{
#	if ($1=="s" || $1=="f") {
	if ($1=="s") {
		i+=1;
	};
}

END{
	print i;
}

