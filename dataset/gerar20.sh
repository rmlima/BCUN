#!/bin/bash

if [ $# -ne 2 ]
then
	echo -e "Usage:  gerar.sh  <nodes> <numtop>\n **** rml@fam.ulusiada.pt v0.1 ****"
	exit 1
else

NODES=$1
NUMTOP=$2
OUTPUT="./"$NODES"nodes"

if [ ! -d $OUTPUT ]
then
        mkdir $OUTPUT
fi

if [ -f ./cenario ]
then
          rm ./cenario
          rm ./network.png
          rm ./topo.ini
fi



for (( i=0; i<$NUMTOP; i++ ))
do

python genMina.py $NODES 0.25 0.01 3

mv cenario "${OUTPUT}/cenario${i}"
mv network.png "${OUTPUT}/network${i}.png"
mv topo.ini "${OUTPUT}/topo${i}.ini"

done

fi

