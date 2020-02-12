p=`pwd`
for gmx in gmx_*; do
    echo $gmx
    cd $gmx
    for alpha in *; do
        if [ -d "$alpha" ] && [ -f "$alpha/nvt/confout.gro" ]; then
            echo $alpha
            l=`pwd`
            cd $alpha/nvt
            gmx_mpi distance -n ${p}/bonds_cr.ndx -f traj_comp.xtc -len 0.15132 -oh hist_${alpha}_cr_bond.xvg -select 0 -b 3000
            cd $l
        fi
    done
    cd $p
done
