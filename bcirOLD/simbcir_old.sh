#ns rmlbcir.tcl -traf traffile -mov movfilesetdest -optpampa policy-delpwr -optargs "3e6 2"
#ns rmlbcir.tcl -traf traffile -mov movfilesetdest -optdelay 0 -optargs "3e6 2"
NAM=1
LOG=0
if [ $LOG -ne 0 ]
then
rm ../backup/LOG/*
fi

sed -i 's/set val(usenam).*/set val(usenam) \t\t '$NAM'/g' rmlsearch.tcl


START=`date +%s`
FAIL=0
DROPFLOOD=0
FLOOD=0

INITIATOR=0
STARTTIME=1
SIZE=1000
DELAY=0.1

TOTALFAILFLOOD=0
TOTALFAILBERS=0
TOTALFAILBCIR=0
TOTALFAILBCIR2=0

TARGETDIR="../backup/LOG/"

if [ ! -d "/dev/shm/ramfs" ]; then
    mkdir /dev/shm/ramfs
    mkdir /dev/shm/ramfs/pair
    mkdir /dev/shm/ramfs/odd
else
	rm /dev/shm/ramfs/pair/*
	rm /dev/shm/ramfs/odd/*
fi


#DENS=25 #Nodes/KM
DENS=25 #Nodes/KM
SIDE=$(echo "scale=2; 1000*sqrt($1/$DENS)" | bc | sed 's/..[0-9]$//') #Meter

if [ $# -ne 2 ]
then
	echo -e "Usage:  multirun.sh  <nodes> <runs> \n **** This is just a simple test ****"
	exit 1
else


cp rmlsearch.tcl rmlsearch.tcl.bak
sed -i 's/set val(nn).*/set val(nn) \t\t '$1'/g' rmlsearch.tcl
sed -i 's/set val(x).*/set val(x) \t\t '$SIDE'/g' rmlsearch.tcl
sed -i 's/set val(y).*/set val(y) \t\t '$SIDE'/g' rmlsearch.tcl


if [ -f ./scenarios/cenario1 ]
then
	rm ./scenarios/*
fi




cd simul
if [ -f trans.dat ]
then
	mv trans.dat trans.bak
fi

if [ -f lat.dat ]
then
	mv lat.dat lat.bak
fi
cd ..


for i in traffileflood traffilebcir traffilebers ; do cp traffile $i ; done
sed -i 's/ns_ at.*/ns_ at '$STARTTIME' "$bcir_('$INITIATOR') flood '$SIZE' '$DELAY'"/g' traffileflood
sed -i 's/ns_ at.*/ns_ at '$STARTTIME' "$bcir_('$INITIATOR') bers '$SIZE' '$DELAY'"/g' traffilebers
sed -i 's/ns_ at.*/ns_ at '$STARTTIME' "$bcir_('$INITIATOR') bcir '$SIZE' '$DELAY'"/g' traffilebcir

for (( c=1; c<=$2; c++ ))
do

	FAILFLOOD=0
	FAILBERS=0
	FAILBCIR=0

	./genRandomGeo.py $1 $SIDE
	cp cenario ./scenarios/cenario$c
	cp network.png ./scenarios/network$c.png


#	for ((resource=$(( $1-1 )); resource<$1; resource++)) > /dev/null 2>&1
	for ((resource=1; resource<$1; resource++))
	do
		if [ "$(( $resource % 2 ))" -eq 0 ] ; then
			RESULTPATH="/dev/shm/ramfs/pair"
			sed -i 's/set val(out).*/set val(out) \t\t "\/dev\/shm\/ramfs\/pair\/rmlsearch"/g' rmlsearch.tcl
		else
			RESULTPATH="/dev/shm/ramfs/odd"
			sed -i 's/set val(out).*/set val(out) \t\t "\/dev\/shm\/ramfs\/odd\/rmlsearch"/g' rmlsearch.tcl
		fi
		echo -e "################# ITR = $c \t NODE = $resource ##################"
		sem  -j+0 ns rmlsearch.tcl -traf traffileflood -mov cenario -proto flood -resource $resource  > /dev/null 2>&1 &
		sem  -j+0 ns rmlsearch.tcl -traf traffilebers -mov cenario -proto bers -resource $resource  > /dev/null 2>&1 &
		sem  -j+0 ns rmlsearch.tcl -traf traffilebcir -mov cenario -proto bcir -resource $resource  > /dev/null 2>&1 &

		sem --wait
		sem --wait
		sem --wait

		#sync
		#sleep 1 #Wait to finish writing

		LATFLOOD=`./lat.awk $RESULTPATH/rmlsearchflood.tr`
		LATBERS=`./lat.awk $RESULTPATH/rmlsearchbers.tr`
		LATBCIR=`./lat.awk $RESULTPATH/rmlsearchbcir.tr`
#		LATBCIR2=`./lat.awk $RESULTPATH/rmlsearchbcir2.tr`


		if [ ! "$LATBERS" = -1 ]; then
			HOPS=`./hop.awk $RESULTPATH/rmlsearchbers.tr`
                elif [ ! "$LATBCIR" = -1 ]; then
			HOPS=`./hop.awk $RESULTPATH/rmlsearchbcir.tr`
#                elif [ ! "$LATBCIR2" = -1 ]; then
#			HOPS=`./hop.awk $RESULTPATH/rmlsearchbcir2.tr`
		elif [ ! "$LATFLOOD" = -1 ]; then
                        HOPS=`./hop.awk $RESULTPATH/rmlsearchflood.tr`
		else
			HOPS=0
                fi



		if [ "$LATFLOOD"  = -1 ]
		then
			TRFLOOD=-1
			FAILFLOOD=$(($FAILFLOOD + 1))
		else
			TRFLOOD=`./trans.awk $RESULTPATH/rmlsearchflood.tr`
			if [ $LOG -ne 0 ]
			then
				cp $RESULTPATH/rmlsearchflood.tr "$TARGETDIR"rmlsearchflood_"$c"_"$resource".tr
			fi
		fi

		if [ "$LATBERS" = -1 ]
		then
                        TRBERS=-1
			FAILBERS=$(($FAILBERS + 1))
                else
			TRBERS=`./trans.awk $RESULTPATH/rmlsearchbers.tr`
			if [ $LOG -ne 0 ]
			then
				cp $RESULTPATH/rmlsearchbers.tr "$TARGETDIR"rmlsearchbers_"$c"_"$resource".tr
			fi
		fi

		if [ "$LATBCIR" = -1 ]
		then
                        TRBCIR=-1
			FAILBCIR=$(($FAILBCIR + 1))
                else
			TRBCIR=`./trans.awk $RESULTPATH/rmlsearchbcir.tr`
			if [ $LOG -ne 0 ]
			then
				cp $RESULTPATH/rmlsearchbcir.tr "$TARGETDIR"rmlsearchbcir_"$c"_"$resource".tr
			fi
		fi

#		if [ "$LATBCIR2" = -1 ]
#		then
#                        TRBCIR2=-1
#			FAILBCIR2=$(($FAILBCIR2 + 1))
#                else
#			TRBCIR2=`./trans.awk $RESULTPATH/rmlsearchbcir.tr`
#			if [ $LOG -ne 0 ]
#			then
#				cp $RESULTPATH/rmlsearchbcir2.tr "$TARGETDIR"rmlsearchbcir2_"$c"_"$resource".tr
#			fi
#		fi



		if [ ! "$HOPS" = 0 ] ; then
		echo -e $resource "\t" $HOPS "\t" $LATFLOOD "\t" $LATBERS "\t" $LATBCIR  >> ./simul/lat.dat
		echo -e $resource "\t" $HOPS "\t" $TRFLOOD "\t" $TRBERS "\t" $TRBCIR  >> ./simul/trans.dat
		fi
#		if grep -q "Resource at Initiator" ./simul/rmlsearchbers.tr \
#			&& grep -q "Resource at Initiator" ./simul/rmlsearchbcir.tr ; then
#    			echo yes
#			./simul/geradat.sh $resource
#			echo -e $resource "\t" `./hop.awk ./simul/rmlsearchflood.tr` "\t" `./trans.awk ./simul/rmlsearchflood.tr` "\t" `./trans.awk ./simul/rmlsearchbers.tr` "\t" `./trans.awk ./simul/rmlsearchbcir.tr` >> ./simul/trans.dat
#			echo -e $resource "\t" `./hop.awk ./simul/rmlsearchflood.tr` "\t" `./lat.awk ./simul/rmlsearchflood.tr` "\t" `./lat.awk ./simul/rmlsearchbers.tr` "\t" `./lat.awk ./simul/rmlsearchbcir.tr` >> ./simul/lat.dat
#		else
#    			echo ALERT: No Resource Found
#			TEMP_FAIL=`expr $TEMP_FAIL + 1`
#		fi
	done
	TOTALFAILFLOOD=$(( $TOTALFAILFLOOD + $FAILFLOOD ))
	TOTALFAILBERS=$(( $TOTALFAILBERS + $FAILBERS ))
	TOTALFAILBCIR=$(( $TOTALFAILBCIR + $FAILBCIR ))


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
	rm temp*
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
echo "Nodes: $1"
echo "Area: "$SIDE"x"$SIDE"m² = $(( $SIDE*$SIDE/1000000 )) Km²"
echo "Density: $((($1 * 1000000) / ($SIDE * $SIDE))) Nodes/Km²"
echo "Iterations: $2"
echo "TOTAL Search: $(( $1*$2 ))"
if [ $LOG -ne 0 ]; then SPACE=`du -s ../backup/LOG| awk '{print $1}'`;echo "Total LOG size: $SPACE";fi
echo "############################ TIME ################################"
echo "Execution time was $(($DIFF / 60)) minutes and $(($DIFF % 60)) seconds =  $(($DIFF / 3600)) Hours" 
echo "################### GLOBAL CONNECTIVITY  #########################"
echo -e "FLOOD FAILS : $TOTALFAILFLOOD \t $(($TOTALFAILFLOOD * 100 / ($1*$2) ))%"
echo -e "BERS  FAILS : $TOTALFAILBERS \t $(($TOTALFAILBERS * 100 / ($1*$2) ))%"
echo -e "BCIR  FAILS : $TOTALFAILBCIR \t $(($TOTALFAILBCIR * 100 / ($1*$2) ))%"
echo "##################################################################"
echo "################# LAST NETWORK - LAST SEARCH #####################"
echo "##################################################################"
echo "####### Simulation TIME  - Last Network - Last Search ############"
echo -e "Simulation Time FLOOD: $FLOODTIME"
echo -e "Simulation Time BERS:  $BERSTIME"
echo -e "Simulation Time BCIR:  $BCIRTIME"
echo "##################################################################"
echo "########## CONNECTIVITY - Last Network - Last Search  ############"
echo -e "FLOOD FAILS : $FAILFLOOD \t $(($FAILFLOOD * 100 / $1 ))%"
echo -e "BERS  FAILS : $FAILBERS \t $(($FAILBERS * 100 / $1 ))%"
echo -e "BCIR  FAILS : $FAILBCIR \t $(($FAILBCIR * 100 / $1 ))%"
echo "##################################################################"
echo "########## COLLISIONS - Last Network - Last Search ###############"
echo -e "Drops at FLOOD - Last: $DROPFLOOD \t $(($DROPFLOOD * 100 / $1))%"
echo -e "Drops at BERS  - Last: $DROPBERS \t $(($DROPBERS * 100 / $1))%"
echo -e "Drops at BCIR  - Last: $DROPBCIR \t $(($DROPBCIR * 100 / $1))%"
echo "##### EVENT COLLISIONS - Last Network - Last Search ##############"
echo -e "Drops at FLOOD - Last: $EVDROPFLOOD \t $(($EVDROPFLOOD * 100 / $1))%"
echo -e "Drops at BERS  - Last: $EVDROPBERS \t $(($EVDROPBERS * 100 / $1))%"
echo -e "Drops at BCIR  - Last: $EVDROPBCIR \t $(($EVDROPBCIR * 100 / $1))%"
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
