#!/usr/bin/awk -f
BEGIN {
sum=0;
}
{
freq[$2]++;
}
END{
for (var in freq)
	sum=sum+freq[var];
for (var in freq)
	print var,"\t", freq[var]/sum;
}
