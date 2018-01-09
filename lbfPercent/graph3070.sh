#!/bin/bash
#FILES=$(ls *.dat)
FILE1=./dataP30.log
FILE2=./dataP40.log
FILE3=./dataP50.log
FILE4=./dataP60.log
FILE5=./dataP70.log
Xi=1
Xf=16

gnuplot -persist <<PLOT


set xrange [$Xi:$Xf]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics

#set title "LBF Estimator"
set xlabel "Confidance bits per cell"
#set xlabel "Resource Density"
set ylabel "# Inserted Elements"

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "lbf_elem.png"


plot '$FILE1' using 1:2 lt 1 pt 13 w lp ti '30%', \
	'$FILE2' using 1:2 lt 2 pt 13 w lp ti '40%', \
	'$FILE3' using 1:2 lt 3 pt 13 w lp ti '50%', \
	'$FILE4' using 1:2 lt 4 pt 13 w lp ti '60%', \
	'$FILE5' using 1:2 lt 5 pt 13 w lp ti '70%'

PLOT

gnuplot -persist <<PLOT3

set xrange [$Xi:$Xf]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


#set title "LBF Estimator"
set xlabel "Confidance bits per cell"
#set xlabel "Resource Density"
set ylabel "LBF Fill Ratio"

#set key box outside
#set key top left
unset key

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "lbf_fillratio.png"

set format y "%g %%"

plot '$FILE1' using 1:3 lt 1 pt 13 w lp ti '30%', \
	'$FILE2' using 1:3 lt 2 pt 13 w lp ti '40%', \
	'$FILE3' using 1:3 lt 3 pt 13 w lp ti '50%', \
	'$FILE4' using 1:3 lt 4 pt 13 w lp ti '60%', \
	'$FILE5' using 1:3 lt 5 pt 13 w lp ti '70%'
PLOT3


eog "lbf_elem.png" > /dev/null 2>&1 &
eog "lbf_fillratio.png" > /dev/null 2>&1 &
