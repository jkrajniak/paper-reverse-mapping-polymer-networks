#! /bin/sh
#
# analyze.sh
# Copyright (C) 2016 Jakub Krajniak <jkrajniak@gmail.com>
#
# Distributed under terms of the GNU GPLv3 license.
#

OUT="data.csv"
echo "box-z P-zz" > $OUT
S="`find -type d -regex ".*pull_[0-9]+" | cut -f2 -d'_' | sort | xargs`"
KEYWORDS="Box-Z Pres-ZZ Box-X Box-Y Pres-XX Pres-YY"
GMX_ENERGY="gmx_mpi energy"
GMX_ANALYSE="gmx_mpi analyze"

echo $KEYWORDS | tr ' ' '\n' | $GMX_ENERGY -f pull_000/ener.edr | tr -s ' ' | cut -f1 -d' ' | egrep "(`echo $KEYWORDS | tr ' ' '|'`)" | xargs > $OUT

for p in $S; do
    echo $p
    cd pull_${p}
    echo $KEYWORDS | tr ' ' '\n' | $GMX_ENERGY
    cd ..
    $GMX_ANALYSE -f pull_${p}/energy.xvg > analyze.tmp
    DATA=""
    IDX=1
    for k in $KEYWORDS; do
        SS="`cat analyze.tmp | grep \"^SS${IDX} \" | tr -s ' ' | cut -f2,4 -d' ' | tr -d '\n'`"
        DATA="$DATA ${SS}"
        let "IDX++"
    done
    echo "${DATA}" >> $OUT
done
