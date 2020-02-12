#! /bin/sh
#
# get_box.sh
# Copyright (C) 2016 Jakub Krajniak <jkrajniak@gmail.com>
#
# Distributed under terms of the GNU GPLv3 license.
#


OUT="box_z.csv"
echo > $OUT
for p in pull_*; do
    s="`echo $p | sed -e 's/pull_//g'`"
    Lz="`tail -n1 $p/confout.gro | sed -e 's/.* \([0-9\.]*$\)/\1/g'`"
    echo "$s $Lz" >>  $OUT
done
