#!/bin/bash
#FILES=$(ls *.dat)

gnuplot -persist <<PLOT
reset


# define axis
# remove border on top and right and set color to gray
set style line 11 lc rgb '#808080' lt 1
set border 3 back ls 11
set tics nomirror
# define grid
set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

# color definitions
set style line 1 lc rgb '#8b1a0e' pt 1 ps 2 lt 1 lw 2 # --- red
set style line 2 lc rgb '#5e9c36' pt 6 ps 2 lt 1 lw 2 # --- green
set style line 3 lc rgb '#191970' pt 4 ps 2 lt 1 lw 2 # --- blue 


#set key bottom right
set key top left

#set xrange [1:4]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics

set grid
set style data linespoints
set key left top
set pointsize 1
set style line 5 lt 5 lw 3
#set title "Comparação - Nº de Retransmissões"
set xlabel "Resource found at hop (H)"
set ylabel "Latency (L)"

#set key box outside

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
#set term png
set terminal png enhanced font 'Verdana,14'
set output "latency5.png"

plot 'outputHOPSlat.dat' using 1:2 w lp ls 1 ti 'BERS ; BCIR', \
	'outputHOPSlat.dat' using 1:3 w lp ls 2 ti 'BERS* ; BCIR*', \
	'outputHOPSlat.dat' using 1:4 w lp ls 3 ti 'Flooding'


PLOT



gnuplot -persist <<PLOT2


reset

# define axis
# remove border on top and right and set color to gray
set style line 11 lc rgb '#808080' lt 1
set border 3 back ls 11
set tics nomirror
# define grid
set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

# color definitions
set style line 1 lc rgb '#8b1a0e' pt 1 ps 2 lt 1 lw 2 # --- red
set style line 2 lc rgb '#5e9c36' pt 6 ps 2 lt 1 lw 2 # --- green
set style line 3 lc rgb '#191970' pt 4 ps 2 lt 1 lw 2 # --- blue 
set style line 4 lc rgb '#b8860b' pt 8 ps 2 lt 1 lw 2 # --- brown 
set style line 5 lc rgb '#9370db' pt 12 ps 2 lt 1 lw 2 # --- violeta 


#set key bottom right
set key top left


#set xrange [1:4]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics

set grid
set style data linespoints
set key left top
set pointsize 1
set style line 5 lt 5 lw 3
#set title "Comparação - Nº de Retransmissões"
set xlabel "Resource found at hop (H)"
set ylabel "Retransmissions Ratio (R)"




#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
#set term png
set terminal png enhanced font 'Verdana,14'
set output "overhead5.png"

plot 'outputHOPSover.dat' using 1:2 w lp ls 1 ti 'BERS', \
	'outputHOPSover.dat' using 1:3 w lp ls 4 ti 'BCIR', \
	'outputHOPSover.dat' using 1:4 w lp ls 2 ti 'BERS*', \
	'outputHOPSover.dat' using 1:5 w lp ls 5 ti 'BCIR*', \
	'outputHOPSover.dat' using 1:6 w lp ls 3 ti 'Flooding'

PLOT2


eog latency5.png > /dev/null 2>&1 &
eog overhead5.png > /dev/null 2>&1 &

