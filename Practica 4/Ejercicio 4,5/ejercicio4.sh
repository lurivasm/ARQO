#!/bin/bash

val=(1 2 4 6 7 8 9 10 12)

for ((i = 0 ; i < 9 ; i++)); do
  echo ${val[$i]} "Tiempo"  $(./pi_par3 ${val[$i]} | grep 'Tiempo' | awk '{print $2}')
done
