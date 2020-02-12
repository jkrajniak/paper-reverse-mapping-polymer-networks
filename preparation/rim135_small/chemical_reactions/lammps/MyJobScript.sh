#!/bin/bash -l
#PBS -N 50_50 
#PBS -l walltime=24:00:00
#PBS -o Output.job
#PBS -j oe
#PBS -l nodes=1:ppn=20

module load intel
module load lammps/pierre
cd $PBS_O_WORKDIR

n_proc=$(cat $PBS_NODEFILE | wc -l)
n_node=$(cat $PBS_NODEFILE | uniq | wc -l)

mpdboot -f $PBS_NODEFILE -n $n_node -r ssh -v

mpirun -np 20 lmp_mpi < in.sim > log.out 
