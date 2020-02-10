# Install the Software

svSolver binaries can be downloaded using the installers located [here](https://simtk.org/frs/index.php?group_id=188). For Ubuntu and MacOS the binaries are installed in /usr/local/sv/svSolver/.

# Building the Software

 svSolver binaries can be built from the GitHub source. The svSolver project uses CMake to create the Makefiles used to compile and link the source into a binary executable. svSolver uses VTK to read and write simulation results. The VTK libraries used by svSolver are downloaded as prebuilt external packages so VTK does not need to be installed. However, VTK depenends on certain grahics libraries being installed (e.g. OpenGL). This may cause compilation probelms for certain clusters that don't have graphics libraries installed.
 
 ## Building on Ubuntu 16.04
 
 ### Software prerequisite
 svSolver requires a CMake version of 3.6 or higher. The CMake version obtained using apt-get may be have a lowere version number. A CMake 3.11 version can be installed by following the instructions [here](https://peshmerge.io/how-to-install-cmake-3-11-0-on-ubuntu-16-04/).
 
 svSolver uses Fortran90. A Fortran90 compiler can be installed using
 ```
 sudo apt-get install gfortran
 ```
     
  svSolver uses the MPICH implementation of MPI. It can be installed using
  ```
  sudo apt-get install mpich 
  ```

### Building svSolver

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

The **svpre** program is used to create a solver .in file from a .svpre file. 
The **svsolver** program executes the solver with a .in file.
The **svpost** program is used to convert svSolver restart files into VTK .vtp and .vtu files for visualization.
 
# Status of Build on Travis

[![Build Status](https://travis-ci.org/SimVascular/svSolver.svg?branch=master)](https://travis-ci.org/SimVascular/svSolver)
