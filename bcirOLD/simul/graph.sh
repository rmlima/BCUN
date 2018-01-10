#!/bin/bash
#FILES=$(ls *.dat)
FILES=trans.dat

gnuplot -persist <<PLOT

#set xrange [1:4]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics

set title "NS2 Test"
set xlabel "Resource Node Location"
set ylabel "Total Transmittions"

#set key box outside

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "trans.png"

plot '$FILES' using 1:3 lt 1 pt 13 w lp ti 'FLOOD', \
	'$FILES' using 1:4 lt 2 pt 13 w lp ti 'BERS', \
	'$FILES' using 1:5 lt 3 pt 13 w lp ti 'BCIR'


PLOT



FILES=lat.dat
gnuplot -persist <<PLOT2


#set xrange [1:4]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "NS2 Test"
set xlabel "Resource Node Location"
#set xlabel "Resource Density"
set ylabel "Latency"

#set key box outside

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "lat.png"

plot '$FILES' using 1:3 lt 1 pt 13 w lp ti 'FLOOD', \
	'$FILES' using 1:4 lt 2 pt 13 w lp ti 'BERS', \
	'$FILES' using 1:5 lt 3 pt 13 w lp ti 'BCIR'

PLOT2

eog trans.png > /dev/null 2>&1 &
eog lat.png > /dev/null 2>&1 &
