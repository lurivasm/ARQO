#!/bin/bash
tam=(1000000 2000000 3000000 4000000 5000000 7000000 8000000 9000000 10000000)
fSerie=serie.dat
fParal=paralelo.dat
cores=8
sumaserie=0
tmedio=0

rm -f $fSerie $fParal
echo "Ejercicio 2 : Tomando datos"
for ((i = 1 ; i <= $cores  ; i++)); do
  for((j = 0; j < 10 ; j++)); do
    for((k = 0; k < 5 ; k++)); do
      if [i -eq 1]
      then
        t=$(./pescalar_serie ${tam[$j]} | grep 'Tiempo' | awk '{print $2}')
        sumaserie=$(echo "scale=10;((sumaserie+t))"|bc)
      fi
    done
    if [i -eq 1]
    then
      tmedio=$(echo "scale=10;sumaserie/5"|bc)
      echo ${tam[$j]} $tmedio >> $fSerie
    fi
  done
done 
