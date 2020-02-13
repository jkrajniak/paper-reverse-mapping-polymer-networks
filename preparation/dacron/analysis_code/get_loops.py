import argparse
import h5py
import sys
import numpy as np
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
    if loop_size:
        return np.average(loop_size), len(loop_size)
    return 0.0, 0.0

def compute_frame(h5filename, frame):
    with h5py.File(h5filename, 'r', driver='stdio') as h5:
        cl_t = h5['/connectivity/chem_bonds_0/step'][frame]
        cl = np.asarray(h5['/connectivity/chem_bonds_0/value'][frame])
        cl = cl[cl != -1]
        cl = cl.reshape(cl.shape[0]/2, 2)
        st_cl = np.asarray(h5['/connectivity/bonds_0'])
        st_cl = st_cl[st_cl != -1]
        st_cl = st_cl.reshape(st_cl.shape[0]/2, 2)
        if len(cl) == 0:
            return [cl_t, 0, 0, 0]
        g = nx.Graph()
        g.add_edges_from(cl)
        g.add_edges_from(st_cl)
        avg_loops, num_loops = get_avg_loop(g)
        print(frame)
        return [cl_t, len(cl), num_loops, avg_loops]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('h5')
    parser.add_argument('--nt', '-nt', default=8, type=int)
    parser.add_argument('-b', default=0, type=int)
    parser.add_argument('-e', default=None, type=int)
    args = parser.parse_args()

    h5filename = args.h5
    h5 = h5py.File(h5filename, 'r')
    print('Opened {}'.format(h5filename))

    file_name = h5filename.replace('.h5', '')

    with h5py.File(h5filename, 'r') as h5:
        cl = h5['/connectivity/chem_bonds_0/value']
        frames = xrange(args.b, cl.shape[0] if args.e is None else args.e)
        print cl.shape[0]
    compute_frame_ = functools.partial(compute_frame, h5filename)

    p = Pool(args.nt)
    loop_size_counter = p.map(compute_frame_, frames)

    cr_file = 'loops_{}_{}.csv'.format(file_name, 'sim')
    np.savetxt(cr_file, loop_size_counter, header='t cr num_loops avg_loops')
    print('Saved {}'.format(cr_file))

if __name__ == '__main__':
    main()
