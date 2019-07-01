---------------------------------------------------------------
# ldmx-containers
---------------------------------------------------------------
#### Proof of concept for LDMX build environment using containers.
#### Author: Florido Paganelli florido.paganelli@hep.lu.se
#### Last edit: 2019-06-27
---------------------------------------------------------------

# § 0. Table of Contents

  1. Scope of this document and repo  
  2. Docker build  
  2.1 Prerequisites  
  2.2 Description of scripts architecture  
  2.3 Directory structure of the container
  2.4 Perform the container build  
  2.5 Use the built image  
  Appendix A: TODO

# § 1. Scope of this document and repo

This is preliminary work to implement cluster-lever Singularity support for the software.
The byproduct will be a working docker environment where users can test
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

Where `<integer>` is the build step and `<softwarename>` is the compiled software.

The build steps must be done in ascendent order 0-5.

The bash scripts are passed to the docker containers and they simply perform 
the builds as described in 

   <https://github.com/LDMX-Software/ldmx-sw/blob/master/README.md> 

With modifications required to live inside a container.

The current order is as follows:

0. Build a basic CentOS7 image with the minimum requirements for LDMX 
0a. Add custom gcc version
0b. Add custom python version and packages
1. Add Xerces to the image
2. Add ROOT to the image
3. Add Geant4 to the image, compiled with LDMX specifics
4. Compile LDMX-SW
5. Create the work-environment container for testing the software and run jobs

The prepareImage.sh script at the moment only downloads the latest version of cmake. 
It can be used for further out-of-image customizations, so that one doesn't have to download/rebuild
additional software that requires no compilation at every image rebuild.

The main script `buildimage.sh` downloads and 
prepares pre-compiled software creates the images in order.

All the installed software can be found inside the container in the ldmx folder.
The rest of libraries are placed in system folders depending on the distribution
used. Currently it is CentOS7.

The custom directory structure of the container for ldmx is as such:

```
/ldmx                 # main ldmx folder, currently contains also bash scripts
  /build              # folder where sources are copied and software is built
     /<softwarename>  # sources for specific software
     / ...
  /libs               # folder with built software
     /<softwarename>  # binaries for specific software
     /...
  /tests              # folders where basic tests suggested by Lene are ran.
                      #   one can inspect the logs in this folder to understand
                      #   if the image built correctly.
```

In the tests folder there is a script setupTestData.sh that prepares the 
test environment and runs the tests. Can be used to understand how to 
perform further testing.

## § 2.3 Perform the container build

Run 

```shell
 cd docker
 ./buildimage.sh
```

## § 2.4 Use the built image(s)

You can test the final built docker image ldmx:user by running

```shell
   docker run -it ldmx:tests
```

It will open a shell inside the container where the ldmx environment 
is already fully initialized. 

## § Appendix A : TODO

- Container folders
  - move all the script to some /containerscripts folder
  
- understand modularization better -- what changes the most?

- minimize size of the Docker image(s)

- create a dev image to develop ldmx sw

- Document conversion to singularity
  - include aurora scripts
