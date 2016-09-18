#/bin/sh -f

if [ "$1" == "centos_6" ]; then
  rm -Rf $HOME/svsolver/externals/bin/gnu-4.4.7/x64
  mkdir -p $HOME/svsolver/externals/bin/gnu-4.4.7/x64
  pushd $HOME/svsolver/externals/bin/gnu-4.4.7/x64
  wget http://simvascular.stanford.edu/downloads/public/svsolver/externals/linux/centos_6/gnu-4.4.7/latest/linux.gnu-4.4.7.x64.vtk-6.2.0-latest.tar.gz
  tar xvzf linux.gnu-4.4.7.x64.vtk-6.2.0-latest.tar.gz
  popd
elif [ "$1" == "ubuntu_14" ]; then
  rm -Rf $HOME/svsolver/externals/bin/gnu-4.8/x64
  mkdir -p $HOME/svsolver/externals/bin/gnu-4.8/x64
  pushd $HOME/svsolver/externals/bin/gnu-4.8/x64
  wget http://simvascular.stanford.edu/downloads/public/svsolver/externals/linux/centos_6/gnu-4.8/latest/linux.gnu-4.8.x64.vtk-6.2.0-latest.tar.gz
  tar xvzf linux.gnu-4.8.x64.vtk-6.2.0-latest.tar.gz
  popd
elif [ "$1" == "msvc-12.5" ]; then
  rm -Rf $HOME/svsolver/externals/bin/msvc-12.5/x64
  mkdir -p $HOME/svsolver/externals/bin/msvc-12.5/x64
  pushd $HOME/svsolver/externals/bin/msvc-12.5/x64
  wget http://simvascular.stanford.edu/downloads/public/svsolver/externals/windows/10/msvc_2013/latest/windows.msvc-12.5.x64.vtk-6.2.0-latest.tar.gz
  tar xvzf windows.msvc-12.5.x64.vtk-6.2.0-latest.tar.gz
  popd
fi

   
