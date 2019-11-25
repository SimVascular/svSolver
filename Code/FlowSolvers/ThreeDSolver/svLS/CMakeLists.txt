set(lib ${SV_LIB_SVLS_NAME}${SV_MPI_NAME_EXT})

set(FSRCS ADDBCMUL.f
  BC.f
  #BICGS.f
  CGRAD.f
  COMMU.f
  CPUT.f
  DOT.f
  GE.f
  GMRES.f
  INCOMMU.f
  LHS.f
  LS.f
  NORM.f
  NSSOLVER.f
  #OMPLA.f
  PRECOND.f
  SOLVE.f
  SPARMUL.f)


add_library(${lib} ${SV_LIBRARY_TYPE} ${FSRCS})

## Set the MPI include directory here so we can use 
#  the dummyMPI mpi.h when building svLS. 
#
if(SV_USE_DUMMY_MPI)
  target_link_libraries(${lib} ${SV_LIB_DUMMY_FORTRAN_MPI_NAME})
  target_include_directories(${lib} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/../dummyMPI)
else()
  target_link_libraries(${lib} ${MPI_LIBRARY} ${MPI_Fortran_LIBRARIES})
  target_include_directories(${lib} PUBLIC ${SV_MPI_INCLUDE_PATH})
endif()

if(SV_INSTALL_LIBS)
  install(TARGETS ${lib}
    RUNTIME DESTINATION ${SV_INSTALL_RUNTIME_DIR} COMPONENT CoreExecutables
    LIBRARY DESTINATION ${SV_INSTALL_LIBRARY_DIR} COMPONENT CoreLibraries
    ARCHIVE DESTINATION ${SV_INSTALL_ARCHIVE_DIR} COMPONENT CoreLibraries
    )
endif()
if(SV_INSTALL_HEADERS)
  install(FILES ${HDRS}
    DESTINATION ${SV_INSTALL_INCLUDE_DIR}/core COMPONENT CoreHeaders
    )
endif()



