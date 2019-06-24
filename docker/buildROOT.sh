#!/bin/bash

rootfiles='root_v6.06.08.source'

curl -OL https://root.cern.ch/download/${rootfiles}.tar.gz
tar -zxvf ${rootfiles}.tar.gz
mkdir root-6.06.08-build
cd root-6.06.08-build
cmake -Dgdml=ON ../root-6.06.08
make 
export ROOTDIR=$PWD
