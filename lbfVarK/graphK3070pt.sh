#!/bin/bash
#FILES=$(ls *.dat)
FILE1=./dataK30.log
FILE2=./dataK40.log
FILE3=./dataK50.log
FILE4=./dataK60.log
FILE5=./dataK70.log
Xi=2
Xf=16

gnuplot -persist <<PLOT


set xrange [$Xi:$Xf]
set yrange [0.5:0.55]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics

#set title "LBF Estimator"
set xlabel "Número de funções de hashing (k)"
set ylabel "Valor Médio do Estimador - FBL"

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png 
set output "lbf_avgK.png"

lat(x) = 2*x*0.1


plot '$FILE1' using 1:2 lt 1 pt 13 w lp ti '30 elem', \
	'$FILE2' using 1:2 lt 2 pt 13 w lp ti '40 elem', \
	'$FILE3' using 1:2 lt 3 pt 13 w lp ti '50 elem', \
	'$FILE4' using 1:2 lt 4 pt 13 w lp ti '60 elem', \
	'$FILE5' using 1:2 lt 5 pt 13 w lp ti '70 elem'

PLOT

gnuplot -persist <<PLOT2

set xrange [1.5:$Xf]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


#set title "LBF Estimator"
set xlabel "Número de funções de hashing (k)"
set ylabel "Erro Quadrático Médio (EQM)"

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "lbf_mseK.png"

lat(x) = 2*x*0.1

plot '$FILE1' using 1:3 lt 1 pt 13 w lp ti '30 elem', \
	'$FILE2' using 1:3 lt 2 pt 13 w lp ti '40 elem', \
	'$FILE3' using 1:3 lt 3 pt 13 w lp ti '50 elem', \
	'$FILE4' using 1:3 lt 4 pt 13 w lp ti '60 elem', \
	'$FILE5' using 1:3 lt 5 pt 13 w lp ti '70 elem'

PLOT2

gnuplot -persist <<PLOT3

set xrange [1.5:$Xf]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


#set title "LBF Estimator"
set xlabel "Número de funções de hashing (k)"
set ylabel "Taxa de Ocupação do FBL"

#set key box outside
set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "lbf_fillratioK.png"

lat(x) = 2*x*0.1

plot '$FILE1' using 1:4 lt 1 pt 13 w lp ti '30 elem', \
	'$FILE2' using 1:4 lt 2 pt 13 w lp ti '40 elem', \
	'$FILE3' using 1:4 lt 3 pt 13 w lp ti '50 elem', \
	'$FILE4' using 1:4 lt 4 pt 13 w lp ti '60 elem', \
	'$FILE5' using 1:4 lt 5 pt 13 w lp ti '70 elem'
PLOT3

gnuplot -persist <<PLOT4


set xrange [$Xi:$Xf]
set yrange [0:1]
#set yrange [0:2.6]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


#set title "LBF Estimator"
set xlabel "Número de funções de hashing (k)"
set ylabel "Desvio Padrão do Estimador"

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "lbf_stdK.png"

plot 'estimatorK70std.log' using 1:2 lt 5 pt 13 w lp ti '70 elem', \
	'estimatorK70std.log' using 1:2:3 lt 1 pt 13 notitle  with errorbars

PLOT4


gnuplot -persist <<PLOT5


set xrange [1:$Xf]
set yrange [0:0.35]
#set xtics 0,10,115
#set ytics 0,0.2,2.6
#set grid xtics ytics


#set title "LBF Estimator"
set xlabel "Número de funções de hashing (k)"
set ylabel "Desvio Padrão do Estimador"

#set key box outside
#set key top left

#In case for building an eps-file ...
#set terminal postscript enhanced color solid eps 15
set term png
set output "lbf_stdK2.png"

plot 'estimatorK70std.log' using 1:4 lt 1 pt 13 w lp ti 'Desvio Padrão Distribuição Uniforme', \
        'estimatorK70std.log' using 1:3 lt 5 pt 13 w lp ti 'Desvio Padrão do Estimador (70 elem)'

PLOT5


eog "lbf_avgK.png" > /dev/null 2>&1 &
eog "lbf_mseK.png" > /dev/null 2>&1 &
eog "lbf_fillratioK.png" > /dev/null 2>&1 &
eog "lbf_stdK.png" > /dev/null 2>&1 &
eog "lbf_stdK2.png" > /dev/null 2>&1 &
