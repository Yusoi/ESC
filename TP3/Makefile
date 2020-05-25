.DEFAULT_GOAL := seq

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

clean:
	-rm -f *.o
	-rm -f seq
	-rm -f seq_dtrace.h



