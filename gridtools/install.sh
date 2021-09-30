#!/bin/bash

# stop on all errors
set -e

main_repo="https://github.com/GridTools/gridtools"
dev_repo="https://github.com/eddie-c-davis/gridtools"
dev_branch="python-sid-adapter-buffer"

work_dir=`pwd`
exit_status=0

# GT1
src_dir="${work_dir}/1_1_3"
/bin/rm -rf ${src_dir}
git clone $main_repo $src_dir
if [ -d ${src_dir} ] ; then
  cd $src_dir
  git checkout release_v1.1
  cd ..
else
  echo "ERROR: Problem checking out GridTools 1.1.3 from remote repository"
  exit_status=1
fi

# GT2
src_dir="${work_dir}/2_1_0"
/bin/rm -rf ${src_dir}
git clone $main_repo $src_dir
if [ ! -d ${src_dir} ] ; then
  echo "ERROR: Problem checking out GridTools 2.1.0 from remote repository"
  exit_status=1
fi

# GT2-Dev
src_dir="${work_dir}/2_1_0_b"
/bin/rm -rf ${src_dir}
git clone $dev_repo $src_dir
if [ -d ${src_dir} ] ; then
  cd $src_dir
  git checkout $dev_branch
  cd ..
else
  echo "ERROR: Problem checking out GridTools '${dev_branch}' from remote repository"
  exit_status=1
fi

exit $exit_status

