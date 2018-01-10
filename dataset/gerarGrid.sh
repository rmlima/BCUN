#!/bin/bash
if [ $# -ne 2 ]
then
	echo -e "Usage:  gerarGrid.sh  <Lnodes> <numtop> , for LxL grid \n **** rml@fam.ulusiada.pt v0.1 ****"
	exit 1
else

L=$1
NUMTOP=$2
OUTPUT="./EquiGrid"

if [ ! -d $OUTPUT ]
then
        mkdir $OUTPUT
fi

if [ -f ./cenario ]
then
          rm ./cenario
fi



for (( i=0; i<$NUMTOP; i++ ))
do

python genGrid.py $L

mv cenario "${OUTPUT}/cenario_${L}_${i}"

done

#python genGrid.py $L

#mv cenario "${OUTPUT}/Grid${L}"

fi
