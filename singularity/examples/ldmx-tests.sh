#!/bin/bash

# this is a sample batch system submission script 
# for ldmx singularity.

# Prerequisite:
# copy the docker/tests folder somewhere writable on the cluster.
# say: /my/writable/folder

# initialize ldmx software paths
# NOTE: this path only exists inside the singularity container!
source /ldmx/libs/ldmx-sw-install/bin/ldmx-setup-env.sh

# cd to the tests folder
cd /my/writable/folder/tests

# run the file1.py test as in docker/tests
# $SNIC_TMP is some temporary folder on a cluster node.
ldmx-app file1.py &> $SNIC_TMP/results

# Copy the result on a permanent home folder
cp $SNIC_TMP/results ~/resultContainer
