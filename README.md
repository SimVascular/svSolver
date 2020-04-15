# Install the Software

svSolver binaries can be downloaded using the installers located [here](https://simtk.org/frs/index.php?group_id=188). For Ubuntu and MacOS the binaries are installed in /usr/local/sv/svSolver/.

# Building the Software

svSolver binaries can be built from the GitHub source using either a CMake build process or a Make build process.  Both are described below.  

## VTK libraries

svSolver uses VTK to read and write simulation results. The VTK libraries used by svSolver are downloaded as prebuilt external packages so VTK does not need to be installed. However, VTK depends on certain grahics libraries being installed (e.g. OpenGL). This may cause compilation problems for certain clusters that don't have graphics libraries installed.
 
External VTK libraries are currently supported for
```
 CentoOS 8.1 (gcc 8.3), CentOS 7.6 (gcc 6.3)
 
 Ubuntu 18.04 (gcc 7.3), Ubuntu 16.04 (gcc 5.4), and Ubuntu 19.04 (gcc 8.3)
 
 MacOS 10.13 (clang 8.1)
 ```

## Building with Make

To build directly with make files, please see the README files in the "BuildWithMake" directory.  Simple scripts are provided to build on Windows, Linux, MacOS as described.

## Building with CMake

The svSolver project can use CMake to create the Makefiles used to compile and link the source into a binary executable. 
The solver may also be built using a locally installed version of VTK. See below.

 ### Building on Ubuntu 16.04
 
 #### Software prerequisites
 svSolver requires a CMake version of 3.6 or higher. The CMake version obtained using apt-get may be have a lower version number. A CMake 3.11 version can be installed by following the instructions [here](https://peshmerge.io/how-to-install-cmake-3-11-0-on-ubuntu-16-04/).
 
 svSolver uses Fortran90. A Fortran90 compiler can be installed using
 ```
 sudo apt-get install gfortran
 ```
     
  svSolver uses the MPICH implementation of MPI. It can be installed using
  ```
  sudo apt-get install mpich 
  ```

#### Building svSolver

svSolver is built using the following steps

```

1) Download the source from GitHub

   https://github.com/SimVascular/svSolver.git
   
2) Create a build directory and change directories to it

   mkdir svSolver-build
   cd svSolver-build
   
3) Execute the build

   cmake ../svSolver
   make
```
 
This creates a svSolver-build/svSolver-build/bin directory that contains the three binary executables 
```
svpost*		
svpre*	
svsolver*
```

The **svpre** program is used to create bct.dat, geombc.dat.1 and restart.0.1 files from a .svpre file. 
The **svsolver** program executes the solver with a .in file. The .svpre and .in files are typically created using the SimVascular GUI. 
The **svpost** program is used to convert svSolver restart files into VTK .vtp and .vtu files for visualization.

## Building using a locally installed version of VTK

You can build svSolver on platforms that don't have VTK externals pre-built for them using the **SV_USE_LOCAL_VTK** CMake flag
```
ccmake -DSV_USE_LOCAL_VTK=ON ..
```
This has been testing on MacOS, Ubuntu, RedHat and CentOS.

# Status of Build on Travis

[![Build Status](https://travis-ci.org/SimVascular/svSolver.svg?branch=master)](https://travis-ci.org/SimVascular/svSolver)
