#ns rmlbcir.tcl -traf traffile -mov movfilesetdest -optpampa policy-delpwr -optargs "3e6 2"
#ns rmlbcir.tcl -traf traffile -mov movfilesetdest -optdelay 0 -optargs "3e6 2"
if [ $# -ne 4 ]
then
	echo -e "Usage:  simbcir.sh  <nodes> <runs> <delay> <jitter>\n **** rml@fam.ulusiada.pt v1.1 ****"
	exit 1
 else

NAM=0
LOG=1
NODES=$1
RUNS=$2
DELAY=$3
JITTER=$4

START=`date +%s`
FAIL=0
DROPFLOOD=0
FLOOD=0

INITIATOR=0 STARTTIME=1 SIZE=1000 #Packet - Message size in Bytes NODES=$1 RUNS=$2 DELAY=$3 JITTER=$4

TOTALFAILFLOOD=0
TOTALFAIL_SEARCH_FLOOD=0
TOTALFAIL_ACK_FLOOD=0
TOTALFAILBERS=0
TOTALFAIL_SEARCH_BERS=0
TOTALFAIL_ACK_BERS=0
TOTALFAIL_CANCEL_BERS=0
TOTALFAILBCIR=0
TOTALFAIL_SEARCH_BCIR=0
TOTALFAIL_CANCEL_BCIR=0
DISCARD=0

RESULTPATH="/dev/shm/ramfs"
LOGPATH="../backup/LOG"

if [ $LOG -eq 1 ]; then
	if [ ! -d $LOGPATH ]; then mkdir $LOGPATH; else
		#if [ ! "$(ls -A $LOGPATH)" ] ; then rm -rf $LOGPATH/* ; fi
		rm -rf $LOGPATH/*
	fi
fi

sed -i 's/set val(usenam).*/set val(usenam) \t\t '$NAM'/g' rmlsearch.tcl



if [ ! -d $RESULTPATH ]; then
    mkdir $RESULTPATH
else
	rm -rf $RESULTPATH/*
fi


#DENS=25 #Nodes/KM
#SIDE=$(echo "scale=2; 1000*sqrt($1/$DENS)" | bc | sed 's/..[0-9]$//') # Calc inside genRandomGeo.py



cp rmlsearch.tcl rmlsearch.tcl.bak
sed -i 's/set val(nn).*/set val(nn) \t\t '$NODES'/g' rmlsearch.tcl

sed -i 's/set val(out).*/set val(out) \t\t "\/dev\/shm\/ramfs\/rmlsearch"/g' rmlsearch.tcl

if [ -f ./scenarios/cenario1 ]
then
	rm ./scenarios/*
fi

if [ -f ./simul/lat.dat ]
then
	rm  ./simul/*.dat
fi

if [ -f ./simul/trans.dat ]
then
	rm  ./simul/*.dat
fi



for i in traffileflood traffilebcir traffilebers ; do cp traffile $i ; done
sed -i 's/ns_ at.*/ns_ at '$STARTTIME' "$bcir_('$INITIATOR') flood '$SIZE' '$DELAY' '$JITTER'"/g' traffileflood
sed -i 's/ns_ at.*/ns_ at '$STARTTIME' "$bcir_('$INITIATOR') bers '$SIZE' '$DELAY' '$JITTER'"/g' traffilebers
sed -i 's/ns_ at.*/ns_ at '$STARTTIME' "$bcir_('$INITIATOR') bcir '$SIZE' '$DELAY' '$JITTER' 1"/g' traffilebcir

for (( c=1; c<=$RUNS; c++ ))
do

	FAIL_ACK_FLOOD=0
	FAIL_SEARCH_FLOOD=0
	FAIL_SEARCH_BERS=0
	FAIL_ACK_BERS=0
	FAIL_SEARCH_BCIR=0
	FAIL_CANCEL_BCIR=0

	SIDE=$(python genRandomGeo.py $NODES)
	echo $SIDE

	sed -i 's/set val(x).*/set val(x) \t\t '$SIDE'/g' rmlsearch.tcl
	sed -i 's/set val(y).*/set val(y) \t\t '$SIDE'/g' rmlsearch.tcl


	cp cenario ./scenarios/cenario$c
	cp network.png ./scenarios/network$c.png


#	for ((resource=$(( $NODES-1 )); resource<$NODES; resource++)) > /dev/null 2>&1
	for ((resource=1; resource<$NODES; resource++))
	do
		echo -e "################# ITR = $c \t NODE = $resource ##################"
		ns rmlsearch.tcl -traf traffileflood -mov cenario -proto flood -resource $resource  > /dev/null 2>&1
		ns rmlsearch.tcl -traf traffilebers -mov cenario -proto bers -resource $resource  > /dev/null 2>&1
		ns rmlsearch.tcl -traf traffilebcir -mov cenario -proto bcir -resource $resource  > /dev/null 2>&1

		#sync
		#sleep 1 #Wait to finish writing

		FAIL_FLOOD=0
		FAIL_BERS=0
		FAIL_BCIR=0

 		if ! grep --quiet Found $RESULTPATH/rmlsearchflood.tr; then FAIL_SEARCH_FLOOD=$(($FAIL_SEARCH_FLOOD + 1)); FAIL_FLOOD=1
 		elif ! grep --quiet Initiator $RESULTPATH/rmlsearchflood.tr; then FAIL_ACK_FLOOD=$(($FAIL_ACK_FLOOD + 1)); FAIL_FLOOD=1
		fi
 		if ! grep --quiet Found $RESULTPATH/rmlsearchbers.tr; then FAIL_SEARCH_BERS=$(($FAIL_SEARCH_BERS + 1)); FAIL_BERS=1
 		elif ! grep --quiet Initiator $RESULTPATH/rmlsearchbers.tr; then FAIL_ACK_BERS=$(($FAIL_ACK_BERS + 1)); FAIL_BERS=1
		fi
 		if ! grep --quiet Found $RESULTPATH/rmlsearchbcir.tr; then FAIL_SEARCH_BCIR=$(($FAIL_SEARCH_BCIR + 1)); FAIL_BCIR=1
 		elif ! grep --quiet Initiator $RESULTPATH/rmlsearchbcir.tr; then FAIL_CANCEL_BCIR=$(($FAIL_CANCEL_BCIR + 1)); FAIL_BCIR=1
		fi

		if [ ! "$FAIL_FLOOD" = 1 ] && [ ! "$FAIL_BERS" = 1 ] && [ ! "$FAIL_BCIR" = 1 ] ; then
			HOPS=`./hop.awk $RESULTPATH/rmlsearchflood.tr`
			LATFLOOD=`./lat.awk $RESULTPATH/rmlsearchflood.tr`
			TRFLOOD=`./trans.awk $RESULTPATH/rmlsearchflood.tr`

#			HOPS=`./hop.awk $RESULTPATH/rmlsearchbers.tr`
			LATBERS=`./lat.awk $RESULTPATH/rmlsearchbers.tr`
			TRBERS=`./trans.awk $RESULTPATH/rmlsearchbers.tr`

#			HOPS=`./hop.awk $RESULTPATH/rmlsearchbcir.tr`
			LATBCIR=`./lat.awk $RESULTPATH/rmlsearchbcir.tr`
			TRBCIR=`./trans.awk $RESULTPATH/rmlsearchbcir.tr`

			echo -e $resource "\t" $HOPS "\t" $LATFLOOD "\t" $LATBERS "\t" $LATBCIR  >> ./simul/lat.dat
			echo -e $resource "\t" $HOPS "\t" $TRFLOOD "\t" $TRBERS "\t" $TRBCIR  >> ./simul/trans.dat

		else
			DISCARD=$(( $DISCARD + 1 ))
		fi


		if [ $LOG -ne 0 ]
			then
				cp $RESULTPATH/rmlsearchflood.tr "$LOGPATH"/rmlsearchflood_"$c"_"$resource".tr
				cp $RESULTPATH/rmlsearchbers.tr "$LOGPATH"/rmlsearchbers_"$c"_"$resource".tr
				cp $RESULTPATH/rmlsearchbcir.tr "$LOGPATH"/rmlsearchbcir_"$c"_"$resource".tr
		fi
	done
	TOTALFAIL_SEARCH_FLOOD=$(( $TOTALFAIL_SEARCH_FLOOD + $FAIL_SEARCH_FLOOD ))
	TOTALFAIL_ACK_FLOOD=$(( $TOTALFAIL_ACK_FLOOD + $FAIL_ACK_FLOOD ))
	TOTALFAIL_SEARCH_BERS=$(( $TOTALFAIL_SEARCH_BERS + $FAIL_SEARCH_BERS ))
	TOTALFAIL_ACK_BERS=$(( $TOTALFAIL_ACK_BERS + $FAIL_ACK_BERS ))
	TOTALFAIL_CANCEL_BCIR=$(( $TOTALFAIL_CANCEL_BCIR + $FAIL_CANCEL_BCIR ))
	TOTALFAIL_SEARCH_BCIR=$(( $TOTALFAIL_SEARCH_BCIR + $FAIL_SEARCH_BCIR ))
done
DROPFLOOD=($(./drop.awk $RESULTPATH/rmlsearchflood.tr))
DROPBERS=($(./drop.awk $RESULTPATH/rmlsearchbers.tr))
DROPBCIR=($(./drop.awk $RESULTPATH/rmlsearchbcir.tr))

EVDROPFLOOD=($(./dropevent.awk $RESULTPATH/rmlsearchflood.tr))
EVDROPBERS=($(./dropevent.awk $RESULTPATH/rmlsearchbers.tr))
EVDROPBCIR=($(./dropevent.awk $RESULTPATH/rmlsearchbcir.tr))



cd simul
if [ -f lat.dat ]
then
 #	./clearnegative.sh
	./mediaslat.awk lat.dat
	cat temp1 | sort -gk 1 > latflood.dat
	cat temp2 | sort -gk 1 > latbers.dat
	cat temp3 | sort -gk 1 > latbcir.dat
	rm temp*

	./mediastrans.awk trans.dat
        cat temp1 | sort -gk 1 > transflood.dat
        cat temp2 | sort -gk 1 > transbers.dat
        cat temp3 | sort -gk 1 > transbcir.dat
	rm temp*

	./freq.awk ./lat.dat > freq.dat
	cat freq.dat | sort -gk 1 | sed '/^-1/d' > freq2.dat
	#./geradat2.sh
	./graphops.sh
fi

cd ..

#### Last Simulation Time ####
FLOODTIME=($(./time.awk $RESULTPATH/rmlsearchflood.tr))
BERSTIME=($(./time.awk $RESULTPATH/rmlsearchbers.tr))
BCIRTIME=($(./time.awk $RESULTPATH/rmlsearchbcir.tr))



END=`date +%s`
DIFF=$(( $END - $START ))
{
echo "######################## Log Simulation ##########################"
echo "Date:`date`"
echo "Nodes: $NODES"
echo "Iterations: $RUNS"
echo "Delay: $DELAY"
echo "Jitter: $JITTER"
echo "Area: "$SIDE"x"$SIDE"m² = $(( $SIDE*$SIDE/1000000 )) Km²"
echo "Density: $((($NODES * 1000000) / ($SIDE * $SIDE))) Nodes/Km²"
echo "TOTAL Search: $(( ($NODES - 1) * $RUNS ))"
echo "Iterations Discarded: $DISCARD : $(($DISCARD*100/(($NODES -1)*$RUNS)))%"
echo "DelayFlood: rng.uniform($DELAY,$JITTER)"
echo "AddedDelay: $DELAY*2*H+DelayFlood"
if [ $LOG -ne 0 ]; then SPACE=`du -s $LOGPATH| awk '{print $1}'`;echo "Total LOG size: $SPACE";fi
echo "############################ TIME ################################"
echo "Execution time was $(($DIFF / 60)) minutes and $(($DIFF % 60)) seconds =  $(($DIFF / 3600)) Hours" 
echo "################### GLOBAL CONNECTIVITY  #########################"
echo -e "FLOOD FAILS : Fs=$TOTALFAIL_SEARCH_FLOOD : Fa=$TOTALFAIL_ACK_FLOOD \t $((($TOTALFAIL_ACK_FLOOD + $TOTALFAIL_SEARCH_FLOOD) * 100 / (($NODES - 1)*$RUNS) ))%"
echo -e "BERS  FAILS : Fs=$TOTALFAIL_SEARCH_BERS : Fa=$TOTALFAIL_ACK_BERS \t $((($TOTALFAIL_ACK_BERS + $TOTALFAIL_SEARCH_BERS) * 100 / (($NODES - 1)*$RUNS) ))%"
echo -e "BCIR  FAILS : Fs=$TOTALFAIL_SEARCH_BCIR : Fc=$TOTALFAIL_CANCEL_BCIR \t $((($TOTALFAIL_CANCEL_BCIR + $TOTALFAIL_SEARCH_BCIR) * 100 / (($NODES - 1)*$RUNS) ))%"
echo "##################################################################"
echo "################# LAST NETWORK - LAST SEARCH #####################"
echo "##################################################################"
echo "####### Simulation TIME  - Last Network - Last Search ############"
echo -e "Simulation Time FLOOD: $FLOODTIME"
echo -e "Simulation Time BERS:  $BERSTIME"
echo -e "Simulation Time BCIR:  $BCIRTIME"
echo "##################################################################"
echo "########## CONNECTIVITY - Last Network - Last Search  ############"
echo -e "FLOOD FAILS : $FAIL_SEARCH_FLOOD : $FAIL_ACK_FLOOD \t $((($FAIL_ACK_FLOOD + $FAIL_SEARCH_FLOOD) * 100 / ($NODES - 1)))%"
echo -e "BERS  FAILS : $FAIL_SEARCH_BERS : $FAIL_ACK_BERS \t $((($FAIL_ACK_BERS + $FAIL_SEARCH_BERS) * 100 / ($NODES - 1)))%"
echo -e "BCIR  FAILS : $FAIL_SEARCH_BCIR : $FAIL_CANCEL_BCIR \t $((($FAIL_CANCEL_BCIR + $FAIL_SEARCH_BCIR) * 100 / ($NODES - 1)))%"
echo "##################################################################"
echo "########## COLLISIONS - Last Network - Last Search ###############"
echo -e "Drops at FLOOD - Last: $DROPFLOOD \t $(($DROPFLOOD * 100 / ($NODES-1)))%"
echo -e "Drops at BERS  - Last: $DROPBERS \t $(($DROPBERS * 100 / ($NODES-1)))%"
echo -e "Drops at BCIR  - Last: $DROPBCIR \t $(($DROPBCIR * 100 / ($NODES-1)))%"
echo "##### EVENT COLLISIONS - Last Network - Last Search ##############"
echo -e "Drops at FLOOD - Last: $EVDROPFLOOD \t $(($EVDROPFLOOD * 100 / ($NODES-1)))%"
echo -e "Drops at BERS  - Last: $EVDROPBERS \t $(($EVDROPBERS * 100 / ($NODES-1)))%"
echo -e "Drops at BCIR  - Last: $EVDROPBCIR \t $(($EVDROPBCIR * 100 / ($NODES-1)))%"
echo "##################################################################"
echo "######################### FLOOD ##################################"
./rate.awk $RESULTPATH/rmlsearchflood.tr
echo "########################## BERS ##################################"
./rate.awk $RESULTPATH/rmlsearchbers.tr
echo "########################## BCIR ##################################"
./rate.awk $RESULTPATH/rmlsearchbcir.tr
} | tee log.txt

fi

exit 0

#	ns rmlsearch.tcl -traf traffileflood -mov movfilesetdest -proto flood -resource $resource
