# Set Coronary Flag
if(SV_THREEDSOLVER_USE_CORONARY)
  SET(VER_CORONARY 1)
else()
  SET(VER_CORONARY 0)
endif()
# Set Closed Loop Flag
if(SV_THREEDSOLVER_USE_CLOSEDLOOP)
  SET(VER_CLOSEDLOOP 1)
else()
  SET(VER_CLOSEDLOOP 0)
endif()
# Set Variable wall Flag
if(SV_THREEDSOLVER_USE_VARWALL)
  SET(VER_VARWALL 1)
else()
  SET(VER_VARWALL 0)
endif()
# Set Use VTK Flag
if(SV_THREEDSOLVER_USE_VTK)
  SET(VER_USE_VTK 1)
else()
  SET(VER_USE_VTK 0)
endif()

configure_file(simvascular_version.h.in ${CMAKE_CURRENT_BINARY_DIR}/simvascular_version.h)
configure_file(simvascular_options.h.in ${CMAKE_CURRENT_BINARY_DIR}/simvascular_options.h)

# Write include file
configure_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/cvFlowsolverOptions.h.in"
  "${CMAKE_CURRENT_BINARY_DIR}/cvFlowsolverOptions.h"
)
