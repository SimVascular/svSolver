#
#  Create directories
#

mkdir -p tmp
mkdir -p tar_output
mkdir -p zip_output

#
#  Build everything, but can manually override for advanced users
#
#  e.g. to build only MITK:
#   export SV_SUPER_OPTIONS="UNTAR_UNZIP_ALL WGET_MITK UNTAR_MITK BUILD_MITK ARCHIVE_MITK ZIP_MITK"
#

if [ -z "$SV_SUPER_OPTIONS" ]; then
   echo "NOTE: SV_SUPER_OPTIONS defaulting to all possible options."
   rm -Rf tar_output
   mkdir -p tar_output
   rm -Rf zip_output
   mkdir -p zip_output
   SV_SUPER_OPTIONS="UNTAR_UNZIP_ALL"
   SV_SUPER_OPTIONS="WGET_VTK         UNTAR_VTK         BUILD_VTK         ARCHIVE_VTK         ZIP_VTK         $SV_SUPER_OPTIONS"
   export SV_SUPER_OPTIONS
fi

echo "SV_SUPER_OPTIONS for build: $SV_SUPER_OPTIONS"

#
# wget all source code
#

source Scripts/build-sv-externals-helper-wget-generic.sh

#
# unpack all of the source code
#

source Scripts/untar-unzip-source-all.sh

#
# must have primary destination build dir for subst commands
#

sed -f CompileScripts/sed-script-x64_cygwin-options-cl.sh CompileScripts/create-toplevel-build-dir.sh > tmp/create-toplevel-build-dir.sh
chmod a+rx ./tmp/create-toplevel-build-dir.sh

#
# make build scripts
#

# vtk
if [[ $SV_SUPER_OPTIONS == *BUILD_VTK* ]]; then
  echo "CREATE_BUILD_SCRIPT_VTK"
  sed -f CompileScripts/sed-script-x64_cygwin-options-cl.sh CompileScripts/compile-cmake-vtk-generic.sh > tmp/compile.cmake.vtk.cl.sh
  chmod a+rx ./tmp/compile.cmake.vtk.cl.sh
fi

# create script to create tar files
if [[ $SV_SUPER_OPTIONS == *ARCHIVE_* ]]; then
  echo "CREATE_BUILD_SCRIPT_TAR_FILES_ALL"
  sed -f CompileScripts/sed-script-x64_cygwin-options-cl.sh Scripts/create-archives-generic.sh > tmp/create-archives-windows.cl.sh
  chmod a+rx ./tmp/create-archives-windows.cl.sh
fi

# create script to create zip files
if [[ $SV_SUPER_OPTIONS == *ZIP_* ]]; then
  echo "CREATE_BUILD_SCRIPT_ZIP_FILES_ALL"
  sed -f CompileScripts/sed-script-x64_cygwin-options-cl.sh Scripts/tar-to-zip-all.sh > tmp/tar-to-zip-all.windows.cl.sh
  chmod a+rx ./tmp/tar-to-zip-all.windows.cl.sh
fi

# should probably do this on a case-by-case basis inside of cmake builders
echo "CREATE_POST_PROCESS_ALL_CMAKE_CONFIG"
  sed -f CompileScripts/sed-script-x64_cygwin-options-cl.sh Scripts/replace-explicit-paths-in-config-cmake.tcl > tmp/replace-explicit-paths-in-config-cmake.tcl
  chmod a+rx ./tmp/replace-explicit-paths-in-config-cmake.tcl

#
# make sure toplevel build directory exists
#

./tmp/create-toplevel-build-dir.sh >& ./tmp/stdout.create-toplevel-build-dir.txt

#
# run installers
#

#
# compile code
#

# vtk
if [[ $SV_SUPER_OPTIONS == *BUILD_VTK* ]]; then
  echo "BUILD_VTK"
  ./tmp/compile.cmake.vtk.cl.sh >& ./tmp/stdout.vtk.cl.txt
  tclsh ./tmp/replace-explicit-paths-in-config-cmake.tcl
fi

#
# check generated cmake configs for hardcorded paths
#
tclsh ./tmp/replace-explicit-paths-in-config-cmake.tcl

#
# create tar files for distrution
#

source ./tmp/create-archives-windows.cl.sh >& ./tmp/stdout.create-archives-windows.cl.txt

source ./tmp/tar-to-zip-all.windows.cl.sh >& ./tmp/stdout.tar-to-zip-all.windows.cl.txt

