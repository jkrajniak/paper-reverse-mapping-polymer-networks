#!/bin/bash -le
#PBS -N em_annling
#PBS -l walltime=24:00:00
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

CURRENTDIR=`pwd`

for alpha in *; do
    if [ -d "$alpha" ] && [ -d "${alpha}/nvt/pull" ] && [ -f "${alpha}/nvt/confout.gro" ]; then
        cd $alpha/nvt/pull
        l=`pwd`
        for p in pull_*; do
            if [ ! -f "${p}/confout.gro" ]; then
                cd $p
                gmx_mpi grompp -f grompp_deform.mdp && gmx_mpi mdrun -ntomp 20
                cd $l
            fi
        done
        cd $CURRENTDIR
    fi
done
