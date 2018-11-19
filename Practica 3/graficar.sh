#!/bin/bash
# Generamos los graficos con gnuplot
echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Fallos de Caché"
set ylabel "Numero de fallos"
set xlabel "Tamaño de Matriz"
set key outside
set grid
set term png
set output "mult_cache.png"
plot "mult.dat" using 1:3 with lines lw 2 title "Lectura(mult)", \
     "mult.dat" using 1:4 with lines lw 2 title "Escritura(mult)", \
		 "mult.dat" using 1:6 with lines lw 2 title "Lectura(tras)", \
		 "mult.dat" using 1:7 with lines lw 2 title "Escritura(tras)"
replot
quit
END_GNUPLOT

gnuplot << END_GNUPLOT
set title "Tiempo de ejecucion"
set ylabel "Tiempo(s)"
set xlabel "Tamaño de Matriz"
set key outside
set grid
set term png
set output "mult_time.png"
plot "mult.dat" using 1:2 with lines lw 2 title "Mult", \
     "mult.dat" using 1:5 with lines lw 2 title "Tras"
replot
quit
END_GNUPLOT
