export PARENT_URL=http://simvascular.stanford.edu/downloads/public/svsolver/externals/2019.06/src/originals/

mkdir Originals
pushd Originals

mkdir -p vtk
pushd vtk
wget $PARENT_URL/vtk/VTK-8.1.1.tar.gz
popd

popd
