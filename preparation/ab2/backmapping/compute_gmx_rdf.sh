bstart="5000 -dt 100"
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
            cd rdf
            [ ! -f "rdf_C_O_excl.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1.2 -b ${bstart} -o rdf_C_O_excl.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "O*"' -excl
            [ ! -f "rdf_C_O.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b ${bstart} -o rdf_C_O.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "O*"'
            [ -f "rdf_O2_C12_C17_excl.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b ${bstart} -o rdf_O2_C12_C17_excl.xvg -s ../topol.tpr -ref 'name "C17" or name "C12"' -sel 'name "O2"' -excl
            [ -f "rdf_O2_C12_C17.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b ${bstart} -o rdf_O2_C12_C17.xvg -s ../topol.tpr -ref 'name "C17" or name "C12"' -sel 'name "O2"'
            #[ ! -f "rdf_C_N.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b ${bstart} -o rdf_C_N.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "N*"'
            #[ -f "rdf_C_H.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b ${bstart} -o rdf_C_H.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "H*"'
            #[ -f "rdf_O_H.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b ${bstart} -o rdf_O_H.xvg -s ../topol.tpr -ref 'name "O*"' -sel 'name "H*"'
            #[ ! -f "rdf_O_N.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b ${bstart} -o rdf_O_N.xvg -s ../topol.tpr -ref 'name "O*"' -sel 'name "N*"'
            #[ ! -f "rdf_N_H.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b ${bstart} -o rdf_N_H.xvg -s ../topol.tpr -ref 'name "N*"' -sel 'name "H*"'
            [ ! -f "rdf_ring_ring.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -s ../topol.tpr -rmax 2 -b ${bstart} -sel 'name C5 C13 C14 C15 C16 C17 C4 C9 C10 C11 C12 C8' -ref 'name C5 C13 C14 C15 C16 C17 C4 C9 C10 C11 C12 C8' -selrpos res_com -seltype res_com -o rdf_ring_ring.xvg
            cd $l
        fi
    done
    cd $p
done
