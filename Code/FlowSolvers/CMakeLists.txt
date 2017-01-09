##=========================================================================
 #
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
 #
 #=========================================================================#
set(INDENTS "${INDENTS}    ")
set(SV_FLOWSOLVERS_DIR ${CMAKE_CURRENT_SOURCE_DIR})

macro(svsolver_third_party _pkg)
	string(TOLOWER "${_pkg}" _lower)
	string(TOUPPER "${_pkg}" _upper)

	set(options OPTIONAL VERSION_EXACT
		DOWNLOADABLE SYSTEM_DEFAULT
		SVEXTERN_CONFIG ADD_INSTALL
		)
	set(oneValueArgs VERSION)
	set(multiValueArgs PATHS HINTS COMPONENTS)

	CMAKE_PARSE_ARGUMENTS("svsolver_third_party"
		"${options}"
		"${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
	set(${_upper}_SUBDIR ThirdParty/${_pkg})
	if(svsolver_third_party_SYSTEM_DEFAULT)
		option(SV_USE_SYSTEM_${_upper} "Use system ${_pkg}" ON)
	else()
		option(SV_USE_SYSTEM_${_upper} "Use system ${_pkg}" OFF)
	endif()

	mark_as_advanced(SV_USE_SYSTEM_${_upper})

  configure_file(${SV_FLOWSOLVERS_DIR}/../${${_upper}_SUBDIR}/simvascular_${_lower}.h.in
		${SV_BINARY_DIR}/${${_upper}_SUBDIR}/simvascular_${_lower}.h)
  include_directories(BEFORE ${SV_BINARY_DIR}/../${${_upper}_SUBDIR} ${SV_FLOWSOLVERS_DIR}/${${_upper}_SUBDIR})
	if(SV_USE_SYSTEM_${_upper})
		set(${_upper}_LIBRARIES)
		set(${_upper}_LIBRARY)
	else()
    set(${_upper}_LIBRARY_NAME _simvascular_thirdparty_${_lower})
    include(${SV_FLOWSOLVERS_DIR}/${${_upper}_SUBDIR}/simvascular_${_lower})
	endif()
endmacro()

option(SV_USE_SPARSE "Use sparse Library" ON)
option(SV_USE_METIS "Use metis Library" ON)
option(SV_USE_NSPCG "Use nspcg Library" ON)
#-----------------------------------------------------------------------------
# Add libraries for flowsolver
if(SV_USE_SPARSE)
	SET(USE_SPARSE ON)
	svsolver_third_party(sparse)
	if(NOT SV_USE_SYSTEM_SPARSE)
          set(SPARSE_LIBRARY ${SV_LIB_THIRDPARTY_SPARSE_NAME})
	else()
		find_package(SPARSE)
	endif()
endif()

if(SV_USE_METIS)
	SET(USE_METIS ON)
	svsolver_third_party(metis)
	if(NOT SV_USE_SYSTEM_METIS)
          set(METIS_LIBRARY ${SV_LIB_THIRDPARTY_METIS_NAME})
	else()
		find_package(METIS)
	endif()
endif()

if(SV_USE_NSPCG)
	SET(USE_NSPCG ON)
	svsolver_third_party(nspcg)
	if(NOT SV_USE_SYSTEM_NSPCG)
          set(NSPCG_LIBRARY ${SV_LIB_THIRDPARTY_NSPCG_NAME})
	else()
		find_package(NSPCG)
	endif()
endif()


if(SV_SUPERBUILD)
	RETURN()
	###### RETURN_SUPERBUILD ######
endif()
if(SV_USE_THREEDSOLVER)
	message(STATUS "FlowSolvers")
	message(STATUS "${INDENTS}ThreeDSolver")
	add_subdirectory(ThreeDSolver)
endif()



