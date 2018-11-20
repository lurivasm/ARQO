LIBS =
LIB_DIR =
FLAGS = -g -Wall -D_GNU_SOURCE

.PHONY: clean all

all: ej3_multiplicacion ej3_transpuesta

ej3_multiplicacion: ej3_multiplicacion.c arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

ej3_transpuesta: ej3_transpuesta.c arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

clean:
	rm -f *.o *~ ej3_multiplicacion ej3_transpuesta
