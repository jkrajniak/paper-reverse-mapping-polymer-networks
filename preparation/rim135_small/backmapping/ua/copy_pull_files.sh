#!/bin/bash -euf

CASE=$1
OUT=gmx_${CASE}

for d in $OUT/*; do
    l=`pwd`
    if [ -d "$d/nvt" ] && [ -f "${d}/nvt/confout.gro" ]; then
        mkdir -p $d/nvt/pull
        cp -v template_pull/global_pull.sh $OUT
        for dir in x y z; do
            dst_dir=$d/nvt/pull/pull_${dir}
            if [ ! -f "${dst_dir}/confout.gro" ]; then
                mkdir -p $dst_dir
                cp -v template_pull/* $dst_dir
                alpha=`basename $d`
                #echo $alpha 
                alpha=`awk "BEGIN { print $alpha }"`
                echo $alpha
                cd $dst_dir
                cp -v ../../confout.gro conf.gro
                bash make_deform.sh 0.1 grompp_deform.tpl ${dir}
                cd $l
            fi
        done
    fi
    cd $l
done
