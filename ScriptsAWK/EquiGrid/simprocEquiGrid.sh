#!/bin/bash

if [ $# -ne 2 ]
then
	echo -e "Usage:  simprocEquiGrid.sh  <mhop> <iter>\n **** rml@fam.ulusiada.pt v1.1 ****"
	exit 1
else

MHOP=$1
ITER=$2
INPUT="/home/rml/work/LOG/ns2RND/EquiGrid"
OUTPUT="/home/rml/work/LOG/dat/EquiGrid"
DROPGBC=0
DROPBCIR=0
DROPBCIR2=0
DROPFLOOD=0
EVDROP=0
TRANSGBC=0
TRANSBCIR=0
TRANSBCIR2=0
TRANSFLOOD=0


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
	./latRND.awk $INPUT/rmlsearchbcir2_$c.tr > $OUTPUT/lattmpRND.dat
	cat $OUTPUT/lattmpRND.dat | sort -n >> $OUTPUT/latbcir2RND.dat
	
	./latRND.awk $INPUT/rmlsearchflood_$c.tr > $OUTPUT/lattmpRND.dat
	cat $OUTPUT/lattmpRND.dat | sort -n >> $OUTPUT/latfloodRND.dat
	
	
	./translearnRND.awk $INPUT/rmlsearchgbc_$c.tr > $OUTPUT/transtmpRND.dat
	cat $OUTPUT/transtmpRND.dat | sort -n >> $OUTPUT/transgbclearnRND.dat
	
	./transRND.awk $INPUT/rmlsearchgbc_$c.tr > $OUTPUT/transtmpRND.dat
	cat $OUTPUT/transtmpRND.dat | sort -n >> $OUTPUT/transgbcRND.dat
	
	./transRND.awk $INPUT/rmlsearchbcir_$c.tr > $OUTPUT/transtmpRND.dat
	cat $OUTPUT/transtmpRND.dat | sort -n >> $OUTPUT/transbcirRND.dat

	./transRND.awk $INPUT/rmlsearchbcir2_$c.tr > $OUTPUT/transtmpRND.dat
	cat $OUTPUT/transtmpRND.dat | sort -n >> $OUTPUT/transbcir2RND.dat
	
	./transRND.awk $INPUT/rmlsearchflood_$c.tr > $OUTPUT/transtmpRND.dat
	cat $OUTPUT/transtmpRND.dat | sort -n >> $OUTPUT/transfloodRND.dat

        DROPtmp=($(./drop.awk $INPUT/rmlsearchgbc_$c.tr))
        DROPGBC=$(( $DROPGBC + $DROPtmp ))
        DROPtmp=($(./drop.awk $INPUT/rmlsearchbcir_$c.tr))
        DROPBCIR=$(( $DROPBCIR + $DROPtmp ))
        DROPtmp=($(./drop.awk $INPUT/rmlsearchbcir2_$c.tr))
        DROPBCIR2=$(( $DROPBCIR2 + $DROPtmp ))
        DROPtmp=($(./drop.awk $INPUT/rmlsearchflood_$c.tr))
        DROPFLOOD=$(( $DROPFLOOD + $DROPtmp ))
        TRANStmp=($(./totaltrans.awk $INPUT/rmlsearchgbc_$c.tr))
        TRANSGBC=$(( $TRANSGBC + $TRANStmp ))
        TRANStmp=($(./totaltrans.awk $INPUT/rmlsearchbcir_$c.tr))
        TRANSBCIR=$(( $TRANSBCIR + $TRANStmp ))
        TRANStmp=($(./totaltrans.awk $INPUT/rmlsearchbcir2_$c.tr))
        TRANSBCIR2=$(( $TRANSBCIR2 + $TRANStmp ))
        TRANStmp=($(./totaltrans.awk $INPUT/rmlsearchflood_$c.tr))
        TRANSFLOOD=$(( $TRANSFLOOD + $TRANStmp ))
        
        #EVDROPtmp=($(./dropevent.awk $RESULTPATH/rmlsearch.tr))
        #EVDROP=$(( $EVDROP + $EVDROPtmp ))

done

rm $OUTPUT/lattmpRND*
rm $OUTPUT/transtmpRND*

./mediaslat.awk $OUTPUT/latgbcRND.dat | sort -n > $OUTPUT/latgbc_avgRND.dat
./mediaslat.awk $OUTPUT/latgbclearnRND.dat | sort -n > $OUTPUT/latgbclearn_avgRND.dat
./mediaslat.awk $OUTPUT/latbcirRND.dat | sort -n >  $OUTPUT/latbcir_avgRND.dat
./mediaslat.awk $OUTPUT/latbcir2RND.dat | sort -n >  $OUTPUT/latbcir2_avgRND.dat
./mediaslat.awk $OUTPUT/latfloodRND.dat | sort -n > $OUTPUT/latflood_avgRND.dat

./mediastrans.awk $OUTPUT/transgbcRND.dat  | sort -n > $OUTPUT/transgbc_avgRND.dat
./mediastrans.awk $OUTPUT/transgbclearnRND.dat  | sort -n > $OUTPUT/transgbclearn_avgRND.dat
./mediastrans.awk $OUTPUT/transbcirRND.dat  | sort -n >  $OUTPUT/transbcir_avgRND.dat
./mediastrans.awk $OUTPUT/transbcir2RND.dat  | sort -n >  $OUTPUT/transbcir2_avgRND.dat
./mediastrans.awk $OUTPUT/transfloodRND.dat  | sort -n > $OUTPUT/transflood_avgRND.dat


./graphRNDpdf.sh $OUTPUT
./amostrasRNDpdf.sh $OUTPUT 

#Queries Fail
./simCountQueryFail.sh EquiGrid $ITER
./failsRNDpdf.sh $OUTPUT

RES1=$(echo "$DROPFLOOD $TRANSFLOOD" | awk '{printf "%.3f \n", $1/$2*100}')
RES2=$(echo "$DROPBCIR $TRANSBCIR" | awk '{printf "%.3f \n", $1/$2*100}')
RES3=$(echo "$DROPBCIR2 $TRANSBCIR2" | awk '{printf "%.3f \n", $1/$2*100}')
RES4=$(echo "$DROPGBC $TRANSGBC" | awk '{printf "%.3f \n", $1/$2*100}')

END=`date +%s`
DIFF=$(( $END - $START ))
{
echo "##################### Log ProcSimulation #########################"
echo "Date:`date`"
echo "CNodes: $CNODES"
echo "ITER: $ITER"
echo "Drops Last FLOOD: $DROPtmp - $(($DROPFLOOD * 100 / ($TRANSFLOOD-1)))%"
echo "############################ TIME ################################"
echo "Execution time was $(($DIFF / 60)) minutes and $(($DIFF % 60)) seconds =  $(($DIFF / 3600)) Hours"
echo "##################################################################"
echo "################### Transmissions Acts ###########################"
echo "TRANSFLOOD - Total: $TRANSFLOOD"
echo "TRANSBCIR  - Total: $TRANSBCIR - Save: $(( ($TRANSFLOOD - $TRANSBCIR) * 100 / ($TRANSFLOOD-1)))%"
echo "TRANSBCIR2 - Total: $TRANSBCIR2 - Save: $(( ($TRANSFLOOD - $TRANSBCIR2) * 100 / ($TRANSFLOOD-1)))%"
echo "TRANSGBC   - Total: $TRANSGBC - Save: $(( ($TRANSFLOOD - $TRANSGBC) * 100 / ($TRANSFLOOD-1)))%"
echo "##################################################################"
echo "########### COLLISIONS - Drop Packets - Percentage ###############"
echo "DropsFLOOD - $RES1%"
echo "DropsBCIR  - $RES2%"
echo "DropsBCIR2 - $RES3%"
echo "DropsGBC   - $RES4%"
#echo "##### EVENT COLLISIONS - Last Network - Last Search ##############"
#echo "Drops - Last: $EVDROP - $(($EVDROP * 100 / ($TRANS-1)))%"
echo "##################################################################"
} | tee $OUTPUT/logPROCEquiGrid.txt
fi
