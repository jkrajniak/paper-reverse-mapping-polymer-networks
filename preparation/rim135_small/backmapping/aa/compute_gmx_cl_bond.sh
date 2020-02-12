
p=`pwd`
for gmx in gmx_*; do
    echo $gmx
    cd $gmx
    for alpha in *; do
        if [ -d "$alpha" ] && [ -f "$alpha/nvt/confout.gro" ]; then
            echo $alpha
            l=`pwd`
            cd $alpha/nvt
            [ ! -f "cl_hist.xvg" ] && echo "0" | gmx_mpi distance -n ../cl.ndx -f traj_comp.xtc -oh cl_hist
            cd $l
        fi
    done
    cd $p
done
