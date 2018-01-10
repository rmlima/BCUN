#Display Latency
import os

DATAFILE='latency3.dat'
PLOTFILE='latency3.png'

f=os.popen('gnuplot -persistent' ,'w')
print >>f, "set xrange [0:25]"
print >>f, "set border 3 back ls 11"
print >>f, "set style line 11 lc rgb '#808080' lt 1"
print >>f, "set border 3 back ls 11"
print >>f, "set tics nomirror"
print >>f, "set style data linespoints"
print >>f, "set style line 12 lc rgb '#808080' lt 0 lw 1"
print >>f, "set grid back ls 12"
print >>f, "set style line 1 lc rgb '#8b1a0e' pt 1 ps 2 lt 1 lw 2"
print >>f, "set style line 2 lc rgb '#5e9c36' pt 6 ps 2 lt 1 lw 2"
print >>f, "set style line 3 lc rgb '#191970' pt 4 ps 2 lt 1 lw 2"
print >>f, "set key top right"
print >>f, "set xlabel 'Record Density (%)'; set ylabel 'Latency (#slots)'"
print >>f, "set sample 8"
print >>f, "plot \"latency3.dat\" using 1:3 ti \"BERS \; BCIR\" w lp ls 1, \"latency3.dat\" using 1:4 ti \"BERS* ; BCIR*\" w lp ls 2, \"latency3.dat\" using 1:2 ti \"Flooding\" w lp ls 3"
#print >>f, "plot '%s' using 1:2 ti 'Flooding' w lp ls 3, '%s' using 1:3  ti 'BERS ; BCIR' w lp ls 1, '%s' using 1:4  ti 'BERS* ; BCIR*' w lp ls 2" % (DATAFILE) % (DATAFILE) % (DATAFILE)
print >>f, "set terminal png enhanced font 'Verdana,14'"
print >>f, "set out '%s'" % PLOTFILE
print >>f, "pause 2; replot"
f.flush()



DATAFILE='overhead3.dat'
PLOTFILE='overhead3a.png'

f=os.popen('gnuplot -persistent' ,'w')
print >>f, "set xrange [0:20]"
print >>f, "set border 3 back ls 11"
print >>f, "set style line 11 lc rgb '#808080' lt 1"
print >>f, "set border 3 back ls 11"
print >>f, "set tics nomirror"
print >>f, "set style data linespoints"
print >>f, "set style line 12 lc rgb '#808080' lt 0 lw 1"
print >>f, "set grid back ls 12"
print >>f, "set style line 1 lc rgb '#8b1a0e' pt 1 ps 2 lt 1 lw 2"
print >>f, "set style line 2 lc rgb '#5e9c36' pt 6 ps 2 lt 1 lw 2"
print >>f, "set style line 3 lc rgb '#191970' pt 4 ps 2 lt 1 lw 2"
print >>f, "set style line 4 lc rgb '#b8860b' pt 8 ps 2 lt 1 lw 2"
print >>f, "set style line 5 lc rgb '#9370db' pt 12 ps 2 lt 1 lw 2"
print >>f, "set key at 20,0.9"
print >>f, "set xlabel 'Record Density (%)'; set ylabel 'Retransmissions Ratio'"
print >>f, "plot \"overhead3.dat\" using 1:3 ti \"BERS\" w lp ls 1, \"overhead3.dat\" using 1:5 ti \"BCIR\" w lp ls 4, \"overhead3.dat\" using 1:4 ti \"BERS*\" w lp ls 2, \"overhead3.dat\" using 1:6 ti \"BCIR*\" w lp ls 5, \"overhead3.dat\" using 1:2 ti \"Flooding\" w lp ls 3"
#print >>f, "plot '%s' using 1:2 ti 'Flooding' w lp ls 3, '%s' using 1:3  ti 'BERS ; BCIR' w lp ls 1, '%s' using 1:4  ti 'BERS* ; BCIR*' w lp ls 2" % (DATAFILE) % (DATAFILE) % (DATAFILE)
print >>f, "set terminal png enhanced font 'Verdana,14'"
print >>f, "set out '%s'" % PLOTFILE
print >>f, "set key at 20,0.9"
print >>f, "pause 2; replot"
f.flush()


DATAFILE='overhead4.dat'
PLOTFILE='overhead3b.png'

f=os.popen('gnuplot -persistent' ,'w')
print >>f, "set xrange [20:85]"
#print >>f, "set sample 8"
print >>f, "set border 3 back ls 11"
print >>f, "set style line 11 lc rgb '#808080' lt 1"
print >>f, "set border 3 back ls 11"
print >>f, "set tics nomirror"
print >>f, "set style data linespoints"
print >>f, "set style line 12 lc rgb '#808080' lt 0 lw 1"
print >>f, "set grid back ls 12"
print >>f, "set style line 1 lc rgb '#8b1a0e' pt 1 ps 2 lt 1 lw 2"
print >>f, "set style line 91 lc rgb '#8b1a0e' pt 1 ps 2 lt 0 lw 2"
print >>f, "set style line 2 lc rgb '#5e9c36' pt 6 ps 2 lt 1 lw 2"
print >>f, "set style line 92 lc rgb '#5e9c36' pt 6 ps 2 lt 0 lw 2"
print >>f, "set style line 3 lc rgb '#191970' pt 4 ps 2 lt 1 lw 2"
print >>f, "set style line 93 lc rgb '#191970' pt 4 ps 2 lt 0 lw 2"
print >>f, "set style line 4 lc rgb '#b8860b' pt 8 ps 2 lt 1 lw 2"
print >>f, "set style line 94 lc rgb '#b8860b' pt 8 ps 2 lt 0 lw 2"
print >>f, "set style line 5 lc rgb '#9370db' pt 12 ps 2 lt 1 lw 2"
print >>f, "set style line 95 lc rgb '#9370db' pt 12 ps 2 lt 0 lw 2"
print >>f, "set key at 85,0.17"
print >>f, "set xlabel 'Record Density (%)'; set ylabel 'Retransmissions Ratio'"
print >>f, "plot \"overhead4.dat\" using 1:3 ti \"BERS\" w lp ls 1, \"overhead4.dat\" using 1:5 ti \"BCIR\" w lp ls 4, \"overhead4.dat\" using 1:4 ti \"BERS*\" w lp ls 2, \"overhead4.dat\" using 1:6 ti \"BCIR*\" w lp ls 5"
#print >>f, "plot '%s' using 1:2 ti 'Flooding' w lp ls 3, '%s' using 1:3  ti 'BERS ; BCIR' w lp ls 1, '%s' using 1:4  ti 'BERS* ; BCIR*' w lp ls 2" % (DATAFILE) % (DATAFILE) % (DATAFILE)
print >>f, "set terminal png enhanced font 'Verdana,14'"
print >>f, "set out '%s'" % PLOTFILE
print >>f, "set key at 85,0.17"
print >>f, "pause 2; replot"
f.flush()



exit()

DATAFILE='overhead3.dat'
PLOTFILE='overhead4.png'

f=os.popen('gnuplot -persistent' ,'w')
print >>f, "set xrange [20:85]"
print >>f, "set border 3 back ls 11"
print >>f, "set style line 11 lc rgb '#808080' lt 1"
print >>f, "set border 3 back ls 11"
print >>f, "set tics nomirror"
print >>f, "set style data linespoints"
print >>f, "set style line 12 lc rgb '#808080' lt 0 lw 1"
print >>f, "set grid back ls 12"
print >>f, "set style line 1 lc rgb '#8b1a0e' pt 1 ps 2 lt 1 lw 2"
print >>f, "set style line 2 lc rgb '#5e9c36' pt 6 ps 2 lt 1 lw 2"
print >>f, "set style line 3 lc rgb '#191970' pt 4 ps 2 lt 1 lw 2"
print >>f, "set style line 4 lc rgb '#b8860b' pt 8 ps 2 lt 1 lw 2"
print >>f, "set style line 5 lc rgb '#9370db' pt 12 ps 2 lt 1 lw 2"
print >>f, "set key at 85,0.17"
print >>f, "set xlabel 'Record Density (%)'; set ylabel 'Retransmissions Ratio'"
print >>f, "plot \"overhead3.dat\" using 1:5 ti \"BERS\" w lp ls 1, \"overhead3.dat\" using 1:3 ti \"BCIR\" w lp ls 4, \"overhead3.dat\" using 1:4 ti \"BERS*\" w lp ls 2, \"overhead3.dat\" using 1:6 ti \"BCIR*\" w lp ls 5"
#print >>f, "plot '%s' using 1:2 ti 'Flooding' w lp ls 3, '%s' using 1:3  ti 'BERS ; BCIR' w lp ls 1, '%s' using 1:4  ti 'BERS* ; BCIR*' w lp ls 2" % (DATAFILE) % (DATAFILE) % (DATAFILE)
print >>f, "set terminal png enhanced font 'Verdana,14'"
print >>f, "set out '%s'" % PLOTFILE
print >>f, "set key at 85,0.17"
print >>f, "pause 2; replot"
print >>f, "set xrange [25:85]"
print >>f, "set out '%s_25_85'" % PLOTFILE
print >>f, "pause 2; replot"
f.flush()







