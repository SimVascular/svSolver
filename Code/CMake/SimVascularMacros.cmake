# Copyright (c) 2014-2015 The Regents of the University of California.
# All Rights Reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
# OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

include (CMakeParseArguments)

macro(dev_message string)
  if(SV_DEVELOPER_OUTPUT)
    message("DEV: ${string}")
  endif()
endmacro()

#-----------------------------------------------------------------------------
# simvascular_external - Macro to find libraries needed by simvascular
# and create the necessary variables to load and link them.
#
macro(simvascular_external _pkg)
  string(TOLOWER "${_pkg}" _lower)

  dev_message("Configuring ${_pkg}")

  set(options OPTIONAL VERSION_EXACT
    DOWNLOADABLE SYSTEM_DEFAULT
    SVEXTERN_CONFIG ADD_INSTALL SHARED_LIB NO_MODULE
    )
  set(oneValueArgs VERSION)
  set(multiValueArgs PATHS HINTS COMPONENTS)

  cmake_parse_arguments("simvascular_external"
    "${options}"
    "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

  set(EXTRA_ARGS)
  if(simvascular_external_COMPONENTS)
    set(EXTRA_ARGS COMPONENTS ${simvascular_external_COMPONENTS})
  endif()

  if(simvascular_external_NO_MODULE)
    set(EXTRA_ARGS ${EXTRA_ARGS} NO_MODULE)
  endif()

  set(${_pkg}_VERSION ${simvascular_external_VERSION})
  if(simvascular_external_VERSION_EXACT)
    set(${_pkg}_VERSION ${${_pkg}_VERSION} EXACT)
  endif()

  unset(ARG_STRING)
  set(_paths "${simvascular_external_PATHS}")
  if(NOT simvascular_external_PATHS)
    set(_paths "${CMAKE_MODULE_PATH}")
  endif()

  #message(STATUS "Search paths for ${_pkg}Config.cmake: ${_paths}")

  if(simvascular_external_SYSTEM_DEFAULT)
    option(SV_USE_SYSTEM_${_pkg} "Use system ${_pkg}" ON)
    mark_as_advanced(SV_USE_SYSTEM_${_pkg})
  else()
    option(SV_USE_SYSTEM_${_pkg} "Use system ${_pkg}" OFF)
  endif()

  if((NOT SV_SUPERBUILD AND simvascular_external_SVEXTERN_CONFIG) OR
    (simvascular_external_SVEXTERN_CONFIG AND SV_USE_SYSTEM_${_pkg}))

  find_package(${_pkg} ${EXTRA_ARGS}
    PATHS ${CMAKE_CURRENT_SOURCE_DIR}/CMake
    NO_CMAKE_MODULE_PATH
    NO_DEFAULT_PATH)
  elseif(NOT SV_SUPERBUILD)
    find_package(${_pkg} ${EXTRA_ARGS})
  elseif(SV_USE_SYSTEM_${_pkg})
    find_package(${_pkg} ${EXTRA_ARGS})
  endif()

  if(simvascular_external_DOWNLOADABLE)
    set(SV_DEPENDS ${SV_DEPENDS} ${_pkg})
    list( REMOVE_DUPLICATES SV_DEPENDS )
  endif()

  if(SV_USE_${_pkg})
    set(USE_${_pkg} ON)
  endif()

  if(simvascular_external_SHARED_LIB)
    set(SV_EXTERNAL_SHARED_LIBS ${SV_EXTERNAL_SHARED_LIBS} ${_pkg})
  endif()

  if(${_pkg}_FOUND)
    message(STATUS "PKG ${_pkg} found!")
    if( ${_pkg}_INCLUDE_DIR )
      dev_message("Including dir: ${${_pkg}_INCLUDE_DIR}")
      # This get many of them
      include_directories(${${_pkg}_INCLUDE_DIR})
    endif()
    if(SV_INSTALL_EXTERNALS)
      if(simvascular_external_ADD_INSTALL)
      	getListOfVars("${_pkg}" "LIBRARY" ${_pkg}_VARS_INSTALL)
      	foreach(lib_install ${${_pkg}_VARS_INSTALL})
      	  list(APPEND ${_pkg}_LIBRARY_INSTALL "${${lib_install}}")
      	endforeach()
      	#message(STATUS "${_pkg}_LIBRARY_INSTALL: ${${_pkg}_LIBRARY_INSTALL}")
      	#install(FILES "${${_pkg}_LIBRARY_INSTALL}" DESTINATION ${SV_INSTALL_EXTERNAL_LIBRARY_DIR})
      endif()
    endif()
  endif()
  unset(simvascular_external_SVEXTERN_CONFIG)
  unset(simvascular_external_ADD_INSTALL)
  if(SV_DEVELOPER_OUTPUT)
    message(STATUS "Finished Configuring ${_pkg}")
    message(STATUS "")
  endif()
endmacro()
#-----------------------------------------------------------------------------
# unset_simvascular_external
#
macro(unset_simvascular_external _pkg)
  string(TOLOWER "${_pkg}" _lower)

  set(options OPTIONAL VERSION_EXACT DOWNLOADABLE SVEXTERN_DEFAULT SVEXTERN_CONFIG)
  set(oneValueArgs VERSION)
  set(multiValueArgs PATHS HINTS)

  cmake_parse_arguments("simvascular_external"
    "${options}"
    "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

  unset(SV_USE_SYSTEM_${_pkg})
  list(REMOVE_ITEM SV_DEPENDS ${_pkg})
endmacro()

#-----------------------------------------------------------------------------
# simvascular_third_party
#
macro(simvascular_third_party _pkg)
  string(TOLOWER "${_pkg}" _lower)
  string(TOUPPER "${_pkg}" _upper)

  set(options OPTIONAL VERSION_EXACT
    DOWNLOADABLE SYSTEM_DEFAULT
    SVEXTERN_CONFIG ADD_INSTALL
    )
  set(oneValueArgs VERSION)
  set(multiValueArgs PATHS HINTS COMPONENTS)

  cmake_parse_arguments("simvascular_third_party"
    "${options}"
    "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
  set(${_upper}_SUBDIR ThirdParty/${_pkg})
  if(simvascular_third_party_SYSTEM_DEFAULT)
    option(SV_USE_SYSTEM_${_upper} "Use system ${_pkg}" ON)
  else()
    option(SV_USE_SYSTEM_${_upper} "Use system ${_pkg}" OFF)
  endif()

  mark_as_advanced(SV_USE_SYSTEM_${_upper})

  configure_file(${SV_SOURCE_DIR}/${${_upper}_SUBDIR}/simvascular_${_lower}.h.in
    ${SV_BINARY_DIR}/${${_upper}_SUBDIR}/simvascular_${_lower}.h)
  include_directories(BEFORE ${SV_BINARY_DIR}/${${_upper}_SUBDIR} ${SV_SOURCE_DIR}/${${_upper}_SUBDIR})
  if(SV_USE_SYSTEM_${_upper})
    set(${_upper}_LIBRARIES)
    set(${_upper}_LIBRARY)
  else()
    if(NOT SV_SUPERBUILD)
      set(${_upper}_LIBRARY_NAME _simvascular_thirdparty_${_lower})
      add_subdirectory(${${_upper}_SUBDIR}/simvascular_${_lower})
    endif()
  endif()
endmacro()
#-----------------------------------------------------------------------------
# print_vars - THis is a simple marco to print out a list of variables
# with their names and value, used mostly for debugging
#
macro(print_vars _VARLIST)
  foreach(var ${${_VARLIST}})
    message(STATUS "${var}: ${${var}}")
  endforeach()
  message(STATUS "")
endmacro()

macro(dev_print_vars _VARLIST)
  foreach(var ${${_VARLIST}})
    dev_message("${var}: ${${var}}")
  endforeach()
  message(STATUS "")
endmacro()


#-----------------------------------------------------------------------------
# listvars2vars - THis is a simple marco to print out a list of variables
# with their names and value, used mostly for debugging
#
macro(listvars2vals _VARLIST _VALS)
  foreach(var ${${_VARLIST}})
    set(_vals ${_vals} ${${var}})
  endforeach()
  list(REMOVE_DUPLICATES _vals)
  set(${_VALS} ${_vals})
  unset(_vals)
endmacro()

#-----------------------------------------------------------------------------
# check_library_exists_concat -
#
macro(check_library_exists_concat LIBRARY SYMBOL VARIABLE)
  check_library_exists("${LIBRARY};${LINK_LIBS}" ${SYMBOL} "" ${VARIABLE})
  if(${VARIABLE})
    set(LINK_LIBS ${LINK_LIBS} ${LIBRARY})
  endif(${VARIABLE})
endmacro ()

#-----------------------------------------------------------------------------
# simvascular_add_executable -
#
macro(simvascular_add_executable TARGET_NAME)
  set(options NO_SCRIPT)
  set(oneValueArgs DEV_SCRIPT_NAME INSTALL_SCRIPT_NAME INSTALL_COMP INSTALL_DESTINATION)
  set(multiValueArgs SRCS)

  unset(simvascular_add_executable_INSTALL_SCRIPT_NAME)
  unset(simvascular_add_executable_DEV_SCRIPT_NAME)
  unset(simvascular_add_executable_NO_SCRIPT)

  cmake_parse_arguments("simvascular_add_executable"
    "${options}"
    "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

  set(WINDOWS_ICON_RESOURCE_FILE "")
  if(WIN32)
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/icons/${TARGET_NAME}.rc")
      set(WINDOWS_ICON_RESOURCE_FILE "${CMAKE_CURRENT_SOURCE_DIR}/icons/${TARGET_NAME}.rc")
    endif()
  endif()

  set(_app_compile_flags )
  if(WIN32)
    set(_app_compile_flags "${_app_compile_flags} -DPOCO_NO_UNWINDOWS -DWIN32_LEAN_AND_MEAN")
  endif()

  if(WIN32)
    add_executable(${TARGET_NAME} WIN32 ${simvascular_add_executable_SRCS} ${WINDOWS_ICON_RESOURCE_FILE})
  else()
    add_executable(${TARGET_NAME} ${simvascular_add_executable_SRCS} ${WINDOWS_ICON_RESOURCE_FILE})
  endif()

  set_target_properties(${TARGET_NAME} PROPERTIES
    COMPILE_FLAGS "${_app_compile_flags}")

  if(simvascular_add_executable_NO_SCRIPT)
    if(	simvascular_add_executable_DEV_SCRIPT_NAME OR simvascular_add_executable_INSTALL_SCRIPT_NAME )
      message(ERROR "Cannot specify no script and specify script names!")
    endif()
    set(${TARGET_NAME}_EXECUTABLE_NAME ${TARGET_NAME} CACHE INTERNAL "" FORCE)
  endif()
  if(NOT simvascular_add_executable_NO_SCRIPT)
    if(simvascular_add_executable_DEV_SCRIPT_NAME)
      set(SV_SCRIPT_TARGETS_WORK ${SV_SCRIPT_TARGETS})
      list(APPEND SV_SCRIPT_TARGETS_WORK "${TARGET_NAME}")
      list(REMOVE_DUPLICATES SV_SCRIPT_TARGETS_WORK)
      set(SV_SCRIPT_TARGETS ${SV_SCRIPT_TARGETS_WORK} CACHE INTERNAL "" FORCE)
      set(${TARGET_NAME}_DEVELOPER_SCRIPT_NAME ${simvascular_add_executable_DEV_SCRIPT_NAME} CACHE INTERNAL "" FORCE)
      set(${TARGET_NAME}_EXECUTABLE_NAME ${${TARGET_NAME}_DEVELOPER_SCRIPT_NAME} CACHE INTERNAL "" FORCE)
    endif()
    if(simvascular_add_executable_INSTALL_SCRIPT_NAME)
      set(${TARGET_NAME}_INSTALL_SCRIPT_NAME ${simvascular_add_executable_INSTALL_SCRIPT_NAME} CACHE INTERNAL "" FORCE)
    endif()
  endif()

  # CHANGE FOR EXECUTABLE RENAME REMOVE (re enable if statement)
  if(simvascular_add_executable_INSTALL_DESTINATION)
    if(simvascular_add_executable_INSTALL_COMP)
      set(_COMPARGS COMPONENT ${simvascular_add_executable_INSTALL_COMP})
    endif()
    if(APPLE)
      install(TARGETS ${TARGET_NAME}
        RUNTIME DESTINATION ${simvascular_add_executable_INSTALL_DESTINATION}
        ${_COMPARGS})
    else()
      install(TARGETS ${TARGET_NAME}
        RUNTIME DESTINATION ${simvascular_add_executable_INSTALL_DESTINATION}
        ${_COMPARGS})
    endif()
  endif()

endmacro()

macro(simvascular_get_external_path_from_include_dir pkg)
  if(NOT ${pkg}_DIR)
    message(FATAL_ERROR "${pkg}_DIR is not set and must be set if using system")
  endif()
  if(${pkg}_INCLUDE_DIRS)
    list(GET ${pkg}_INCLUDE_DIRS 0 TMP_DIR)
    get_filename_component(TMP_DIR ${TMP_DIR} PATH)
    get_filename_component(TMP_DIR ${TMP_DIR} PATH)
  endif()
  if(${pkg}_INCLUDE_DIR)
    list(GET ${pkg}_INCLUDE_DIR 0 TMP_DIR)
    get_filename_component(TMP_DIR ${TMP_DIR} PATH)
    get_filename_component(TMP_DIR ${TMP_DIR} PATH)
  endif()
  if(NOT TMP_DIR OR NOT EXISTS ${TMP_DIR})
    message("${pkg}_INCLUDE_DIR is not set")
  else()
    set(SV_${pkg}_DIR ${TMP_DIR})
  endif()
endmacro()

macro(simvascular_get_major_minor_version version major_version minor_version)
  string(REPLACE "." ";" version_list ${version})
  list(GET version_list 0 ${major_version})
  list(GET version_list 1 ${minor_version})
endmacro()
