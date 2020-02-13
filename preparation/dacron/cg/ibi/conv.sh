#!/bin/bash

if [ "X$1" != "X" ]; then
	DIR="$1"
else
	DIR="$PWD"
fi

n=1

echo > conv.dat

for i in $DIR/step_*; do
  if [ -f "$i/A-A.conv" ]; then
     #n="`echo $i | cut -f4- -d'_'`"
     val="`cat $i/A-A.conv`"
     echo "$n $val" | tee --append conv.dat
     n=$(($n+1))
  fi
done #| tee 'conv.dat' - | python -c "import sys;print 'min_idx:',min([map(float, x.split()) for x in sys.stdin.readlines()], key=lambda x: x[1])[0]"
