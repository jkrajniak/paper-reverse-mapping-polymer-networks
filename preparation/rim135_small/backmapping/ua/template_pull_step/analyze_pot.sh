#! /bin/sh
#
# analyze.sh
# Copyright (C) 2016 Jakub Krajniak <jkrajniak@gmail.com>
#
# Distributed under terms of the GNU GPLv3 license.
#

OUT="data_pot.csv"
S="`find -type d -regex ".*pull_0\.[0-9]+" | cut -f2 -d'_' | sort | xargs`"
echo $S

KEYWORDS="Bond Angle Ryckaert-Bell. LJ-14 Coulomb-14 LJ-(SR) Coulomb-(SR) Potential Box-Z Pres-ZZ"

echo $KEYWORDS | tr ' ' '\n' | g_energy_mpi -f pull_0.00/ener.edr | tr -s ' ' | cut -f1 -d' ' | egrep "(`echo $KEYWORDS | tr ' ' '|'`)" | xargs > $OUT

for p in $S; do
    echo $p
    cd pull_${p}
    echo $KEYWORDS | tr ' ' '\n' | g_energy_mpi
    cd ..
    g_analyze_mpi -f pull_${p}/energy.xvg > analyze.tmp
    DATA=""
    IDX=1
    for k in $KEYWORDS; do
        SS="`cat analyze.tmp | grep \"^SS${IDX} \" | tr -s ' ' | cut -f2,4 -d' ' | tr -d '\n'`"
        DATA="$DATA ${SS}"
        let "IDX++"
    done
    echo "${DATA}" >> $OUT
done
