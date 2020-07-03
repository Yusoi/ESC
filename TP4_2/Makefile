.DEFAULT_GOAL=all

clean:
	-rm naive
	-rm naive2

all: naive.c naive2.c
	gcc -ggdb -Wall -O3 -o naive naive.c
	gcc -ggdb -Wall -O3 -o naive2 naive2.c
