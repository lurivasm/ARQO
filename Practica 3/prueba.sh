#!/bin/bash
valgrind --tool=cachegrind  --LL=8388608,1,64 --I1=1024,1,64 --D1=1024,1,64 --cachegrind-out-file=slow_cachegrind.dat ./slow 4
