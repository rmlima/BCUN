#!/bin/bash
#FILES=$(ls *.dat)
DIR=$1
FILE1=./data60.log


gnuplot -persist <<PLOT


set xrange [0:60]
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
set output "${DIR}/lbf60.png"

lat(x) = 2*x*0.1


plot '$FILE1' using 1:1 lt 1 pt 13 w lp ti 'GOD', \
	'$FILE1' using 1:2 lt 2 pt 13 w lp ti 'LBF60'

PLOT

eog "${DIR}/lbf60.png" > /dev/null 2>&1 &
