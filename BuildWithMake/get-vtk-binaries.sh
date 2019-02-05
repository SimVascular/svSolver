#/bin/sh -f

if [ "$1" == "centos_6" ]; then
  rm -Rf $HOME/svsolver/externals/bin/gnu-4.4/x64
  mkdir -p $HOME/svsolver/externals/bin/gnu-4.4/x64
  pushd $HOME/svsolver/externals/bin/gnu-4.4/x64
  wget http://simvascular.stanford.edu/downloads/public/svsolver/externals/linux/centos_6/gnu-4.4/2016.09.18/linux.gnu-4.4.x64.vtk-6.2.0-BUILD2016-09-18.tar.gz
  tar xvzf ./linux.gnu-4.4.x64.vtk-6.2.0-BUILD2016-09-18.tar.gz
  popd
elif [ "$1" == "ubuntu_14" ]; then
  rm -Rf $HOME/svsolver/externals/bin/gnu-4.8/x64
  mkdir -p $HOME/svsolver/externals/bin/gnu-4.8/x64
  pushd $HOME/svsolver/externals/bin/gnu-4.8/x64
  wget http://simvascular.stanford.edu/downloads/public/svsolver/externals/linux/ubuntu/14.04/gnu/4.8/x64/RelWithDebInfo/2016.09.18/ubuntu.14.04.gnu.4.8.x64.RelWithDebInfo.2016.09.18.vtk.6.2.0.tar.gz
  tar xvzf ./ubuntu.14.04.gnu.4.8.x64.RelWithDebInfo.2016.09.18.vtk.6.2.0.tar.gz
  popd
elif [ "$1" == "macosx_11" ]; then
  rm -Rf $HOME/svsolver/externals/bin/clang-7.3/x64
  mkdir -p $HOME/svsolver/externals/bin/clang-7.3/x64
  pushd $HOME/svsolver/externals/bin/clang-7.3/x64
  wget http://simvascular.stanford.edu/downloads/public/svsolver/externals/darwin/mac_osx/10.11/clang/7.3/x64/RelWithDebInfo/2016.09.18/mac_osx.10.11.clang.7.3.x64.RelWithDebInfo.2016.09.18.vtk.6.2.0.tar.gz
  tar xvzf ./mac_osx.10.11.clang.7.3.x64.RelWithDebInfo.2016.09.18.vtk.6.2.0.tar.gz
  popd
elif [ "$1" == "msvc-12.5" ]; then
  rm -Rf $HOME/svsolver/externals/bin/msvc-12.5/x64
  mkdir -p $HOME/svsolver/externals/bin/msvc-12.5/x64
  pushd $HOME/svsolver/externals/bin/msvc-12.5/x64
  wget http://simvascular.stanford.edu/downloads/public/svsolver/externals/windows/10/msvc_2013/2016.09.18/windows.msvc-12.5.x64.vtk-6.2.0-BUILD2016-09-18.tar.gz
  tar xvzf ./windows.msvc-12.5.x64.vtk-6.2.0-BUILD2016-09-18.tar.gz
  popd
fi

   
