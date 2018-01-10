#!/bin/bash

if [ $# -ne 2 ]
then
	echo -e "Usage:  simprocRND.sh  <cnodes> <iter>\n **** rml@fam.ulusiada.pt v1.1 ****"
	exit 1
else

CNODES=$1
ITER=$2
INPUT="/home/rml/work/LOG/ns2RND/"$CNODES"nodes"
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


rm $OUTPUT/*RND.dat


for (( c=0; c<$ITER; c++ ))
do
	#Aquecimento
	./latlearnRND.awk $INPUT/rmlsearchgbc_$c.tr > $OUTPUT/lattmpRND.dat
	cat $OUTPUT/lattmpRND.dat | sort -n >> $OUTPUT/latgbclearnRND.dat
	./latRND.awk $INPUT/rmlsearchgbc_$c.tr > $OUTPUT/lattmpRND.dat
	cat $OUTPUT/lattmpRND.dat | sort -n >> $OUTPUT/latgbcRND.dat
	./latRND.awk $INPUT/rmlsearchbcir_$c.tr > $OUTPUT/lattmpRND.dat
	cat $OUTPUT/lattmpRND.dat | sort -n >> $OUTPUT/latbcirRND.dat
	
	./latRND.awk $INPUT/rmlsearchflood_$c.tr > $OUTPUT/lattmpRND.dat
	cat $OUTPUT/lattmpRND.dat | sort -n >> $OUTPUT/latfloodRND.dat
	
	
	./translearnRND.awk $INPUT/rmlsearchgbc_$c.tr > $OUTPUT/transtmpRND.dat
	cat $OUTPUT/transtmpRND.dat | sort -n >> $OUTPUT/transgbclearnRND.dat
	
	./transRND.awk $INPUT/rmlsearchgbc_$c.tr > $OUTPUT/transtmpRND.dat
	cat $OUTPUT/transtmpRND.dat | sort -n >> $OUTPUT/transgbcRND.dat
	
	./transRND.awk $INPUT/rmlsearchbcir_$c.tr > $OUTPUT/transtmpRND.dat
	cat $OUTPUT/transtmpRND.dat | sort -n >> $OUTPUT/transbcirRND.dat
	
	./transRND.awk $INPUT/rmlsearchflood_$c.tr > $OUTPUT/transtmpRND.dat
	cat $OUTPUT/transtmpRND.dat | sort -n >> $OUTPUT/transfloodRND.dat

done

rm $OUTPUT/lattmpRND*
rm $OUTPUT/transtmpRND*

./mediaslat.awk $OUTPUT/latgbcRND.dat | sort -n > $OUTPUT/latgbc_avgRND.dat
./mediaslat.awk $OUTPUT/latgbclearnRND.dat | sort -n > $OUTPUT/latgbclearn_avgRND.dat
./mediaslat.awk $OUTPUT/latbcirRND.dat | sort -n >  $OUTPUT/latbcir_avgRND.dat
./mediaslat.awk $OUTPUT/latfloodRND.dat | sort -n > $OUTPUT/latflood_avgRND.dat

./mediastrans.awk $OUTPUT/transgbcRND.dat  | sort -n > $OUTPUT/transgbc_avgRND.dat
./mediastrans.awk $OUTPUT/transgbclearnRND.dat  | sort -n > $OUTPUT/transgbclearn_avgRND.dat
./mediastrans.awk $OUTPUT/transbcirRND.dat  | sort -n >  $OUTPUT/transbcir_avgRND.dat
./mediastrans.awk $OUTPUT/transfloodRND.dat  | sort -n > $OUTPUT/transflood_avgRND.dat


eog ../../dataset/"$CNODES"nodes/network$((ITER-1)).png &
./graphRND.sh $OUTPUT
./amostrasRND.sh $OUTPUT

END=`date +%s`
DIFF=$(( $END - $START ))
{
echo "##################### Log ProcSimulation #########################"
echo "Date:`date`"
echo "CNodes: $CNODES"
echo "############################ TIME ################################"
echo "Execution time was $(($DIFF / 60)) minutes and $(($DIFF % 60)) seconds =  $(($DIFF / 3600)) Hours" 
echo "##################################################################"
} | tee $OUTPUT/logRGProc.txt
fi
cp $INPUT/logRGSimul.txt $OUTPUT
