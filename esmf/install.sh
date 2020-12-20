#!/bin/bash
set -x
set -e

repo="https://git.code.sf.net/p/esmf/esmf"
workdir=`pwd`
srcdir=${workdir}/src_$$

version=$1
if [ -z "${version}" ] ; then
  echo "ERROR: Please specificy an ESMF version to install."
  echo "Usage: $0 <VERSION> <COMPILER>"
  exit 1
fi

compiler=$2
if [ -z "${compiler}" ] ; then
  echo "ERROR: Please specificy a compiler to use for ESMF install. "
  echo "Usage: $0 <VERSION> <COMPILER>"
  exit 1
fi

if [ ! -f module.env.${compiler} ] ; then
  echo "ERROR: Cannot find module.env.${compiler} file to setup compile environment."
  exit 1
fi
source module.env.${compiler}

if [ -d ${version}_${compiler} ] ; then
  echo "ERROR: Previous esmf directory already exists. Please remove and restart!"
  exit 1
fi

/bin/rm -rf ${srcdir}
ver=`echo ${version} | sed 's/\./_/g'`
git clone -b ESMF_${ver} --depth 1 ${repo} ${srcdir}
if [ ! -d ${srcdir} ] ; then
  echo "ERROR: Problem checking out ESMF from remote repository"
  exit 1
fi

export ESMF_DIR=${srcdir}
export ESMF_COMPILER=${compiler}
if [ "${compiler}" == "gnu" ] ; then
  export ESMF_COMPILER=gfortran
fi
export ESMF_INSTALL_PREFIX=${workdir}/${version}_${compiler}
export ESMF_BOPT=O3
export ESMF_SHARED_LIB_BUILD=OFF
export ESMF_OPENMP=ON
#export ESMF_LAPACK=/opt/cray/pe/libsci/19.06.1/INTEL/16.0/x86_64/lib/libsci_intel_mp.a
export ESMF_INSTALL_MODDIR=include
export ESMF_INSTALL_LIBDIR=lib
export ESMF_INSTALL_BINDIR=bin

cd ${srcdir}
gmake -j 8 lib
gmake info
gmake install
cd ..

/bin/rm -rf ${srcdir}

# goodbye
