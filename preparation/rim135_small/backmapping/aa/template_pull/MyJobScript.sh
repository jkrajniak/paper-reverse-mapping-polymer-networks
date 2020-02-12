#!/bin/bash -le
#PBS -N em_annling
#PBS -l walltime=4:00:00
#PBS -o Output.job
#PBS -j oe
#PBS -l nodes=1:ppn=20
#PBS -M jakub.krajniak@cs.kuleuven.be
#PBS -A  lp_sim_interpoco

source switch_to_2015a

module purge
module load 2015a/GROMACS/2016.3

cd $PBS_O_WORKDIR

# Set up OpenMPI environment
n_proc=$(cat $PBS_NODEFILE | wc -l)
n_node=$(cat $PBS_NODEFILE | uniq | wc -l)
#mpdboot -f $PBS_NODEFILE -n $n_node -r ssh -v

LOG="${PBS_O_WORKDIR}/${PBS_JOBID}.log"

MD="em.mdp npt.mdp nvt.mdp"
FIRST=1
LASTDIR=""

gmx_mpi grompp -f grompp_deform.mdp 
gmx_mpi mdrun -ntomp $n_proc
