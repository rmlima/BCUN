#!/bin/bash
#FILES=$(ls *.dat)
DIR=$1
FILE1=$DIR/transflood_avgRND.dat
FILE2=$DIR/transbcir_avgRND.dat
FILE21=$DIR/transbcir2_avgRND.dat
FILE3=$DIR/transgbc_avgRND.dat
FILE4=$DIR/transgbclearn_avgRND.dat
gnuplot -persist <<PLOT
reset
set style line 11 lc rgb '#808080' lt 1
set border 3 back ls 11
set tics nomirror
# define grid
set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

# color definitions
set style line 1 lc rgb '#8b1a0e' pt 1 ps 1 lt 1 lw 2 # --- red
set style line 2 lc rgb '#5e9c36' pt 6 ps 1 lt 1 lw 2 # --- green
set style line 3 lc rgb '#191970' pt 3 ps 1 lt 1 lw 2 # --- blue
set style line 4 lc rgb '#000000' pt 4 ps 1 lt 1 lw 2 # --- black

set xrange [1:]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


#set title "NS2: Adaptive Broadcast Cancellation"
set xlabel "Distance (hop)"
#set xlabel "Resource Density"
set ylabel "# Records Found"

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15

set terminal pdfcairo  enhanced font 'Verdana,14' linewidth 2
set output "${DIR}/sampleRNDgrid.pdf"


plot '$FILE1' using 1:3 ti 'FLOOD' w lp ls 1 , \
	'$FILE2' using 1:3 ti 'BCIR' w lp ls 2 , \
	'$FILE21' using 1:3 ti 'BCIR*' w lp ls 3 , \
	'$FILE3' using 1:3 ti 'ABC' w lp ls 4

PLOT

#eog "${DIR}/sampleRND.png" > /dev/null 2>&1 &
