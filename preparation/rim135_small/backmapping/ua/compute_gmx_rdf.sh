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
            [ ! -f "rdf_C_O.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -o rdf_C_O.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "O*"' -dt 100
            [ ! -f "rdf_C_O_excl.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -o rdf_C_O_excl.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "O*"' -dt 100 -excl
            [ ! -f "rdf_C_C.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -o rdf_C_C.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "C*"' -dt 100
            [ ! -f "rdf_O_O.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -o rdf_O_O.xvg -s ../topol.tpr -ref 'name "O*"' -sel 'name "O*"' -dt 100
            [ ! -f "rdf_N_N.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -o rdf_N_N.xvg -s ../topol.tpr -ref 'name "N*"' -sel 'name "N*"' -dt 100
            [ ! -f "rdf_C_N.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1 -o rdf_C_N.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "N*"' -dt 100
            [ ! -f "rdf_C_N_excl.xvg" ] && gmx_mpi rdf -f ../traj_comp.xtc -rmax 1.2 -o rdf_C_N_excl.xvg -s ../topol.tpr -ref 'name "C*"' -sel 'name "N*"' -excl -dt 100
            cd $l
        fi
    done
    cd $p
done
