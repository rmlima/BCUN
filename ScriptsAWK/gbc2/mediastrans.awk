#!/usr/bin/awk -f
{
	trans[$3]+=$2;
	ctrans[$3]++;
}
END{
for (hop in trans) {
	print hop,"\t", trans[hop]/ctrans[hop],"\t",ctrans[hop];
	}
}
