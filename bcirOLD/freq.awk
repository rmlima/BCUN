#!/usr/bin/awk -f
{
freq[$2]++;
}
END{
for (var in freq)
print var,"\t", freq[var];
}
