#!/bin/bash -le
#PBS -N MELF_NPT_468
#PBS -l walltime=48:00:00
#PBS -o Output.job
#PBS -j oe
#PBS -l nodes=1:ppn=20
#PBS -M jakub.krajniak@cs.kuleuven.be
#PBS -A  lp_sim_interpoco

source switch_to_2015a

module purge
module load 2015a/GROMACS/2016.3

MDRUN="mdrun_mpi -cpi state.cpt -v"
GROMPP="grompp_mpi"

cd $PBS_O_WORKDIR

# Set up OpenMPI environment
n_proc=$(cat $PBS_NODEFILE | wc -l)
n_node=$(cat $PBS_NODEFILE | uniq | wc -l)
#mpdboot -f $PBS_NODEFILE -n $n_node -r ssh -v

./stress_strain_step.sh tensil_settings
