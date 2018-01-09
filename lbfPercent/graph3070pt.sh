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
set style line 1 lc rgb '#8b1a0e' pt 1 ps 2 lt 1 lw 2 # --- red
set style line 2 lc rgb '#5e9c36' pt 6 ps 2 lt 1 lw 2 # --- green
set style line 3 lc rgb '#191970' pt 4 ps 2 lt 1 lw 2 # --- blue
set style line 4 lc rgb '#9400d3' pt 2 ps 2 lt 1 lw 2 # --- viotela
set style line 5 lc rgb '#999900' pt 8 ps 2 lt 1 lw 2 # --- Amarelo
set border 3 back ls 3
set tics nomirror
set grid back ls 0

set xrange [$Xi:$Xf]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics

#set title "LBF Estimator"
set xlabel "Número de bits por célula (b)" enhanced
#set xlabel "Resource Density"
set ylabel "Número de elementos inseridos (n)" enhanced

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png  enhanced font 'Verdana,14'
set output "lbf_elem.png"


plot '$FILE1' using 1:2 w lp ls 5 ti '30%', \
	'$FILE2' using 1:2 w lp ls 4 ti '40%', \
	'$FILE3' using 1:2 w lp ls 3 ti '50%', \
	'$FILE4' using 1:2 w lp ls 2 ti '60%', \
	'$FILE5' using 1:2 w lp ls 1 ti '70%'

PLOT

gnuplot -persist <<PLOT3
set style line 1 lc rgb '#8b1a0e' pt 1 ps 2 lt 1 lw 2 # --- red
set style line 2 lc rgb '#5e9c36' pt 6 ps 2 lt 1 lw 2 # --- green
set style line 3 lc rgb '#191970' pt 4 ps 2 lt 1 lw 2 # --- blue
set style line 4 lc rgb '#9400d3' pt 2 ps 2 lt 1 lw 2 # --- viotela
set style line 5 lc rgb '#999900' pt 8 ps 2 lt 1 lw 2 # --- Amarelo
set border 3 back ls 3
set tics nomirror
set grid back ls 0

set xrange [$Xi:$Xf]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


#set title "LBF Estimator"
set xlabel "Número de bits por célula (b)"
#set xlabel "Resource Density"
set ylabel "Número de elementos inseridos (n)"

#set key box outside
#set key top left
unset key

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png  enhanced font 'Verdana,14'
set output "lbf_fillratio.png"

set format y "%g %%"

plot '$FILE1' using 1:3 w lp ls 5 ti '30%', \
	'$FILE2' using 1:3 w lp ls 4 ti '40%', \
	'$FILE3' using 1:3 w lp ls 3 ti '50%', \
	'$FILE4' using 1:3 w lp ls 2 ti '60%', \
	'$FILE5' using 1:3 w lp ls 1 ti '70%'
PLOT3


eog "lbf_elem.png" > /dev/null 2>&1 &
eog "lbf_fillratio.png" > /dev/null 2>&1 &
