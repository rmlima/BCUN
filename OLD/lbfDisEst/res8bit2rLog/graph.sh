#!/bin/bash
#FILES=$(ls *.dat)
DIR=$1
FILE1=./data20.log
FILE2=./data25.log
FILE3=./data30.log
FILE4=./data35.log
FILE5=./data40.log
FILE6=./data45.log
FILE7=./data50.log
FILE8=./data55.log
FILE9=./data60.log


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
set output "${DIR}/lbf.png"

lat(x) = 2*x*0.1


plot '$FILE1' using 1:1 lt 1 pt 13 w lp ti 'GOD', \
	'$FILE1' using 1:2 lt 2 pt 13 w lp ti 'LBF20', \
	'$FILE2' using 1:2 lt 3 pt 13 w lp ti 'LBF25', \
	'$FILE3' using 1:2 lt 4 pt 13 w lp ti 'LBF30', \
	'$FILE4' using 1:2 lt 5 pt 13 w lp ti 'LBF35', \
	'$FILE5' using 1:2 lt 6 pt 13 w lp ti 'LBF40', \
	'$FILE6' using 1:2 lt 7 pt 13 w lp ti 'LBF45', \
	'$FILE7' using 1:2 lt 8 pt 13 w lp ti 'LBF50', \
	'$FILE8' using 1:2 lt 9 pt 13 w lp ti 'LBF55', \
	'$FILE9' using 1:2 lt 10 pt 13 w lp ti 'LBF60'

PLOT

eog "${DIR}/lbf.png" > /dev/null 2>&1 &
