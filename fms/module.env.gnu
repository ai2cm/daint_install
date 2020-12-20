#!/bin/bash
module load daint-gpu
module switch PrgEnv-cray PrgEnv-gnu
module load cray-netcdf

if [ "$omp" == "y" ] ; then
  omp_flag="-fopenmp"
else
  omp_flag=""
fi

if [ "$real_kind" == "r4" ] ; then
  real_flag=""
  real_pp="-DOVERLOAD_R4 -DOVERLOAD_R8"
else
  real_flag="-fdefault-double-8 -fdefault-real-8"
  real_pp=""
fi

export CC=cc
export CXX=CC
export CFLAGS="-g -O3 -fPIC -mavx -D__IFC ${omp_flag}"

export FC=ftn
export FCFLAGS="-g -O2 -fcray-pointer -ffree-line-length-none -fno-range-check -fPIC ${real_flag} ${omp_flag}"

export LDFLAGS="${omp_flag}"

export CPPFLAGS="-Duse_LARGEFILE -DMAXFIELDMETHODS_=500 ${real_pp}"
export LOG_DRIVER_FLAGS="--comments"

