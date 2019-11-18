------------------------------------------------------------------------
            Compiling Instructions for svSolver on Windows
                       Revised 2019-11-17
------------------------------------------------------------------------

Overview
--------

By default, svSolver is configured to build on Windows using
makefiles.

NOTE: On Windows, the CMake system is currently broken for svSolver.

Building the "external" open source packages is very complicated
and requires additional packages not discussed below. Only
advanced users should attempt to build the externals open source
packages.

Our base test configuration for Windows is:

Windows 10 64-bit desktop (w/ patches)
Intel 7/9 processor

These instructions are valid for the 2019.06 version of the
externals only.  See below for older versions.

You CANNOT mix and match compiler versions, you must use
the required version of MSVC depending on externals version.

-------------------------------
Major Steps (2019.06 externals)
-------------------------------

1. Windows prerequisities
-------------------------
The following packages are required to build simvascular

A. Recent Cygwin 64 bit (www.cygwin.com) with at least:

   make, tclsh, zip, gzip, tar, date, patch

   installed in the default C:/cygwin64

We use:

   CYGWIN_NT-10.0 xxxxxxx 2.10.0(0.325/5/3) 2018-02-02 15:16 x86_64 Cygwin

B. MSVC 2017 (vs 15.x) win64 compiler  -> default
   install directory (e.g. "Program Files") okay

We use the community edition of the MSVC 2017 compiler
(Windows 64-bit only) but commercial versions should also work.

C. Intel Fortran Compiler: ifort version 19.0

D. Note that it is now required that CL and MSVC "link" be found in your
   path and be found PRIOR to the link contained in Cygwin.

For example, here is a "startX-with-2017.bat" script that we use:

*** start file "startX-with-2017.bat"

@echo off

C:
chdir C:\cygwin64\bin

REM set the correct path and visual studio path if you have Intel Fortran compiler
call "C:\Program Files (x86)\IntelSWTools\compilers_and_libraries_2019.4.245\windows\bin\compilervars.bat" intel64 vs2017

REM Add in MSVC 2017 C++ x64 compiler (not needed if you include ifort above)
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat"

REM use startxwin if you use x server, otherwise just use next line
REM bash --login
bash --login -c startxwin

*** end file "startX-with-2017.bat"

You also need to modify your .bashrc file so that link and the CL compiler
tools are at the beginning of the path (i.e. before /bin):

*** begin add to bottom of your ~/.bashrc file ***
#
# alias cd=cd_func

if hash CL 2>/dev/null; then
    clfullpath=`which CL`
    clparentdir="$(dirname "$clfullpath")"
    export PATH=$clparentdir::$PATH
fi
if hash vsstrace.exe 2>/dev/null; then
    rcfullpath=`which vsstrace.exe`
    rcparentdir="$(dirname "$rcfullpath")"
    export PATH=$rcparentdir:$PATH
fi

# add my custom dir to path
export PATH=~/bin:$PATH

*** end of code to add to bottom of ~/.bashrc file ***

2. Checkout svSolver source code
--------------------------------

% git clone https://github.com/SimVascular/svSolver.git svsolver

3. Building svSolver
---------------------

By default, on Windows svSolver is built with MSMPI.  The
required distribution of MSMPI is included with the svSolver
source code.

% cd svsolver/BuildWithMake
% source quick-build-windows.sh

4. Launching svSolver
---------------------

% cd BuildWithMake
% mypre  (preprocessor)
% mypost (postprocessor)
% mysolver-msmpi (wrapper script for solver)

5. Building an Installer (optional)
-----------------------------------

% cd Release
% make

6. Optional override options
----------------------------
You can override defaults in the make build
using one or more of the "override" files:

  * cluster_overrides.mk
  * global_overrides.mk
  * site_overrides.mk
  * pkg_overrides.mk

See include.mk for all options.

For example, to build with a dummy MPI (only
can use a single core), put the folllowing into
global_overrides.mk:

*** start file "global_overrides.mk"

#
# Notes on MPI:
# * default is to use msmpi
# * can only build one at a time

SV_USE_DUMMY_MPI=1
SV_USE_OPENMPI=0
SV_USE_MPICH=0

*** end file "global_overrides.mk"

7.  To build external open source packages (very optional)
----------------------------------------------------------

% cd Externals/Make/2019.06
% source build-sv-exeternals-windows.sh
