#!/usr/bin/awk -f
BEGIN{
	drops=0;
}

{
if ($1=="d" && $21="COL")
	drops++;
}

END{
	print drops;
}

