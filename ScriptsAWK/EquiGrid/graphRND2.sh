#!/bin/bash
#FILES=$(ls *.dat)
DIR=/home/rml/work/LOG/dat/Manhattan
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

set xrange [1:25]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "NS2 Gradient Test"
set xlabel "HOP"
#set xlabel "Resource Density"
set ylabel "Latency"

#set key box outside
set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set terminal png  enhanced font 'Verdana,14'
set output "${DIR}/latMAN.png"

lat(x) = 2*x*0.1


plot '$FILE1' using 1:2 ti 'FLOOD' w lp ls 1 , \
	'$FILE2' using 1:2 ti 'BCIR' w lp ls 2 , \
	'$FILE3' using 1:2 ti 'GBC' w lp ls 3 
#	'$FILE7' using 1:2 lt 4 pt 13 w lp ti 'GBClearn'
#	lat(x) usings lt 4 pt 13 w li ti 'flood'

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

set xrange [1:25]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "NS2 Gradient Test"
set xlabel "HOP"
#set xlabel "Resource Density"
set ylabel "Transmissions"

#set key box outside
set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set terminal png  enhanced font 'Verdana,14'
set output "${DIR}/transMAN.png"
trans(x) = 18 + x

plot '$FILE4' using 1:2 ti 'FLOOD' w lp ls 1 , \
	'$FILE5' using 1:2 ti 'BCIR' w lp ls 2 , \
	'$FILE6' using 1:2 ti 'GBC' w lp ls 3 
#	'$FILE8' using 1:2 lt 4 pt 13 w lp ti 'GBClearn'
#	trans(x) lt 3 pt 13 w li ti 'flood'

PLOT2
gnuplot -persist <<PLOT3


set xrange [1:25]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


set title "NS2 Gradient Test"
set xlabel "HOP"
#set xlabel "Resource Density"
set ylabel "Latency"

#set key box outside
set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "${DIR}/sparseMANgbc.png"
trans(x) = 18 + x
plot "${DIR}/latgbcRND.dat" using 3:2, \
	"${DIR}/latgbc_avgRND.dat" using 1:2 lt 2 pt 13 w lp

PLOT3
eog "${DIR}/latMAN.png" > /dev/null 2>&1 &
eog "${DIR}/transMAN.png" > /dev/null 2>&1 &

eog "${DIR}/sparseMANgbc.png" > /dev/null 2>&1 &
