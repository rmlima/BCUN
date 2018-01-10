#!/usr/bin/awk -f
{
if ($10=="-Hops" && $16=="Found")
	print $11;
}

