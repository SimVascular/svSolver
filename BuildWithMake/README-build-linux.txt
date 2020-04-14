------------------------------------------------------------------------
            Compiling Instructions for svSolver on Linux
                       Revised 2020-04-08
------------------------------------------------------------------------

--------
Overview
--------

By default, SimVascular is configured to build on Windows using
makefiles.  You must override the deafult options to build on linux.

Our base test configuration for linux is:

minimim requirements:

Ubuntu 16.04 64-bit desktop (w/ patches)
Intel 7/9 processor
gcc/g++/gfortran version 5.4

Highly recommended:

Ubuntu 18.04 64-bit desktop (w/ patches)
Intel 7/9 processor
gcc/g++/gfortran version 7.4

CentOS 8.1 64-bit desktop (w/ patches)
Intel 7/9 processor
gcc/g++/gfortran version 8.3

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

1a. CentOS (8.1)
----------------
### compiler
% yum install gcc-gfortran

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

### may be necessary, depending on config
% source /etc/profile.d/modules.sh
% module avail

% module load mpi/mpich-x86_64

or

% module load mpi/openmpi-x86_64

NOTE: "module load mpi" appears to load openmpi!

1b. CentOS (7.6)
----------------
The following packages are required to build svsolver

### compiler
% yum install gcc-gfortran

### helpers for build
% yum install tcl

### cmake tools
% yum install cmake
% yum install cmake-gui

### mpi versions
% yum install openmpi
% yum install openmpi-devel
% yum install mpich-3.2
% yum install mpich-3.2-devel

1c. Ubuntu (18.04)
--------------------
The following packages are required to build simvascular

### compilers & dev tools
% sudo apt-get install g++
% sudo apt-get install gfortran
% sudo apt-get install git

### cmake tools
% sudo apt-get install cmake
% sudo apt-get install cmake-qt-gui

### for flowsolver
% sudo apt-get install libmpich-dev
% sudo apt-get install libopenmpi-dev

### for vtk
% sudo apt-get install libglu1-mesa-dev
% sudo apt-get install libxt-dev

### some optional helpers
% sudo apt-get install dos2unix
% sudo apt-get install emacs


2. Checkout svSolver source code
--------------------------------
% git clone https://github.com/SimVascular/svSolver.git svsolver

3. Building svSolver
---------------------

By default, on Linux svSolver is built with a dummy version of MPI.
This is a single processor only version of MPI for testing.  See
below on how to use openmpi or mpich.

% cd svsolver/BuildWithMake
% module add mpi/openmpi-x86_64  (if needed on centos)
% module add mpi/mpich-3.2-x86_64  (if needed on centos)
% source quick-build-linux.sh

4. Launching svSolver
---------------------

% cd BuildWithMake
% mypre  (preprocessor)
% mypost (postprocessor)
% mysolver-nompi (wrapper script for solver)

5. Building an Installer (optional)
-----------------------------------

An installer isn't needed for Linux.  The executables
are self contained and shouldn't need environment variables
to be set before running the solver.

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

SV_USE_DUMMY_MPI=1
SV_USE_OPENMPI=0
SV_USE_MPICH=0

*** end file "global_overrides.mk"

7. Building with mpich or openmpi

Make sure that the system mpich or openmpi is installed on your
system (see above), update "global_overrides.mk", e.g.:

*** start file "global_overrides.mk"

SV_USE_DUMMY_MPI=0
SV_USE_OPENMPI=0
SV_USE_MPICH=1

*** end file "global_overrides.mk"

And then run:

% cd BuildWithMake
% make fast

Note: you can build the dummy, openmpi, and mpich version
in the same source try but you must build them once at a time!

For any non-standard MPI installation, you must override the
parameters automatically detected by either:

MakeHelpers/2019.06/mpich.x64_linux.mk 
MakeHelpers/2019.06/openmpi.x64_linux.mk 

You can do this in:

*** start file "pkg_overrides.mk"

#
# customize the commands or hardcode the paths
# for your system
#

MPI_NAME    = some_version_mpi
MPI_INCDIR  = $(shell mpif90 --showme:compile)
MPI_LIBS    = $(shell mpicxx --showme:link) $(shell mpif90 --showme:link)
MPI_SO_PATH = $(shell which mpiexec)/../..
MPIEXEC_PATH  = $(dir $(shell which mpiexec))
MPIEXEC       = mpiexec

*** end file "pkg_overrides.mk"

And then run:

% make fast

8. No installers necessary
--------------------------
The executables generated in Bin link against static libraries as
much as possible, so you shouldn't need wrapper scripts for svpre,
svpost, or the svsolver.  The executables can be added to your path
or copied as needed.  If you link against a non-system MPI, make
sure that the shared libraries for MPI are accesssible from each
computational node on your cluster.  Some compilers (e.g. Intel)
may require compiler runtime libraries as well.  The linux command
"ldd" can be used to see what shared libraries are needed for
each executable.

9.  To build external open source packages (very optional)
----------------------------------------------------------

% cd Externals/Make/2019.06
% source build-sv-exeternals-linux.sh
