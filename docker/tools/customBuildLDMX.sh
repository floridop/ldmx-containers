#!/bin/bash

# geant4 tag, will be prefixed by $G4DIR/lib64/
G4TAG='Geant4-10.2.3'

THIS_PATH=`pwd`
SOURCE_PATH=$THIS_PATH/ldmx-sw

if [ ! -d $SOURCE_PATH ] ; then
   echo "no ldmx-sw folder found, exiting"
   exit 1
fi
       	
BUILD_PATH=$SOURCE_PATH/build
INSTALL_PATH=$THIS_PATH/ldmx-sw-install

PYTHON_EXECUTABLE=`which python`

echo "creating dirs..."
mkdir -p $BUILD_PATH
cd $BUILD_PATH

echo "starting build..."
cmake -DPYTHON_EXECUTABLE=$PYTHON_EXECUTABLE -DGeant4_DIR=$G4DIR/lib64/$G4TAG/ -DROOT_DIR=$ROOTDIR -DXercesC_DIR=$XercesC_DIR -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH $SOURCE_PATH

echo $?

if [ $? -ne 0 ]; then
   echo "build failed, exiting"
   exit 1
fi

echo "installing..."
make install

if [ $? -ne 0 ]; then
   echo "install failed, exiting"
   exit 1
fi


echo "To initialize the the LDXM environment use"
echo "    source $INSTALL_PATH/bin/ldmx-setup-env.sh"
echo
