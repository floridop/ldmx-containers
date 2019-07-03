#!/bin/bash

# This scripts builds the software based on the base container. 
# the users can customize the default values below so that
# they don't need to enter parameters.

#### USER-DEFINED DEFAULTS ###########

# Uncomment relevant config entries below to set your own default.

# Destination where to install built LDMX software (CMAKE_INSTALL_PREFIX)
#INSTALL_PATH='/tmp/ldmx-install'

# Container used to build the software
#ENV_CONTAINER_NAME='ldmx:tests'

# Path to the source code (Where CMakeLists.txt is)
#SOURCE_PATH='.'

# Temporary path where the software will be built
#BUILD_PATH=`mktemp -d --suffix=LDXM-build`

# Tag of the selected Geant4 version, directory name (Geant4_DIR, will be prefixed with $G4DIR/lib64/)
#G4TAG='Geant4-10.2.3'

# Location of the python executable
#PYTHON_EXECUTABLE=`which python`


######### Helper functions  ###########

# sets defaults and canonicalize paths
function setdefaults {
INSTALL_PATH_DESC='Destination where to install built LDMX software (CMAKE_INSTALL_PREFIX)'
INSTALL_PATH=${INSTALLPATH:='/tmp/ldmx-install'}
INSTALL_PATH=`readlink -f $INSTALL_PATH`
ENV_CONTAINER_NAME_DESC='Container used to build the software'
ENV_CONTAINER_NAME=${ENV_CONTAINER_NAME:='ldmx:tests'}
SOURCE_PATH_DESC='Path to the source code (Where CMakeLists.txt is)'
SOURCE_PATH=${SOURCE_PATH:='.'}
SOURCE_PATH=`readlink -f $SOURCE_PATH`
BUILD_PATH_DESC='Temporary path where the software will be built'
BUILD_PATH=${BUILD_PATH:=`mktemp -d --suffix=LDXM-build`}
G4TAG_DESC="Tag of the selected Geant4 version, directory name (Geant4_DIR, will be prefixed with $G4DIR/lib64/)"
G4TAG=${G4TAG:='Geant4-10.2.3'}
PYTHON_EXECUTABLE_DESC='Location of the python executable'
PYTHON_EXECUTABLE=${PYTHON_EXECUTABLE:=`which python`}

}

function showhelp {
HELPSTR=$(cat <<EOF
   This script builds the LDMX software against a docker container.
   Starts the container with the proper mounts 
   and creates folders accordingly.
   Options:
      -h show this help
      -p print default values
EOF
)

echo "   Usage: $0 [options]"
echo ""
echo "$HELPSTR" 
echo ""

}

function printdefaults {
	echo
	echo "Printing defaults:"
	for ENVVAR in INSTALLPATH ENV_CONTAINER_NAME SOURCE_PATH BUILD_PATH G4TAG PYTHON_EXECUTABLE ; do
		DESC="${ENVVAR}_DESC"
		echo "${!DESC}:"
		echo "   $ENVVAR = ${!ENVVAR}"
	done
	echo "you may change these defaults by editing $0"
	echo
}

###### script starts

# set default values if not set 
setdefaults

# parse options
while getopts ":ph" opt; do
  case $opt in
    h)
      showhelp
      exit 0
      ;;
    p)
      printdefaults
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      showhelp
      exit 1
      ;;
  esac
done

# check that we are in the correct dir
cd $SOURCE_PATH
ISSRCDIR=$(grep ldmx-sw README.md)
if ! test $?; then
   echo "Wrong directory. Run this script from the ldmx source folder."
   exit 1
fi

printdefaults

########################################

echo "build starting..."

# cd to build folder, compile ldmx, install
BUILDCOMMAND="cd $BUILD_PATH && cmake -DPYTHON_EXECUTABLE=$PYTHON_EXECUTABLE -DGeant4_DIR=\$G4DIR/lib64/$G4TAG -DROOT_DIR=\$ROOTDIR -DXercesC_DIR=\$XercesC_DIR -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH $SOURCE_PATH && make install"

#BUILDCOMMAND="cd $BUILD_PATH && ls $SOURCE_PATH $BUILD_PATH $INSTALL_PATH"

# Mount relevant folders and start container
docker run -v $SOURCE_PATH:$SOURCE_PATH -v $BUILD_PATH:$BUILD_PATH -v $INSTALL_PATH:$INSTALL_PATH $ENV_CONTAINER_NAME bash -c "$BUILDCOMMAND"

