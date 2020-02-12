#! /bin/sh
#
# copy_energy_files.sh
# Copyright (C) 2017 Jakub Krajniak <jkrajniak@gmail.com>
#
# Distributed under terms of the GNU GPLv3 license.
#

# /home/teodor/sshfs/vic-staging/rim135/backmapping/small/0_100/backmapping_ua/gmx_1/0.00001/nvt/energy.xvg

find ~/sshfs/vic-staging/rim135/backmapping/small/0_100/backmapping_aa -iregex ".*gmx_s[0-9]+/.*/nvt/hbond.*\.xvg" | while read a; do
    case=`echo $a | cut -f11 -d'/' | cut -f2 -d_`
    alpha=`echo $a | cut -f12 -d'/'`
    fname=`echo $a | cut -f15 -d'/' | cut -f2 -d_ | tr -d _`
    #echo rdf_${case}_${alpha}_${fname}
    #echo ${fname}
    cp -v $a hbond_${case}_${alpha}.xvg
done
