#!/bin/bash
#FILES=$(ls *.dat)
FILE1=./failtable2.dat
gnuplot -persist <<PLOT
reset
set style line 11 lc rgb '#808080' lt 1
set border 3 back ls 11
set tics nomirror
# define grid
set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

# color definitions

set terminal pdfcairo  enhanced font 'Verdana,14' linewidth 2
set output "./failBARtop.pdf"

set style fill solid 1.00 border 0
set style histogram errorbars gap 2 lw 1
set style data histogram
set xtics rotate by -45
set grid ytics
set xlabel "Searching Methods"
set ylabel "Queries Fails (%)"
set yrange [0:*]
#set datafile separator ","

plot '$FILE1' using 2:3:xtic(1) ti 'Flood' linecolor rgb "#8b1a0e", \
	'$FILE1' using 4:5 ti 'BCIR' lt 1 lc rgb "#5e9c36", \
	'$FILE1' using 6:7 ti 'BCIR*' lt 1 lc rgb "#191970", \
	'$FILE1' using 8:9 ti 'ABC' lt 1 lc rgb "#000000"

PLOT
