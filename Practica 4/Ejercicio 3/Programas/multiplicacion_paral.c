#include "arqo4.h"
#include <omp.h>

#define ERROR 1
#define OK 0

float **multiplica1(int n, float **m1, float **m2, float** resultado);
float **multiplica2(int n, float **m1, float **m2, float** resultado);
float **multiplica3(int n, float **m1, float **m2, float** resultado);

int main(int argc, char **argv){
  /*Comprobamos los parámetros*/
  if(argc != 4){
    printf("Error de ejecución\nEjecute ./ejercicio3 N H \nN = Tamaño de matriz cuadrada\nH = Numero de hilos\nP = Bucle a paralelizar\n");
    exit(ERROR);
  }
  int n = atoi(argv[1]);
  int p = atoi(argv[3]);
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
  if(p == 1){
    gettimeofday(&ini, NULL);
    /* Main computation */
    resultado = multiplica1(n, matrix1, matrix2,resultado);
    /* End of computation */
    gettimeofday(&fin, NULL);
  }
  else if(p == 2){
    gettimeofday(&ini, NULL);
    /* Main computation */
    resultado = multiplica2(n, matrix1, matrix2,resultado);
    /* End of computation */
    gettimeofday(&fin, NULL);
  }
  else if(p == 3){
    gettimeofday(&ini, NULL);
    /* Main computation */
    resultado = multiplica3(n, matrix1, matrix2,resultado);
    /* End of computation */
    gettimeofday(&fin, NULL);
  }
  else{
    printf("P incorrecto\n");
    freeMatrix(matrix1);
    freeMatrix(matrix2);
    exit(ERROR);
  }


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
float **multiplica1(int n, float **m1, float **m2, float **resultado){
  int i, j, k;
  float aux;

  for(i = 0; i < n; i++){
    for(j = 0; j < n; j++){
      aux = 0;
      #pragma omp parallel for reduction(+:aux)
      for(k = 0; k < n; k++){
        aux += m1[i][k]*m2[k][j];
      }
      resultado[i][j] = aux;
    }
  }

  return resultado;
}

float **multiplica2(int n, float **m1, float **m2, float **resultado){
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

float **multiplica3(int n, float **m1, float **m2, float **resultado){
  int i, j, k;
  float aux = 0 ;

  #pragma omp parallel for reduction(+:aux) private(j,k)
  for(i = 0; i < n; i++){
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
