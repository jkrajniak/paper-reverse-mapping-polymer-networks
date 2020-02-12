#! /bin/sh
#
# copy_energy_files.sh
# Copyright (C) 2017 Jakub Krajniak <jkrajniak@gmail.com>
#
# Distributed under terms of the GNU GPLv3 license.
#

# /home/teodor/sshfs/vic-staging/rim135/backmapping/small/0_100/backmapping_ua/gmx_1/0.00001/nvt/energy.xvg

source ../file_settings

echo $DIR

find $DIR -iregex ".*gmx_s1[0-9]+/.*/nvt/energy.xvg" | while read a; do
    echo $a
    case=`echo $a | cut -f9 -d'/' | cut -f2 -d_`
    alpha=`echo $a | cut -f10 -d'/'`
    #echo $case $alpha
    cp -v $a energy_${alpha}_${case}.xvg
done

cp -v /home/teodor/sshfs/vic-staging/mf/mf3/backmapping/gmx_sfix9/0.001/nvt/energy.xvg energy_0.001_s13.xvg
