#!/bin/bash

if [ $# -ne 1 ]
then
	echo -e "Usage:  back.sh  <output>\n **** rml@fam.ulusiada.pt v0.1 ****"
	exit 1
else

OUT=$1
LOG="./"$OUT"Log"

if [ ! -d $LOG ]
then
        mkdir $LOG
fi

mv *.log $LOG
mv *.png $LOG
cp graph* $LOG

fi
