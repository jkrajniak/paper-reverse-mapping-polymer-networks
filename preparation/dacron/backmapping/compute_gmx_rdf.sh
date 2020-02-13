nvt=nvt
bstart="2500 -dt 100 -e 5000"
p=`pwd`
for gmx in gmx_s*; do
    echo $gmx
    cd $gmx
    for alpha in *; do
        if [ -d "$alpha" ] && [ -f "$alpha/${nvt}/confout.gro" ]; then
            echo $alpha
            l=`pwd`
            cd $alpha/${nvt}
            mkdir -p rdf
            cd rdf
            [ ! -f "rdf_C_O.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b ${bstart} -o rdf_C_O.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "O*"'
            [ ! -f "rdf_C_O_excl.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 2 -b ${bstart} -o rdf_C_O_excl.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "O*"' -excl
            #gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b ${bstart} -o rdf_C_N.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "N*"'
            #gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b ${bstart} -o rdf_C_H.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "H*"'
            #gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b ${bstart} -o rdf_O_H.xvg -s ../topol.tpr -ref 'name "O*"' -sel 'name "H*"'
            [ ! -f "rdf_ring_ring.xvg" ] && gmx_mpi rdf -rmax 2 -b ${bstart} -f ../traj_comp.xtc -sel 'resname TER && name "C[2-7]"' -ref 'resname TER && name "C[2-7]"' -selrpos res_com -seltype res_com -s ../topol.tpr -o rdf_ring_ring.xvg
            cd $l
        fi
    done
    cd $p
done
