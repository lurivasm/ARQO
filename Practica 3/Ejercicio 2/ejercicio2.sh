#!/bin/bash

# inicializar variables
Ninicio=6096
Npaso=64
Nfinal=7120
rpng=cache_lectura.png
wpng=cache_escritura.png
tamCache=(1024 2048 4096 8192)
contador=0
declare -a D1mr_slow
declare -a D1mw_slow
declare -a D1mr_fast
declare -a D1mw_fast

# borrar el fichero DAT y el fichero PNG
rm -f $rpng $wpng cache_1024.dat cache_2048.dat cache_4096.dat cache_8192.dat


echo "Ejercicio 2 : Running slow and fast..."
# bucle que varia el tamaño de la matriz desde 2000+1024*4 hasta 2000+1024*5

for ((N = Ninicio ; N <=Nfinal ; N += Npaso));
do
	echo "N: $N / $Nfinal..."

   # Bucle para variar el tamaño de la cache
   for ((i=0; i<${#tamCache[*]}; i++));
   do

      # Ejecutamos valgrind con la configuración de cache pedida y generamos el fichero
      valgrind --tool=cachegrind --LL=8388608,1,64 --I1=${tamCache[$i]},1,64 --D1=${tamCache[$i]},1,64 --cachegrind-out-file=slow_cachegrind.dat ./slow $N
      valgrind --tool=cachegrind --LL=8388608,1,64 --I1=${tamCache[$i]},1,64 --D1=${tamCache[$i]},1,64 --cachegrind-out-file=fast_cachegrind.dat ./fast $N

      D1mr_slow[$contador]=$(cg_annotate slow_cachegrind.dat | head -n 22 | grep 'PROGRAM TOTALS' | awk '{print $5}'| sed -e 's/,//g')
		  D1mw_slow[$contador]=$(cg_annotate slow_cachegrind.dat | head -n 22 | grep 'PROGRAM TOTALS' | awk '{print $8}'| sed -e 's/,//g')

      D1mr_fast[$contador]=$(cg_annotate fast_cachegrind.dat | head -n 22 | grep 'PROGRAM TOTALS' | awk '{print $5}'| sed -e 's/,//g')
      D1mw_fast[$contador]=$(cg_annotate fast_cachegrind.dat | head -n 22 | grep 'PROGRAM TOTALS' | awk '{print $8}'| sed -e 's/,//g')

   		echo $N ${D1mr_slow[$contador]} ${D1mw_slow[$contador]} ${D1mr_fast[$contador]} ${D1mw_fast[$contador]} >> cache_${tamCache[$i]}.dat

			((contador++))

   done

done

# Generamos los graficos con gnuplot
echo "Generating plot..."

gnuplot << END_GNUPLOT
set title "Fallos de lectura"
set ylabel "Fallos de Caché"
set xlabel "Tamaño de Matriz"
set key outside
set grid
set term png
set output "$rpng"
plot "cache_1024.dat" using 1:2 with lines lw 2 title "1024 slow", \
     "cache_1024.dat" using 1:4 with lines lw 2 title "1024 fast", \
		 "cache_2048.dat" using 1:2 with lines lw 2 title "2048 slow", \
		 "cache_2048.dat" using 1:4 with lines lw 2 title "2048 fast", \
		 "cache_4096.dat" using 1:2 with lines lw 2 title "4096 slow", \
		 "cache_4096.dat" using 1:4 with lines lw 2 title "4096 fast", \
		 "cache_8192.dat" using 1:2 with lines lw 2 title "8192 slow", \
		 "cache_8192.dat" using 1:4 with lines lw 2 title "8192 fast"
replot
quit
END_GNUPLOT

gnuplot << END_GNUPLOT
set title "Fallos de escritura"
set ylabel "Fallos de Caché"
set xlabel "Tamaño de Matriz"
set key right bottom
set grid
set term png
set output "$wpng"
plot "cache_1024.dat" using 1:3 with lines lw 2 title "1024 slow", \
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

rm -f slow_cachegrind.dat fast_cachegrind.dat
