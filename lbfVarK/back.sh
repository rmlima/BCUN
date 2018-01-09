#!/bin/bash

if [ $# -ne 1 ]
then
	echo -e "Usage:  back.sh  <output>\n **** rml@fam.ulusiada.pt v0.1 ****"
	exit 1
else

OUT=$1
LOG="./"$OUT"Log"

if [-d $LOG ]
then
	rm -rf $LOG
fi

mkdir $LOG

./stats.pl estimatorK70.log estimatorK70std.log 

mv *.log $LOG
mv $LOG/estimatorK70.log .
mv *.png $LOG
cp graph* $LOG

fi
