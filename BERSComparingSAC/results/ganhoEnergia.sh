gnuplot -persist << EOF
H=20
Norm=(2*(H+1)**2)
set xrange [0:H]
set grid
set style fill pattern 2
set pointsize 1
#set title "Ganho em nº de transmissões do BC-1H face ao BERS*"
set xlabel "Resource found at hop (H)"
set ylabel "% Energy"
Ebers2(x)=2*x**2+5*x+2
Ebc1h(x)=x**2-0.46*x-0.23
plot (Ebers2(x)-Ebc1h(x))/Norm ti "BERS* - BCIR*" with filledcurve x1
set term pdfcairo enhanced font "Vera,14" linewidth 2
set output "./ganhoEnergia.pdf"
replot
EOF
