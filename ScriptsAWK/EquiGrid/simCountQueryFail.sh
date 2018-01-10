#!/bin/bash

if [ $# -ne 1 ]
then
	echo -e "Usage:  simCountQueryFail.sh  <iter>\n **** rml@fam.ulusiada.pt v1.1 ****"
	exit 1
else

#DIR=$1
ITER=$1
INPUT="/home/rml/work/LOG/ns2RND/EquiGrid"
OUTPUT="/home/rml/work/LOG/dat/EquiGrid"


if [ ! -d $INPUT ]
then
	echo -e "Error:	No dataset available"
	exit 1
fi

if [ ! -d $OUTPUT ]
then
	mkdir $OUTPUT
fi


START=`date +%s`


rm $OUTPUT/fail.dat
touch $OUTPUT/fail.dat

for (( c=0; c<$ITER; c++ ))
do

	FLOODSNT=`cat $INPUT/rmlsearchflood_$c.tr | grep "\-Initiator" | wc -l`
	FLOODRCV=`cat $INPUT/rmlsearchflood_$c.tr | grep "Resource at Initiator" | wc -l`

	BCIRSNT=`cat $INPUT/rmlsearchbcir_$c.tr | grep "\-Initiator" | wc -l`
	BCIRRCV=`cat $INPUT/rmlsearchbcir_$c.tr | grep "Resource at Initiator" | wc -l`

	BCIR2SNT=`cat $INPUT/rmlsearchbcir2_$c.tr | grep "\-Initiator" | wc -l`
	BCIR2RCV=`cat $INPUT/rmlsearchbcir2_$c.tr | grep "Resource at Initiator" | wc -l`

	GBCSNT=`cat $INPUT/rmlsearchgbc_$c.tr | grep "\-Initiator" | wc -l`
	GBCRCV=`cat $INPUT/rmlsearchgbc_$c.tr | grep "Resource at Initiator" | wc -l`

	echo -e "$c\t$(($FLOODSNT-$FLOODRCV))\t$(($BCIRSNT-$BCIRRCV))\t$(($BCIR2SNT-$BCIR2RCV))\t$(($GBCSNT-$GBCRCV))" >>$OUTPUT/fail.dat

done
fi
