#!/bin/bash
# Generamos los graficos con gnuplot
echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Tiempo de ejecucion(hilos 1 - 8)"
set ylabel "Tiempo(s)"
set xlabel "Tamaño de Vector"
set key outside
set grid
set term png
set output "pescalar_tiempo1.png"
plot "Paral1.dat" using 1:2 with lines lw 2 title "1 hilo", \
     "Paral2.dat" using 1:2 with lines lw 2 title "2 hilos", \
     "Paral3.dat" using 1:2 with lines lw 2 title "3 hilos", \
     "Paral4.dat" using 1:2 with lines lw 2 title "4 hilos", \
		 "Paral5.dat" using 1:2 with lines lw 2 title "5 hilos", \
		 "Paral6.dat" using 1:2 with lines lw 2 title "6 hilos", \
		 "Paral7.dat" using 1:2 with lines lw 2 title "7 hilos", \
		 "Paral8.dat" using 1:2 with lines lw 2 title "8 hilos"
replot
quit
END_GNUPLOT



echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Tiempo de ejecucion(hilos 9 - 16)"
set ylabel "Tiempo(s)"
set xlabel "Tamaño de Vector"
set key outside
set grid
set term png
set output "pescalar_tiempo2.png"
plot "Paral9.dat" using 1:2 with lines lw 2 title "9 hilos", \
     "Paral10.dat" using 1:2 with lines lw 2 title "10 hilos", \
     "Paral11.dat" using 1:2 with lines lw 2 title "11 hilos", \
     "Paral12.dat" using 1:2 with lines lw 2 title "12 hilos", \
		 "Paral13.dat" using 1:2 with lines lw 2 title "13 hilos", \
		 "Paral14.dat" using 1:2 with lines lw 2 title "14 hilos", \
		 "Paral15.dat" using 1:2 with lines lw 2 title "15 hilos", \
		 "Paral16.dat" using 1:2 with lines lw 2 title "16 hilos"
replot
quit
END_GNUPLOT



echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Aceleración(Hilos 1 - 8)"
set ylabel "Aceleración"
set xlabel "Tamaño de Vector"
set key outside
set grid
set term png
set output "pescalar_aceleracion1.png"
plot "Acc1.dat" using 1:2 with lines lw 2 title "1 hilo", \
     "Acc2.dat" using 1:2 with lines lw 2 title "2 hilos", \
     "Acc3.dat" using 1:2 with lines lw 2 title "3 hilos", \
     "Acc4.dat" using 1:2 with lines lw 2 title "4 hilos", \
		 "Acc5.dat" using 1:2 with lines lw 2 title "5 hilos", \
		 "Acc6.dat" using 1:2 with lines lw 2 title "6 hilos", \
		 "Acc7.dat" using 1:2 with lines lw 2 title "7 hilos", \
		 "Acc8.dat" using 1:2 with lines lw 2 title "8 hilos"
replot
quit
END_GNUPLOT



echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Aceleración(Hilos 9 - 16)"
set ylabel "Aceleración"
set xlabel "Tamaño de Vector"
set key outside
set grid
set term png
set output "pescalar_aceleracion2.png"
plot "Acc10.dat" using 1:2 with lines lw 2 title "10 hilos", \
     "Acc11.dat" using 1:2 with lines lw 2 title "11 hilos", \
     "Acc12.dat" using 1:2 with lines lw 2 title "12 hilos", \
     "Acc13.dat" using 1:2 with lines lw 2 title "13 hilos", \
     "Acc14.dat" using 1:2 with lines lw 2 title "14 hilos", \
     "Acc15.dat" using 1:2 with lines lw 2 title "15 hilos", \
     "Acc16.dat" using 1:2 with lines lw 2 title "16 hilos"

replot
quit
END_GNUPLOT
