#!/bin/bash
set -x
set -e

repo="https://github.com/bats-core/bats-core.git"
workdir=`pwd`
srcdir=${workdir}/src_$$

if [ ! -f module.env ] ; then
  echo "ERROR: Cannot find module.env file to setup compile environment."
  exit 1
fi
source module.env

#if [ -d ${workdir} ] ; then
#  echo "ERROR: Previous install directory already exists. Please remove and restart!"
#  exit 1
#fi

/bin/rm -rf ${srcdir}
git clone --depth 1 ${repo} ${srcdir}
if [ ! -d ${srcdir} ] ; then
  echo "ERROR: Problem checking out bats-core from remote repository"
  exit 1
fi

mkdir -p ${workdir}

cd ${srcdir}
./install.sh ${workdir}
cd ..

/bin/rm -rf ${srcdir}

