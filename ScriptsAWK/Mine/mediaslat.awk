#!/usr/bin/awk -f
{
	lat[$3]+=$2;
	clat[$3]++;
}
END{
for (hop in lat) {
	print hop,"\t", lat[hop]/clat[hop],"\t",clat[hop];
	}
}
