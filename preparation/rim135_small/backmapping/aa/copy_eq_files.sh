#!/bin/bash

CASE=$1
OUT=gmx_${CASE}
FILE=$2

for d in $OUT/*; do
    if [ -d "$d" ]; then
        if [ "X${FILE}" = "X" ]; then
            cp -v template_eq/* $d;
        else
            cp -v template_eq/${FILE} $d;
        fi
        alpha=`basename $d`
        #echo $alpha 
        alpha=`awk "BEGIN { print $alpha }"`
        echo $alpha
        #cp -v data_${CASE}/sim0confout_final_aa_${alpha}_* $d/conf.gro
    fi
done
