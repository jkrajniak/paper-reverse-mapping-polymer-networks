
p=`pwd`
for gmx in gmx_*; do
    echo $gmx
    cd $gmx
    for alpha in *; do
        if [ -d "$alpha" ] && [ -f "$alpha/nvt/confout.gro" ]; then
            echo $alpha
            l=`pwd`
            cd $alpha/nvt
            echo "2 4\n" | gmx_mpi hbond -f traj_comp.xtc -num hbond_${alpha}.xvg -b 2500
            cd $l
        fi
    done
    cd $p
done
