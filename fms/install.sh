#!/bin/bash

# stop on all errors
set -e

repo="https://github.com/VulcanClimateModeling/fv3gfs-fortran.git"
workdir=`pwd`
srcdir=${workdir}/src_$$

compiler=$1
if [ -z "${compiler}" ] ; then
  echo "ERROR: Please specificy a compiler to use for FMS install. "
  echo "Usage: $0 <COMPILER> <REAL_KIND> <OMP>"
  exit 1
fi

real_kind=$2
if [ "$real_kind" != "r4" -a "$real_kind" != "r8" ] ; then
  echo "ERROR: Real kind must be one of r4 and r8."
  echo "Usage: $0 <COMPILER> <REAL_KIND> <OMP>"
  exit 1
fi

omp=$3
if [ "$omp" != "y" -a "$omp" != "n" ] ; then
  echo "ERROR: OMP must be y/n"
  echo "Usage: $0 <COMPILER> <REAL_KIND> <OMP>"
  exit 1
fi
if [ "$omp" == "n" ] ; then
  noomp="_noomp"
fi

if [ ! -f module.env.${compiler} ] ; then
  echo "ERROR: Cannot find module.env.${compiler} file to setup compile environment."
  exit 1
fi
source module.env.${compiler}

if [ -d ${compiler}_${real_kind}${noomp} ] ; then
  echo "ERROR: Previous fms directory already exists. Please remove and restart!"
  exit 1
fi

/bin/rm -rf ${srcdir}
git clone --depth 1 ${repo} ${srcdir}
if [ ! -d ${srcdir} ] ; then
  echo "ERROR: Problem checking out FMS from remote repository"
  exit 1
fi

# compile and install
cd ${srcdir}/FMS
export PATH=${PATH}:/project/s1053/install/bats/bin
autoreconf --install -vfi
./configure --prefix=${workdir}/${compiler}_${real_kind}${noomp}
make
make install
cd ../../
/bin/rm -rf ${srcdir}

# rename *.a from FMS to fms for legacy applications
cd ${compiler}_${real_kind}${noomp}/lib
ln -s libFMS.a libfms.a
cd ../../

# goodbye
