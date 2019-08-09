======================================================================================
---------------------------------------- README -------------------------------------
======================================================================================
Ingrid Lan - ingridl@stanford.edu - July 2019

For the remainder of this document, thicknessvw, Evw, ksvw, csvw, and p0vw refer
to the wall thickness, Young's modulus, spring constant, damping constant, and
external pressure, respectively. External tissue support is implemented via Neumann
traction boundary conditions involving springs, dampers, and external pressures on
user-specified walls.

References
- Figueroa et al. (2006) - A coupled momentum method for modeling blood flow in
    three-dimensional deformable arteries. Comput Methods Appl Mech Engrg 195:5685-5706.
- Moireau et al. (2012) - External tissue support and fluid-structure simulation
    in blood flows. Biomech Model Mechanobiol 11:1-18.

1) UNIFORM WALL SIMULATION  - constant {thicknessvw, Evw, ksvw, csvw, p0vw}

   - No changes to .cvpre/.svpre

   - Required additions to solver.inp (no default values provided)

      - Spring Constant of External Support: [value]
      - Damping Constant of External Support: [value]
      - External Pressure: [value]

2) VARIABLE WALL SIMULATION - variable {thicknessvw, Evw, ksvw, csvw, p0vw}

   - Required additions to .cvpre/.svpre

      - set_surface_ks_vtp [.vtp] [value]
      - ...
      - solve_varwall_ks

      - set_surface_cs_vtp [.vtp] [value]
      - ...
      - solve_varwall_cs

      - set_surface_p0_vtp [.vtp] [value]
      - ...
      - solve_varwall_p0

   - Required change to solver.inp
      - Variable Wall Properties: True (instead of 'Variable Thickness and Young Mod')

