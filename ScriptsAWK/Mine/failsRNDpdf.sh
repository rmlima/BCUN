#!/bin/bash
#FILES=$(ls *.dat)
DIR=$1
FILE1=$DIR/fail.dat
gnuplot -persist <<PLOT
reset
set format y '%.0f%%'
set style line 11 lc rgb '#808080' lt 1
set border 3 back ls 11
set tics nomirror
# define grid
set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

# color definitions
set style line 1 lc rgb '#8b1a0e' pt 1 ps 1 lt 1 lw 1 # --- red
set style line 2 lc rgb '#5e9c36' pt 6 ps 1 lt 1 lw 1 # --- green
set style line 3 lc rgb '#191970' pt 4 ps 1 lt 1 lw 1 # --- blue
set style line 4 lc rgb '#000000' pt 3 ps 1 lt 1 lw 1 # --- black


set xrange [1:]
set yrange [0.4:]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


#set title "NS2: Adaptive Broadcast Cancellation"
set xlabel "Network Scenario Instance"
#set xlabel "Mine Topology"
set ylabel "Queries Fails (%)"

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15

set terminal pdfcairo  enhanced font 'Verdana,14' linewidth 2
set output "${DIR}/failRNDrgg.pdf"

set logscale y 10

plot '$FILE1' using 1:(\$2/2) ti 'FLOOD' w p ls 1 , \
	'$FILE1' using 1:(\$3/2) ti 'BCIR' w p ls 2 , \
	'$FILE1' using 1:(\$4/2) ti 'BCIR*' w p ls 3 , \
	'$FILE1' using 1:(\$5/2) ti 'ABC' w p ls 4

PLOT

#eog "${DIR}/sampleRND.png" > /dev/null 2>&1 &
