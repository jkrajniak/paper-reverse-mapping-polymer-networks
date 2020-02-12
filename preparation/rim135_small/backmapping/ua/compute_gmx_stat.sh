
p=`pwd`
for gmx in gmx_*; do
    echo $gmx
    cd $gmx
    for alpha in *; do
        if [ -d "$alpha" ] && [ -f "$alpha/nvt/confout.gro" ]; then
            echo $alpha
            l=`pwd`
            cd $alpha/nvt
            mkdir -p rdf
            csg_stat --options ../settings.xml --trj traj_comp.xtc --cg '../ring_epo.xml;../ring_ipd.xml' --top ../topol.xml
            cd $l
        fi
    done
    cd $p
done
