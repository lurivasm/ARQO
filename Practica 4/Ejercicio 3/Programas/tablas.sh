#!/bin/bash
hilos=4
tam=1000

rm -f tablas.dat

for ((i = 1 ; i <= $hilos  ; i++)); do
    if [ $i -eq 1 ]; then
      t=$(./multiplicacion_serie $tam | grep 'time' | awk '{print $3}')
      echo "Serie " $t >> tablas.dat
    fi
    for ((j = 1 ; j <= 3 ; j++)); do
      t=$(./multiplicacion_paral $tam $i $j | grep 'time' | awk '{print $3}')
      echo "Tam $tam Nhilos :" $i "Bucle: " $j $t >> tablas.dat
    done
  done

  tam=2000
  for ((i = 1 ; i <= $hilos  ; i++)); do
      if [ $i -eq 1 ]; then
        t=$(./multiplicacion_serie $tam | grep 'time' | awk '{print $3}')
        echo "Serie " $t >> tablas.dat
      fi
      for ((j = 1 ; j <= 3 ; j++)); do
        t=$(./multiplicacion_paral $tam $i $j | grep 'time' | awk '{print $3}')
        echo "Tam $tam Nhilos :" $i "Bucle: " $j $t >> tablas.dat
      done
    done
