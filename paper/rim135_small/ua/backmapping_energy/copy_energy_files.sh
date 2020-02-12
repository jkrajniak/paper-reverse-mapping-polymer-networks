#! /bin/sh
#
# copy_energy_files.sh
# Copyright (C) 2017 Jakub Krajniak <jkrajniak@gmail.com>
#
# Distributed under terms of the GNU GPLv3 license.
#

# /home/teodor/sshfs/vic-staging/rim135/backmapping/small/0_100/backmapping_ua/gmx_1/0.00001/nvt/energy.xvg

find ~/sshfs/vic-staging/rim135/backmapping/small/0_100/backmapping_ua -iregex ".*data_s[0-9]+/.*energy.*" | while read a; do
    fname=`basename $a`
    case=`echo $a | cut -f11 -d'/' | cut -f2 -d_ | tr -d 's'`
    if [ "$case" -ge 7 ]; then
        alpha=`echo $fname | cut -f3 -d_`
        cp -v $a energy_${alpha}_${case}.xvg
    fi
done
