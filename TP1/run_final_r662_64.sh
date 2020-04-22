#!/bin/sh
#
#PBS -N "ESC"
#PBS -l nodes=1:ppn=24:r662
#PBS -l walltime=3:00:00
#PBS -o output.txt
#PBS -e error.txt


cd $PBS_O_WORKDIR

module load gcc/5.3.0
module load gnu/openmpi_eth/1.8.4

machine=r662_64

now=$(date +"%T")
echo "Starting time: $now"

for ver in NPB3.3-MZ-SER NPB3.3-MZ-OMP NPB3.3-MZ-MPI
do
	if [ "$ver" != "NPB3.3-MZ-MPI" ]
	then
		export OMP_NUM_THREADS=6
		export OMP_NUM_THREADS2=4
	else
		export OMP_NUM_THREADS=12
	fi

	cd $ver
	make clean

	mkdir -p ../RESULTS_FINAL/$ver

	for benchmark in sp-mz #bt-mz sp-mz lu-mz
	do
		for class in A B C D E F
		do
			echo "-------- $ver $benchmark $class --------"

			if [ "$ver" != "NPB3.3-MZ-MPI" ]
			then
				make $benchmark CLASS=$class VERSION=VEC
				mkdir -p ../RESULTS_FINAL/$ver/$benchmark.$class
				(sleep 1 && ((vmstat -s > ../RESULTS_FINAL/$ver/$benchmark.$class/vmstat.txt) & (iostat > ../RESULTS_FINAL/$ver/$benchmark.$class/iostat.txt) & (mpstat > ../RESULTS_FINAL/$ver/$benchmark.$class/mpstat.txt) & (ps > ../RESULTS_FINAL/$ver/$benchmark.$class/ps.txt) & (top -n 1 -b | grep "a77230" > ../RESULTS_FINAL/$ver/$benchmark.$class/top.txt) & (lsof -u a77230 > ../RESULTS_FINAL/$ver/$benchmark.$class/lsof.txt))) & bin/$benchmark.$class.x > ../RESULTS_FINAL/$ver/$benchmark.$class/output.txt
			else
				make $benchmark CLASS=$class NPROCS=2 VERSION=VEC
				mkdir -p ../RESULTS_FINAL/$ver/$benchmark.$class.2
				(sleep 1 && ((vmstat -s > ../RESULTS_FINAL/$ver/$benchmark.$class.2/vmstat.txt) & (iostat > ../RESULTS_FINAL/$ver/$benchmark.$class.2/iostat.txt) & (mpstat > ../RESULTS_FINAL/$ver/$benchmark.$class.2/mpstat.txt) & (ps > ../RESULTS_FINAL/$ver/$benchmark.$class.2/ps.txt) & (top -n 1 -b | grep "a77230" > ../RESULTS_FINAL/$ver/$benchmark.$class.2/top.txt) & (lsof -u a77230 > ../RESULTS_FINAL/$ver/$benchmark.$class.2/lsof.txt))) & mpirun -np 2 -mca btl self,sm,tcp bin/$benchmark.$class.2 > ../RESULTS/$ver/$benchmark.$class.2/output.txt
			fi 

		done
	done

	cd ..
done

now=$(date +"%T")
echo "Ending time: $now"
