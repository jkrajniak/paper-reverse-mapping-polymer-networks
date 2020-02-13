import h5py
import sys
import numpy as np
import networkx as nx

h5filename = sys.argv[1]
h5 = h5py.File(h5filename, 'r')
print('Opened {}'.format(h5filename))

file_name = h5filename.replace('.h5', '')

cl = h5['/connectivity/chem_bonds_0/value']
cl_t = h5['/connectivity/chem_bonds_0/step']
st_cl = filter(lambda x: -1 not in x, h5['/connectivity/bonds_0'])
st = filter(lambda x: x != -1, h5['/particles/atoms/state/value'][-1])
sp = filter(lambda x: x != -1, h5['/particles/atoms/species/value'][-1])

t_cr = []
t_idx = 0
for t_cl in cl:
    s_cl = np.asarray(t_cl)
    t_cr.append([cl_t[t_idx], len(s_cl[s_cl != -1])/2.0])
    print t_idx, cl_t[t_idx]
    t_idx += 1

cr_file = 'cr_{}_{}.csv'.format(file_name, 'sim')
np.savetxt(cr_file, t_cr, header='t cr')
print('Saved {}'.format(cr_file))
