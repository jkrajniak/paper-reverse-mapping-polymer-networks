#! /bin/sh
#
# copy_energy_files.sh
# Copyright (C) 2017 Jakub Krajniak <jkrajniak@gmail.com>
#
# Distributed under terms of the GNU GPLv3 license.
#

# /home/teodor/sshfs/vic-staging/rim135/backmapping/small/0_100/backmapping_ua/gmx_1/0.00001/nvt/energy.xvg
#DIR=dacron/chemical_reactions/new_ff/with_water/p0_gamma_50/backmapping/

source ../file_settings

find ${DIR} -iregex ".*gmx_s[0-9]+/.*/nvt/rdf.*\.xvg" | while read a; do
    case=`echo $a | cut -f12 -d'/' | cut -f2 -d_`
    alpha=`echo $a | cut -f13 -d'/'`
    fname=`echo $a | cut -f16 -d'/' | cut -f2-4 -d_`
    #echo rdf_${case}_${alpha}_${fname} `basename $a`
    cp -v $a rdf_${case}_${alpha}_${fname}
done
