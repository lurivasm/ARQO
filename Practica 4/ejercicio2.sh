#!/bin/bash
tam=(1000000 2000000 3000000 4000000 5000000 6000000 7000000 8000000 9000000 10000000)
fSerie=serie.dat
cores=4
declare -a serie
sumapar=0
tmedio=0
acc=0

rm -f $fSerie

for((i = 0; i < 10 ; i++)); do
  serie[$i]=0
done
echo "Ejercicio 2 : Tomando datos"
for ((i = 1 ; i <= $cores  ; i++)); do
  rm -f Paral$i.dat Acc$i.dat
  for((j = 0; j < 10 ; j++)); do
    sumapar=0
    for((k = 0; k < 5 ; k++)); do
      if [ $i -eq 1 ]; then
        t=$(./pescalar_serie ${tam[$j]} | grep 'Tiempo' | awk '{print $2}')
        serie[$j]=$(echo "scale=10;((${serie[$j]}+$t))"|bc)
      fi
      t=$(./pescalar_par2 ${tam[$j]} $i | grep 'Tiempo' | awk '{print $2}')
      sumapar=$(echo "scale=10;(($sumapar+$t))"|bc)
    done
    if [ $i -eq 1 ];then
      serie[j]=$(echo "scale=10;${serie[$j]}/5"|bc)
      echo ${tam[$j]} ${serie[$j]}  >> $fSerie
    fi

    tmedio=$(echo "scale=10;$sumapar/5"|bc)
    echo ${tam[$j]} $tmedio >> Paral$i.dat
    acc=$(echo "scale=10;${serie[$j]}/$tmedio"|bc)
    echo ${tam[$j]} $acc >> Acc$i.dat
  done
done

# Generamos los graficos con gnuplot
echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Tiempo de ejecucion"
set ylabel "Tiempo(s)"
set xlabel "Tamaño de Vector"
set key outside
set grid
set term png
set output "pescalar_tiempo.png"
plot "serie.dat" using 1:2 with lines lw 2 title "Serie", \
		 "Paral1.dat" using 1:2 with lines lw 2 title "1 hilo", \
     "Paral2.dat" using 1:2 with lines lw 2 title "2 hilos", \
     "Paral3.dat" using 1:2 with lines lw 2 title "3 hilos", \
     "Paral4.dat" using 1:2 with lines lw 2 title "4 hilos"
replot
quit
END_GNUPLOT
echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Aceleración"
set ylabel "Aceleración"
set xlabel "Tamaño de Vector"
set key outside
set grid
set term png
set output "mult_cache_escritura.png"
plot "Acc1.dat" using 1:2 with lines lw 2 title "1 hilo", \
     "Acc2.dat" using 1:2 with lines lw 2 title "2 hilos", \
     "Acc3.dat" using 1:2 with lines lw 2 title "3 hilos", \
     "Acc4.dat" using 1:2 with lines lw 2 title "4 hilos"
replot
quit
END_GNUPLOT
