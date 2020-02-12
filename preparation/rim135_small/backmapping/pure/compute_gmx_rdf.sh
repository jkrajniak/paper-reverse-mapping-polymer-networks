
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
            [ ! -f "rdf_C_O.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b 2500 -o rdf_C_O.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "O*"'
            [ ! -f "rdf_C_N.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b 2500 -o rdf_C_N.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "N*"'
            [ ! -f "rdf_C_N_excl.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b 2500 -o rdf_C_N_excl.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "N*"' -excl -dt 100
            [ ! -f "rdf_C_H.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b 2500 -o rdf_C_H.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "H*"'
            [ ! -f "rdf_O_H.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b 2500 -o rdf_O_H.xvg -s ../topol.tpr -ref 'name "O*"' -sel 'name "H*"'
            [ ! -f "rdf_O_C.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b 2500 -o rdf_O_C.xvg -s ../topol.tpr -ref 'name "O*"' -sel 'name "C*"'
            [ ! -f "rdf_O_N.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b 2500 -o rdf_O_N.xvg -s ../topol.tpr -ref 'name "O*"' -sel 'name "N*"'
            [ ! -f "rdf_N_H.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -b 2500 -o rdf_N_H.xvg -s ../topol.tpr -ref 'name "N*"' -sel 'name "H*"'
            cd $l
        fi
    done
    cd $p
done
