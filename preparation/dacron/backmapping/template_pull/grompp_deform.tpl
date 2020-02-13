; RUN CONTROL PARAMETERS
integrator               = md
; Start time and timestep in ps
tinit                    = 0
dt                       = 0.001
nsteps                   = 10000000
; For exact run continuation or redoing part of a run
init_step                = 0
; mode for center of mass motion removal
comm-mode                = Linear
; number of steps for center of mass motion removal
nstcomm                  = 10
; group(s) for center of mass motion removal
comm_grps                = System


periodic-molecules = yes

; LANGEVIN DYNAMICS OPTIONS
; Friction coefficient (amu/ps) and random seed
ld-seed                  = 1993

; OUTPUT CONTROL OPTIONS
; Output frequency for coords (x), velocities (v) and forces (f)
nstxout                  = 0
nstvout                  = 0
nstfout                  = 0
; Output frequency for energies to log file and energy file
nstlog                   = 10000
nstenergy                = 1000
; Output frequency and precision for xtc file
nstxtcout                = 0
xtc-precision            = 1000
; This selects the subset of atoms for the xtc file. You can
; select multiple groups. By default all atoms will be written.
xtc_grps                 = System ;Protein
; Selection of energy groups
energygrps               = System

; NEIGHBORSEARCHING PARAMETERS
; nblist update frequency
cutoff-scheme            = verlet
nstlist                  = 10
; ns algorithm (simple or grid)
ns_type                  = grid
; Periodic boundary conditions: xyz (default), no (vacuum)
; or full (infinite systems only)
pbc                      = xyz
; nblist cut-off
rlist                    = 1.2

; OPTIONS FOR ELECTROSTATICS AND VDW
; Method for doing electrostatics
coulombtype              = cut-off
rcoulomb-switch          = 0
rcoulomb                 = 1.2
; Relative dielectric constant for the medium and the reaction field
epsilon_r                = 1
epsilon_rf               = 1
; Method for doing Van der Waals
vdwtype                  = cut-off
; cut-off lengths
rvdw-switch              = 0
rvdw                     = 1.2
; Apply long range dispersion corrections for Energy and Pressure
DispCorr                 = No
; Extension of the potential lookup tables beyond the cut-off
table-extension          = 1.0
; Seperate tables between energy group pairs
;energygrp_table          = A A
; Spacing for the PME/PPPM FFT grid
fourierspacing           = 0.12
; FFT grid size, when a value is 0 fourierspacing will be used
fourier_nx               = 0
fourier_ny               = 0
fourier_nz               = 0
; EWALD/PME/PPPM parameters
pme_order                = 4
ewald_rtol               = 1e-05
ewald_geometry           = 3d
epsilon_surface          = 0
optimize_fft             = no

; OPTIONS FOR WEAK COUPLING ALGORITHMS
; Temperature coupling
tcoupl                   = Nose-Hoover; V-rescale; No ;Nose-Hoover
; Groups to couple separately
tc-grps                  = System
; Time constant (ps) and reference temperature (K)
tau_t                    = 1.0
ref_t                    = 298
; Pressure coupling
;Pcoupl                   = Parrinello-Rahman
;pcoupltype               = isotropic
; Time constant (ps), compressibility (1/bar) and reference P (bar)
;tau_p                    = 1.0
;compressibility          = 4.5e-5
;ref_p                    = 1.0
; Random seed for Andersen thermostat
andersen_seed            = 815131


; GENERATE VELOCITIES FOR STARTUP RUN
gen_vel                  = no
gen_temp                 = 298
gen_seed                 = -1

; OPTIONS FOR BONDS
constraints              = none
; Type of constraint algorithm
constraint_algorithm     = LINCS
; Use successive overrelaxation to reduce the number of shake iterations
Shake-SOR                = no
; Relative tolerance of shake
shake-tol                = 1e-04
; Highest order in the expansion of the constraint coupling matrix
lincs-order              = 4
; Number of iterations in the final step of LINCS. 1 is fine for
; normal simulations, but use 2 to conserve energy in NVE runs.
; For energy minimization with constraints it should be 4 to 8.
lincs_iter               = 2
; Lincs will write a warning to the stderr if in one step a bond
; rotates over more degrees than
lincs-warnangle          = 30
; Convert harmonic bonds to morse potentials
morse                    = no

; ENERGY GROUP EXCLUSIONS
; Pairs of energy groups for which all non-bonded interactions are excluded
energygrp_excl           =


; Deformation options
deform = 0 0 V_DEFORM_Z 0 0 0
; Pressure coupling
Pcoupl                   = Parrinello-Rahman
pcoupltype               = anisotropic
; Time constant (ps), compressibility (1/bar) and reference P (bar)
tau_p                    = 1.0
compressibility          = 4.5e-5 4.5e-5 0.0 0.0 0.0 0.0
ref_p                    = 1.0 1.0 1.0 0.0 0.0 0.0
