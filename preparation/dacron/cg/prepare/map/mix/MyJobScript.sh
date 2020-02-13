#!/bin/bash -l
#PBS -N MIX  
#PBS -l mem=8gb
#PBS -l walltime=24:00:00
#PBS -o Output.job
#PBS -j oe
#PBS -l nodes=1:ppn=20
#PBS -A lp_polymer_goa_project

module purge
module load GROMACS/5.0.5-intel-2015a-hybrid

cd $PBS_O_WORKDIR

n_proc=$(cat $PBS_NODEFILE | wc -l)
n_node=$(cat $PBS_NODEFILE | uniq | wc -l)
mpdboot -f $PBS_NODEFILE -n $n_node -r ssh -v

gmx_mpi grompp -v

mpiexec -n $n_proc gmx_mpi mdrun -v
#gmx_mpi mdrun -v -ntomp $n_proc

mpdallexit
