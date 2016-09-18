#/bin/sh -f
mkdir -p $HOME/svsolver/externals/bin/gnu-4.4.7/x64
pushd $HOME/svsolver/externals/bin/gnu-4.4.7/x64
wget http://simvascular.stanford.edu/downloads/public/svsolver/externals/linux/centos_6/gnu-4.4.7/latest/linux.gnu-4.4.7.x64.vtk-6.2.0-latest.tar.gz
tar xvzf linux.gnu-4.4.7.x64.vtk-6.2.0-latest.tar.gz
popd
