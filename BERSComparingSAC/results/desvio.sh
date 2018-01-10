#!/bin/bash
gnuplot -persist << EOF
reset
set format x '%.0f%%'
# define axis
# remove border on top and right and set color to gray
set style line 11 lc rgb '#808080' lt 1
set border 3 back ls 11
set tics nomirror
# define grid
set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

#Norm=H**2
Norm=100
# color definitions
set style line 1 lc rgb '#8b1a0e' pt 0 ps 2 lt 1 lw 1 # --- red
set style line 2 lc rgb '#5e9c36' pt 6 ps 2 lt 1 lw 2 # --- green
set style line 3 lc rgb '#191970' pt 4 ps 2 lt 1 lw 2 # --- blue 
set style line 4 lc rgb '#b8860b' pt 0 ps 2 lt 1 lw 2 # --- brown 
set style line 5 lc rgb '#9370db' pt 12 ps 2 lt 1 lw 2 # --- violeta
#set yrange [0:1]
set xrange [0:85]
set grid
set style data linespoints
set pointsize 1
set style line 5 lt 5 lw 3
#set title "Comparação - Latência"
set xlabel "Record Density"
set ylabel "Retransmission Ratio"

#set label 2 "with Standard Deviation" at screen 0.65, screen 0.84
#show label 2

plot "outputBC2.dat" using 1:2 w lp ls 4 ti 'Average (BCIR)', \
"outputBC2.dat" using 1:2:3 with errorbars ls 1 ti 'Standard Deviation (BCIR)'
	
#plot bers(x)/Norm ti "BCIR"
set term pdfcairo enhanced font "Vera,14 linewidth 2"
set output "./graficoBCIR.pdf"

replot
EOF

