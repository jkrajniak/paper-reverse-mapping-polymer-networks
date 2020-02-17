#! /usr/bin/env python
#
# Copyright (c) 2016 Jakub Krajniak <jkrajniak@gmail.com>
#
# Distributed under terms of the GNU GPLv3 license.
#


import argparse
from md_libs import files_io

parser = argparse.ArgumentParser('Convert CG topology for AB2 system')
parser.add_argument('in_top', help='Input topology')
parser.add_argument('out_top', help='Output topology')

res_type2name = {
    ('MA', 'ML', 'MB', 'MB'): 'N1T',    # [0,2,1,1]
    ('PA', 'PL', 'PB', 'RB'): 'N1L1',  # [3,5,4,7] or [3,5,7,4]
    ('PA', 'PL', 'RB', 'PB'): 'N1L2',
    ('PA', 'PL', 'RB', 'RB'): 'N1D',  # [3,5,7,7]
    ('RA', 'PL', 'PB', 'PB'): 'N2T',  # [6,5,4,4]
    ('RA', 'PL', 'RB', 'PB'): 'N2L1',  # [6,5,4,7] or [6,5,7,4]
    ('RA', 'PL', 'PB', 'RB'): 'N2L2',  # [6,5,4,7] or [6,5,7,4]
    ('RA', 'PL', 'RB', 'RB'): 'N2D'  # [6,5,7,7]
}

window_size = [len(x) for x in res_type2name]
if len(window_size) != window_size.count(window_size[0]):
    raise RuntimeError('Wrong res_type2name, window size has to be the same')
print('Window size: {}'.format(window_size))
window_size = window_size[0]

args = parser.parse_args()

in_top = files_io.GROMACSTopologyFile(args.in_top)
in_top.read()

at_ids = sorted(in_top.atoms.keys())

for i in range(0, len(at_ids), window_size):
    chunk_at_ids = at_ids[i:i+window_size]
    chunk_types = tuple(in_top.atoms[x].atom_type for x in chunk_at_ids)
    new_res_name = res_type2name[chunk_types]
    print((chunk_types, new_res_name))
    for at_id in chunk_at_ids:
        in_top.atoms[at_id].chain_name = new_res_name

in_top.write(args.out_top)
