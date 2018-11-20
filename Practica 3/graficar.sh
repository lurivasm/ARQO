#!/bin/bash
# Generamos los graficos con gnuplot
fPNG=slow_fast_time.png
fDAT=slow_fast_time.dat
gnuplot << END_GNUPLOT
set title "Tiempo de Ejecución Slow-Fast "
set ylabel "Tiempo(s)"
set xlabel "Tamaño de Matriz"
set key right bottom
set grid
set term png
set output "$fPNG"
plot "$fDAT" using 1:2 with lines lw 2 title "slow", \
     "$fDAT" using 1:3 with lines lw 2 title "fast"
replot
quit
END_GNUPLOT
