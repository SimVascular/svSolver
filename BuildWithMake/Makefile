# Hey emacs, this is a -*- makefile -*-

# Copyright (c) 2009-2011 Open Source Medical Software Corporation,
#                         University of California, San Diego.
# 
# All rights reserved. 
#
# Portions copyright (c) 1999-2007 Stanford University,
# Nathan Wilson, Ken Wang, Charles Taylor.
# 
# See SimVascular Acknowledgements file for additional
# contributors to the source code. 
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
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

TOP = .

include $(TOP)/include.mk

all-shared: shared-pre-build static-build shared-build exec-shared-build

all: mixed

mixed: static-pre-build static-build shared-build exec-build

fast:
	-make shared-pre-build static-build
	-make -j6 shared-build exec-shared-build
	make shared-build exec-shared-build

mksedscript:
	if [ -e tclscript ];then /bin/rm -f tclscript;fi
	if [ -e sedscript ];then /bin/rm -f sedscript;fi
	if [ -e mysolver ];then /bin/rm -f mysolver;fi
	-echo "puts \"s+REPLACEME_SOFTWARE_PLATFORM+$(CLUSTER)+g\"" > tclscript 
	-echo "puts \"s+REPLACEME_CXX_COMPILER_VERSION+$(CXX_COMPILER_VERSION)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_FORTRAN_COMPILER_VERSION+$(FORTRAN_COMPILER_VERSION)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_SV_HOME+[file rootname `pwd`]/..+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_SV_VERSION+$(SIMVASCULAR_VERSION)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_LIB_BUILD_DIR+$(LIB_BUILD_DIR)+g\"" >> tclscript
ifeq ($(CLUSTER),x64_cygwin)
	-echo "puts \"s+REPLACEME_SV_OS+windows+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_OPEN_SOFTWARE_BINARIES_TOPLEVEL+`cygpath -u $(OPEN_SOFTWARE_BINARIES_TOPLEVEL)`+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_LICENSED_SOFTWARE_TOPLEVEL+`cygpath -u $(LICENSED_SOFTWARE_TOPLEVEL)`+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_INTEL_COMPILER_SO_PATH++g\"" >> tclscript
ifeq ($(SV_USE_MPI),1)
  ifdef $(MPI_SO_PATH)
	-echo "puts \"s+REPLACEME_MPI_SO_PATH+`cygpath -u $(MPI_SO_PATH)`+g\"" >> tclscript
  endif
  ifdef $(MPIEXEC_PATH)
	-echo "puts \"s+REPLACEME_MPIEXEC_PATH+`cygpath -u $(MPIEXEC_PATH)`+g\"" >> tclscript
  endif
	-echo "puts \"s+MPIEXEC+$(MPIEXEC)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_MPI_NAME+$(MPI_NAME)+g\"" >> tclscript
endif
ifeq ($(SV_USE_LESLIB),1)
	-echo "puts \"s+REPLACEME_LES_LICENSE_SERVER+$(LES_LICENSE_SERVER)+g\"" >> tclscript
endif
ifeq ($(SV_USE_VTK),1)
	-echo "puts \"s+REPLACEME_VTK_SO_PATH+`cygpath -u $(VTK_SO_PATH)`+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_VTK_BIN_PATH+`cygpath -u $(VTK_BINDIRS)`+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_VTK_LIB_PATH+`cygpath -u $(VTK_LIBDIRS)`+g\"" >> tclscript
endif
endif
ifeq ($(CLUSTER),x64_linux)
	-echo "puts \"s+MPIEXEC+$(MPIEXEC)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_SV_OS+linux+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_OPEN_SOFTWARE_BINARIES_TOPLEVEL+$(OPEN_SOFTWARE_BINARIES_TOPLEVEL)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_LICENSED_SOFTWARE_TOPLEVEL+$(LICENSED_SOFTWARE_TOPLEVEL)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_MPI_SO_PATH+$(MPI_SO_PATH)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_MPIEXEC_PATH+$(MPIEXEC_PATH)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_VTK_SO_PATH+$(VTK_SO_PATH)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_VTK_BIN_PATH+$(VTK_BINDIRS)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_VTK_LIB_PATH+$(VTK_LIBDIRS)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_INTEL_COMPILER_SO_PATH+$(INTEL_COMPILER_SO_PATH)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_MPI_NAME+$(MPI_NAME)+g\"" >> tclscript
endif

ifeq ($(CLUSTER),x64_macosx)
	-echo "puts \"s+MPIEXEC+$(MPIEXEC)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_SV_OS+macosx+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_OPEN_SOFTWARE_BINARIES_TOPLEVEL+$(OPEN_SOFTWARE_BINARIES_TOPLEVEL)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_LICENSED_SOFTWARE_TOPLEVEL+$(LICENSED_SOFTWARE_TOPLEVEL)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_MPI_SO_PATH+$(MPI_SO_PATH)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_MPIEXEC_PATH+$(MPIEXEC_PATH)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_VTK_SO_PATH+$(VTK_SO_PATH)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_VTK_BIN_PATH+$(VTK_BINDIR)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_VTK_LIB_PATH+$(VTK_LIBDIRS)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_INTEL_COMPILER_SO_PATH+$(INTEL_COMPILER_SO_PATH)+g\"" >> tclscript
	-echo "puts \"s+REPLACEME_MPI_NAME+$(MPI_NAME)+g\"" >> tclscript
endif
	-/usr/bin/tclsh tclscript > sedscript
	-rm -f tclscript

common-pre-build: mksedscript create-svsolver-options-file post-build
	mkdir -p Bin
	mkdir -p Lib
	mkdir -p ../Code/Source/Include/Make
	touch ../Code/Source/Include/Make/simvascular_options.h
	touch ../Code/Source/Include/Make/simvascular_version.h

shared-pre-build: common-pre-build

static-pre-build: common-pre-build

shared-build:
	for i in ${SHARED_LIBDIRS}; do ( \
	  echo "building shared directory ($$i)"; \
	  if [ -e $$i ];then \
	  cd $$i; \
	  $(MAKE) shared;fi ) ; done

static-third-party-build:
	for i in ${THIRD_PARTY_LIBDIRS}; do ( \
	  echo "static building directory ($$i)"; \
	  if [ -e $$i ];then \
	  cd $$i; \
	  $(MAKE) SV_STATIC_BUILD=1 lib;fi ) ; done

static-build: static-third-party-build
	for i in ${LIBDIRS}; do ( \
	  echo "static building directory ($$i)"; \
	  if [ -e $$i ];then \
	  cd $$i; \
	  $(MAKE) SV_STATIC_BUILD=1 lib;fi ) ; done

exec-build:
	for i in ${EXECDIRS}; do ( \
	  echo "building execs ($$i)"; \
	  if [ -e $$i ];then \
	  cd $$i; \
	  $(MAKE) SV_STATIC_BUILD=1 static;fi ) ; done

exec-shared-build:
	for i in ${EXECDIRS}; do ( \
	  echo "building execs ($$i)"; \
	  if [ -e $$i ];then \
	  cd $$i; \
	  $(MAKE) shared;fi ) ; done

post-build: mksedscript
	-sed -f sedscript $(TOP)/Release/developer_wrapper_scripts/developer-core-script > mypre
	-sed -f sedscript $(TOP)/Release/developer_wrapper_scripts/developer-core-script > mypost
	-sed -f sedscript $(TOP)/Release/developer_wrapper_scripts/developer-svpre-script >> mypre
	-sed -f sedscript $(TOP)/Release/developer_wrapper_scripts/developer-svpost-script >> mypost
ifeq ($(CLUSTER),x64_linux)
#	-sed -f sedscript $(TOP)/Release/developer_wrapper_scripts/developer-svsolver-nompi-linux-script > mysolver-nompi
#	-sed -f sedscript $(TOP)/Release/developer_wrapper_scripts/developer-svsolver-nompi-linux-script > mysolver-$(MPI_NAME)
endif
ifeq ($(CLUSTER),x64_macosx)
#	-sed -f sedscript $(TOP)/Release/developer_wrapper_scripts/developer-svsolver-nompi-macosx-script > mysolver-nompi
#	-sed -f sedscript $(TOP)/Release/developer_wrapper_scripts/developer-svsolver-nompi-macosx-script > mysolver-$(MPI_NAME)
endif

ifeq ($(CLUSTER),x64_cygwin)
	-sed -f sedscript $(TOP)/Release/developer_wrapper_scripts/developer-svsolver-nompi-windows-script > mysolver-nompi
	-sed -f sedscript $(TOP)/Release/developer_wrapper_scripts/developer-svsolver-nompi-windows-script > mysolver-msmpi
	$(info  ### MPI_NAME is $(MPI_NAME))
	#-sed -f sedscript $(TOP)/Release/developer_wrapper_scripts/developer-svsolver-nompi-windows-script > mysolver-$(MPI_NAME)
endif
	-chmod a+rx mypre
	-chmod a+rx mypost
	-chmod a+rx mysolver-nompi
	-chmod a+rx mysolver-$(MPI_NAME)
#	-rm -f sedscript

create-svsolver-options-file:
	mkdir -p $(TOP)/../Code/FlowSolvers/Include/Make
	@echo "#define VER_CORONARY $(SV_THREEDSOLVER_USE_CORONARY)" > $(TOP)/../Code/FlowSolvers/Include/Make/cvFlowsolverOptions.h
	@echo "#define VER_CLOSEDLOOP $(SV_THREEDSOLVER_USE_CLOSEDLOOP)" >> $(TOP)/../Code/FlowSolvers/Include/Make/cvFlowsolverOptions.h
	@echo "#define VER_VARWALL $(SV_THREEDSOLVER_USE_VARWALL)" >> $(TOP)/../Code/FlowSolvers/Include/Make/cvFlowsolverOptions.h
	@echo "#define VER_USE_VTK $(SV_THREEDSOLVER_USE_VTK)" >> $(TOP)/../Code/FlowSolvers/Include/Make/cvFlowsolverOptions.h

veryclean:  clean
	if [ -e ext ];then /bin/rm -fR ext;fi

clean:
	for i in ${THIRD_PARTY_LIBDIRS}; do ( \
	  echo "super cleaning directory ($$i)"; \
	  if [ -e $$i ];then \
	  cd $$i; \
	  $(MAKE) NO_DEPEND=1 veryclean;fi ) ;done
	for i in ${LIBDIRS}; do ( \
	  echo "super cleaning directory ($$i)"; \
	  if [ -e $$i ];then \
	  cd $$i; \
	  $(MAKE) NO_DEPEND=1 veryclean;fi ) ; done
	for i in ${SHARED_LIBDIRS}; do ( \
	  echo "super cleaning directory ($$i)"; \
	  if [ -e $$i ];then \
	  cd $$i; \
	  $(MAKE) NO_DEPEND=1 veryclean;fi ) ; done
	for i in ${EXECDIRS}; do ( \
	  echo "super cleaning directory ($$i)"; \
	  if [ -e $$i ];then \
	  cd $$i; \
	  $(MAKE) NO_DEPEND=1 SV_STATIC_BUILD=1 veryclean;fi ) ; done
	for fn in $(TOP)/*~; do /bin/rm -f $$fn;done
	for fn in $(TOP)/Lib/*; do /bin/rm -f -r $$fn; done
	for fn in $(TOP)/Bin/*; do /bin/rm -f -r $$fn; done
	if [ -e mysolver-nompi ];then /bin/rm -f mysolver-nompi;fi
	if [ -e mysolver-msmpi ];then /bin/rm -f mysolver-msmpi;fi
	if [ -e mypost ];then /bin/rm -f mypost;fi
	if [ -e mypre ];then /bin/rm -f mypre;fi
	/bin/rm -f  ../Code/Source/Include/Make/simvascular_options.h
	/bin/rm -f  ../Code/Source/Include/Make/simvascular_version.h
	/bin/rm -f  ../Code/FlowSolvers/Include/Make/cvFlowsolverOptions.h
	/bin/rm -fR ../Code/Source/Include/Make
	/bin/rm -fR ../Code/FlowSolvers/Include/Make
	/bin/rm -f  sedscript

