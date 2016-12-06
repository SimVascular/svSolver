cmake_minimum_required(VERSION 2.8.12)

if (POLICY CMP0040)
	cmake_policy(SET CMP0040 OLD)
endif()
if (POLICY CMP0046)
	cmake_policy(SET CMP0046 OLD)
endif()
if (POLICY CMP0053)
	cmake_policy(SET CMP0053 OLD)
endif()
if (POLICY CMP0054)
	cmake_policy(SET CMP0054 OLD)
endif()


#-----------------------------------------------------------------------------
Project(SV)
#-----------------------------------------------------------------------------
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake"
	"${CMAKE_MODULE_PATH}")

#-----------------------------------------------------------------------------
# Include Macros
include(SimVascularMacros)
include(CheckLibraryExists)

SET(CMAKE_SKIP_BUILD_RPATH  TRUE)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
SET(CMAKE_INSTALL_RPATH "")
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

#-----------------------------------------------------------------------------
# Include Initial Options
include(SimVascularOptions)
include(SimVascularSystemCheck)
include(SimVascularVersion)
include(SimVascularInternals)
include(SimVascularFunctionCheckCompilerFlags)
#-----------------------------------------------------------------------------
# Include Dependent Options
include(SimVascularDependentOptions)

#-----------------------------------------------------------------------------
# Set EXE names for the executables
set(SV_MESHSIM_ADAPTOR_EXE "svadapt")
set(SV_PRESOLVER_EXE "svpre")
set(SV_FLOWSOLVER_EXE "svsolver")
set(SV_POSTSOLVER_EXE "svpost")

#-----------------------------------------------------------------------------
# start internal cache variables
set(SV_INCLUDE_DIRS "")

#-----------------------------------------------------------------------------
# Includes
#-----------------------------------------------------------------------------
include(SimVascularInstallSetup)
include(SimVascularHomeSetup)

#-----------------------------------------------------------------------------
# Setting up default directories for SimVascular Externals
# Note: *These can be changes by the user if they have moved the sv_extern directories*
# This is part of the legacy build system
find_package(Doxygen)
if(DOXYGEN_FOUND)
  file(TO_NATIVE_PATH "${SV_BINARY_DIR}/Doxygen/" SV_DOCS_DIR_WORK)
  set(SV_DOCS_DIR ${SV_DOCS_DIR_WORK} CACHE PATH "Location to place docs")
  configure_file(${SV_SOURCE_DIR}/../Documentation/simvascular.Doxyfile.in
    ${SV_BINARY_DIR}/simvascular.Doxyfile @ONLY)
  add_custom_target(doc
    ${DOXYGEN_EXECUTABLE} ${SV_BINARY_DIR}/simvascular.Doxyfile
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Generating API documentation with Doxygen" VERBATIM
    )
endif(DOXYGEN_FOUND)

#-----------------------------------------------------------------------------
# We can not begin enabling libraries
# Libraries that we always need...
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# VTK
if(SV_USE_VTK_SHARED)
  set(SV_EXTERNAL_SHARED_LIBS ${SV_EXTERNAL_SHARED_LIBS} VTK)
  set(SV_INSTALL_EXTERNALS ON)
endif()
simvascular_external(VTK DOWNLOADABLE
  COMPONENTS
  vtkFiltersFlowPaths vtkWrappingTcl
  vtkRenderingTk vtkCommonDataModel vtkCommonCore vtkChartsCore vtkCommonExecutionModel
  vtkFiltersCore vtkIOLegacy)
if(SV_USE_SYSTEM_VTK)
  simvascular_get_external_path_from_include_dir(VTK)
endif()

#-----------------------------------------------------------------------------
# tkcximage (Legacy)
if(WIN32)
  if(SV_USE_TKCXIMAGE)
    find_library(TKCXIMAGE_DLL tkcximage)
    if(TKCXIMAGE_DLL)
      set(TKCXIMAGE_DLL_LIBRARY ${TKCXIMAGE_DLL})
      get_filename_component(TKCXIMAGE_DLL_PATH ${TKCXIMAGE_DLL} DIRECTORY CACHE)
      set(SV_EXTERNAL_SHARED_LIBS ${SV_EXTERNAL_SHARED_LIBS} "TKCXIMAGE")
    endif()
  endif()
endif()

#-----------------------------------------------------------------------------
# ZLIB
if(SV_USE_ZLIB)
  set(USE_ZLIB ON)
  simvascular_third_party(zlib)
  if(NOT SV_USE_SYSTEM_ZLIB)
    set(ZLIB_LIBRARY ${SV_LIB_THIRDPARTY_ZLIB_NAME})
  else()
    find_package(ZLIB)
  endif()
else()
  unset(ZLIB_LIBRARY CACHE)
endif()

#-----------------------------------------------------------------------------
# Flowsolver
#-----------------------------------------------------------------------------
if(SV_THREEDSOLVER_SOLVERIO_REDIRECT)
  set(GLOBAL_DEFINES "${GLOBAL_DEFINES} -DBUILD_WITH_FLOWSOLVER_STDOUT_STDERR_REDIRECT")
endif()

#-----------------------------------------------------------------------------
#  SVLS
# svLS depends on the THREEDSOLVER build state so it must be here.
if(SV_THREEDSOLVER_USE_SVLS)
  set(SVLS_BUILD_TYPE "Source")
  #simvascular_external(svls SVEXTERN_DEFAULT)
  set(svSolver_USE_MPI ON)
endif()

if(SV_THREEDSOLVER_USE_LESLIB)
  find_package(LESLIB REQUIRED)
endif()

#-----------------------------------------------------------------------------
# Add libraries for flowsolver
if(SV_USE_SPARSE)
  set(USE_SPARSE ON)
  simvascular_third_party(sparse)
  if(NOT SV_USE_SYSTEM_SPARSE)
    set(SPARSE_LIBRARY ${SV_LIB_THIRDPARTY_SPARSE_NAME})
  else()
    find_package(SPARSE)
  endif()
endif()

if(SV_USE_METIS)
  set(USE_METIS ON)
  simvascular_third_party(metis)
  if(NOT SV_USE_SYSTEM_METIS)
    set(METIS_LIBRARY ${SV_LIB_THIRDPARTY_METIS_NAME})
  else()
    find_package(METIS)
  endif()
endif()

if(SV_USE_NSPCG)
  set(USE_NSPCG ON)
  simvascular_third_party(nspcg)
  if(NOT SV_USE_SYSTEM_NSPCG)
    set(NSPCG_LIBRARY ${SV_LIB_THIRDPARTY_NSPCG_NAME})
  else()
    find_package(NSPCG)
  endif()
endif()

#-----------------------------------------------------------------------------
# Remaining optional dependencies
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Enable Interl Runtime libs if we need or want them
if(svSolver_USE_INTEL)
  simvascular_external(INTELRUNTIME SYSTEM_DEFAULT SHARED_LIB)
  if(SV_USE_SYSTEM_ZLIB)
    set(INTELRUNTIME_LIB_DIR "" CACHE PATH "A directory where intel runtimes may be, use this if its not in the path")
  endif()
else()
    unset(INTELRUNTIME_LIBRARIES CACHE)
endif()

#-----------------------------------------------------------------------------
# Enable Fortran
enable_language(Fortran)
if(CMAKE_Fortran_COMPILER_ID MATCHES "GNU")
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -ffixed-line-length-132 -cpp")
else()
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -132 -fpp")
endif()

#-----------------------------------------------------------------------------
# Enable MPI
if(svSolver_USE_MPI OR USE_MPI)
  set(svSolver_USE_MPI ON)
  if (NOT svSolver_USE_DUMMY_MPI)
    simvascular_external(MPI SYSTEM_DEFAULT SHARED_LIB)
    if(MPI_FOUND)
      get_filename_component(MPI_LIBRARY_DIR ${MPI_LIBRARY} PATH)
    endif()
    if(WIN32)
      find_library(MPI_fmpich2_LIBRARY NAMES fmpich2 HINTS ${MPI_LIBRARY_DIR})
      set(MPI_EXTRA_LIBRARY ${MPI_EXTRA_LIBRARY} ${MPI_fmpich2_LIBRARY} ${MPI_CXX_LIBRARIES})
      #message("${MPI_EXTRA_LIBRARY}")
    endif()

    if(SV_DEVELOPER_OUTPUT)
      #getListOfVarsPrefix("MPI" _VARLIST)
      #print_vars(_VARLIST)
    endif()
    if(SV_USE_MSMPI)
      # TODO(jmerkow): Change this.
      set(SV_MPI_DIR "${CMAKE_CURRENT_SOURCE_DIR}/ThirdParty/msmpi/")
      set(SV_MPI_LIB_DIR  "${SV_MPI_DIR}/Lib/x64/")
      set(SV_MPI_INCLUDE_PATH "${SV_MPI_DIR}/Include/;${SV_MPI_DIR}/Include/x64/")
      set(SV_MPI_EXTRA_LIBRARY "")
      set(SV_MPI_Fortran_LIBRARIES "${SV_MPI_LIB_DIR}/msmpi.lib;${SV_MPI_LIB_DIR}/msmpifmc.lib;${SV_MPI_LIB_DIR}/msmpifec.lib")
    else()
      set(SV_MPI_EXTRA_LIBRARY ${MPI_EXTRA_LIBRARY})
      set(SV_MPI_Fortran_LIBRARIES ${MPI_Fortran_LIBRARIES})
      set(SV_MPI_INCLUDE_PATH ${MPI_Fortran_INCLUDE_PATH})
    endif()
    include_directories(${SV_MPI_INCLUDE_PATH})
  else()
    set(SV_MPI_EXTRA_LIBRARY lib_extra_simvascular_dummympi)
    set(SV_MPI_Fortran_LIBRARIES lib_fortran_simvascular_dummympi)
  endif()
endif()

#-----------------------------------------------------------------------------
# Enable Testing
if(BUILD_TESTING)
  enable_testing()
  add_subdirectory(Testing)
endif()

if(WIN32)
  if(SV_ENABLE_DISTRIBUTION)
    set(SV_USE_WIN32_REGISTRY ON)
  endif()
endif()
if(SV_USE_WIN32_REGISTRY_FORCE_OFF)
   set(SV_USE_WIN32_REGISTRY OFF)
   message(STATUS "Forcing SV_USE_WIN32_REGISTRY off, even in distribution mode")
   message(STATUS "SV_USE_WIN32_REGISTRY: ${SV_USE_WIN32_REGISTRY}")
endif()

set(git_protocol "git")

#-----------------------------------------------------------------------------
# Now we need to finish configuring now that the external projects are configured
#-----------------------------------------------------------------------------
foreach(proj ${SV_EXTERNALS_LIST})
  if(SV_USE_${proj}_SHARED)
    ExternalProject_Install_CMake_NoSB(${proj})
  endif()
endforeach()

#-----------------------------------------------------------------------------
# VTK Setup
find_package(VTK COMPONENTS
  vtkFiltersFlowPaths vtkWrappingTcl vtkRenderingTk
  vtkCommonDataModel vtkCommonCore vtkChartsCore vtkCommonExecutionModel
  vtkFiltersCore vtkIOLegacy ${VTK_MODULES_ENABLED})
include(${VTK_USE_FILE})
include(VTKSVConfig)
#Does not pick up vtkCommonCoreTCL, need to add manually
set(VTK_LIBRARIES ${VTK_LIBRARIES} vtkCommonCoreTCL)
if(SV_USE_VTK_SHARED)
  set(SV_INSTALL_EXTERNALS ON)
  set(GLOBAL_DEFINES "${GLOBAL_DEFINES} -DSV_USE_VTK_SHARED")
endif()
if(${VTK_DIR} MATCHES "intel")
  set(VTK_LIBRARIES ${VTK_LIBRARIES} ${INTELRUNTIME_LIBRARIES})
endif()

#-----------------------------------------------------------------------------
# Add GLOBAL_DEFINES to definitions
dev_message(" Global Flags: ${GLOBAL_DEFINES}")
add_definitions(${GLOBAL_DEFINES})

#-----------------------------------------------------------------------------
# Add Local Includes
set(LOCAL_LIBDIR Lib)
set(SV_SCRIPT_TARGETS "" CACHE INTERNAL "" FORCE)
set(INDENTS "")

#-----------------------------------------------------------------------------
# Include the Core subdirs
# These are handled here because other sub directories depend on them
# set
set(SV_INCLUDE_DIRS ${SV_INCLUDE_DIRS}
  "FlowSolvers/Include"
  )

foreach(dir ${SV_INCLUDE_DIRS})
  add_subdirectory(${dir})
  include_directories(${SV_SOURCE_DIR}/${dir} ${SV_BINARY_DIR}/${dir})
endforeach()

#-----------------------------------------------------------------------------
# Add directories
# Modules
add_subdirectory(FlowSolvers)

#-----------------------------------------------------------------------------
# Configure Exe Scripts, this should be the last subdirectory
include(SimVascularInstallLibs)
