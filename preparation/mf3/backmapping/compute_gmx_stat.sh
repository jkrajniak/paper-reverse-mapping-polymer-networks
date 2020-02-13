
p=`pwd`
for gmx in gmx_s*; do
    echo $gmx
    cd $gmx
    for alpha in *; do
        if [ -d "$alpha" ] && [ -f "$alpha/nvt/confout.gro" ]; then
            echo $alpha
            l=`pwd`
            cd $alpha/nvt
            [ ! -f ring-ring.dist.new ] && csg_stat --options ../settings.xml --trj traj_comp.xtc --cg ../MF_ONE.xml --top ../topol.xml --normalize True --nt 20
            cd $l
        fi
    done
    cd $p
done
