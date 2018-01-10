#!/usr/bin/awk -f
BEGIN{
	sent=0;
}

{
if ($1=="s")
	sent++;
}

END{
	print sent;
}

