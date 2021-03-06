#!/bin/bash

if [ $# -ne 2 ]
then
	echo -e "Usage:  simulEquiGrid.sh  <cnodes> <iter>\n **** rml@fam.ulusiada.pt v2.0 ****"
	exit 1
else

CNODES=$1
ITER=$2
ALCANCE=200
NODES=$(($CNODES*$CNODES))
SIDE=$(($ALCANCE * ($(($CNODES+1))) ))

EVENTS=200

WARMUP=100
MAXTIMEQUERY=10
SIMULTIME=$(($WARMUP+$(($EVENTS+1))*$MAXTIMEQUERY)) #MAX Simulation Time

case "$CNODES" in
10) MHOP=12
    ;;
13) MHOP=16
    ;;
25) MHOP=32
     ;;
100) MHOP=100
     ;;
*) echo -e "Error:      cnodes must be 10 or 13 or 25 or 100"
   exit 1
   ;;
esac



RESULTPATH="/dev/shm/ramfs"
LOG="/home/rml/work/LOG/ns2RND/EquiGrid"
OUTPUT="/home/rml/work/LOG/dat/EquiGrid"
DATASET="/home/rml/work/dataset/EquiGrid"
DROP=0
EVDROP=0
TRANS=0



if [ ! -d $DATASET ]
then
	echo -e "Error:	No dataset available"
	exit 1
fi

if [ ! -d $LOG ]
then
        mkdir $LOG
else
	rm $LOG"/rmlsearch"*
fi


START=`date +%s`


if [ ! -d $RESULTPATH ]; then
    mkdir $RESULTPATH
else
	rm -rf $RESULTPATH/*
fi


cp gbcsearch.tcl gbcsearch.tcl.bak


sed -i 's/set val(stop).*/set val(stop) \t\t '$SIMULTIME'/g' gbcsearch.tcl

sed -i 's/set val(nn).*/set val(nn) \t\t '$NODES'/g' gbcsearch.tcl

sed -i 's/set val(x).*/set val(x) \t\t '$SIDE'/g' gbcsearch.tcl
sed -i 's/set val(y).*/set val(y) \t\t '$SIDE'/g' gbcsearch.tcl

sed -i 's/set val(out).*/set val(out) \t\t "\/dev\/shm\/ramfs\/rmlsearch"/g' gbcsearch.tcl


for (( c=0; c<$ITER; c++ ))
do

	python genTraffileRND.py $NODES $EVENTS

	#cat traffileGBCtmp | sort -k3 -n > tmp
	#head -n -5 tmp > traffileGBC
	cat traffileGBCtmp | sort -k3 -n > traffileGBC
	cat traffileBCIRtmp | sort -k3 -n > traffileBCIR
	cat traffileBCIR2tmp | sort -k3 -n > traffileBCIR2
	cat traffileFLOODtmp | sort -k3 -n > traffileFLOOD

	SCENARIO=$DATASET"/cenario_"$CNODES"_"$c

	ns gbcsearch.tcl -traf traffileGBC -mov $SCENARIO
	cp $RESULTPATH/rmlsearch.tr $LOG"/rmlsearchgbc_"$c".tr"
	ns gbcsearch.tcl -traf traffileBCIR -mov $SCENARIO
	cp $RESULTPATH/rmlsearch.tr $LOG"/rmlsearchbcir_"$c".tr"
	ns gbcsearch.tcl -traf traffileBCIR2 -mov $SCENARIO
	cp $RESULTPATH/rmlsearch.tr $LOG"/rmlsearchbcir2_"$c".tr"
	ns gbcsearch.tcl -traf traffileFLOOD -mov $SCENARIO
	cp $RESULTPATH/rmlsearch.tr $LOG"/rmlsearchflood_"$c".tr"
	
	#Falta copiar nam se existir!

	
	DROPtmp=($(./drop.awk $RESULTPATH/rmlsearch.tr))
	EVDROPtmp=($(./dropevent.awk $RESULTPATH/rmlsearch.tr))
	TRANStmp=($(./sent.awk $RESULTPATH/rmlsearch.tr))
	
	DROP=$(( $DROP + $DROPtmp ))
	EVDROP=$(( $EVDROP + $EVDROPtmp ))
	TRANS=$(( $TRANS + $TRANStmp ))
done


if [ -f ./bloom.log ]
then
        mv bloom.log $LOG/bloomRND$PROTO.log
fi
if [ -f ./gradient.log ]
then
        mv gradient.log $LOG/gradientRND.log
fi

END=`date +%s`
DIFF=$(( $END - $START ))
{
echo "######################## Log Simulation ##########################"
echo "Date:`date`"
echo "Nodes: $NODES"
echo "Iterations: $ITER"
echo "Area: "$SIDE"x"$SIDE"m² = $(( $SIDE*$SIDE/1000000 )) Km²"
echo "Density: $((($NODES * 1000000) / ($SIDE * $SIDE))) Nodes/Km²"
echo "##################### Execution Command ##########################"
echo "Execution Command: $0 $1 $2 $3" 
echo "############################ TIME ################################"
echo "Execution time was $(($DIFF / 60)) minutes and $(($DIFF % 60)) seconds =  $(($DIFF / 3600)) Hours" 
echo "################### Transmissions Acts ###########################"
echo "TRANS - Last: $TRANStmp - Total: $TRANS"
echo "##################################################################"
echo "##################################################################"
echo "############# COLLISIONS - TOTAL - Global Search #################"
echo "Drops - Total: $DROP - $(($DROP * 100 / ($TRANS-1)))%"
echo "############# EVENT COLLISIONS - GLOBAL - Search #################"
echo "Drops - Total: $EVDROP - $(($EVDROP * 100 / ($TRANS-1)))%"
echo "##################################################################"
echo "########## COLLISIONS - Last Network - Last Search ###############"
echo "Drops - Last: $DROPtmp - $(($DROPtmp * 100 / ($TRANStmp-1)))%"
echo "##### EVENT COLLISIONS - Last Network - Last Search ##############"
echo "Drops - Last: $EVDROPtmp - $(($EVDROPtmp * 100 / ($TRANStmp-1)))%"
echo "##################################################################"
} | tee $OUTPUT/logEquiGridSimul.txt
fi

echo
echo End simulation ... starting processing data
echo
./simprocEquiGrid.sh $MHOP $ITER
echo
rm *tmp
echo The End
echo
