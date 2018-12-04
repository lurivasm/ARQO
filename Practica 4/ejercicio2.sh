#!/bin/bash
tam=(2000000 18444444 34888889 51333333 67777778 84222222 100666667 1171111111 133555556 150000000)
fSerie=serieescalar.dat
cores=16
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
  echo $i
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
    echo ${tam[$j]} $tmedio >> ParalEsc$i.dat
    acc=$(echo "scale=10;${serie[$j]}/$tmedio"|bc)
    echo ${tam[$j]} $acc >> AccEsc$i.dat
  done
done
