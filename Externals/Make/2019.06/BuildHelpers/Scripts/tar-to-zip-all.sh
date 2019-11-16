BUILDDATE=`date +%F`

SV_TAR_FILE_PREFIX=REPLACEME_SV_TAR_FILE_PREFIX.${BUILDDATE}
SV_ZIP_FILE_PREFIX=REPLACEME_SV_TAR_FILE_PREFIX.${BUILDDATE}

rm -Rf zip_output_tmp
mkdir -p zip_output_tmp

# vtk
if [[ $SV_SUPER_OPTIONS == *ZIP_VTK* ]]; then
  echo "ZIP_VTK"
  REPLACEME_TAR -C zip_output_tmp/ -xvzf tar_output/$SV_TAR_FILE_PREFIX.REPLACEME_SV_VTK_DIR.tar.gz
  pushd zip_output_tmp
  REPLACEME_ZIP -r ../zip_output/$SV_ZIP_FILE_PREFIX.REPLACEME_SV_VTK_DIR.zip REPLACEME_SV_VTK_DIR
  popd
fi

rm -Rf zip_output_tmp
