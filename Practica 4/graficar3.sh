#!/bin/bash
echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Tiempo de ejecucion"
set ylabel "Tiempo(s)"
set xlabel "Tamaño de Matriz"
set key outside
set grid
set term png
set output "mult_tiempo.png"
plot "seriemult.dat" using 1:2 with lines lw 2 title "Serie", \
     "paralmult.dat" using 1:2 with lines lw 2 title "Paralelo"

quit
END_GNUPLOT

echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Aceleracion"
set ylabel "Aceleracion"
set xlabel "Tamaño de Matriz"
set key outside
set grid
set term png
set output "mult_acc.png"
plot "Accmult.dat" using 1:2 with lines lw 2 title "Aceleracion"

quit
END_GNUPLOT
