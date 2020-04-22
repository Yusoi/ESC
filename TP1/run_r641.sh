#!/bin/sh
#
#PBS -N "ESC"
#PBS -l nodes=1:ppn=16:r641
#PBS -l walltime=3:00:00
#PBS -o output.txt
#PBS -e error.txt


cd $PBS_O_WORKDIR

module load gcc/5.3.0
module load gnu/openmpi_eth/1.8.4

machine=r641

now=$(date +"%T")
echo "Starting time: $now"

for ver in NPB3.3-MZ-SER NPB3.3-MZ-OMP NPB3.3-MZ-MPI
do
	if [ "$ver" != "NPB3.3-MZ-MPI" ]
	then
		export OMP_NUM_THREADS=4
		export OMP_NUM_THREADS2=4
	else
		export OMP_NUM_THREADS=8
	fi

	cd $ver
	make clean

	mkdir -p ../RESULTS/$machine/$ver

	for benchmark in bt-mz sp-mz lu-mz
	do
		for class in A B C
		do
			echo "-------- $ver $benchmark $class --------"

			if [ "$ver" != "NPB3.3-MZ-MPI" ]
			then
				make $benchmark CLASS=$class VERSION=VEC
				mkdir -p ../RESULTS/$machine/$ver/$benchmark.$class
				(sleep 1 && vmstat -s) > ../RESULTS/$machine/$ver/$benchmark.$class/vmstat.txt & bin/$benchmark.$class.x > ../RESULTS/$machine/$ver/$benchmark.$class/output.txt
			else
				make $benchmark CLASS=$class NPROCS=2 VERSION=VEC
				mkdir -p ../RESULTS/$machine/$ver/$benchmark.$class.2
				(sleep 1 && vmstat -s) > ../RESULTS/$machine/$ver/$benchmark.$class.2/vmstat.txt & mpirun -np 2 -mca btl self,sm,tcp bin/$benchmark.$class.2 > ../RESULTS/$machine/$ver/$benchmark.$class.2/output.txt
			fi 

		done
	done

	cd ..
done

now=$(date +"%T")
echo "Ending time: $now"
