#!/bin/bash
#FILES=$(ls *.dat)
DIR=$1
FILE1=$DIR/transflood_avg.dat
FILE2=$DIR/transbcir_avg.dat
FILE3=$DIR/transgbc_avg.dat
FILE4=$DIR/transgbclearn_avg.dat

gnuplot -persist <<PLOT


set xrange [1:15]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "Frequency"
set xlabel "HOP"
#set xlabel "Resource Density"
set ylabel "# Events"

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "${DIR}/sample.png"



plot '$FILE1' using 1:3 lt 1 pt 13 w lp ti 'FLOOD', \
	'$FILE2' using 1:3 lt 2 pt 13 w lp ti 'BCIR', \
	'$FILE3' using 1:3 lt 3 pt 13 w lp ti 'GBC', \
	'$FILE4' using 1:3 lt 4 pt 13 w lp ti 'GBClearn'
#	lat(x) usings lt 4 pt 13 w li ti 'flood'

PLOT

eog "${DIR}/sample.png" > /dev/null 2>&1 &
