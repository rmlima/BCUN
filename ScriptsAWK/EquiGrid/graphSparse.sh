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
set style line 1 lc rgb '#8b1a0e' pt 1 ps 2 lt 1 lw 3 # --- red
set style line 2 lc rgb '#5e9c36' pt 6 ps 2 lt 1 lw 3 # --- green
set style line 3 lc rgb '#191970' pt 4 ps 2 lt 1 lw 3 # --- blue

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15

set terminal png  enhanced font 'Verdana,14'

set output "${DIR}/sparseMANgbc.png"
f(x)=a*x*x+b*x+c
fit f(x) "${DIR}/latgbcRND.dat" using 3:2 via a,b,c

plot "${DIR}/latgbcRND.dat" using 3:2 ti "Points", \
	"${DIR}/latgbcRND.dat" using 3:2:(2.0) smooth acsplines ti "Smooth" ls 2 , \
	f(x) ti "Quadratic" ls 3 

PLOT3

gnuplot -persist <<PLOT4
reset

# wxt
#set terminal wxt size 350,262 enhanced font 'Verdana,10' persist
# png
#set terminal pngcairo size 350,262 enhanced font 'Verdana,10'
#set output 'sparse_image_data2.png'

unset key

# Axes
set style line 11 lc rgb '#808080' lt 1
set border 3 back ls 11
set tics nomirror out scale 0.75

#set xrange [0:105]
#set yrange [0:101]
#set size ratio -1
set title "Sparse Graph"
set xlabel "HOP"
#set xlabel "Resource Density"
set ylabel "Latency"

set xrange [1:25]
set term png


set palette negative defined ( \
    0 '#D53E4F',\
    1 '#F46D43',\
    2 '#FDAE61',\
    3 '#FEE08B',\
    4 '#E6F598',\
    5 '#ABDDA4',\
    6 '#66C2A5',\
    7 '#3288BD' )

set output "${DIR}/sparseGBC.png"
set size ratio -1
f(x) = 0.4
set style fill transparent solid 0.8 noborder
#plot '<sort -g -k3 ${DIR}/latgbcRND.dat' u 3:2:(1):(f(\$2)) w circles lw .5 lc palette
plot '<sort -g -k3 ${DIR}/latgbcRND.dat' u 3:2:(f(\$2)):2 w circles lw 1 lc palette

PLOT4

eog "${DIR}/latMAN.png" > /dev/null 2>&1 &
eog "${DIR}/transMAN.png" > /dev/null 2>&1 &
eog "${DIR}/sparseMANgbc.png" > /dev/null 2>&1 &
eog "${DIR}/sparseGBC.png" > /dev/null 2>&1 &
