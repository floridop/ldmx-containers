#!/bin/bash

git clone https://github.com/LDMXAnalysis/geant4.git
cd geant4
git checkout tags/LDMX.10.2.3_v0.2 -b LDMX.10.2.3_v0.2
mkdir build; cd build
cmake -DGEANT4_USE_GDML=ON -DGEANT4_INSTALL_DATA=ON -DXERCESC_ROOT_DIR=${XercesC_DIR}/install \
    -DGEANT4_USE_OPENGL_X11=ON -DCMAKE_INSTALL_PREFIX=../install -DGEANT4_USE_SYSTEM_EXPAT=OFF ..
make install
cd ../install
export G4DIR=$PWD


