#!/bin/bash

# Copyright (c) Stanford University, The Regents of the University of
#               California, and others.
#
# All Rights Reserved.
#
# See Copyright-SimVascular.txt for additional details.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
# OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#
# build nompi by default
#

./quick-build-linux.sh

#
# now build mpich version
#

echo "SV_USE_DUMMY_MPI=0" >> global_overrides.mk
echo "SV_USE_OPENMPI=0" >> global_overrides.mk
echo "SV_USE_MPICH=1" >> global_overrides.mk

echo "MPI_NAME    = mpich" > pkg_overrides.mk
echo "MPI_INCDIR  = \$(wordlist 2,99,\$(shell mpif90.mpich -link_info))" >> pkg_overrides.mk
echo "MPI_LIBS    = \$(wordlist 2,99,\$(shell mpicxx.mpich -link_info)) \$(wordlist 2,99,\$(shell mpif90.mpich -link_info))" >> pkg_overrides.mk
echo "MPI_SO_PATH = " >> pkg_overrides.mk
echo "MPIEXEC_PATH  = " >> pkg_overrides.mk
echo "MPIEXEC       = mpiexec.mpich" >> pkg_overrides.mk

make

#
# now build openmpi version
#

echo "SV_USE_DUMMY_MPI=0" >> global_overrides.mk
echo "SV_USE_OPENMPI=1" >> global_overrides.mk
echo "SV_USE_MPICH=0" >> global_overrides.mk

echo "MPI_NAME    = openmpi" > pkg_overrides.mk
echo "MPI_INCDIR  = \$(shell mpif90.openmpi --showme:compile)" >> pkg_overrides.mk
echo "MPI_LIBS    = \$(shell mpicxx.openmpi --showme:link) \$(shell mpif90.openmpi --showme:link)" >> pkg_overrides.mk
echo "MPI_SO_PATH = \$(shell which mpiexec.openmpi)/../.." >> pkg_overrides.mk
echo "MPIEXEC_PATH  = \$(dir $(shell which mpiexec.openmpi))" >> pkg_overrides.mk
echo "MPIEXEC       = mpiexec.openmpi"

make
