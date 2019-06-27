#!/bin/bash

#LDMXTAGS='LDMX.10.2.3_v0.2'
LDMXTAGS='LDMX.10.2.3_v0.3'


mkdir -p /ldmx/build/
cd /ldmx/build/
git clone https://github.com/LDMXAnalysis/geant4.git
cd geant4
git checkout tags/${LDMXTAGS} -b ${LDMXTAGS}
mkdir build; cd build
cmake -DGEANT4_USE_GDML=ON -DGEANT4_INSTALL_DATA=ON -DXERCESC_ROOT_DIR=${XercesC_DIR} \
    -DGEANT4_USE_OPENGL_X11=ON -DCMAKE_INSTALL_PREFIX=/ldmx/libs/geant4 -DGEANT4_USE_SYSTEM_EXPAT=OFF ..
make install
cd /ldmx/libs/geant4
export G4DIR=$PWD


