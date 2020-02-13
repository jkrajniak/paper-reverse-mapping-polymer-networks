#!/usr/bin/env python
"""
Copyright (C) 2017 Jakub Krajniak <jkrajniak@gmail.com>

This file is distributed under free software licence:
you can redistribute it and/or modify it under the terms of the
GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

import argparse
import copy
from md_libs import files_io
import sys
import h5py

def _args():
    parser = argparse.ArgumentParser()
    parser.add_argument('top')
    parser.add_argument('conf')
    parser.add_argument('h5')

    return parser.parse_args()

def main():
    args = _args()

    top = args.top
    conf = args.conf
    h5 = args.h5

    top = files_io.GROMACSTopologyFile(top)
    top.read()

    conf = files_io.GROFile(conf)
    conf.read()

    h5 = h5py.File(h5, 'r')

    species2typename = {0: 'D', 1: 'A', 2: 'B', 3: 'C', 4: 'E', 5: 'W', 6: 'Z', 7: 'X'}
    species = h5['/particles/atoms/species/value'][-1]

    chain_names = {
        0: 'DIO',
        4: 'DIO',
        1: 'TER',
        2: 'TER',
        3: 'TER',
        5: 'H2O',
        6: 'H2O',
        7: 'DUM'
    }

    names = {
        'DIO': {('D',): ['D1'],
                ('E',): ['E1'],
            },
        'TER': {('A', 'B', 'A'): ['A1', 'B1', 'A2'],
                ('A', 'B', 'C'): ['A1', 'B1', 'Q2'],
                ('C', 'B', 'A'): ['Q1', 'B1', 'A2'],
                ('C', 'B', 'C'): ['Q1', 'B1', 'Q2']
                },
        'H2O': {('W', ): ['W1'],
                ('Z', ): ['Z1']
                }
    }


# First set correct type
    last_chain_idx = 0
    chain_id = 1
    old2new = {}
    atidx = 1
    new_atoms = {}
    conf_new_atoms = {}
    for at_id, sp in enumerate(species, 1):
        if at_id not in top.atoms:
            continue
        old2new[at_id] = atidx
        at_data = copy.copy(top.atoms[at_id])
        new_atoms[atidx] = at_data
        at_data.atom_type = species2typename[sp]
        at_data.atom_id = atidx
        if top.atoms[at_id].chain_idx != last_chain_idx:
            last_chain_idx = top.atoms[at_id].chain_idx
            at_data.chain_idx = chain_id
            chain_id += 1
        at_data.chain_name = chain_names[sp]
        conf_new_atoms[atidx] = conf.atoms[at_id]._replace(
            chain_name=chain_names[sp], chain_idx=chain_id, atom_id=atidx)
        atidx += 1

    atom_list = [new_atoms[x] for x in sorted(new_atoms)]

# Set names
    at_id = 0
    total_num = len(atom_list)
    while at_id < total_num:
        at_data = atom_list[at_id]
        name_seq = names[at_data.chain_name]
        window_size = len(name_seq.keys()[0])
        at_type_seq = tuple(x.atom_type for x in atom_list[at_id:at_id+window_size])
        for i, x in enumerate(atom_list[at_id:at_id+window_size]):
            x.name = name_seq[at_type_seq][i]
            new_atoms[x.atom_id].atom_name = x.name
            conf_new_atoms[x.atom_id] = conf_new_atoms[x.atom_id]._replace(name=x.name)
        at_id += window_size

    top.atoms = new_atoms
    conf.atoms = conf_new_atoms

    top.write('new_{}'.format(sys.argv[1]), force=True)
    conf.write('new_{}'.format(sys.argv[2]), force=True)

if __name__ == '__main__':
    main()
