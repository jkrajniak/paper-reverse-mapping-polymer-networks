nvt=nvt

p=`pwd`
for gmx in gmx_s*; do
    echo $gmx
    cd $gmx
    for alpha in *; do
        if [ -d "$alpha" ] && [ -f "$alpha/${nvt}/confout.gro" ]; then
            echo $alpha
            l=`pwd`
            cd $alpha/${nvt}
            if [ ! -f hbond_${alpha}.xvg ]; then
                echo "4 5\n" | gmx_mpi hbond -f traj_comp.xtc -num hbond_${alpha}.xvg -b 2500 -e 5000 -n ../index.ndx -dt 10
            fi
            cd $l
        fi
    done
    cd $p
done
