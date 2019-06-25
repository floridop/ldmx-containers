#!/bin/bash

git clone https://github.com/LDMXAnalysis/ldmx-sw.git
cd ldmx-sw
mkdir build; cd build
cmake -DGeant4_DIR=$G4DIR/lib64/Geant4-10.2.3/ -DROOT_DIR=$ROOTDIR -DXercesC_DIR=$XercesC_DIR/install -DCMAKE_INSTALL_PREFIX=../ldmx-sw-install ..
make install
