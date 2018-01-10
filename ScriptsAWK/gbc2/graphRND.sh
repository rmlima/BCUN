#!/bin/bash
#FILES=$(ls *.dat)
DIR=$1
FILE1=$DIR/latflood_avgRND.dat
FILE2=$DIR/latbcir_avgRND.dat
FILE3=$DIR/latgbc_avgRND.dat
FILE4=$DIR/transflood_avgRND.dat
FILE5=$DIR/transbcir_avgRND.dat
FILE6=$DIR/transgbc_avgRND.dat
FILE7=$DIR/latgbclearn_avgRND.dat
FILE8=$DIR/transgbclearn_avgRND.dat

gnuplot -persist <<PLOT
reset
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

set xrange [1:16]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "NS2: Adaptive Broadcast Cancellation - Latency"
set xlabel "Distance (HOP)"
set ylabel "End-To-End Delay (s)"

#set key box outside
set key top left

set terminal png  enhanced font 'Verdana,14'
set output "${DIR}/latRND.png"

lat(x) = 2*x*0.1


#plot '$FILE1' using 1:2 lt 1 pt 13 w lp li 'FLOOD', \
#	'$FILE2' using 1:2 lt 2 pt 13 w lp ti 'BCIR*', \
#	'$FILE3' using 1:2 lt 3 pt 13 w lp ti 'ABC'
#	'$FILE7' using 1:2 lt 4 pt 13 w lp ti 'GBClearn'
#	lat(x) usings lt 4 pt 13 w li ti 'flood'

plot '$FILE1' using 1:2 ti 'FLOOD' w lp ls 1 , \
        '$FILE2' using 1:2 ti 'BCIR*' w lp ls 2 , \
        '$FILE3' using 1:2 ti 'ABC' w lp ls 3



PLOT

gnuplot -persist <<PLOT2
reset
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

set xrange [1:16]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "NS2: Adaptive Broadcast Cancellation - Energy Impact"
set xlabel "Distance (HOP)"
set ylabel "# Transmissions"

#set key box outside
set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15

set terminal png  enhanced font 'Verdana,14'
set output "${DIR}/transRND.png"

trans(x) = 18 + x

#plot '$FILE4' using 1:2 lt 1 pt 13 w lp ti 'FLOOD', \
#	'$FILE5' using 1:2 lt 2 pt 13 w lp ti 'BCIR*', \
#	'$FILE6' using 1:2 lt 3 pt 13 w lp ti 'ABC'
#	'$FILE8' using 1:2 lt 4 pt 13 w lp ti 'GBClearn'
#	trans(x) lt 3 pt 13 w li ti 'flood'

plot '$FILE4' using 1:2 ti 'FLOOD' w lp ls 1 , \
        '$FILE5' using 1:2 ti 'BCIR*' w lp ls 2 , \
        '$FILE6' using 1:2 ti 'ABC' w lp ls 3 



PLOT2

gnuplot -persist <<PLOT3


set xrange [1:6]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "NS2: Adaptive Broadcast Cancellation"
set xlabel "Distance (HOPs)"
#set xlabel "Resource Density"
set ylabel "Latency (s)"

#set key box outside
set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "${DIR}/latRNDini.png"

lat(x) = 2*x*0.1


plot '$FILE1' using 1:2 lt 1 pt 13 w lp ti 'FLOOD', \
	'$FILE2' using 1:2 lt 2 pt 13 w lp ti 'BCIR*', \
	'$FILE3' using 1:2 lt 3 pt 13 w lp ti 'ABC'
#	'$FILE7' using 1:2 lt 4 pt 13 w lp ti 'GBClearn'
#	lat(x) usings lt 4 pt 13 w li ti 'flood'

PLOT3

gnuplot -persist <<PLOT4


set xrange [1:6]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "NS2: Adaptive Broadcast Cancellation"
set xlabel "Distance (HOPs)"
#set xlabel "Resource Density"
set ylabel "Transmissions"

#set key box outside
set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "${DIR}/transRNDini.png"
trans(x) = 18 + x

plot '$FILE4' using 1:2 lt 1 pt 13 w lp ti 'FLOOD', \
	'$FILE5' using 1:2 lt 2 pt 13 w lp ti 'BCIR*', \
	'$FILE6' using 1:2 lt 3 pt 13 w lp ti 'ABC'
#	'$FILE8' using 1:2 lt 4 pt 13 w lp ti 'GBClearn'
#	trans(x) lt 3 pt 13 w li ti 'flood'

PLOT4

eog "${DIR}/latRND.png" > /dev/null 2>&1 &
eog "${DIR}/transRND.png" > /dev/null 2>&1 &
eog "${DIR}/latRNDini.png" > /dev/null 2>&1 &
eog "${DIR}/transRNDini.png" > /dev/null 2>&1 &
