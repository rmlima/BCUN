#!/bin/bash
#FILES=$(ls *.dat)
FILE1=./dataP30.log
FILE2=./dataP40.log
FILE3=./dataP50.log
FILE4=./dataP60.log
FILE5=./dataP70.log
Xi=1.5
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
set yrange [0.5:0.85]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


#set title "LBF Estimator"
set xlabel "Número de bits por célula (b)"
set ylabel "Valor Médio do Estimador - FBL"

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png  enhanced font 'Verdana,14'
set output "lbf_avg.png"

lat(x) = 2*x*0.1


plot '$FILE1' using 1:2 w lp ls 5 ti '30 elem', \
	'$FILE2' using 1:2 w lp ls 4 ti '40 elem', \
	'$FILE3' using 1:2 w lp ls 3 ti '50 elem', \
	'$FILE4' using 1:2 w lp ls 2 ti '60 elem', \
	'$FILE5' using 1:2 w lp ls 1 ti '70 elem'

PLOT

gnuplot -persist <<PLOT2
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
set ylabel "Erro Quadrático Médio (EQM)"

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png  enhanced font 'Verdana,14'
set output "lbf_mse.png"

lat(x) = 2*x*0.1

plot '$FILE1' using 1:3 w lp ls 5 ti '30 elem', \
	'$FILE2' using 1:3 w lp ls 4 ti '40 elem', \
	'$FILE3' using 1:3 w lp ls 3 ti '50 elem', \
	'$FILE4' using 1:3 w lp ls 2 ti '60 elem', \
	'$FILE5' using 1:3 w lp ls 1 ti '70 elem'

PLOT2

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
set ylabel "Taxa de Ocupação do FBL"

#set key box outside
set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png  enhanced font 'Verdana,14'
set output "lbf_fillratio.png"

lat(x) = 2*x*0.1

plot '$FILE1' using 1:4 w lp ls 5 ti '30 elem', \
	'$FILE2' using 1:4 w lp ls 4 ti '40 elem', \
	'$FILE3' using 1:4 w lp ls 3 ti '50 elem', \
	'$FILE4' using 1:4 w lp ls 2 ti '60 elem', \
	'$FILE5' using 1:4 w lp ls 1 ti '70 elem'
PLOT3

gnuplot -persist <<PLOT4
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
set ylabel "Desvio Padrão do Estimador"

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png  enhanced font 'Verdana,14'
set output "lbf_std.png"

plot 'estimator70std.log' using 1:2 w lp ls 1 ti '70 elem', \
	'estimator70std.log' using 1:2:3 lt 1 pt 13 notitle  with yerrorbars

PLOT4



gnuplot -persist <<PLOT5
set style line 1 lc rgb '#8b1a0e' pt 1 ps 2 lt 1 lw 2 # --- red
set style line 2 lc rgb '#5e9c36' pt 6 ps 2 lt 1 lw 2 # --- green
set style line 3 lc rgb '#191970' pt 4 ps 2 lt 1 lw 2 # --- blue
set style line 4 lc rgb '#9400d3' pt 2 ps 2 lt 1 lw 2 # --- viotela
set style line 5 lc rgb '#999900' pt 8 ps 2 lt 1 lw 2 # --- Amarelo
set border 3 back ls 3
set tics nomirror
set grid back ls 0

set xrange [1:$Xf]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


#set title "LBF Estimator"
set xlabel "Número de bits por célula (b)"
set ylabel "Desvio Padrão do Estimador"

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png  enhanced font 'Verdana,14'
set output "lbf_std2.png"

plot 'estimator70std.log' using 1:4 w lp ls 1 ti 'Desvio Padrão Distribuição Uniforme', \
	'estimator70std.log' using 1:3 w lp ls 3 ti 'Desvio Padrão do Estimador (70 elem)'

PLOT5



eog "lbf_avg.png" > /dev/null 2>&1 &
eog "lbf_mse.png" > /dev/null 2>&1 &
eog "lbf_fillratio.png" > /dev/null 2>&1 &
eog "lbf_std.png" > /dev/null 2>&1 &
eog "lbf_std2.png" > /dev/null 2>&1 &
