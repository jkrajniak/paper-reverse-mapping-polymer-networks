import sys
import files_io

def hook_after_init(system, particle_list, adress_tuple, gromacs_topology, part_prop):
    """Adds repulsive interaction and special particle to prevent ring overlapping"""
    hyb_gro = files_io.GROFile('hyb_conf.gro')
    hyb_top = files_io.GROMACSTopologyFile('hyb_topol.top')
    hyb_gro.read()
    hyb_top.read()
    ring_atoms = sorted([
        at_id for at_id, at_data in hyb_gro.atoms.items()
        if at_data.name in ['C11', 'C12', 'C13', 'N11', 'N12', 'N13']])
    cg_ring_atoms = sorted([at_id for at_id, at_data in hyb_gro.atoms.items()
                if at_data.name in ['A1', 'A2', 'A3']])
    max_pid = max(hyb_gro.atoms)
    max_at_type = max(gromacs_topology.atomtypeparams)
    print(max_at_type)
    cg_id = max_pid+1
    cg_at_type = max_at_type + 1
    cg_atoms = []
    print(part_prop)
    print(len(cg_ring_atoms))
    print(cg_ring_atoms[:10])
    ['id', 'type', 'pos', 'res_id', 'mass', 'q', 'lambda_adr', 'vp', 'v']
    prop_idx = {a: i for i, a in enumerate(part_prop)}
    # For every of ring atom create a CG bead. Iterate over atom rings
    cg_exclusions = []
    for a in range(0, len(ring_atoms), 6):
        atom_in_ring = ring_atoms[a:a+6]
        adress_tuple.append([cg_id] + atom_in_ring)
        com = sum([hyb_gro.atoms[x].position for x in atom_in_ring])/6.0
        mass = sum([hyb_top.atoms[x].mass for x in atom_in_ring])
        cg_atom = [None]*len(part_prop)
        cg_atom[prop_idx['id']] = cg_id
        cg_atom[prop_idx['type']] = cg_at_type
        cg_atom[prop_idx['pos']] = espressopp.Real3D(com)
        cg_atom[prop_idx['res_id']] = hyb_top.atoms[atom_in_ring[0]].chain_idx
        cg_atom[prop_idx['mass']] = mass
        cg_atom[prop_idx['q']] = 0
        cg_atom[prop_idx['lambda_adr']] = 0.0
        cg_atom[prop_idx['vp']] = True
        cg_atom[prop_idx['v']] = espressopp.Real3D(0, 0, 0)
        cg_atoms.append(cg_atom)
        for _ in range(3):
            cg_exclusions.append((cg_id, cg_ring_atoms.pop(0)))
        cg_id += 1
    particle_list.extend(cg_atoms)
    gromacs_topology.exclusions.extend(cg_exclusions)


def hook_setup_interactions(system, gromacs_topology, vlAT, vlCG):
    cg_at_type = 815
    cg_at_type_A = 814

    lj_interaction = espressopp.interaction.VerletListHybridLennardJones(vlCG, True)
    sigmaT = 0.6
    ljpot = espressopp.interaction.LennardJones(epsilon=1.0, sigma=sigmaT, shift='auto', cutoff=sigmaT*(2**(1/6.0)))
    lj_interaction.setPotential(
        type1=cg_at_type,
        type2=cg_at_type,
        potential=ljpot)
    #lj_interaction.setPotential(
    #    type1=cg_at_type,
    #    type2=cg_at_type_A,
    #    potential=espressopp.interaction.LennardJones(epsilon=1.0, sigma=0.29, shift='auto', cutoff=0.29*(2**(1.0/6.0))))
    lj_interaction.max_force = 500000.0
    system.addInteraction(lj_interaction, 'lj-cg')

#if __name__ == '__main__':
#    import collections
#    ad_t = []
#    p_l = []
#    gt = collections.namedtuple('GS', ['atomtypeparams'])([1,2,3,4])
#    hook_after_init(None, p_l, ad_t, gt)
