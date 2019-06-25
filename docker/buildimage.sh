#!/bin/bash

docker build -t ldmx:centosbase -f /export/hepdrift/dockerstuff/ldmx/Dockerfile0.centosbase .
docker build -t ldmx:0.1 -f /export/hepdrift/dockerstuff/ldmx/Dockerfile1.xerces .
docker build -t ldmx:0.2 -f /export/hepdrift/dockerstuff/ldmx/Dockerfile2.Geant4 .
docker build -t ldmx:0.3 -f /export/hepdrift/dockerstuff/ldmx/Dockerfile3.root .
docker build -t ldmx:0.4 -f /export/hepdrift/dockerstuff/ldmx/Dockerfile4.ldmx-sw .

