.DEFAULT_GOAL := all

# re-create new dprime.h if dprime.d file has been changed
heattimer.h: heattimer.d
	dtrace -h -s heattimer.d

# compile the main program
seq.o: seq.c heattimer.h
	gcc -O3 -c seq.c
# have dtrace post-process the object files
seq_final.o: heattimer.d seq.o
	dtrace -G -s heattimer.d seq.o -o seq_final.o
# link and create executable file "prime"
seq: seq_final.o
	gcc -O3 -Wl,--strip-all -o seq seq_final.o seq.o heattimer.h -lm

# compile the main program
openmp.o: openmp.c heattimer.h
	gcc -O3 -c openmp.c -lm -fopenmp
# have dtrace post-process the object files
openmp_final.o: heattimer.d openmp.o
	dtrace -G -s heattimer.d openmp.o -o openmp_final.o
# link and create executable file "prime"
openmp: openmp_final.o
	gcc -O4 -Wl,--strip-all -o openmp openmp_final.o openmp.o heattimer.h -lm -fopenmp

# compile the main program
mpi.o: mpi.c heattimer.h
	/usr/local/bin/mpicc -O3 -c mpi.c
# have dtrace post-process the object files
mpi_final.o: heattimer.d mpi.o
	dtrace -G -s heattimer.d mpi.o -o mpi_final.o
# link and create executable file "prime"
mpi: mpi_final.o
	/usr/local/bin/mpicc -O3 -Wl,--strip-all -o mpi mpi_final.o mpi.o heattimer.h -lm

all: seq openmp mpi

clean:
	-rm -f *.o
	-rm -f seq
	-rm -f openmp
	-rm -f mpi
	-rm -f heattimer.h



