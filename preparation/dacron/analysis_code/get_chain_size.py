import argparse
import h5py
import sys
import numpy as np
import networkx as nx
from multiprocessing import Pool
import functools


def compute_frame(h5filename, frame):
    pid2res_id = {p: p for p in range(1, 1001)}
    pid2res_id.update({pid: 1001+(pid-1001)//3 for pid in range(1001, 4001)})
    with h5py.File(h5filename, 'r', driver='stdio') as h5:
        st_cl = np.asarray(h5['/connectivity/bonds_0'])
        st_cl = st_cl[st_cl != -1]
        st_cl = st_cl.reshape(st_cl.shape[0]/2, 2)
        s_cl = np.asarray(h5['/connectivity/chem_bonds_0/value'][frame])
        s_cl = s_cl[s_cl != -1]
        s_cl = s_cl.reshape(s_cl.shape[0]/2, 2)
        static_b = {tuple(sorted(map(pid2res_id.get, b))) for b in st_cl}
        static_b = filter(lambda b: b[0] != b[1], static_b)
        g = nx.Graph()
        g.add_nodes_from(range(1, 2001))
        g.add_edges_from(static_b)
        g.add_edges_from({tuple(sorted(map(pid2res_id.get, b))) for b in s_cl})
        g_sub = list(nx.connected_component_subgraphs(g))
        out = [len(s_cl)]
        if g_sub:
            g_sub_sizes = [x.number_of_nodes() for x in g_sub]
            out.extend(np.bincount(g_sub_sizes))
        print(frame)
        return out


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('h5')
    parser.add_argument('--nt', '-nt', default=8, type=int)
    parser.add_argument('-b', default=0, type=int)
    parser.add_argument('-e', default=None, type=int)
    parser.add_argument('-s', default=1, type=int)
    args = parser.parse_args()

    h5filename = args.h5
    h5 = h5py.File(h5filename, 'r')
    print('Opened {}'.format(h5filename))

    file_name = h5filename.replace('.h5', '')

    with h5py.File(h5filename, 'r') as h5:
        cl = h5['/connectivity/chem_bonds_0/value']
        frames = xrange(args.b, cl.shape[0] if args.e is None else args.e, args.s)
        print cl.shape[0]
    compute_frame_ = functools.partial(compute_frame, h5filename)

    p = Pool(args.nt)
    loop_size_counter = p.map(compute_frame_, frames)
    max_shape = max(map(len, loop_size_counter))
    print max_shape
    out_data = np.zeros((len(loop_size_counter), max_shape))
    for li, ll in enumerate(loop_size_counter):
        out_data[li, :len(ll)] = ll

    cr_file = 'chains_{}_{}.csv'.format(file_name, 'sim')
    np.savetxt(cr_file, out_data, header='cr')
    print('Saved {}'.format(cr_file))

if __name__ == '__main__':
    main()
