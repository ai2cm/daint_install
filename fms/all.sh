#!/bin/bash

\rm -rf gnu_r4; ./install.sh gnu r4 y
\rm -rf gnu_r8; ./install.sh gnu r8 y
\rm -rf gnu_r4_noomp; ./install.sh gnu r4 n
\rm -rf gnu_r8_noomp; ./install.sh gnu r8 n

\rm -rf intel_r4; ./install.sh intel r4 y
\rm -rf intel_r8; ./install.sh intel r8 y
\rm -rf intel_r4_noomp; ./install.sh intel r4 n
\rm -rf intel_r8_noomp; ./install.sh intel r8 n

