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
include(SimVascularFunctions)
include(SimVascularMacros)
include(CheckLibraryExists)

set(CMAKE_SKIP_BUILD_RPATH  TRUE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
set(CMAKE_INSTALL_RPATH "")
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

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
# Externals
#-----------------------------------------------------------------------------
include(SimVascularExternals)

#-----------------------------------------------------------------------------
# ThirdParty
#-----------------------------------------------------------------------------
include(SimVascularThirdParty)

#-----------------------------------------------------------------------------
# Add GLOBAL_DEFINES to definitions
dev_message(" Global Flags: ${GLOBAL_DEFINES}")
if(GLOBAL_DEFINES)
  list(REMOVE_DUPLICATES GLOBAL_DEFINES)
endif()
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
# Enable distribution if turned on
if(SV_ENABLE_DISTRIBUTION)
  add_subdirectory(${SV_DISTRIBUTION_DIR} ${SV_BINARY_DISTRIBUTION_DIR})
endif()

#-----------------------------------------------------------------------------
# Configure Exe Scripts, this should be the last subdirectory
include(SimVascularInstallLibs)
add_subdirectory(Scripts)
