#ns rmlbcir.tcl -traf traffile -mov movfilesetdest -optpampa policy-delpwr -optargs "3e6 2"
#ns rmlbcir.tcl -traf traffile -mov movfilesetdest -optdelay 0 -optargs "3e6 2"

start_time=`date +%s`
FAIL=0
DROP=0

DENS=100 #Nodes/KM
d=$(echo "sqrt($1*$DENS)" | bc)
SIDE=$(( d*100 )) #Meter

SIDE=2000
if [ $# -ne 2 ]
then
	echo -e "Usage:  flood.sh  <nodes> <runs> \n **** This is just a simple test ****"
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


for (( c=1; c<=$2; c++ ))
do
	./genRandomGeo.py $1 $SIDE
	cp cenario ./scenarios/cenario$c
	cp network.png ./scenarios/network$c.png


#	for ((resource=$(( $1-1 )); resource<$1; resource++))
	for ((resource=1; resource<$1; resource++))
	do
		ns rmlsearch.tcl -traf traffileflood -mov cenario -proto flood -resource $resource
#		ns rmlsearch.tcl -traf traffilebers -mov cenario -proto bers -resource $resource
#		ns rmlsearch.tcl -traf traffilebcir -mov cenario -proto bcir -resource $resource

		if grep -q "Resource at Initiator" ./simul/rmlsearchflood.tr ; then
#    			echo yes
#			./simul/geradat.sh $resource
			echo -e $resource "\t" `./hop.awk ./simul/rmlsearchflood.tr` "\t" `./trans.awk ./simul/rmlsearchflood.tr` >> ./simul/trans.dat
			echo -e $resource "\t" `./hop.awk ./simul/rmlsearchflood.tr` "\t" `./lat.awk ./simul/rmlsearchflood.tr` >> ./simul/lat.dat
		else
#    			echo ALERT: No Resource Found
			FAIL=`expr $FAIL + 1`
		fi
		TEMP=($(./drop.awk ./simul/rmlsearchflood.tr))
		DROP=`expr $DROP + $TEMP`

	done

done

cd simul
if [ -f lat.dat ]
then
#	./clearnegative.sh
	./medias.awk lat.dat | sort -gk 1 > lat2.dat
	./medias.awk trans.dat | sort -gk 1 > trans2.dat
	#./geradat2.sh
	./graphops.sh
fi

cd ..
fi

end_time=`date +%s`
echo ###########################################################
echo END SIMULATION
echo execution time was `expr $end_time - $start_time` s
echo No resource found: $FAIL
echo Total drops at FLOOD: $DROP
echo ###########################################################

exit 0

#	ns rmlsearch.tcl -traf traffileflood -mov movfilesetdest -proto flood -resource $resource
