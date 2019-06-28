#!/bin/bash

mkdir /ldmx/tests
cd /ldmx/tests

echo "symlinking test data in $PWD"
#cp /ldmx/build/ldmx-sw/MagFieldMap/*dat.tar.gz .
tar -xvzf /ldmx/build/ldmx-sw/MagFieldMap/BmapCorrected3D_13k_unfolded_scaled_1.15384615385.dat.tar.gz

ln -s /ldmx/build/ldmx-sw/Detectors/data/ldmx-det-full-v5-fieldmap-magnet/* .
ln -s /ldmx/build/ldmx-sw/Detectors/data detectors

echo "

Possible tests:
# Not working, something changed in the api
#ldmx-sim /ldmx/build/ldmx-sw/SimApplication/macros/4pt0_gev_electron_pn_biasing.mac

# This worked
#ldmx-sim /ldmx/build/ldmx-sw/SimApplication/macros/4pt0_gev_electron_gun.mac

"

runtests() {
  TESTCMD=$1
  OUTFILE=$2

  echo "Running test $TESTCMD"
  echo "Output written to $OUTFILE"

  $TESTCMD 2>&1 | tee $OUTFILE

}

runtests 'ldmx-sim /ldmx/build/ldmx-sw/SimApplication/macros/4pt0_gev_electron_gun.mac' ldmx-sim_test1-out.log
runtests 'ldmx-app file.py' filepy_test0-out.log
runtests 'ldmx-app file1.py' filepy_test1-out.log

