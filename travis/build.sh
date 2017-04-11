#!/bin/bash

set -e

if $WITH_CMAKE; then
  MAKE="make --jobs=$NUM_THREADS --keep-going"
  mkdir -p $BUILD_DIR
  cd $BUILD_DIR
  SV_EXTERNALS_ARGS=""
  if $BUILD_VTK; then
     SV_EXTERNALS_ARGS="-DSV_EXTERNALS_DOWNLOAD_VTK:BOOL=OFF"
  fi
  echo CMAKE_BUILD_ARGS: $CMAKE_BUILD_ARGS
  source $SCRIPTS/travis_cmake_config_linux_download_externals.sh
  pushd $BUILD_DIR
  $MAKE
  popd
fi

