#!/bin/bash

# inicializar variables
Ninicio=6096
Npaso=64
Nfinal=7120
fDAT=slow_fast_time.dat
fPNG=slow_fast_time.png
tamCache=(1024 2048 4096 8192)
contador=0


# borrar el fichero DAT y el fichero PNG
rm -f slow_cachegrind.dat fast_cachegrind.dat $fDAT fPNG

# generar el fichero DAT vacío
touch $fDAT

# Establecemos los valores para la cache de ultimo nivel
# Nivel 1 de instrucciones, nivel 1 de datos y ultimo nivel
# Size, associative, line size (bytes)
valgrind --tool=cachegrind --LL=8388608,1,64

echo "Running slow and fast..."
# bucle para N desde 2000+1024*4 hasta 2000+1024*5
#for N in $(seq $Ninicio $Npaso $Nfinal);
for ((N = Ninicio ; N <= Nfinal ; N += Npaso));
do
	echo "N: $N / $Nfinal..."

   for ((i=0; i<${#tamCache[*]}; i++));
   do
      valgrind --tool=cachegrind --I1=${tamCache[i]},1,64
      valgrind --tool=cachegrind --D1=${tamCache[i]},1,64
   	echo "cache_${tamCache[i]}.dat"
   done

	# ejecutar los programas slow y fast consecutivamente con tamaño de matriz N
	# para cada uno, filtrar la línea que contiene el tiempo y seleccionar la
	# tercera columna (el valor del tiempo). Dejar los valores en variables
	# para poder imprimirlos en la misma línea del fichero de datos
	slowTime=$(./slow $N | grep 'time' | awk '{print $3}')
	fastTime=$(./fast $N | grep 'time' | awk '{print $3}')

   # Ejecutamos valgrind y generamos el fichero
   valgrind --tool=cachegrind  --cachegrind-out-file=slow_cachegrind.dat ./slow $N
   valgrind --tool=cachegrind  --cachegrind-out-file=fast_cachegrind.dat ./fast $N
   cg_annotate slow_cachegrind.dat | head -n 22 | grep 'PROGRAM TOTALS' | awk '{print $1}'


	echo "$N	$slowTime	$fastTime" >> $fDAT
done

# Generamos los graficos con gnuplot
echo "Generating plot..."

gnuplot << END_GNUPLOT
set title "Slow-Fast Execution Time"
set ylabel "Execution time (s)"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNG"
plot "$fDAT" using 1:2 with lines lw 2 title "slow", \
     "$fDAT" using 1:3 with lines lw 2 title "fast"
replot
quit
END_GNUPLOT
