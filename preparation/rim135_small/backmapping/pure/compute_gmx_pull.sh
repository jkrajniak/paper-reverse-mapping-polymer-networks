p=`pwd`
for gmx in gmx_*; do
    echo $gmx
    cd $gmx
    for alpha in *; do
        if [ -d "$alpha/nvt/pull" ]; then
            echo $alpha
            l=`pwd`
            cd $alpha/nvt/pull
            for px in pull_*; do
                if [ ! -f "${px}/confout.gro" ]; then
                    continue
                fi
                dir="`echo ${px} | cut -f2 -d_`"
                if [ "$dir" = "step" ]; then
                    continue
                fi
                echo $px
                echo "Box-X Box-Y Box-Z Pres-XX Pres-YY Pres-ZZ" | tr ' ' '\n' | gmx_mpi energy -f ${px}/ener.edr -o ${px}/pull_${dir}.xvg
            done
            cd $l
        fi
    done
    cd $p
done
