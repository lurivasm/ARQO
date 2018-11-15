#!/bin/bash

# inicializar variables
Ninicio=14096
Npaso=64
Nfinal=15120
fDAT=slow_fast_time.dat
fPNG=slow_fast_time.png
declare -a sumaslow
declare -a sumafast
declare -i cont

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT $fPNG

#llenamos los arrays de 0
cont=0
for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
	sumaslow[$cont]=0
	sumafast[$cont]=0
	((cont++))
done

# generar el fichero DAT vacío
touch $fDAT

echo "Running slow and fast..."
#bucle para repetir varias veces la ejecución de slow y fast para todos los N
for ((i = 0 ; i < $1 ; i++)); do
	cont=0
	for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
		echo "N($i): $N / $Nfinal..."

		# ejecutar los programas slow y fast consecutivamente con tamaño de matriz N
		# para cada uno, filtrar la línea que contiene el tiempo y seleccionar la
		# tercera columna (el valor del tiempo). Dejar los valores en variables
		# para poder imprimirlos" en la misma línea del fichero de datos
		slowTime=$(./slow $N | grep 'time' | awk '{print $3}')
		fastTime=$(./fast $N | grep 'time' | awk '{print $3}')
		sumaslow[$cont]=$(echo "scale=10;((${sumaslow[$cont]}+$slowTime))"|bc)
		sumafast[$cont]=$(echo "scale=10;((${sumafast[$cont]}+$fastTime))"|bc)
		((cont++))
	done
	#echo ${sumaslow[@]}
	#echo ${sumafast[@]}
done

#escribimos los resultados en el .dat
cont=0
for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
	mediaslow=$(echo "scale=10;${sumaslow[$cont]}/$1"|bc)
	mediafast=$(echo "scale=10;${sumafast[$cont]}/$1"|bc)
	((cont++))
	echo $N $mediaslow $mediafast >>$fDAT
done

echo "Generating plot..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
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
