import argparse
import h5py
import sys
import numpy as np
import networkx as nx
from multiprocessing import Pool
import functools

parallel = True

# calculate pn(cr)
def get_mn(g, g_sub=None):
    """Gets number average molecular weight."""
    # Number of polymers
    num_connected_g = len(g_sub)
    if num_connected_g > 0:
        return g.number_of_nodes() / float(num_connected_g)
    else:
        return 0.0

def get_mw(g, g_sub=None):
    """Gets weighted average molecular weight"""
    if g_sub is None:
        g_sub = list(nx.connected_component_subgraphs(g))
    s2 =  sum([sg.number_of_nodes()**2 for sg in g_sub])/float(g.number_of_nodes())
    return s2

def get_mn_mass(g, g_sub=None):
    """Gets number average molecular weight."""
    # Number of polymers
    #g_sub = [x for x in nx.connected_component_subgraphs(g)]
    num_connected_g = len(g_sub)
    #total_mass = sum([x['mass'] for sg in g_sub for x in sg.node.values()])
    #total_mass = sum((sg.number_of_nodes() - 3.0)/2 for sg in g_sub)
    total_mass = g.graph['total_mass']
    if num_connected_g > 0:
        return total_mass / float(num_connected_g)
    else:
        return 0.0

def get_mw_mass(g, g_sub=None):
    """Gets weighted average molecular weight"""
    #g_sub = [x for x in nx.connected_component_subgraphs(g)]
    #total_mass = float(sum([x['mass'] for sg in g_sub for x in sg.node.values()]))
    total_mass = g.graph['total_mass']
    return sum([sum(x['mass'] for x in sg.node.values())**2/total_mass for sg in g_sub])

def get_pdi(g, g_sub=None):
    """Gets polydispersity index PDI"""
    mn = get_mn(g, g_sub)
    mw = get_mw(g, g_sub)
    if mn > 0.0:
        return mw/mn
    return 0.0

def get_pdi_mass(g, g_sub=None):
    """Gets polydispersity index PDI"""
    mn = get_mn_mass(g, g_sub)
    mw = get_mw_mass(g, g_sub)
    if mn > 0.0:
        return mw/mn
    return 0.0

def get_pn(g, g_sub=None):
    """Gets average size of polymer molecule."""
    if g_sub is None:
        g_sub = list(nx.connected_component_subgraphs(g))
    if len(g_sub) > 0:
        return np.average([sg.number_of_nodes() for sg in g_sub])
    return 0.0

def compute_frame(h5filename, frame):
    # Dictionary, pid->res_id
    pid2res_id = {p: p for p in range(1, 1001)}
    pid2res_id.update({pid: 1001+(pid-1001)//3 for pid in range(1001, 4001)})
    type2mass = {0: 62.050, 1: 44.999, 2: 76.098, 3: 44.009,
                 4: 28.054, 5: 18.006}

    with h5py.File(h5filename, 'r', driver='sec2') as h5:
        species = h5['/particles/atoms/species/value'][frame]
        st_cl = np.asarray(h5['/connectivity/bonds_0'])
        st_cl = st_cl[st_cl != -1]
        st_cl = st_cl.reshape(st_cl.shape[0]/2, 2)
        s_cl = np.asarray(h5['/connectivity/chem_bonds_0/value'][frame])
        s_cl = s_cl[s_cl != -1]
        s_cl = s_cl.reshape(s_cl.shape[0]/2, 2)
        static_b = {tuple(sorted(map(pid2res_id.get, b))) for b in st_cl}
        static_b = filter(lambda b: b[0] != b[1], static_b)
        g = nx.Graph(total_mass=2000.0)
        g.add_nodes_from(range(1, 1001), type='EG', mass=0.0)
        g.add_nodes_from(range(1001, 2001), type='TPA', mass=0.0)
        for cg_id in range(1, 4001):
            type_id = species[cg_id-1]
            res_id = pid2res_id[cg_id]
            cg_mass = type2mass.get(type_id, 0.0)
            g.node[res_id]['mass'] += cg_mass
            g.graph['total_mass'] += cg_mass

        g.add_edges_from(static_b)
        g.add_edges_from({tuple(sorted(map(pid2res_id.get, b))) for b in s_cl})
        g_sub = list(nx.connected_component_subgraphs(g))
        #g_sub = [x for x in nx.connected_component_subgraphs(g) if x.number_of_nodes() > 1]
        if g_sub:
            size_max_component = max([x.number_of_nodes() for x in g_sub])
        else:
            size_max_component = 0
        cr = len(s_cl)
        print(frame)
        pn = get_pn(g, g_sub)
        mn = get_mn(g, g_sub)
        mw = get_mw(g, g_sub)
        mn_mass = get_mn_mass(g, g_sub)
        mw_mass = get_mw_mass(g, g_sub)
        if mn > 0.0:
            pdi = mw / mn
        else:
            pdi = 0.0
        if mn_mass > 0.0:
            pdi_mass = mw_mass/mn_mass
        else:
            pdi_mass = 0.0
        return [cr, len(g_sub), len([x for x in g_sub if x.number_of_nodes() > 1]), size_max_component, pn, mw, mn, pdi, mw_mass, mn_mass, pdi_mass]

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('h5')
    parser.add_argument('--nt', default=20, type=int)
    parser.add_argument('-b', default=0, type=int)
    parser.add_argument('-e', default=None, type=int)
    args = parser.parse_args()

    h5filename = args.h5
    print('Opened {}'.format(h5filename))

    file_name = h5filename.replace('.h5', '')

    cr_pn = []
    last_cr = -1

    with h5py.File(h5filename, 'r', driver='sec2') as h5:
        s_cl = h5['/connectivity/chem_bonds_0/value']
        frames = xrange(args.b, s_cl.shape[0] if args.e is None else args.e)
        print('Frames: {}'.format(len(frames)))

    compute_frame_ = functools.partial(compute_frame, h5filename)

    if parallel:
        p = Pool(args.nt)
        cr_pn = p.map(compute_frame_, frames)
    else:
        cr_pn = map(compute_frame_, frames)

    cr_file = 'polstat_{}_{}.csv'.format(file_name, 'sim')
    np.savetxt(cr_file, cr_pn, header='cr num_clusters num_clusters2 size_max_cluster pn mw mn pdi')
    print('Saved {}'.format(cr_file))

if __name__ == '__main__':
    main()
