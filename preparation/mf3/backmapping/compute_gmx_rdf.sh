
p=`pwd`
for gmx in gmx_s*; do
    echo $gmx
    cd $gmx
    for alpha in *; do
        if [ -d "$alpha" ] && [ -f "$alpha/nvt/confout.gro" ]; then
            echo $alpha
            l=`pwd`
            cd $alpha/nvt
            mkdir -p rdf
            cd rdf
            [ ! -f "rdf_C_O.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b 5000 -o rdf_C_O.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "O*"'
            [ ! -f "rdf_C_N.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b 5000 -o rdf_C_N.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "N*"'
            [ ! -f "rdf_C_N_excl.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 2 -b 5000 -o rdf_C_N_excl.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "N*"' -excl -dt 100
            [ ! -f "rdf_C_H.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b 5000 -o rdf_C_H.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "H*"'
            [ ! -f "rdf_O_H.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b 5000 -o rdf_O_H.xvg -s ../topol.tpr -ref 'name "O*"' -sel 'name "H*"'
            [ ! -f "rdf_O_N.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b 5000 -o rdf_O_N.xvg -s ../topol.tpr -ref 'name "O*"' -sel 'name "N*"'
            [ ! -f "rdf_O_N_excl.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 2 -b 5000 -o rdf_O_N_excl.xvg -s ../topol.tpr -ref 'name "O*"' -sel 'name "N*"' -excl -dt 100
            [ ! -f "rdf_N_H.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b 5000 -o rdf_N_H.xvg -s ../topol.tpr -ref 'name "N*"' -sel 'name "H*"'
            [ ! -f "rdf_N1_O.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b 5000 -o rdf_N1_O.xvg -s ../topol.tpr -ref 'name "N1*"' -sel 'name "O*"'
            [ ! -f "rdf_N2_O.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b 5000 -o rdf_N2_O.xvg -s ../topol.tpr -ref 'name "N2*"' -sel 'name "O*"'
            #gmx_mpi rdf -f ../traj_comp.xtc -rmax 2 -b 5000 -o rdf_ring_ring.xvg -s ../topol.tpr -ref 'name "[CN]1[1-3]"' -sel 'name "[CN]1[1-3]"' -selrpos dyn_res_com -seltype dyn_res_com
            [ ! -f "rdf_ring_ring.xvg" ] &&  gmx_mpi rdf -f ../traj_comp.xtc -rmax 2 -b 5000 -o rdf_ring_ring.xvg -s ../topol.tpr -ref 'name "[CN]1[1-3]"' -sel 'name "[CN]1[1-3]"' -selrpos dyn_res_com -seltype dyn_res_com
            cd $l
        fi
    done
    cd $p
done
