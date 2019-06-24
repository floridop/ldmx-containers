#!/bin/bash

# Author: Florido Paganelli florido.paganelli@hep.lu.se
# Last edit: 20190624
#
# This file downloads and prepares the requires software for the LDMX
# project to create a docker image with the needed software.
# Requirements are taken from
#   https://github.com/LDMX-Software/ldmx-sw
#

tmpdir='tmp'

mkdir tmp
cd tmp

cmakefile='cmake-3.6.2-Linux-x86_64'

curl -OL https://github.com/Kitware/CMake/releases/download/v3.6.2/${cmakefile}.tar.Z


tar xvf ${cmakefile}.tar.Z

mv ${cmakefile} cmakedirs
