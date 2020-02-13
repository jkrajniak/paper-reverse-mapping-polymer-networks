from md_libs import files_io
import sys
import networkx as nx


cg_top = files_io.GROMACSTopologyFile(sys.argv[1])
at_top = files_io.GROMACSTopologyFile(sys.argv[2])
cg_top.read()
at_top.read()

g = nx.Graph()
for b1, b2 in cg_top.bonds:
    g.add_edge(b1, b2)

cg_degrees = g.degree()

new_res_names = {}
for at_id in cg_top.atoms:
    at_data = cg_top.atoms[at_id]
    if at_id in cg_degrees:
        if at_data.chain_name == 'DIO':
            if cg_degrees[at_id] == 1:
                new_res_names[at_data.chain_idx] = 'EI1'
            elif cg_degrees[at_id] == 2:
                new_res_names[at_data.chain_idx] = 'EI2'

ter_atoms = range(1001, 4000, 3)
for t in ter_atoms:
    ts = t, t+1, t+2
    ts_names = tuple(map(lambda x: x.name, map(cg_top.atoms.get, ts)))
    seq2name = {
        ('Q1', 'B1', 'Q2'): 'TE2',
        ('A1', 'B1', 'A2'): 'TER',
        ('A1', 'B1', 'Q2'): 'TE1A',
        ('Q1', 'B1', 'A2'): 'TE2A'
    }
    new_res_names[cg_top.atoms[ts[0]].chain_idx] = seq2name[ts_names]


for at_id in at_top.atoms:
    at_data = at_top.atoms[at_id]
    if at_data.chain_idx in new_res_names:
        at_data.chain_name = new_res_names[at_data.chain_idx]

at_top.write('new_{}'.format(sys.argv[2]))

# Write also new cg topology
for at_id in cg_top.atoms:
    at_data = cg_top.atoms[at_id]
    if at_data.chain_idx in new_res_names:
        at_data.chain_name = new_res_names[at_data.chain_idx]
cg_top.write('new_{}'.format(sys.argv[1]))
