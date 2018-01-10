#!/bin/bash
cd simul
if grep -q "Resource Found" rmlsearchflood.tr; then

#	echo -e "FLOOD \t BERS \t BCIR"
	echo -e $1 "\t" `./hop.awk rmlsearchflood.tr` "\t" `./trans.awk rmlsearchflood.tr` "\t" `./trans.awk rmlsearchbers.tr` "\t" `./trans.awk rmlsearchbcir.tr` >> ./trans.dat
	echo -e $1 "\t" `./hop.awk rmlsearchflood.tr` "\t" `./lat.awk rmlsearchflood.tr` "\t" `./lat.awk rmlsearchbers.tr` "\t" `./lat.awk rmlsearchbcir.tr` >> ./lat.dat
else
	echo "ERROR (final.sh): No resource FOUND "
fi
cd ..
