#ns rmlbcir.tcl -traf traffile -mov movfilesetdest -optpampa policy-delpwr -optargs "3e6 2"
#ns rmlbcir.tcl -traf traffile -mov movfilesetdest -optdelay 0 -optargs "3e6 2"
DENS=9 #Nodes/KM
d=$(echo "sqrt($1*$DENS)" | bc)
SIDE=$(( d*100 )) #Meter


if [ $# -ne 1 ]
then
	echo -e "Usage:  multirun.sh  <nodes>  \n **** This is just a simple test ****"
	exit 1
else
echo Side:$SIDE

./genRandomGeo.py $1 $SIDE
fi

exit 0

#	ns rmlsearch.tcl -traf traffileflood -mov movfilesetdest -proto flood -resource $resource
