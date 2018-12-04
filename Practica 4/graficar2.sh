#!/bin/bash
# Generamos los graficos con gnuplot
echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Tiempo de ejecucion"
set ylabel "Tiempo(s)"
set xlabel "Tamaño de Vector"
set key outside
set grid
set term png
set output "pescalar_tiempo.png"
plot "serie.dat" using 1:2 with lines lw 2 title "Serie", \
		 "Paral1.dat" using 1:2 with lines lw 2 title "1 hilo", \
     "Paral2.dat" using 1:2 with lines lw 2 title "2 hilos", \
     "Paral3.dat" using 1:2 with lines lw 2 title "3 hilos", \
     "Paral4.dat" using 1:2 with lines lw 2 title "4 hilos"
replot
quit
END_GNUPLOT
echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Aceleración"
set ylabel "Aceleración"
set xlabel "Tamaño de Vector"
set key outside
set grid
set term png
set output "mult_cache_escritura.png"
plot "Acc1.dat" using 1:2 with lines lw 2 title "1 hilo", \
     "Acc2.dat" using 1:2 with lines lw 2 title "2 hilos", \
     "Acc3.dat" using 1:2 with lines lw 2 title "3 hilos", \
     "Acc4.dat" using 1:2 with lines lw 2 title "4 hilos"
replot
quit
END_GNUPLOT
