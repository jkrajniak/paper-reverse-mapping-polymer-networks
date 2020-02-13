import argparse
import h5py
import sys
import numpy as np
import os
import networkx as nx
from multiprocessing import Pool
import functools


def get_avg_loop(g, g_sub=None):
    if g_sub is None:
        g_sub = nx.connected_component_subgraphs(g)

    loop_size = []
    for sub_g in g_sub:
        deg_sub = sub_g.degree().values()
        if deg_sub.count(2) == len(deg_sub):
            loop_size.append(sub_g.number_of_nodes())
    return loop_size

def compute_frame(h5filename, frame):
    pid2res_id = {p: p for p in range(1, 1001)}
    pid2res_id.update({pid: 1001+(pid-1001)//3 for pid in range(1001, 4001)})
    with h5py.File(h5filename, 'r', driver='stdio') as h5:
        cl_t = h5['/connectivity/chem_bonds_0/step'][frame]
        cl = np.asarray(h5['/connectivity/chem_bonds_0/value'][frame])
        cl = cl[cl != -1]
        cl = cl.reshape(cl.shape[0]/2, 2)
        if len(cl) == 0:
            return []
        st_cl = np.asarray(h5['/connectivity/bonds_0'])
        st_cl = st_cl[st_cl != -1]
        st_cl = st_cl.reshape(st_cl.shape[0]/2, 2)
        static_b = {tuple(sorted(map(pid2res_id.get, b))) for b in st_cl}
        static_b = filter(lambda b: b[0] != b[1], static_b)
        g = nx.Graph()
        g.add_edges_from(static_b)
        g.add_edges_from({tuple(sorted(map(pid2res_id.get, b))) for b in cl})
        return get_avg_loop(g)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('h5')
    parser.add_argument('--nt', '-nt', default=8, type=int)
    parser.add_argument('-b', default=0, type=int)
    parser.add_argument('-e', default=None, type=int)
    parser.add_argument('--out', default=None)
    parser.add_argument('--prefix', default=None)
    args = parser.parse_args()

    h5filename = args.h5

    if h5filename == 'scan':
        h5files = [x for x in os.listdir('.') if x.endswith('h5')]
    else:
        h5files = [h5filename]

    # Filter filenames
    if args.prefix:
        prefixes = args.prefix.split(',')
        h5files = [f for f in h5files[:] if any([p in f for p in prefixes])]

    loop_sizes = []
    for h5filename in h5files:
        h5 = h5py.File(h5filename, 'r')
        print('Opened {}'.format(h5filename))

        file_name = h5filename.replace('.h5', '')

        with h5py.File(h5filename, 'r') as h5:
            cl = h5['/connectivity/chem_bonds_0/value']
            frames = xrange(cl.shape[0]-1 if args.b == -1 else args.b, cl.shape[0] if args.e is None else args.e)
            print cl.shape[0]
        compute_frame_ = functools.partial(compute_frame, h5filename)

        p = Pool(args.nt)
        loops = p.map(compute_frame_, frames)
        loop_sizes.extend(loops)

    if args.out is None:
        cr_file = 'loops_hist_{}_{}.pck'.format(file_name, 'sim')
    else:
        cr_file = args.out

    with open(cr_file, 'wb') as ob:
        import cPickle
        cPickle.dump(loop_sizes, ob)

    print('Saved {}'.format(cr_file))

if __name__ == '__main__':
    main()
