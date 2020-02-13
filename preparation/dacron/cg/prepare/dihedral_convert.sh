# Based on https://groups.google.com/d/msg/votca/OSaBKQTR7C0/_dtF93DJZP0J

BOND_FILE="$1"
SETTINGS="convert_dihedral.xml"

# cut bad sampled regions at the boundaries
sed -e '1,5d' -e 's/$/ i/' $BOND_FILE | tac | sed -e '1,4d' | tac > "$BOND_FILE.cut"

csg_call table smooth "$BOND_FILE.cut" "$BOND_FILE.smooth"
csg_resample --in "$BOND_FILE.smooth" --out "$BOND_FILE.refined" --grid -3.135::0.001:3.135
csg_call table extrapolate --function quadratic "$BOND_FILE.refined" "$BOND_FILE.cur"
csg_call --ia-type dihedral --ia-name dihedral --options $SETTINGS convert_potential gromacs "$BOND_FILE.cur" table_d${2}.xvg
