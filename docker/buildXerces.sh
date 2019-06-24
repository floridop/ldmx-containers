#!/bin/bash

xercesfile=xerces-c-3.2.2

curl -OL http://apache.mirrors.hoobly.com//xerces/c/3/sources/${xercesfile}.tar.gz
tar -zxvf ${xercesfile}.tar.gz
cd ${xercesfile}
mkdir install
./configure --prefix=/ldmx/xerces/install
make install
export XercesC_DIR=/ldmx/xerces/install
