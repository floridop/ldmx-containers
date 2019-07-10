---------------------------------------------------------------
# ldmx-containers - singularity 
---------------------------------------------------------------
#### Proof of concept for LDMX build environment using 
#### Singularity containers.
#### Author: Florido Paganelli florido.paganelli@hep.lu.se
#### Last edit: 2019-07-10
---------------------------------------------------------------

# § 0. Table of Contents

  1. Scope of this document and repo  
  2. Singularity container
  3. Using the singularity container
  3.1. For running jobs
  3.2. For building

# § 1. Scope of this document and repo 

This is preliminary work to implement cluster-leverl Singularity support for the software.
At the moment this is based on docker containers but in the future
could be a native container.
In what follows is a description of how to use the docker container
in a singularity-enabled cluster.

# §  2. Singularity Container

There is no native Singularity container at the moment of writing.

The suggested way to build a singularity container is to use 
the docker compatibility approach. 

Once the LDMX docker container is build or placed in docker hub, the
user can do

```shell
    singularity pull docker://<dockercontainer>
```

Example:

```shell
    singularity pull docker://floridop/ldmx:user
```

Singularity will rebuild the image according to the local settings.
   
For the docker container, see further documentation in the /docker folder.

# §  3. Using the singularity container

The singularity container can be used to run jobs directly if it contains
an existing build of ldmx or can be used as an environment to build newer
versions of ldmx-sw, that is, if you are a developer you can use it
to bring up the development environment.

In most cases on a cluster one will need to mount additional paths for
to make the jobs work. For this reason a sample wrapper script is
provided that can be adjusted to the site needs, `ldmx-img`.

This script just runs singularity against the ldmx image and 
adds site-specific mounts (using the -B option), then passes a parameter to the
original image, tipically the executable or script one wants 
to run in the image.

Users must just run the wrapper script with an appropriate parameter and
they will be inside the ldmx environment. For example to get a 
bash prompt:

```shell
   ldmx-img bash
```

