#!/bin/bash

CASE=$1
OUT=gmx_${CASE}
DATA=$2

for d in $OUT/*; do
    echo $d
    if [ -f "$d/nvt/confout.gro" ]; then
        mkdir $d/nvt/tg
        cp -v template_tg/global_tg.sh $OUT
        cp -v template_tg/* $d/nvt/tg
        cp -v $d/nvt/confout.gro $d/nvt/tg/conf.gro
    fi
done
