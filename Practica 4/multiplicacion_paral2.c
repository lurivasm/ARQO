#include "arqo4.h"
#include <omp.h>

#define ERROR 1
#define OK 0

float **multiplica(int n, float **m1, float **m2, float** resultado);

int main(int argc, char **argv){
  /*Comprobamos los parámetros*/
  if(argc != 3){
    printf("Error de ejecución\nEjecute ./ejercicio3 N H \nN = Tamaño de matriz cuadrada\nH = Numero de hilos\n");
    exit(ERROR);
  }
  int n = atoi(argv[1]);
  struct timeval fin, ini;

  /*Generamos las matrices*/
  float **matrix1, **matrix2, **resultado;
  matrix1 = generateMatrix(n);
  if(!matrix1){
    printf("Error matrix1\n");
    exit(ERROR);
  }

  matrix2 = generateMatrix(n);
  if(!matrix2){
    printf("Error matrix2\n");
    freeMatrix(matrix1);
    exit(ERROR);
  }

  resultado = generateEmptyMatrix(n);
  if(!resultado){
    printf("Error resultado\n");
    freeMatrix(matrix1);
    freeMatrix(matrix2);
    exit(ERROR);
  }

  omp_set_num_threads(atoi(argv[2]));
  gettimeofday(&ini, NULL);
	/* Main computation */
	resultado = multiplica(n, matrix1, matrix2,resultado);
	/* End of computation */
  gettimeofday(&fin, NULL);

  if(!resultado){
    freeMatrix(matrix1);
    freeMatrix(matrix2);
    exit(ERROR);
  }

  printf("Execution time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);
  freeMatrix(matrix1);
  freeMatrix(matrix2);
  exit(OK);
}

/**
* Función que multiplica dos matrices, m1 y m2 de tamaño nxn
*/
float **multiplica(int n, float **m1, float **m2, float **resultado){
  int i, j, k;
  float aux;

  for(i = 0; i < n; i++){
  #pragma omp parallel for reduction(+:aux) private(k)
    for(j = 0; j < n; j++){
      aux = 0;
        for(k = 0; k < n; k++){
        aux += m1[i][k]*m2[k][j];
      }
      resultado[i][j] = aux;
    }
  }

  return resultado;
}
