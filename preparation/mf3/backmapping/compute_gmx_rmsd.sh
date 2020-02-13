p=`pwd`
for gmx in gmx_*; do
    echo $gmx
    cd $gmx
    for alpha in *; do
        if [ -d "$alpha" ] && [ -f "$alpha/nvt/confout.gro" ]; then
            echo $alpha
            l=`pwd`
            cd $alpha/nvt
            echo 2 2 | gmx_mpi rms -s ../../../single_gmx.tpr -f traj_comp.xtc
            cd $l
        fi
    done
    cd $p
done
