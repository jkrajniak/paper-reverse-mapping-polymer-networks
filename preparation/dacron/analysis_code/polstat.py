import h5py
import numpy as np


def get_cr(h5filename):
    h5 = h5py.File(h5filename, 'r')
    print('Opened {}'.format(h5filename))

    file_name = h5filename.replace('.h5', '')
    cl = h5['/connectivity/chem_bonds_0/value']
    cl_t = h5['/connectivity/chem_bonds_0/step']

    t_cr = np.zeros((cl.shape[0], 2))
    t_idx = 0
    for t_cl in cl:
        s_cl = filter(lambda x: -1 not in x, t_cl)
        t_cr[t_idx][0] = cl_t[t_idx]
        t_cr[t_idx][1] = len(s_cl)
        print(t_idx)
        t_idx += 1

    cr_file = 'cr_{}_{}.csv'.format(file_name, 'sim')
    np.savetxt(cr_file, t_cr, header='t cr')
    print('Saved {}'.format(cr_file))
