#!/bin/bash

if [ $# -ne 2 ]
then
	echo -e "Usage:  gbcproc.sh  <cnodes> <iter>\n **** rml@fam.ulusiada.pt v1.1 ****"
	exit 1
else

CNODES=$1
ITER=$2
INPUT="/home/rml/work/LOG/ns2/"$CNODES"nodes"
OUTPUT="/home/rml/work/LOG/dat/"$CNODES"nodes"
DROP=0
EVDROP=0
TRANS=0


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


rm $OUTPUT/*


for (( c=0; c<$ITER; c++ ))
do

	./lat.awk $INPUT/rmlsearchgbc_$c.tr > $OUTPUT/lattmp.dat
	cat $OUTPUT/lattmp.dat | sort -n > $OUTPUT/lat.dat
	cat $OUTPUT/lat.dat | awk 'NR==1{print}' >> $OUTPUT/latnograd.dat
	#Ignor
	#nquery=$(( NODES * (NODES + 1) * 0.5 ))
	SKIP=$(( NODES * 2 ))
	tail -n +$SKIP $OUTPUT/lat.dat >> $OUTPUT/latgrad.dat
	
	./trans1.awk $INPUT/rmlsearchgbc_$c.tr > $OUTPUT/transtmp.dat
	cat $OUTPUT/transtmp.dat | sort -n > $OUTPUT/trans.dat
	cat $OUTPUT/trans.dat | awk 'NR==1{print}' >> $OUTPUT/transnograd.dat
	tail -n +$SKIP $OUTPUT/trans.dat >> $OUTPUT/transgrad.dat

done

./mediaslat.awk $OUTPUT/latnograd.dat | sort -n > $OUTPUT/latnograd_avg.dat
./mediaslat.awk $OUTPUT/latgrad.dat | sort -n >  $OUTPUT/latgrad_avg.dat

./mediastrans.awk $OUTPUT/transnograd.dat  | sort -n > $OUTPUT/transnograd_avg.dat
./mediastrans.awk $OUTPUT/transgrad.dat  | sort -n >  $OUTPUT/transgrad_avg.dat



eog ../../dataset/"$CNODES"nodes/network$((ITER-1)).png &
./graph.sh $OUTPUT

END=`date +%s`
DIFF=$(( $END - $START ))
{
echo "##################### Log ProcSimulation #########################"
echo "Date:`date`"
echo "CNodes: $CNODES"
echo "############################ TIME ################################"
echo "Execution time was $(($DIFF / 60)) minutes and $(($DIFF % 60)) seconds =  $(($DIFF / 3600)) Hours" 
echo "##################################################################"
} | tee $OUTPUT/log.txt
fi
