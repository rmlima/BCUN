#!/bin/bash
#FILES=$(ls *.dat)
gnuplot -persist <<PLOT


set xrange [2:9]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "LBF Estimator - Discret"
set xlabel "Confidance bits per cell"
#set xlabel "Resource Density"
set ylabel "Average LBF Estimation"

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "lbfbits_avg.png"

lat(x) = 2*x*0.1


plot 'confbits.dat' using 1:2 lt 1 pt 13 w lp ti 'Average'

PLOT

gnuplot -persist <<PLOT2


set xrange [2:9]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "LBF Estimator - Discret"
set xlabel "Confidance bits per cell"
#set xlabel "Resource Density"
set ylabel "RMS LBF Estimation"

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "lbfbits_rms.png"

lat(x) = 2*x*0.1


plot 'confbits.dat' using 1:3 lt 2 pt 13 w lp ti 'RMS'

PLOT2

eog "lbfbits_avg.png" > /dev/null 2>&1 &
eog "lbfbits_rms.png" > /dev/null 2>&1 &
