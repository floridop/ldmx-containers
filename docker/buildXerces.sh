#!/bin/bash

xercesfile=xerces-c-3.2.2

mkdir -p /ldmx/build
cd /ldmx/build
curl -OL http://apache.mirrors.hoobly.com//xerces/c/3/sources/${xercesfile}.tar.gz
tar -zxvf ${xercesfile}.tar.gz
cd ${xercesfile}
./configure --prefix=/ldmx/libs/xerces
make install
export XercesC_DIR=/ldmx/libs/xerces
