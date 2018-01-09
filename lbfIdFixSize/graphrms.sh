#!/bin/bash
#FILES=$(ls *.dat)
DIR=$1
FILE1=./data2.log
FILE2=./data3.log
FILE3=./data4.log
FILE4=./data5.log
FILE5=./data6.log
FILE6=./data7.log
FILE7=./data8.log
FILE8=./data9.log
FILE9=./data10.log


gnuplot -persist <<PLOT


set xrange [1:49]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "LBF Estimator RMS ERRORs"
set xlabel "Element"
#set xlabel "Resource Density"
set ylabel "LBF RMS Error"

#set key box outside
set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "${DIR}/lbfrms.png"

lat(x) = 2*x*0.1


plot '$FILE1' using 1:3 lt 1 pt 13 w lp ti '2bits', \
	'$FILE2' using 1:3 lt 2 pt 13 w lp ti '3 bits', \
	'$FILE3' using 1:3 lt 3 pt 13 w lp ti '4 bits', \
	'$FILE4' using 1:3 lt 2 pt 13 w lp ti '5 bits', \
	'$FILE5' using 1:3 lt 3 pt 13 w lp ti '6 bits', \
	'$FILE6' using 1:3 lt 4 pt 13 w lp ti '7 bits', \
	'$FILE7' using 1:3 lt 5 pt 13 w lp ti '8 bits', \
	'$FILE8' using 1:3 lt 6 pt 13 w lp ti '9 bits', \
	'$FILE9' using 1:3 lt 7 pt 13 w lp ti '10 bits'

PLOT

eog "${DIR}/lbfrms.png" > /dev/null 2>&1 &
