#!/bin/bash

# Deformation with strain.

echo "./$0 STRAIN Lz TEMPLATE_FILE DIRECTION"

STRAIN=$1
Lz=$2

if [ "X$2" = "X" ]; then
    echo "No Lz"
    exit 1
fi
TEMPLATE_FILE=$3
if [ "X$4" = "X" ]; then
    DIR="z"
else
    DIR="$4"
fi

echo "Direction: $DIR"

# Gets the box in z direction
STEPS=$(cat $TEMPLATE_FILE | grep nsteps | cut -f2 -d'=')
DT=$(cat $TEMPLATE_FILE | grep dt | cut -f2 -d'=')
echo Deformation steps $STEPS dt=$DT
Vz=$(awk "BEGIN {printf \"%.16f\", ${STRAIN}*${Lz}/(${STEPS}*${DT})}")
case $DIR in
    X|x) V_DEFORM="deform = $Vz 0 0 0 0 0"; compress="0.0 4.5e-5 4.5e-5 0.0 0.0 0.0";;
    Y|y) V_DEFORM="deform = 0 $Vz 0 0 0 0"; compress="4.5e-5 0.0 4.5e-5 0.0 0.0 0.0";;
    Z|z) V_DEFORM="deform = 0 0 $Vz 0 0 0"; compress="4.5e-5 4.5e-5 0.0 0.0 0.0 0.0";;
esac

cat $TEMPLATE_FILE | sed -e "s/deform.*/${V_DEFORM}/g;" > grompp_deform.mdp
sed -i "s/^compressibility.*/compressibility = ${compress}  ; dir=$DIR/g" grompp_deform.mdp

echo "Lz: ${Lz}"
echo "Vz: ${Vz}"

exit 0
