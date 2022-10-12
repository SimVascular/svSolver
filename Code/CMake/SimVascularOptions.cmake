# Initial SV Options
#-----------------------------------------------------------------------------
# Developer flag (Output extra info during configure)
option(SV_DEVELOPER_OUTPUT "This is a developer mode to print extra messages during configure" OFF)

set(SV_BUILD_TYPE "CMAKE" CACHE STRING "Designate CMAKE build" FORCE)
set_property(CACHE SV_BUILD_TYPE PROPERTY STRINGS CMAKE)
mark_as_advanced(SV_BUILD_TYPE)
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Distribution
option(SV_ENABLE_DISTRIBUTION "Distribute" OFF)
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Enable Testing
option(BUILD_TESTING "Build ${PROJECT_NAME} testing" OFF)
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Libs - SHARED or STATIC
option(BUILD_SHARED_LIBS "Build ${PROJECT_NAME} as shared libraries." OFF)

set(SV_LIBRARY_TYPE "STATIC" CACHE STRING "Options are STATIC or SHARED" FORCE)
set_property(CACHE SV_LIBRARY_TYPE PROPERTY STRINGS STATIC SHARED)
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# SimVascular Build options
option(SV_SUPPRESS_WARNINGS "Option to suppress all compiler warnings while compiling" ON)
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# General Options
option(SV_USE_MPI "Use MSMPI" ON)
option(SV_USE_DUMMY_MPI "Use Dummy MPI" OFF)
option(SV_USE_MSMPI "Use MSMPI" OFF)
option(SV_BUILD_ADDITIONAL_NOMPI_VERSION "Distribute an additional nompi version of svsolver" ON)
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# ThirdParty
option(SV_USE_ZLIB "Use ZLib" ON)
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Remaining optional dependencies
#-----------------------------------------------------------------------------
# Enable Intel Runtime libs if we need or want them
option(SV_USE_INTEL "Add Intel Runtime Libraries (these may be needed by some libraries)" OFF)
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# All OS
option(SV_USE_NOTIMER "Use notimer" ON)
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Solver Build Options (Modules)
option(SV_USE_SOLVERIO "Option to build solverIO module (requires Fortran)" ON)
option(SV_USE_SVPRE "Option to build Pre-solver module (requires Fortran)" ON)
option(SV_USE_SVPOST "Option to build post-solver module" ON)
option(SV_SOLVERIO_REDIRECT "Option to redirect solver IO" OFF)
option(SV_USE_CORONARY "" ON)
option(SV_USE_CLOSEDLOOP "" ON)
option(SV_USE_VARWALL "" ON)
option(SV_USE_SPARSE "Use sparse Library" ON)
option(SV_USE_METIS "Use metis Library" ON)
option(SV_USE_NSPCG "Use nspcg Library" ON)
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Externals
set(SV_EXTERNALS_TOPLEVEL_DIR "${CMAKE_BINARY_DIR}/sv_externals" CACHE PATH "Externals toplevel directory")
set(SV_EXTERNALS_SRC_DIR "${SV_EXTERNALS_TOPLEVEL_DIR}/src" CACHE PATH "Externals toplevel src dir")
set(SV_EXTERNALS_BLD_DIR "${SV_EXTERNALS_TOPLEVEL_DIR}/build" CACHE PATH "Externals toplevel build dir")
set(SV_EXTERNALS_PFX_DIR "${SV_EXTERNALS_TOPLEVEL_DIR}/prefix" CACHE PATH "Externals toplevel prefix dir")
set(SV_EXTERNALS_BIN_DIR "${SV_EXTERNALS_TOPLEVEL_DIR}/bin/${SV_COMPILER_DIR}/${SV_COMPILER_VERSION_DIR}/${SV_ARCH_DIR}" CACHE PATH "Externals toplevel bin dir")

set(SV_EXTERNALS_INSTALL_PREFIX "sv_externals" CACHE PATH "Externals toplevel directory")

option(SV_EXTERNALS_USE_TOPLEVEL_DIR "If ON, SV_EXTERNALS_TOPLEVEL_DIR will be used as location for external packages" OFF)
# VTK

simvascular_add_new_external(VTK 8.1.1 ON OFF vtk)
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Linear Solver Options: SVLS
option(SV_USE_SVLS "Use svLS as linear solver" ON )
if(SV_USE_SVLS)
  set(USE_SVLS 1)
endif()
set(SVLS_BUILD_TYPE "Source")

option(SV_USE_LESLIB "Use leslib as linear solver" OFF )
if(SV_USE_LESLIB)
  set(SV_USE_LESLIB 1)
endif()
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# WIN32
option(SV_USE_WIN32_REGISTRY "Use Windows registry to obtain certain settings (install mode)" OFF)
mark_as_advanced(SV_USE_WIN32_REGISTRY)
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Enable Fortran
enable_language(Fortran)
get_filename_component(Fortran_COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME)
if(CMAKE_Fortran_COMPILER_ID MATCHES "GNU")
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -ffixed-line-length-132 -cpp")
  simvascular_get_major_minor_version(${CMAKE_Fortran_COMPILER_VERSION} COMPILER_MAJOR_VERSION 
    COMPILER_MINOR_VERSION)
  # Set the -std=legacy option to compile code using gcc 8.1 (see svSolver GitHub Issue #32). 
  if(APPLE AND (Fortran_COMPILER_NAME MATCHES "gfortran.*") AND (COMPILER_MAJOR_VERSION GREATER 7))
      set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -std=legacy")
  elseif(COMPILER_MAJOR_VERSION GREATER 11)
      set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -std=legacy")
  endif()
else()
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -132 -fpp")
endif()
#-----------------------------------------------------------------------------
