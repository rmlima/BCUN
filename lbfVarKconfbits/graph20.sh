#!/bin/bash
#FILES=$(ls *.dat)
FILE1=./dataP20.log
FILE2=./dataK20.log
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
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "lbf_avgK20.png"

lat(x) = 2*x*0.1


plot '$FILE1' using 1:2 lt 1 pt 13 w lp ti 'k=4', \
	'$FILE2' using 1:2 lt 2 pt 13 w lp ti 'k=opt'
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
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "lbf_rmsK20.png"

lat(x) = 2*x*0.1

plot '$FILE1' using 1:3 lt 1 pt 13 w lp ti 'k=4', \
	'$FILE2' using 1:3 lt 2 pt 13 w lp ti 'k=opt'


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
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "lbf_fillratioK20.png"

lat(x) = 2*x*0.1

plot '$FILE1' using 1:4 lt 1 pt 13 w lp ti 'k=4', \
	'$FILE2' using 1:4 lt 2 pt 13 w lp ti 'k=opt'


PLOT3
gnuplot -persist <<PLOT4


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
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "lbf_diffK20.png"

lat(x) = 2*x*0.1

plot '< paste $FILE1 $FILE2' using 1:($3 - $8) lt 1 pt 13 w lp ti 'Diference RMS'


PLOT4

eog "lbf_avgK20.png" > /dev/null 2>&1 &
eog "lbf_rmsK20.png" > /dev/null 2>&1 &
eog "lbf_fillratioK20.png" > /dev/null 2>&1 &
eog "lbf_diffK20.png" > /dev/null 2>&1 &

