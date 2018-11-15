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
# bucle que varia el tamaño de la matriz desde 2000+1024*4 hasta 2000+1024*5
#for N in $(seq $Ninicio $Npaso $Nfinal);
for ((N = Ninicio ; N <= Nfinal ; N += Npaso));
do
	echo "N: $N / $Nfinal..."

  # Ejecutamos valgrind y generamos el fichero
  valgrind --tool=cachegrind  --cachegrind-out-file=mult_cachegrind.dat ./mult $N
  valgrind --tool=cachegrind  --cachegrind-out-file=tras_cachegrind.dat ./tras $N

  D1mr_mult[contador]=$(cg_annotate mult_cachegrind.dat | head -n 22 | grep 'PROGRAM TOTALS' | awk '{print $5}')
  D1mw_mult[contador]=$(cg_annotate mult_cachegrind.dat | head -n 22 | grep 'PROGRAM TOTALS' | awk '{print $8}')
  time_mult[contador]=$(./ej3_multiplica $N | grep 'time' | awk '{print $3}')

  D1mr_tras[contador]=$(cg_annotate tras_cachegrind.dat | head -n 22 | grep 'PROGRAM TOTALS' | awk '{print $5}')
  D1mw_tras[contador]=$(cg_annotate tras_cachegrind.dat | head -n 22 | grep 'PROGRAM TOTALS' | awk '{print $8}')
  time_tras[contador]=$(./ej3_transpuesta $N | grep 'time' | awk '{print $3}')
  ((contador++))


  echo "$N ${time_mult[$contador]} ${D1mr_mult[$contador]} ${D1mw_mult[$contador]} ${time_tras[$contador]} ${D1mr_tras[$contador]} ${D1mw_tras[$contador]}" >> mult.dat

  done

done

# Generamos los graficos con gnuplot
echo "Generating plot..."

gnuplot << END_GNUPLOT
set title "Fallos de lectura"
set ylabel "Fallos de Caché"
set xlabel "Tamaño de Caché"
set key right bottom
set grid
set term png
set output "$rpng"
plot "cache_1024" using 1:2 with lines lw 2 title "mult", \
     "$fDAT" using 1:3 with lines lw 2 title "tras"
replot
quit
END_GNUPLOT

rm -f mult_cachegrind.dat tras_cachegrind.dat
