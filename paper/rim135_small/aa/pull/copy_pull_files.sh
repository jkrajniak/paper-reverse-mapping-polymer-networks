#! /bin/sh
#
# copy_energy_files.sh
# Copyright (C) 2017 Jakub Krajniak <jkrajniak@gmail.com>
#
# Distributed under terms of the GNU GPLv3 license.
#

# /home/teodor/sshfs/vic-staging/rim135/backmapping/small/0_100/backmapping_ua/gmx_1/0.00001/nvt/energy.xvg

find ~/sshfs/vic-staging/rim135/backmapping/small/0_100/backmapping_aa -iregex ".*gmx_s[0-9]+/.*/nvt/pull/pull_[xyz]/pull_[xyz]\.xvg" > l

cat l | while read a; do
    echo $a
    case=`echo $a | cut -f11 -d'/' | cut -f2 -d_`
    alpha=`echo $a | cut -f12 -d'/'`
    dir=`basename $a | cut -f2 -d_ | cut -f1 -d.`
    #echo $case $alpha $dir
    ls -ll $a
    cp -v $a pull_${dir}_${alpha}_${case}.xvg
done
