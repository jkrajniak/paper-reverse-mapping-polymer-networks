p=`pwd`
for gmx in gmx_*; do
    echo $gmx
    cd $gmx
    for alpha in *; do
        if [ -d "$alpha" ]; then # && [ -f "$alpha/nvt/confout.gro" ]; then
            echo $alpha
            l=`pwd`
            cd $alpha/nvt
            echo "1 2 3 4 5 6 7 8 9 10 0" | gmx_mpi energy &> /dev/null
            cd $l
        fi
    done
    cd $p
done
