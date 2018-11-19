#!/bin/bash

# inicializar variables
Ninicio=1280
Npaso=16
Nfinal=1536
contador=0
declare -a D1mr_mult
declare -a D1mw_mult
declare -a D1mr_tras
declare -a D1mw_tras


echo "Ejercicio 3 : Running mult and tras..."
# bucle que varia el tamaño de la matriz desde 256+256*4 hasta 256+256*5
for ((N = Ninicio ; N <= Nfinal ; N += Npaso));
do
	echo "N: $N / $Nfinal..."

  # Ejecutamos valgrind y generamos el fichero
  valgrind --tool=cachegrind  --cachegrind-out-file=mult_cachegrind.dat ./ej3_multiplicacion $N
  valgrind --tool=cachegrind  --cachegrind-out-file=tras_cachegrind.dat ./ej3_transpuesta $N

  D1mr_mult[$contador]=$(cg_annotate mult_cachegrind.dat | head -n 22 | grep 'PROGRAM TOTALS' | awk '{print $5}'|sed -e 's/,//g')
  D1mw_mult[$contador]=$(cg_annotate mult_cachegrind.dat | head -n 22 | grep 'PROGRAM TOTALS' | awk '{print $8}'|sed -e 's/,//g')
  time_mult[$contador]=$(./ej3_multiplicacion $N | grep 'time' | awk '{print $3}')

  D1mr_tras[$contador]=$(cg_annotate tras_cachegrind.dat | head -n 22 | grep 'PROGRAM TOTALS' | awk '{print $5}')
  D1mw_tras[$contador]=$(cg_annotate tras_cachegrind.dat | head -n 22 | grep 'PROGRAM TOTALS' | awk '{print $8}')
  time_tras[$contador]=$(./ej3_transpuesta $N | grep 'time' | awk '{print $3}')

  echo $N ${time_mult[$contador]} ${D1mr_mult[$contador]} ${D1mw_mult[$contador]} ${time_tras[$contador]} ${D1mr_tras[$contador]} ${D1mw_tras[$contador]} >> mult.dat

	  ((contador++))
  done



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


rm -f mult_cachegrind.dat tras_cachegrind.dat
