#!/usr/bin/awk -f
BEGIN {max = 0} {
if ($2>max) max=$3
} END {print max}
