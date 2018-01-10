#!/bin/bash
#FILES=$(ls *.dat)

gnuplot -persist <<PLOT

set xrange [1:15]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics

set title "NS2 Test"
set xlabel "Hops"
set ylabel "Total Transmittions"

#set key box outside

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "trans.png"

plot 'transflood.dat' using 1:2 lt 1 pt 13 w lp ti 'FLOOD', \
	'transbers.dat' using 1:2 lt 2 pt 13 w lp ti 'BERS', \
	'transbcir.dat' using 1:2 lt 3 pt 13 w lp ti 'BCIR'


PLOT



gnuplot -persist <<PLOT2


set xrange [1:15]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "NS2 Test"
set xlabel "Hops"
#set xlabel "Resource Density"
set ylabel "Latency"

#set key box outside

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "lat.png"

plot 'latflood.dat' using 1:2 lt 1 pt 13 w lp ti 'FLOOD', \
	'latbers.dat' using 1:2 lt 2 pt 13 w lp ti 'BERS', \
	'latbcir.dat' using 1:2 lt 3 pt 13 w lp ti 'BCIR'

PLOT2

FILES=freq2.dat
gnuplot -persist <<PLOT3


set xrange [1:15]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "Relative Frequency"
set xlabel "Hops"
#set xlabel "Resource Density"
set ylabel "Empirical Probability"

#set key box outside

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "prob.png"

plot '$FILES' using 1:2 lt 1 pt 13 w lp ti ''

PLOT3

./showgraphs.sh

