#!/bin/bash

if [ $# -ne 3 ]
then
	echo -e "Usage:  simulRND.sh  <cnodes> <iter> <delta>\n **** rml@fam.ulusiada.pt v1.1 ****"
	exit 1
else

CNODES=$1
ITER=$2
DELTA=$3
RESULTPATH="/dev/shm/ramfs"
LOG="/home/rml/work/LOG/ns2RND/"$CNODES"nodes"
DATASET="/home/rml/work/dataset/"$CNODES"nodes"
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


for (( c=0; c<$ITER; c++ ))
do

	TOPO=$DATASET"/topo"$c".ini"
	NODES=`cat $TOPO | awk '{print $2}' | head -1`
	SIDE=`cat $TOPO | awk '{print $2}' | tail -1`
	echo C=$c
	
	cp gbcsearch.tcl gbcsearch.tcl.bak
#Estimar a duracao da simulacao	
	SIMULTIME=$((($(($NODES * ($(($NODES-1))) ))) * $(($DELTA+1))))
	
	sed -i 's/set val(stop).*/set val(stop) \t\t '$SIMULTIME'/g' gbcsearch.tcl
	
	sed -i 's/set val(nn).*/set val(nn) \t\t '$NODES'/g' gbcsearch.tcl
	
	sed -i 's/set val(x).*/set val(x) \t\t '$SIDE'/g' gbcsearch.tcl
	sed -i 's/set val(y).*/set val(y) \t\t '$SIDE'/g' gbcsearch.tcl
	
	sed -i 's/set val(out).*/set val(out) \t\t "\/dev\/shm\/ramfs\/rmlsearch"/g' gbcsearch.tcl

	python genTraffileRND.py $CNODES $c $(($SIMULTIME-$DELTA))
	cat traffileGBCtmp | sort -k3 -n > tmp
	head -n -5 tmp > traffileGBC
	cat traffileBCIRtmp | sort -k3 -n > tmp
	head -n -5 tmp > traffileBCIR
	cat traffileFLOODtmp | sort -k3 -n > tmp
	head -n -5 tmp > traffileFLOOD
	rm *tmp
	
	SCENARIO=$DATASET"/cenario"$c
	
	ns gbcsearch.tcl -traf traffileGBC -mov $SCENARIO
	cp $RESULTPATH/rmlsearch.tr $LOG"/rmlsearchgbc_"$c".tr"
	ns gbcsearch.tcl -traf traffileBCIR -mov $SCENARIO
	cp $RESULTPATH/rmlsearch.tr $LOG"/rmlsearchbcir_"$c".tr"
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


eog $DATASET/network$((ITER-1)).png &

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
echo "Area: "$SIDE"x"$SIDE"m² = $(( $SIDE*$SIDE/1000000 )) Km²"
echo "Density: $((($NODES * 1000000) / ($SIDE * $SIDE))) Nodes/Km²"
echo "##################### Execution Command ##########################"
echo "Execution Command: ./simulRND.sh $1 $2 $3" 
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
} | tee $LOG/logRGSimul.txt
fi

