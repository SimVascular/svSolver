set(FSRCS mpi_stubs.f)
set(CSRCS mpi_stubs_c.c)

add_library(lib_fortran_simvascular_dummympi ${SV_LIBRARY_TYPE} ${FSRCS})
add_library(lib_extra_simvascular_dummympi ${SV_LIBRARY_TYPE} ${CSRCS})

if(SV_INSTALL_LIBS)
  install(TARGETS ${lib}
    RUNTIME DESTINATION ${SV_INSTALL_RUNTIME_DIR} COMPONENT CoreExecutables
    LIBRARY DESTINATION ${SV_INSTALL_LIBRARY_DIR} COMPONENT CoreLibraries
    ARCHIVE DESTINATION ${SV_INSTALL_ARCHIVE_DIR} COMPONENT CoreLibraries
    )
endif()
