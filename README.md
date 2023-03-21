# Install the Software

svSolver binaries can be downloaded using the installers located [here](https://simtk.org/frs/index.php?group_id=188). For Ubuntu and MacOS the binaries are installed in /usr/local/sv/svSolver/.

# Building the Software

svSolver binaries can be built from the GitHub source using either a CMake build process or a Make build process.  Both are described below.  

## VTK libraries

svSolver uses VTK to read and write simulation results. The VTK libraries used by svSolver are downloaded as prebuilt external packages so VTK does not need to be installed. However, VTK depends on certain graphics libraries being installed (e.g. OpenGL, X11). 
 
External VTK libraries are currently supported for
```
 CentoOS 8.1 (gcc 8.3), CentOS 7.6 (gcc 6.3)
 
 Ubuntu 18.04 (gcc 7.3), Ubuntu 16.04 (gcc 5.4), and Ubuntu 19.04 (gcc 8.3)
 
 MacOS 10.13 (clang 8.1)
 ```
 
 svSolve can also be built from VTK local and custom installs (see below).

## Building with CMake

The svSolver project uses CMake to create the Makefiles used to compile and link the source into a binary executable. 

 ### Building on Ubuntu 16.04
 
 #### Software prerequisites
 svSolver requires a CMake version of 3.6 or higher. The CMake version obtained using apt-get may be have a lower version number. 
 A CMake 3.11 version can be installed by following the instructions [here](https://peshmerge.io/how-to-install-cmake-3-11-0-on-ubuntu-16-04/).
 
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

## Building using a custom VTK build

You can also build vSolver using a custom VTK build located in a non-standard directory that CMake may not be able to find. The location of the custom VTK build directory can be specified using the **SV_VTK_LOCAL_PATH** CMake flag
```
cmake -DSV_USE_LOCAL_VTK=ON -DSV_VTK_LOCAL_PATH=$HOME/vtk-install/ ..
```
where $HOME/vtk-install/ contains the VTK include, ibrary and share (documantaion) directories.
```
include/	lib/		share/
```

# Building on an HPC cluster

Building svSolver on an HPC cluster requires first building a local version of VTK. After VTK is built then you will need to load the 
appropriate modules needed by svSolver and then build using
```
cmake -DSV_USE_LOCAL_VTK=ON -DSV_VTK_LOCAL_PATH=$HOME/vtk-install/ ..
```

## Loading modules
You can load the modules needed by svSover using the following commands
```
module purge
module load gcc openmpi openblas cmake
```

## Building VTK
VTK source is downloaded from https://www.vtk.org/files/release/8.2/VTK-8.2.0.tar.gz. Note that svSolver is not compatible with VTK 9.

The following steps are used to build VTK
CMake command-line options are used to build VTK without graphics
```
mkdir $HOME/vtk
cd $HOME/vtk
wget https://www.vtk.org/files/release/8.2/VTK-8.2.0.tar.gz
tar xvf VTK-8.2.0.tar.gz 
mkdir build
cd build
cmake -DBUILD_SHARED_LIBS:BOOL=OFF \
      -DCMAKE_BUILD_TYPE:STRING=RELEASE \
      -DBUILD_EXAMPLES=OFF \
      -DBUILD_TESTING=OFF \
      -DVTK_USE_SYSTEM_EXPAT:BOOL=ON \
      -DVTK_USE_SYSTEM_ZLIB:BOOL=ON \
      -DVTK_LEGACY_REMOVE=ON \
      -DVTK_Group_Rendering=OFF \
      -DVTK_Group_StandAlone=OFF \
      -DVTK_RENDERING_BACKEND=None \
      -DVTK_WRAP_PYTHON=OFF \
      -DModule_vtkChartsCore=ON \
      -DModule_vtkCommonCore=ON \
      -DModule_vtkCommonDataModel=ON \
      -DModule_vtkCommonExecutionModel=ON \
      -DModule_vtkFiltersCore=ON \
      -DModule_vtkFiltersFlowPaths=ON \
      -DModule_vtkFiltersModeling=ON \
      -DModule_vtkIOLegacy=ON \
      -DModule_vtkIOXML=ON \
      -DVTK_GROUP_ENABLE_Views=NO \
      -DVTK_GROUP_ENABLE_Web=NO \
      -DVTK_GROUP_ENABLE_Imaging=NO \
      -DVTK_GROUP_ENABLE_Qt=DONT_WANT \
      -DVTK_GROUP_ENABLE_Rendering=DONT_WANT \
      -DCMAKE_INSTALL_PREFIX=/$HOME/vtk/install \
      ../VTK-8.2.0
make
make install

# Status of Build on Travis

[![Build Status](https://travis-ci.org/SimVascular/svSolver.svg?branch=master)](https://travis-ci.org/SimVascular/svSolver)




