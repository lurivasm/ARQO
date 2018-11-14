#!/bin/bash

# inicializar variables
Ninicio=6096
Npaso=64
Nfinal=7120
rpng=cache_lectura.png
wpng=cache_escritura.png
tamCache=(1024 2048 4096 8192)
contador=0
D1mr_slow=()
D1mw_slow=()
D1mr_fast=()
D1mw_fast=()

# borrar el fichero DAT y el fichero PNG
rm -f slow_cachegrind.dat fast_cachegrind.dat $rpng wpng

# Establecemos los valores para la cache de ultimo nivel
# Size, associative, line size (bytes)
valgrind --tool=cachegrind --LL=8388608,1,64

echo "Ejercicio 2 : Running slow and fast..."
# bucle que varia el tamaño de la matriz desde 2000+1024*4 hasta 2000+1024*5
#for N in $(seq $Ninicio $Npaso $Nfinal);
for ((N = Ninicio ; N <= Nfinal ; N += Npaso));
do
	echo "N: $N / $Nfinal..."

   # Bucle para variar el tamaño de la cache
   for ((i=0; i<${#tamCache[*]}; i++));
   do
      # Configuramos la cache de nivel 1 de instrucciones y de datos
      valgrind --tool=cachegrind --I1=${tamCache[i]},1,64
      valgrind --tool=cachegrind --D1=${tamCache[i]},1,64

      # Ejecutamos valgrind y generamos el fichero
      valgrind --tool=cachegrind  --cachegrind-out-file=slow_cachegrind.dat ./slow $N
      valgrind --tool=cachegrind  --cachegrind-out-file=fast_cachegrind.dat ./fast $N

      D1mr_slow[contador]=$(cg_annotate slow_cachegrind.dat | head -n 22 | grep 'PROGRAM TOTALS' | awk '{print $5}')
      D1mw_slow[contador]=$(cg_annotate slow_cachegrind.dat | head -n 22 | grep 'PROGRAM TOTALS' | awk '{print $8}')

      D1mr_fast[contador]=$(cg_annotate fast_cachegrind.dat | head -n 22 | grep 'PROGRAM TOTALS' | awk '{print $5}')
      D1mw_fast[contador]=$(cg_annotate fast_cachegrind.dat | head -n 22 | grep 'PROGRAM TOTALS' | awk '{print $8}')
      contador ++

   	echo "$N $D1mr $D1mw $D1mr $D1mw" >> cache_${tamCache[i]}.dat

   done

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
