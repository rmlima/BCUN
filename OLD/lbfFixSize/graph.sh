#!/bin/bash
#FILES=$(ls *.dat)
DIR=$1
FILE1=./data11.log
FILE2=./data12.log
FILE3=./data13.log
FILE4=./data14.log
FILE5=./data15.log
FILE6=./data16.log


gnuplot -persist <<PLOT


set xrange [0:20]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "LBF Estimator Test"
set xlabel "HOP"
#set xlabel "Resource Density"
set ylabel "Average LBF Estimation"

#set key box outside
set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "${DIR}/lbf11_16.png"

lat(x) = 2*x*0.1


plot '$FILE1' using 1:1 lt 1 pt 13 w lp ti 'GOD', \
	'$FILE1' using 1:2 lt 2 pt 13 w lp ti '11 bits', \
	'$FILE2' using 1:2 lt 3 pt 13 w lp ti '12 bits', \
	'$FILE3' using 1:2 lt 2 pt 13 w lp ti '13 bits', \
	'$FILE4' using 1:2 lt 3 pt 13 w lp ti '14 bits', \
	'$FILE5' using 1:2 lt 4 pt 13 w lp ti '15 bits', \
	'$FILE6' using 1:2 lt 5 pt 13 w lp ti '16 bits'

PLOT

eog "${DIR}/lbf11_16.png" > /dev/null 2>&1 &
