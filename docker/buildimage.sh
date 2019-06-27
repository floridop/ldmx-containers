#!/bin/bash

# Downloads additional binary software that can be copied directly in the machine
./prepareImage.sh

docker build -t ldmx:centosbase -f Dockerfile0.centosbase .
docker build -t ldmx:centosbase.gcc -f Dockerfile0.centosbase.gcc .
docker build -t ldmx:0.1 -f Dockerfile1.xerces .
docker build -t ldmx:0.2 -f Dockerfile2.root .
docker build -t ldmx:0.3 -f Dockerfile3.Geant4 .
docker build -t ldmx:0.4 -f Dockerfile4.ldmx-sw .

