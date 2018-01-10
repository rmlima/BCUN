#!/usr/bin/awk -f
{

if ($3!=-1) {
	flood[$2]+=$3;
	cflood[$2]++;
	}
if ($4!=-1) {
	bers[$2]+=$4;
	cbers[$2]++;
	}
if ($5!=-1) {
	bcir[$2]+=$5;
	cbcir[$2]++;
	}
}

END{
for (ele in flood)
	print ele,"\t", flood[ele]/cflood[ele] >> "temp1";
for (ele in bers)
	print ele,"\t",bers[ele]/cbers[ele] >> "temp2";
for (ele in bcir)
	print ele,"\t",bcir[ele]/cbcir[ele] >> "temp3";
}
