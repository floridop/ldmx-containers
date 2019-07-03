---------------------------------------------------------------
# ldmx-containers - docker
---------------------------------------------------------------
#### LDMX build environment using docker containers.
#### Author: Florido Paganelli florido.paganelli@hep.lu.se
#### Last edit: 2019-07-03
---------------------------------------------------------------

# § 0. Table of Contents

  1. Scope of this document and repo  
  2. Docker build  
  2.1 Prerequisites  
  2.2 Description of scripts architecture  
  2.3 Directory structure inside the container  
  2.4 Perform the container build  
  2.5 Use the built image  
      2.5.1 Persistent data and mounting volumes  
  2.6 Develop against the container

# § 1. Scope of this document and repo

This document describes how to create a a working docker environment 
where users can test and build the ldmx-sw on any machine with a 
similar environment as in a cluster.

# § 2. Docker build

This code will create a docker image for running LDMX software inside docker containers.


## § 2.1 Prerequisites

Install docker according to:

  <https://docs.docker.com/install/>

## § 2.2 Description of scripts architecture

The docker build uses the following components:

dockerfiles: Files used by docker
scripts: scripts run inside the dockerfile to install the software
/tests: scripts to test the software
/tools: this dir contains useful tools for developers.

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
5. Create the work-environment container for building, testing the software and run jobs

The prepareImage.sh script at the moment only downloads the latest version of cmake. 
It can be used for further out-of-image customizations, so that one doesn't have to download/rebuild
additional software that requires no compilation at every image rebuild.

The main script `buildimage.sh` downloads and 
prepares pre-compiled software creates the images in order.

All the installed software can be found inside the container in the ldmx folder.
The rest of libraries are placed in system folders depending on the distribution
used. Currently it is CentOS7.

## § 2.3 Directory structure inside the container

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

## § 2.4 Perform the container build

Run 

```shell
 cd docker
 ./buildimage.sh
```

## § 2.5 Use the built image(s)

You can test the final built docker image ldmx:dev by running

```shell
   docker run -it ldmx:dev
```

It will open a shell inside the container where the ldmx environment 
is already fully initialized.

When the image is run as a container as above, it will create an 
environment with all LDMX dependencies.

A container is not a persistent virtual machine, it's a temporary 
environment whose lifetime is the same as a simple application. 
One cannot start the LDMX container in the background; 
it is a stateless container. 

One can start a bash terminal inside it, and the container will survive 
until the bash terminal exists. After exiting, 
all the contents of folders belonging to the container 
modified inside the container will be destroyed.

### § 2.5.1 Persistent data and mounting volumes

If one wants the container to interact with external data, one must 
mount local folders inside the container. In that case the changes to the
contents of mounted folders modified inside the container will be
persistent.

For example, if my data is in a folder in my home 
  /home/pflorido/data
and I want to modify it with the LDMX container, I must mount it when starting
the container, using the `-v` option:

```shell
   docker run -v /home/pflorido/data:/home/pflorido/data -it ldmx:dev
```

The syntax of the `-v` option is `<host folder>:<container folder>`

Docker will create the missing folder paths to mount inside the container
automatically. One can have multiple `-v` options for multiple paths.

More about mounting volumes can be found in docker documentation.

Examples:

To mount your home folder inside the container:

```shell
   docker run -v /my-home-folder-path:/my-home-folder-path -it ldmx:dev
```

To mount your home folder inside the container, and a data folder from some storage:

```shell
   docker run -v /my-home-folder-path:/my-home-folder-path -v /mydatastorage:/mydatastorage -it ldmx:dev
```

## § 2.6 Develop against the container


To develop against the container, one can develop the software
anywhere but then the folder with the software must be mounted in the
container for processing (see §2.5 about mounting volumes)

One usually needs to mount at least three folders (they might be the same)

- Source folder (where your own sources are)
- Build folder (if one wants to keep and inspect the build files)
- Target installation folder (where the compiled software will be installed)

In the following examples we will assume that all the three folders are in a single folder,
as such:
/home/username/ldxm
                /ldmx-sw
                /ldmx-sw/build
                /ldmx-sw-install
 

### 2.6.1 Interactive development inside the container

To develop interactively, start the container with the command:

```shell
   docker run -v /home/username/ldmx:home/username/ldmx -it ldmx:dev
```

Once inside the container shell, simply cd into /home/username/ldmx

and follow the instructions to build the ldmx software as usual inside that folder.

It is important that one sources the newly created ldmx environment as it 
differs from the one inside the ldmx-tests container.

```shell
   source /home/username/ldmx/ldmx-sw-install/bin/ldmx-setup-env.sh
```

I have provided a script to build a custom version of ldmx in the /tools
directory, called customBuildLDMX.sh

Simply cd in a directory structure that contains the `ldmx-sw` sources directory,
and run

  /ldmx/tools/customBuildLDMX.sh

It will create the same layout as explained in § 2.6
