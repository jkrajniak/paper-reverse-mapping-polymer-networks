#!/bin/bash

CASE=$1
OUT=gmx_${CASE}

for d in $OUT/*; do
    if [ -d "$d" ]; then
        cp -v template_eq/* $d;
        alpha=`basename $d`
        #echo $alpha 
        alpha=`awk "BEGIN { print $alpha }"`
        echo $alpha
        #cp -v data_${CASE}/sim0confout_final_aa_${alpha}_* $d/conf.gro
    fi
done
