#!/bin/bash
#FILES=$(ls *.dat)
FILE1=./data3D.log
Xi=1
Xf=8
Yi=1
Yf=10

gnuplot -persist <<PLOT


set xrange [$Xi:$Xf]
set yrange [$Yi:$Yf]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "LBF Estimator - Averge"
set xlabel "#Bits per Cell"
set ylabel "#Hash Functions"
#set zlabel "Average LBF Estimation"

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15

set dgrid3d 30,30
set hidden3d


set term png
set output "lbf_avg3D.png"



splot '$FILE1' using 1:2:3 lt 1 pt 13 w lp ti '60 elem'

PLOT

gnuplot -persist <<PLOT2


set xrange [$Xi:$Xf]
set yrange [$Yi:$Yf]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "LBF Estimator - RMSS"
set xlabel "#Bits per Cell"
set ylabel "#Hash Functions"
#set zlabel "Average LBF Estimation"

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15

set dgrid3d 30,30
set hidden3d


set term png
set output "lbf_rms3D.png"



splot '$FILE1' using 1:2:4 lt 1 pt 13 w lp ti '60 elem'

PLOT2

gnuplot -persist <<PLOT3


set xrange [$Xi:$Xf]
set yrange [$Yi:$Yf]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "LBF Estimator - Fill Ratio"
set xlabel "#Bits per Cell"
set ylabel "#Hash Functions"
#set zlabel "Average LBF Estimation"

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15

set dgrid3d 30,30
set hidden3d


set term png
set output "lbf_fillratio3D.png"



splot '$FILE1' using 1:2:5 lt 1 pt 13 w lp ti '60 elem'

PLOT3

