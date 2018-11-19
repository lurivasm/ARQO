
#include "arqo3.h"

#define ERROR 1
#define OK 0

tipo **transpuesta(int n, tipo **m);
tipo **multiplica(int n, tipo **m1, tipo **m2, tipo** resultado);
int main(int argc, char **argv){
  /*Comprobamos los parámetros*/
  if(argc != 2){
    printf("Error de ejecución\nEjecute ./ejercicio3 N\nN = Tamaño de matriz cuadrada\n");
    exit(ERROR);
  }
  int n = atoi(argv[1]);
  struct timeval fin, ini;

  /*Generamos las matrices*/
  tipo **matrix1, **matrix2, **resultado;
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

  gettimeofday(&ini, NULL);
	/* Main computation */
  /*Trasponemos la matriz 2*/
  matrix2 = transpuesta(n, matrix2);
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
tipo **multiplica(int n, tipo **m1, tipo **m2, tipo **resultado){
  int i, j, k, aux;
  if(!m1 || !m2 || !resultado || n < 0) return NULL;

  for(i = 0; i < n; i++){
    for(j = 0; j < n; j++){
      for(k = 0, aux = 0; k < n; k++){
        aux += m1[i][k]*m2[j][k]; /*Cambiamos kj por jk*/
      }
      resultado[i][j] = aux;
    }
  }

  return resultado;
}

/**
* Funcion que transpone la matriz pasada como parametro
*/
tipo **transpuesta(int n, tipo **m){
  if(!m || n < 0) return NULL;
  int i, j, aux;

  for(i = 0; i < n; i++){
    for(j = i+1; j < n; j++){
      aux = m[i][j];
      m[i][j] = m[j][i];
      m[j][i] = aux;
    }
  }

  return m;
}
