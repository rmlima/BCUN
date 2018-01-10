#!/usr/bin/awk -f
{
	trans[$3]+=$2; # Transmissions
	ctrans[$3]++; # Inserted elements
}
END{
for (hop in trans) {
	print hop,"\t", trans[hop]/ctrans[hop],"\t",ctrans[hop];
	}
}
