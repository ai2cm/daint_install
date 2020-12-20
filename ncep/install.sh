#!/bin/bash
set -x
set -e

repo="https://github.com/VulcanClimateModeling/NCEPlibs"
workdir=`pwd`
srcdir=${workdir}/src_$$

machine=$1
if [ -z "${machine}" ] ; then
  echo "ERROR: Please specificy an machine to install."
  echo "Usage: $0 <MACHINE> <COMPILER>"
  exit 1
fi

compiler=$2
if [ -z "${compiler}" ] ; then
  echo "ERROR: Please specificy a compiler to use for NCEPlibs install. "
  echo "Usage: $0 <MACHINE> <COMPILER>"
  exit 1
fi

if [ ! -f module.env.${compiler} ] ; then
  echo "ERROR: Cannot find module.env.${compiler} file to setup compile environment."
  exit 1
fi
source module.env.${compiler}

if [ -d ${workdir}/${compiler} ] ; then
  echo "ERROR: Previous NCEPlibs directory already exists. Please remove and restart!"
  exit 1
fi

/bin/rm -rf ${srcdir}
git clone --depth 1 ${repo} ${srcdir}
if [ ! -d ${srcdir} ] ; then
  echo "ERROR: Problem checking out NCEPlibs from remote repository"
  exit 1
fi

export JASPER_INC=/users/olifu/vulcan/jasper.install
export PNG_INC=/users/olifu/vulcan/libpng.install
export NETCDF=${NETCDF_DIR}

mkdir -p ${workdir}/${compiler}

cd ${srcdir}
echo "y" | ./make_ncep_libs.sh -s ${machine} -c ${compiler} -d ${workdir}/${compiler} -o 1
cd ..

/bin/rm -rf ${srcdir}

