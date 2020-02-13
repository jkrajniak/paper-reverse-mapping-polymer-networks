#!/usr/bin/env python
import sys
import numpy as np
import h5py
import argparse
import functools

from multiprocessing import Pool


def get_states(filename, types, max_st, frame):
    h5 = h5py.File(filename, 'r', libver='latest', driver='stdio')

    sp = h5['/particles/atoms/species/value']
    st_t = h5['/particles/atoms/state/time']
    st = h5['/particles/atoms/state/value']

    sp_frame = sp[frame]

    res = []
    for t in types:
        t_st = np.zeros(max_st+1)
        type_mask = np.where(sp_frame == t)
        st_count = np.bincount(st[frame][type_mask], minlength=max_st)
        t_st[0] = st_t[frame]
        t_st[1:st_count.shape[0]+1] = st_count
        res.append(t_st)
    return res


def main():
    args = argparse.ArgumentParser()
    args.add_argument('h5')
    args.add_argument('types')
    args.add_argument('--nt', default=8, type=int)
    args.add_argument('--begin', '-b', default=0, type=int)
    args.add_argument('--end', '-e', default=None, type=int)
    args.add_argument('--max_st', default=None, type=int)

    args = args.parse_args()

    types = np.array(map(int, args.types.split(',')))

    h5filename = args.h5
    h5 = h5py.File(h5filename, 'r')

    print('Open {}'.format(h5filename))

    filename = h5filename.replace('.h5', '')

    st = h5['/particles/atoms/state/value']
    if args.max_st is None:
        max_st = np.max(st) + 1
    else:
        max_st = args.max_st + 1

    p = Pool(args.nt)
    frames = range(args.begin, st.shape[0] if args.end is None else args.end)
    map_func = functools.partial(get_states, args.h5, types, max_st)
    results_obj = p.imap(map_func, frames, 256)# len(frames)/args.nt)
    #results_obj = map(map_func, frames)

    p.close()

    results = {t: [] for t in types}

    num_frames = float(len(frames))
    print('Num frames: {}'.format(num_frames))
    for i, data in enumerate(results_obj, 1):
        sys.stdout.write('\rdone {}'.format(i/num_frames))
        sys.stdout.flush()
        for ti, t in enumerate(types):
            results[t].append(data[ti])

    p.join()

    for ti, data in results.items():
        ot_file = 'states_t{}_{}_{}.csv'.format(ti, filename, 'sim')
        np.savetxt(ot_file, data, header='t {}'.format(' '.join(map('s{}'.format, range(max_st)))))
        print('\nSaved {}'.format(ot_file))


if __name__ == '__main__':
    main()
