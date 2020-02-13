#!/bin/bash

CASE=$1
OUT=gmx_${CASE}

for d in $OUT/*; do
    if [ -d "$d" ]; then
        mkdir -p $d/eq2
        cp -v template_eq2/* $d/eq2;
        alpha=`basename $d`
        #echo $alpha 
        alpha=`awk "BEGIN { print $alpha }"`
        echo $alpha
        cp -v data_${CASE}/sim0confout_final_aa_${alpha}_* $d/eq2/conf.gro
    fi
done
