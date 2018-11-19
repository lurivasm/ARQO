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
plot "mult.dat" using 1:3 with lines lw 2 title "1024 slow", \
     "cache_1024.dat" using 1:5 with lines lw 2 title "1024 fast", \
		 "cache_2048.dat" using 1:3 with lines lw 2 title "2048 slow", \
		 "cache_2048.dat" using 1:5 with lines lw 2 title "2048 fast", \
		 "cache_4096.dat" using 1:3 with lines lw 2 title "4096 slow", \
		 "cache_4096.dat" using 1:5 with lines lw 2 title "4096 fast", \
		 "cache_8192.dat" using 1:3 with lines lw 2 title "8192 slow", \
		 "cache_8192.dat" using 1:5 with lines lw 2 title "8192 fast"
replot
quit
END_GNUPLOT
