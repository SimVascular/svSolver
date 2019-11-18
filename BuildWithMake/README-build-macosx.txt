------------------------------------------------------------------------
            Compiling Instructions for svSolver on MacOS
                       Revised 2019-11-17
------------------------------------------------------------------------

--------
Overview
--------

By default, SimVascular is configured to build on Windows using
makefiles.  You must override the deafult options to build on MacOS.

Our base test configuration for MacOS is:

MacOS 10.13
Intel 7/9 processor
clang/clang++ version 8.3+
gcc/g++/gfortran via home brew

and/or

ifort/icpc/icc intel compilers

Building with the Intel compilers (ifort/icpc/icc) should
work but this has limited testing.

-------------------------------
Major Steps (2019.06 externals)
-------------------------------

-----------
Major Steps
-----------

1. System Prerequisities
------------------------

brew update
brew install gcc
brew install mpich

2. Checkout svSolver source code
--------------------------------
% git clone https://github.com/SimVascular/svSolver.git svsolver

3. Building svSolver
---------------------

By default, on MacOS svSolver is built with a dummy version of MPI.
This is a single processor only version of MPI for testing.  See
below on how to use openmpi or mpich.

% cd svsolver/BuildWithMake
% source quick-build-macos.sh

4. Launching svSolver
---------------------

% cd BuildWithMake
% mypre  (preprocessor)
% mypost (postprocessor)
% mysolver-nompi (wrapper script for solver)

5. Building an Installer (optional)
-----------------------------------

Use the CMake build if you want to build an installer
for svSolver.  The executable files built by the
make build should have limited dependencies.

6. Optional override options
----------------------------
You can override defaults in the make build
using one or more of the "override" files:

  * cluster_overrides.mk
  * global_overrides.mk
  * site_overrides.mk
  * pkg_overrides.mk

See include.mk for all options.

See the "quick-build" script to see what must
be set in cluster_overrides.mk to build on linux.

For example, to build with a dummy MPI (only
can use a single core), put the folllowing into
global_overrides.mk:

*** start file "global_overrides.mk"

#
# Notes on MPI:
# * default is to use dummy mpi
# * can only build one at a time

SV_USE_DUMMY_MPI=0
SV_USE_OPENMPI=0
SV_USE_MPICH=1

*** end file "global_overrides.mk"

7.  To build external open source packages (very optional)
----------------------------------------------------------

% cd Externals/Make/2019.06
% source build-sv-exeternals-macos.sh
