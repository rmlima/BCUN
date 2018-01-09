#!/bin/bash
#FILES=$(ls *.dat)
FILE1=./dataH30.log
FILE2=./dataH40.log
FILE3=./dataH50.log
FILE4=./dataH60.log
FILE5=./dataH70.log
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
set output "lbf_avgH.png"

lat(x) = 2*x*0.1


plot '$FILE1' using 1:2 lt 1 pt 13 w lp ti '30 elem', \
	'$FILE2' using 1:2 lt 2 pt 13 w lp ti '40 elem', \
	'$FILE3' using 1:2 lt 3 pt 13 w lp ti '50 elem', \
	'$FILE4' using 1:2 lt 4 pt 13 w lp ti '60 elem', \
	'$FILE5' using 1:2 lt 5 pt 13 w lp ti '70 elem'

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
set output "lbf_rmsH.png"

lat(x) = 2*x*0.1

plot '$FILE1' using 1:3 lt 1 pt 13 w lp ti '30 elem', \
	'$FILE2' using 1:3 lt 2 pt 13 w lp ti '40 elem', \
	'$FILE3' using 1:3 lt 3 pt 13 w lp ti '50 elem', \
	'$FILE4' using 1:3 lt 4 pt 13 w lp ti '60 elem', \
	'$FILE5' using 1:3 lt 5 pt 13 w lp ti '70 elem'


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
set output "lbf_fillratioH.png"

lat(x) = 2*x*0.1

plot '$FILE1' using 1:4 lt 1 pt 13 w lp ti '30 elem', \
	'$FILE2' using 1:4 lt 2 pt 13 w lp ti '40 elem', \
	'$FILE3' using 1:4 lt 3 pt 13 w lp ti '50 elem', \
	'$FILE4' using 1:4 lt 4 pt 13 w lp ti '60 elem', \
	'$FILE5' using 1:4 lt 5 pt 13 w lp ti '70 elem'


PLOT3

eog "lbf_avgH.png" > /dev/null 2>&1 &
eog "lbf_rmsH.png" > /dev/null 2>&1 &
eog "lbf_fillratioH.png" > /dev/null 2>&1 &
