#!/bin/bash
#FILES=$(ls *.dat)
DIR=$1
FILE1=$DIR/latflood_avgRND.dat
FILE2=$DIR/latbcir_avgRND.dat
FILE3=$DIR/latgbc_avgRND.dat
FILE4=$DIR/transflood_avgRND.dat
FILE5=$DIR/transbcir_avgRND.dat
FILE6=$DIR/transgbc_avgRND.dat
FILE7=$DIR/latgbclearn_avgRND.dat
FILE8=$DIR/transgbclearn_avgRND.dat

gnuplot -persist <<PLOT


set xrange [1:15]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "NS2: Fast Broadcast Cancellation"
set xlabel "Distance (HOPs)"
#set xlabel "Resource Density"
set ylabel "Latency"

#set key box outside
set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "${DIR}/latRND.png"

lat(x) = 2*x*0.1


plot '$FILE1' using 1:2 lt 1 pt 13 w lp ti 'FLOOD', \
	'$FILE2' using 1:2 lt 2 pt 13 w lp ti 'BCIR', \
	'$FILE3' using 1:2 lt 3 pt 13 w lp ti 'FBC
#	'$FILE7' using 1:2 lt 4 pt 13 w lp ti 'GBClearn'
#	lat(x) usings lt 4 pt 13 w li ti 'flood'

PLOT

gnuplot -persist <<PLOT2


set xrange [1:15]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "NS2: Fast Broadcast Cancellation"
set xlabel "Distance (HOPs)"
#set xlabel "Resource Density"
set ylabel "Transmissions"

#set key box outside
set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "${DIR}/transRND.png"
trans(x) = 18 + x

plot '$FILE4' using 1:2 lt 1 pt 13 w lp ti 'FLOOD', \
	'$FILE5' using 1:2 lt 2 pt 13 w lp ti 'BCIR', \
	'$FILE6' using 1:2 lt 3 pt 13 w lp ti 'GBC'
#	'$FILE8' using 1:2 lt 4 pt 13 w lp ti 'GBClearn'
#	trans(x) lt 3 pt 13 w li ti 'flood'

PLOT2

eog "${DIR}/latRND.png" > /dev/null 2>&1 &
eog "${DIR}/transRND.png" > /dev/null 2>&1 &
