#!/bin/bash -l
#PBS -l walltime=24:00:00
#PBS -o Output.job
#PBS -j oe
#PBS -l nodes=1:ppn=20
#PBS -M jakub.krajniak@cs.kuleuven.be
#PBS -A lp_sim_interpoco

module purge

source switch_to_2015a

cd $PBS_O_WORKDIR

module load 2015a/espressopp/adress
module load bakery-github-dev

# Set up OpenMPI environment
n_proc=$(cat $PBS_NODEFILE | wc -l)
n_node=$(cat $PBS_NODEFILE | uniq | wc -l)

for alpha in 0.001; do
    for s in {13..15}; do
        rng="`shuf -i12345-99999 -n1`"
        mkdir -p data_s${s}
        mkdir -p gmx_s${s}/${alpha}
        mpirun -n 18 start_backmapping.py @params9_fix2 --rng_seed ${rng}  --alpha $alpha --output_prefix data_s${s}/sim0 &> log_s${s}_${alpha}.log
        alpha1=`awk "BEGIN { print $alpha }"`
        cp -v data_s${s}/sim0confout_final_aa_${alpha1}_* gmx_s${s}/${alpha}/conf.gro
        bash copy_eq_files.sh s${s}
    done
done
