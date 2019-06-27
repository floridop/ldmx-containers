#!/bin/bash

mkdir tests
cd tests

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
