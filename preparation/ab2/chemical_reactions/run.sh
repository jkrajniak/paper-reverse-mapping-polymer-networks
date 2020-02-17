for((i=0;i<1;i++))
do
    mpirun -np 18 start_simulation.py @params >& log_$i
    mv *before_reaction_confout.gro conf.gro
done
