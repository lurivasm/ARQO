#!/bin/bash
# Generamos los graficos con gnuplot
echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Fallos de Lectura"
set ylabel "Numero de fallos"
set xlabel "Tamaño de Matriz"
set key outside
set grid
set term png
set output "mult_cache_lectura.png"
plot "mult.dat" using 1:3 with lines lw 2 title "Lectura(mult)", \
		 "mult.dat" using 1:6 with lines lw 2 title "Lectura(tras)"
replot
quit
END_GNUPLOT

echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Fallos de Escritura"
set ylabel "Numero de fallos"
set xlabel "Tamaño de Matriz"
set key outside
set grid
set term png
set output "mult_cache_escritura.png"
plot "mult.dat" using 1:4 with lines lw 2 title "Escritura(mult)", \
		 "mult.dat" using 1:7 with lines lw 2 title "Escritura(tras)"
replot
quit
END_GNUPLOT
