LOG="${PBS_O_WORKDIR}/${PBS_JOBID}.log"

for alpha in 0.00001; do
    for s in {2..2}; do
        mkdir -p jump_s${s}
        #rng_seed=`shuf -n1 -i1000-10000`
        rng_seed=2047
        mpirun -n $1 start_backmapping.py @params --alpha $alpha --rng_seed $rng_seed --output_prefix jump_s${s}/sim0 --energy_collect 100 --energy_collect_bck 100 --gro_collect 100 --trj_collect 100 --long 1000 --skin 0.4 --lj_cutoff 1.2 --cg_cutoff 1.2
        #start_backmapping.py @params --alpha $alpha --rng_seed $rng_seed --output_prefix jump_s${s}/sim0 --energy_collect 100 --energy_collect_bck 100 --gro_collect 100 --trj_collect 100 --long 10000  --save_interactions 1
    done
done
