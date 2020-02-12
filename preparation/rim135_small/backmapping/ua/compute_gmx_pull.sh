p=`pwd`
for gmx in gmx_[0-9]*; do
    echo $gmx
    cd $gmx
    for alpha in *; do
        if [ -d "$alpha/nvt/pull" ]; then
            #echo $alpha
            l=`pwd`
            cd $alpha/nvt/pull
            for dir in x y z; do
                px=pull_${dir}
                if [ -f "${px}/confout.gro" ]; then
                    echo $alpha $px
                    echo "Box-X Box-Y Box-Z Pres-XX Pres-YY Pres-ZZ" | tr ' ' '\n' | gmx_mpi energy -f ${px}/ener.edr -o ${px}/pull_${dir}.xvg
                fi
            done
            cd $l
        fi
    done
    cd $p
done
