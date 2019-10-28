======================================================================================
---------------------------------------- README -------------------------------------
======================================================================================
Ingrid Lan - ingridl@stanford.edu - Sept. 2019

External tissue support is implemented via Robin boundary conditions involving 
springs, dampers, and external pressures on user-specified walls. 

For the remainder of this document, thicknessvw, Evw, ksvw, csvw, and p0vw refer
to the wall thickness, Young's modulus, spring constant, damping constant, and
external pressure, respectively. 

-------------------------------------- References --------------------------------------
- Figueroa et al. (2006) - A coupled momentum method for modeling blood flow in
    three-dimensional deformable arteries. Comput Methods Appl Mech Engrg 195:5685-5706.
- Moireau et al. (2012) - External tissue support and fluid-structure simulation
    in blood flows. Biomech Model Mechanobiol 11:1-18.

By default, External Tissue Support is OFF. Simulation files can be left unchanged if
External Tissue Support is not desired. Otherwise, see below for how to enable
External Tissue Support for uniform / variable wall simulations. 

---------------------------------------- Notes ----------------------------------------
(1) If thicknessvw and Evw are specified as uniform properties, then all tissue support
    parameters (ksvw, csvw, and p0vw) must also be specified as uniform properties
(2) If thicknessvw and Evw are specified as variable properties, then all tissue support
    parameters must also be specified as variable properties.

To summarize, when external tissue support is turned ON, all 5 wall properties must be
of the same type -- either uniform or variable.


1) UNIFORM WALL / EXTERNAL TISSUE SUPPORT ON - uniform {thicknessvw, Evw, ksvw, csvw, p0vw}
   - No changes to .cvpre/.svpre

   - Required additions to solver.inp (no default values provided)
      - External Tissue Support: True
      - Spring Constant of External Support: [ksvw value]
      - Damping Constant of External Support: [csvw value]
      - External Pressure: [p0vw value]

2) VARIABLE WALL / EXTERNAL TISSUE SUPPORT ON - variable {thicknessvw, Evw, ksvw, csvw, p0vw}

   - Required additions to .cvpre/.svpre:

      - set_surface_ks_vtp [.vtp] [ksvw value]
      - ...
      - solve_varwall_ks

      - set_surface_cs_vtp [.vtp] [csvw value]
      - ...
      - solve_varwall_cs

      - set_surface_p0_vtp [.vtp] [p0vw value]
      - ...
      - solve_varwall_p0

      **NOTE** If these are placed before 'varwallprop_write_vtp', the external tissue support
               parameters will also be written to varwallprop.vtp.

   - Required addition to solver.inp
      - External Tissue Support: True

