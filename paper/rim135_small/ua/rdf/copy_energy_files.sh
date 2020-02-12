#! /bin/sh
#
# copy_energy_files.sh
# Copyright (C) 2017 Jakub Krajniak <jkrajniak@gmail.com>
#
# Distributed under terms of the GNU GPLv3 license.
#

# /home/teodor/sshfs/vic-staging/rim135/backmapping/small/0_100/backmapping_ua/gmx_1/0.00001/nvt/energy.xvg

find ~/sshfs/vic-staging/rim135/backmapping/small/0_100/backmapping_ua -iregex ".*gmx_[0-9]+/.*/nvt/rdf.*\.xvg" | while read a; do
    case=`echo $a | cut -f11 -d'/' | cut -f2 -d_`
    alpha=`echo $a | cut -f12 -d'/'`
    fname=`echo $a | cut -f15 -d'/' | cut -f2-4 -d_`
    #echo rdf_${case}_${alpha}_${fname} `basename $a`
    cp -v $a rdf_${case}_${alpha}_${fname}
done

find ~/sshfs/vic-staging/rim135/backmapping/small/0_100/backmapping_ua -iregex ".*gmx_[0-9]+/.*/nvt/ring-ring.dist.new" | while read a; do
    case=`echo $a | cut -f11 -d'/' | cut -f2 -d_`
    alpha=`echo $a | cut -f12 -d'/'`
    fname=`echo $a | cut -f14 -d'/' | cut -f1 -d.`
    #echo rdf_${case}_${alpha}_${fname} `basename $a`
    cp -v $a rdf_${case}_${alpha}_${fname}.xvg
done
