p=`pwd`
for gmx in gmx_s*; do
    echo $gmx
    cd $gmx
    for alpha in *; do
        if [ -d "$alpha" ] && [ -f "$alpha/nvt/confout.gro" ]; then
            echo $alpha
            l=`pwd`
            cd $alpha/nvt
            echo "1 2 3 4 5 6 7 8 9 10 0" | gmx_mpi energy -e 5000
            cd $l
        fi
    done
    cd $p
done
