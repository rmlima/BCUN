#!/bin/bash
#FILES=$(ls *.dat)
FILE1=./dataP50.log
FILE2=./dataP60.log
FILE3=./dataP70.log
FILE4=./dataP80.log
FILE5=./dataP90.log
FILE6=./dataP100.log
Xi=2
Xf=16
gnuplot -persist <<PLOT


set xrange [$Xi:$Xf]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "LBF Estimator - Discret"
set xlabel "Confidance bits per cell"
#set xlabel "Resource Density"
set ylabel "Average LBF Estimation"

#set key box outside
set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "lbf_avg.png"

lat(x) = 2*x*0.1


plot '$FILE1' using 1:2 lt 1 pt 13 w lp ti '50 elem', \
	'$FILE2' using 1:2 lt 2 pt 13 w lp ti '60 elem', \
	'$FILE3' using 1:2 lt 3 pt 13 w lp ti '70 elem', \
	'$FILE4' using 1:2 lt 4 pt 13 w lp ti '80 elem', \
	'$FILE5' using 1:2 lt 5 pt 13 w lp ti '90 elem', \
	'$FILE6' using 1:2 lt 6 pt 13 w lp ti '100 elem'

PLOT

gnuplot -persist <<PLOT2

set xrange [$Xi:$Xf]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "LBF Estimator - Discret"
set xlabel "Confidance bits per cell"
#set xlabel "Resource Density"
set ylabel "RMS LBF Estimation"

#set key box outside
set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "lbf_rms.png"

lat(x) = 2*x*0.1
plot '$FILE1' using 1:3 lt 1 pt 13 w lp ti '50 elem', \
	'$FILE2' using 1:3 lt 2 pt 13 w lp ti '60 elem', \
	'$FILE3' using 1:3 lt 3 pt 13 w lp ti '70 elem', \
	'$FILE4' using 1:3 lt 4 pt 13 w lp ti '80 elem', \
	'$FILE5' using 1:3 lt 5 pt 13 w lp ti '90 elem', \
	'$FILE6' using 1:3 lt 6 pt 13 w lp ti '100 elem'

PLOT2

gnuplot -persist <<PLOT3

set xrange [$Xi:$Xf]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "LBF Estimator - Discret"
set xlabel "Confidance bits per cell"
#set xlabel "Resource Density"
set ylabel "LBF Fill Ratio"

#set key box outside
set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "lbf_fillratio.png"

lat(x) = 2*x*0.1

plot '$FILE1' using 1:4 lt 1 pt 13 w lp ti '50 elem', \
	'$FILE2' using 1:4 lt 2 pt 13 w lp ti '60 elem', \
	'$FILE3' using 1:4 lt 3 pt 13 w lp ti '70 elem', \
	'$FILE4' using 1:4 lt 4 pt 13 w lp ti '80 elem', \
	'$FILE5' using 1:4 lt 5 pt 13 w lp ti '90 elem', \
	'$FILE6' using 1:4 lt 6 pt 13 w lp ti '100 elem'

PLOT3

eog "lbf_avg.png" > /dev/null 2>&1 &
eog "lbf_rms.png" > /dev/null 2>&1 &
eog "lbf_fillratio.png" > /dev/null 2>&1 &
