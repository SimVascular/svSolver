set(FSRCS mpi_stubs.f)
set(CSRCS mpi_stubs_c.c)

add_library(lib_fortran_simvascular_dummympi ${SV_LIBRARY_TYPE} ${FSRCS})
add_library(lib_extra_simvascular_dummympi ${SV_LIBRARY_TYPE} ${CSRCS})
