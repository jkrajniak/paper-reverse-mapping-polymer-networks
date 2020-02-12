#!/bin/bash -euf

CASE=$1
OUT=gmx_${CASE}

for d in $OUT/*; do
    l=`pwd`
    if [ -d "$d/nvt" ]; then
        mkdir $d/nvt/pull_step
        cp -v template_pull_step/global_pull_step.sh $OUT
        for dir in x y z; do
            dst_dir=$d/nvt/pull_step/pull_${dir}
            mkdir $dst_dir
            cp -v template_pull_step/* $dst_dir
            cd $dst_dir
            sed -i "s/DIRECTION=.*/DIRECTION=${dir}/g" tensil_settings
            cp -v ../../confout.gro conf.gro
            cd $l
        done
    fi
    cd $l
done
