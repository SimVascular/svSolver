------------------------------------------------------------------------
            Compiling Instructions for svSolver on Linux
                       Revised 2016-09-18
------------------------------------------------------------------------

--------
Overview
--------

By default, svSolver is configured to build on linux using
makefiles.  Our base test configuration for linux is:

CentOS 6.8 (developer configuration)
Intel 7 processor

gcc/g++/gfortran version 4.4.7

and/or

ifort/icpc/icc intel compilers

NOTE: The CMake system is currently broken for svSolver and
      is under revision.

-----------
Major Steps
-----------

1. CentOS prerequisities
------------------------
The following packages are required to build svsolver

### helpers for build
% yum install tcl

### cmake tools
% yum install cmake
% yum install cmake-gui

### mpi versions
% yum install openmpi
% yum install openmpi-devel
% yum install mpich
% yum install mpich-devel

3. Checkout svSolver source code
--------------------------------
% git clone https://github.com/SimVascular/svSolver.git svsolver

2. vtk libraries
----------------
svSolver requires vtk libraries.  They can be build using the
the scripts in "../Externals", or pre-built binaries can be
downloaded using the script

% cd svsolver/BuildWithMake
% ./get-vtk-binaries.sh

4. Override options
-------------------
Override defaults with:

  * cluster_overrides.mk
  * global_overrides.mk
  * site_overrides.mk
  * pkg_overrides.mk

Building with gnu compilers and the vtk binaries should
build "out of the box" without required overrides.

See include.mk for all options.  Sample override files
can be found in:

SampleOverrides

to use one of these files, copy into local BuildWithMake
directory and modify as needed, e.g.:

% cd svsolver/BuildWithMake
% cp SampleOverrides/centos_6/global_overrides.mk .

6. Build
--------
% cd svsolver/BuildWithMake
% module add openmpi-x86_64  (if needed)
% make

7. Running developer version
----------------------------
Binaries are in "BuildWithMake/Bin" directory.

8. Build release (NOTE: out-of-date!)
-----------------
% cd svsolver/BuildWithMake/Release
% make

9. Installing a distribution (NOTE: out-of-date!)
----------------------------
To be updated.
