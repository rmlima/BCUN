#!/bin/bash
#FILES=$(ls *.dat)
DIR=$1
FILE1=$DIR/latflood_avg.dat
FILE2=$DIR/latbcir_avg.dat
FILE3=$DIR/latgbc_avg.dat
FILE4=$DIR/transflood_avg.dat
FILE5=$DIR/transbcir_avg.dat
FILE6=$DIR/transgbc_avg.dat
FILE7=$DIR/latgbclearn_avg.dat
FILE8=$DIR/transgbclearn_avg.dat
FILE9=$DIR/latgbctotal_avg.dat


gnuplot -persist <<PLOT


set xrange [1:15]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "NS2 Gradient Test"
set xlabel "HOP"
#set xlabel "Resource Density"
set ylabel "Latency"

#set key box outside
set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "${DIR}/lat.png"

lat(x) = 2*x*0.1


plot '$FILE1' using 1:2 lt 1 pt 13 w lp ti 'FLOOD', \
	'$FILE2' using 1:2 lt 2 pt 13 w lp ti 'BCIR', \
	'$FILE3' using 1:2 lt 3 pt 13 w lp ti 'GBC', \
	'$FILE7' using 1:2 lt 4 pt 13 w lp ti 'GBClearn', \
	'$FILE9' using 1:2 lt 5 pt 13 w lp ti 'GBCall'
#	lat(x) usings lt 4 pt 13 w li ti 'flood'

PLOT

gnuplot -persist <<PLOT2


set xrange [1:15]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "NS2 Gradient Test"
set xlabel "HOP"
#set xlabel "Resource Density"
set ylabel "Transmissions"

#set key box outside
set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "${DIR}/trans.png"
trans(x) = 18 + x

plot '$FILE4' using 1:2 lt 1 pt 13 w lp ti 'FLOOD', \
	'$FILE5' using 1:2 lt 2 pt 13 w lp ti 'BCIR', \
	'$FILE6' using 1:2 lt 3 pt 13 w lp ti 'GBC', \
	'$FILE8' using 1:2 lt 4 pt 13 w lp ti 'GBClearn'
#	trans(x) lt 3 pt 13 w li ti 'flood'

PLOT2

eog "${DIR}/lat.png" > /dev/null 2>&1 &
eog "${DIR}/trans.png" > /dev/null 2>&1 &
