---------------------------------------------------------------
# ldmx-containers
---------------------------------------------------------------
#### Proof of concept for LDMX build environment using containers.
#### Author: Florido Paganelli florido.paganelli@hep.lu.se
---------------------------------------------------------------

# § 0. Table of Contents

  1. Scope of this document and repo  
  2. Docker build  
  2.1 Prerequisites  
  2.2 Description of scripts architecture  
  2.3 Perform the container build  
  2.4 Use the built image  

# § 1. Scope of this document and repo

This is preliminary work to implement cluster-lever Singularity support for the software.
The byproduct will be a workind docker environment where users can test
the ldmx-sw on any machine with a similar environment as in a cluster.

# § 2. Docker build

This code will create a docker image for running LDMX software inside docker containers.

## § 2.1 Prerequisites

Install docker according to:

  <https://docs.docker.com/install/>

## § 2.2 Description of scripts architecture

This code follows docker idea of layered builds. Every Dockerfile creates 
as step of the configuration so that one can build the machine step by step 
and change things. The dependencies within softwares make it so that there is a
compilation order that is reflected in the Dockerfile steps.

The notation used is as follows
```
   Dockerfile<integer>.<softwarename>
```

Where <integer> is the build step and <softwarename> is the compiled software.

The build steps must be done in ascendent order 0-4.

The bash scripts are passed to the docker containers and they simply perform 
the builds as described in 

   <https://github.com/LDMX-Software/ldmx-sw/blob/master/README.md> 

With modifications required to live inside a container.

The main script buildimage.sh creates the images in order.

All the installed software can be found inside the container in the ldmx folder.
The rest of libraries are placed in system folders depending on the distribution
used. Currently it is CentOS7.

## § 2.3 Perform the container build

Run 

```shell
 cd docker
 ./buildimage.sh
```

## § 2.4 Use the built image

WIP
