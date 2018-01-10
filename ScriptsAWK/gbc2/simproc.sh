#!/bin/bash

if [ $# -ne 2 ]
then
	echo -e "Usage:  simproc.sh  <cnodes> <iter>\n **** rml@fam.ulusiada.pt v1.1 ****"
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

find $OUTPUT -type f -not -name '*RND*' -delete


for (( c=0; c<$ITER; c++ ))
do
	#Aquecimento
	./latlearn.awk $INPUT/rmlsearchgbc_$c.tr > $OUTPUT/lattmp.dat
	cat $OUTPUT/lattmp.dat | sort -n >> $OUTPUT/latgbclearn.dat
	./lat.awk $INPUT/rmlsearchgbc_$c.tr > $OUTPUT/lattmp.dat
	cat $OUTPUT/lattmp.dat | sort -n >> $OUTPUT/latgbc.dat
	./latTOTAL.awk $INPUT/rmlsearchgbc_$c.tr > $OUTPUT/lattmp.dat
	cat $OUTPUT/lattmp.dat | sort -n >> $OUTPUT/latgbctotal.dat
	
	./lat.awk $INPUT/rmlsearchbcir_$c.tr > $OUTPUT/lattmp.dat
	cat $OUTPUT/lattmp.dat | sort -n >> $OUTPUT/latbcir.dat
	
	./lat.awk $INPUT/rmlsearchflood_$c.tr > $OUTPUT/lattmp.dat
	cat $OUTPUT/lattmp.dat | sort -n >> $OUTPUT/latflood.dat
	
	
	./translearn.awk $INPUT/rmlsearchgbc_$c.tr > $OUTPUT/transtmp.dat
	cat $OUTPUT/transtmp.dat | sort -n >> $OUTPUT/transgbclearn.dat
	
	./trans.awk $INPUT/rmlsearchgbc_$c.tr > $OUTPUT/transtmp.dat
	cat $OUTPUT/transtmp.dat | sort -n >> $OUTPUT/transgbc.dat
	
	./trans.awk $INPUT/rmlsearchbcir_$c.tr > $OUTPUT/transtmp.dat
	cat $OUTPUT/transtmp.dat | sort -n >> $OUTPUT/transbcir.dat
	
	./trans.awk $INPUT/rmlsearchflood_$c.tr > $OUTPUT/transtmp.dat
	cat $OUTPUT/transtmp.dat | sort -n >> $OUTPUT/transflood.dat

done

rm $OUTPUT/lattmp*
rm $OUTPUT/transtmp*

./mediaslat.awk $OUTPUT/latgbc.dat | sort -n > $OUTPUT/latgbc_avg.dat
./mediaslat.awk $OUTPUT/latgbclearn.dat | sort -n > $OUTPUT/latgbclearn_avg.dat
./mediaslat.awk $OUTPUT/latgbctotal.dat | sort -n > $OUTPUT/latgbctotal_avg.dat
./mediaslat.awk $OUTPUT/latbcir.dat | sort -n >  $OUTPUT/latbcir_avg.dat
./mediaslat.awk $OUTPUT/latflood.dat | sort -n > $OUTPUT/latflood_avg.dat

./mediastrans.awk $OUTPUT/transgbc.dat  | sort -n > $OUTPUT/transgbc_avg.dat
./mediastrans.awk $OUTPUT/transgbclearn.dat  | sort -n > $OUTPUT/transgbclearn_avg.dat
./mediastrans.awk $OUTPUT/transbcir.dat  | sort -n >  $OUTPUT/transbcir_avg.dat
./mediastrans.awk $OUTPUT/transflood.dat  | sort -n > $OUTPUT/transflood_avg.dat


eog ../../dataset/"$CNODES"nodes/network$((ITER-1)).png &
./graph.sh $OUTPUT
./amostras.sh $OUTPUT

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
