#!/bin/bash
set -x
set -e

repo="https://github.com/ai2cm/serialbox"
workdir=`pwd`
build_dir=${workdir}/build
boost_dir=/project/s1053/install/boost/1_74_0/include

compiler=$1
if [ -z "${compiler}" ] ; then
  echo "ERROR: Please specificy a compiler to use for the serialbox install. "
  echo "Usage: $0 <COMPILER>"
  exit 1
fi
install_dir=/project/s1053/install/serialbox2_master/${compiler}


if [ ! -f module.env.${compiler} ] ; then
  echo "ERROR: Cannot find module.env.${compiler} file to setup compile environment."
  exit 1
fi
source module.env.${compiler}


/bin/rm -rf ${srcdir}
git clone --depth 1 ${repo} ${srcdir}
if [ ! -d ${srcdir} ] ; then
  echo "ERROR: Problem checking out Serialbox from remote repository"
  exit 1
fi

mkdir -p ${build_dir}
cd ${build_dir}
python -m venv venv
source venv/bin/activate
pip install cmake

cmake -DSERIALBOX_ENABLE_PYTHON=ON -DBoost_INCLUDE_DIR=${boost_dir} -DCMAKE_INSTALL_PREFIX=${install_dir} ../
cmake --build . -j6
cmake --build . --target install


/bin/rm -rf ${build_dir}

