
# vtk
if [[ $SV_SUPER_OPTIONS == *UNTAR_VTK* ]]; then
  echo "UNTAR_VTK"
  rm -Rf ../vtk-8.1.1
  tar xf Originals/vtk/VTK-8.1.1.tar.gz
  mv VTK-8.1.1 ../vtk-8.1.1
  pushd ../vtk-8.1.1
  patch -p1 < ../BuildHelpers/Patches/2019.06/patch-vtk-8.1.1-windows.patch
  patch -p1 < ../BuildHelpers/Patches/2019.06/patch-vtk-8.1.1-tk-windows.patch
  popd
fi
