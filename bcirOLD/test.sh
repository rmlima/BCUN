#ns rmlbcir.tcl -traf traffile -mov movfilesetdest -optpampa policy-delpwr -optargs "3e6 2"
#ns rmlbcir.tcl -traf traffile -mov movfilesetdest -optdelay 0 -optargs "3e6 2"
if [ $# -ge 1 ]
then
	echo -e "Usage:  test.sh \n **** This is just a simple test ****"
	exit 1
else

cd simul
mv trans.dat trans.bak
mv lat.dat lat.bak
cd ..

for resource in {1..4}
do
	ns rmlsearch.tcl -traf traffileflood -mov movfilesetdest -proto flood -resource $resource
	ns rmlsearch.tcl -traf traffilebers -mov movfilesetdest -proto bers -resource $resource
	ns rmlsearch.tcl -traf traffilebcir -mov movfilesetdest -proto bcir -resource $resource
	./final.sh $resource
done
	cd simul
	./graph.sh
	cd ..
	exit 0
fi


