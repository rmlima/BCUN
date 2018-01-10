#!/usr/bin/awk -f
BEGIN{
	event_drops=0;
	delta=0.000001; #microsecond
	time=0;
}

{
if ($1=="d" && $21="COL" && ($3 - time > delta)) {
		time = $3;
		event_drops++;
		}
}

END{
	print event_drops;
}
