import h5py
import numpy as np
cimport numpy

cpdef get_types(str h5filename):
    h5 = h5py.File(h5filename, 'r')
    print('Opened {}'.format(h5filename))

    cdef int max_sp, t_idx
    cdef numpy.ndarray t_sp

    cdef str file_name = h5filename.replace('.h5', '')

    sp = h5['/particles/atoms/species/value']
    sp_t = h5['/particles/atoms/species/time']

    t_idx = 0
    max_sp = np.max(sp)+1

    t_sp = np.zeros((sp.shape[0], max_sp+1))
    print((t_sp.shape[0], t_sp.shape[1]))
    print(np.max(sp))

    for t_cl in sp:
        #f_sp = [x for x in t_cl if x != -1]
        sp_count = np.bincount(t_cl+1, minlength=max_sp)[1:]
        t_sp[t_idx][0] = sp_t[t_idx]
        t_sp[t_idx][1:sp_count.shape[0]+1] = sp_count
        #print(t_idx)
        t_idx += 1

    #t_sp = np.array(t_sp)

    cr_file = 'species_{}_{}.csv'.format(file_name, 'sim')
    np.savetxt(cr_file, t_sp, header='t {}'.format(' '.join(map('t{}'.format, range(max_sp)))))
    print('Saved {}'.format(cr_file))
