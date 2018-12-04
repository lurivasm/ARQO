#!/bin/bash
hilos=4
bucle=3
NInicio=517
NFin=1541
NPaso=64
serie=0
par=0
acc=0
fSerie=seriemult.dat
fPar=paralmult.dat
fAcc=Accmult.dat

echo "Tomando datos..."

for ((i = NInicio ; i <= NFin ; i+=NPaso)); do
  for ((j = 0 ; j < 5 ; j++)); do
    t=$(./multiplicacion_serie $i | grep 'time' | awk '{print $3}')
    serie=$(echo "scale=10;(($serie+$t))"|bc)
    t=$(./multiplicacion_paral $i $hilos $bucle | grep 'time' | awk '{print $3}')
    par=$(echo "scale=10;(($par}+$t))"|bc)
  done

  serie=$(echo "scale=10;$serie/5"|bc)
  echo $i $serie  >> $fSerie

  par=$(echo "scale=10;$par/5"|bc)
  echo $i $par  >> $fPar

  acc=$(echo "scale=10;$serie/$par"|bc)
  echo $i $acc >> $fAcc
done
