#!/bin/bash

rootfiles='root_v6.06.08'

mkdir -p /ldmx/build
cd /ldmx/build
curl -OL https://root.cern.ch/download/${rootfiles}.source.tar.gz
tar -zxvf ${rootfiles}.source.tar.gz
mkdir -p /ldmx/libs/root-6.06.08-build
cd /ldmx/libs/root-6.06.08-build
cmake -Dgdml=ON /ldmx/build/root-6.06.08
make 
export ROOTDIR=$PWD
