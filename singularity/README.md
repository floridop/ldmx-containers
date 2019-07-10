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
  3. Description of files
  4. Using the singularity container
  4.1. Basic usage
  4.2. For running jobs
  4.3. For code development

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
    singularity pull docker://floridop/ldmx:tests
```

Singularity will rebuild the image according to the local settings.

In most cases this will generate a file in the current directory
called

```
   ldmx-tests.simg
```
   
For information about the docker container, see further 
documentation in the /docker folder.

# § 3. Description of files

The content of the example scriptis assumes that 
1) there is a singularity image generated as described in § 2. ,
   called `ldmx-tests.simg`
2) The docker/tests folder is copied somewhere writable on the cluster,
   say the path `/my/writable/folder`

I suggest you open the scripts and files to understand how the process is done.
```
README.md : this document

 ldmx-img : A wrapper script that mounts site-specific folders
            inside the ldmx-tests.simg image and executes a command
            passed via command line. For example to start an interactive
            session inside the ldmx container run:

               ldmx-img bash

            To start some computing script `ldmx-tests.sh` run

               ldmx-img ldmx-tests.sh

examples/ folder:
 ldmx-tests.sh : An example of how to use the container environment
                   inside a script instead of interactively.

examples/SLURM folder:
  testbatch.sh : An example of how to use the container inside a SLURM script
```
I suggest to copy these files on a cluster and modify them according to 
your needs, as explained in the next sections.

# § 4. Using the singularity container

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
## 4.1  Basic Usage

The basic concept is that one can run the container as an application
to create the computing environment.

```shell
   ldmx-img ldmx-tests.sh
```

myldmxmyscript.sh is passed to the container image and run inside it.

If you want to use the ldmx- commands, you need to have this line in the script:

```shell
  source /ldmx/libs/ldmx-sw-install/bin/ldmx-setup-env.sh
```

>NOTE: The path `/ldmx/libs/ldmx-sw-install/bin/ldmx-setup-env.sh` ONLY EXISTS
      INSIDE THE CONTAINER.


>NOTE:Tests have shown that the ldmx production environment interferes 
      with the build environment. Therefore, the ldmx environment is 
      NOT initialized automatically when running the container. 
      This is why one has to call the above script as the first part
      of any LDMX script.

## 4.2 For running jobs

When running/preparing jobs to run on a singularity enabled cluster, there are few concepts one
has to understand:

1) The *production task script* is a script that uses the LDMX software. Let's call it `myproductiontask.sh`
   This should contain things you use ldmx-sw for. It can contain paths both relative
   to the container and the cluster.
2) The *singularity image* is the environment where the script runs. For a script to 
   run in a singularity image `ldxm-tests.simg` container envrironment one has to pass the script to the image:
   `ldxm-tests.simg myproductiontask.sh`
   However, the singularity image is _readonly_, and so are _all the paths inside it_. If you want to write something,
   you must *mount* some writable cluster storage path *inside the container* when you call it.
   One uses singularity's `-B` option to mount local folders:
```shell
   singularity -B /my/cluster/folder -B /my/other/cluster/folder ldmx-tests.simg myproductiontask.sh
```
   in this way the production task script can write on the folders `/my/cluster/folder` and `/my/other/cluster/folder`
   when running inside the container environment.
   The user home path is usually mounted by default by singularity, and it's writable, so there is no need
   to specify the -B option.
3) The ldmx container *wrapper script* `ldmx-img` is used to simplify the mount task above, and potentially other
   tedious tasks that should be done in production. 
   The singularity image is readonly, and so are all the paths inside it. If you want to write something,
   you must *mount* some writable cluster path *inside the container* when you call it at step 2).
   To do this, and make it easier for all users to use the same environment, the `ldmx-img` *wrapper script* is 
   used.
   The wrapper script uses singularity's `-B` option to mount local folders:
```shell
   singularity -B /my/cluster/folder -B /my/other/cluster/folder ldmx-tests.simg myproductiontask.sh
```
   in this way the production script can write on the folders `/my/cluster/folder` when running inside
   the container environment.
   The user should not bother about mounting these folders, an ldmx cluster expert should modify the
   `ldmx-img` script to mount the useful folders.
   So the user that wants to run production jobs simply has to call:
```shell
   ldmx-img myproductiontask.sh
```
 4) A *batch system job script* is a batch script that has some batch system directives and
   *calls* the ldmx wrapper AND a script. 
   Therefore a batch job script MUST contain the line at 3).
   This batch script can ONLY CONTAIN PATHS IN THE CLUSTER. It has no knowledge of what happens
   inside the container, or how the folders in the container are organized.
 5) The graph below shows the only way to combine these three concepts properly.
    Any other combination of the above concepts is wrong.
```
<batch system command> mybatchscript.sh
                           |-> contains `ldmx-img myproductiontaskscript.sh`
                                            |-> contains `singularity -B /my/cluster/folder -B /my/other/cluster/folder ldmx-tests.simg <myproductionscript.sh as above>`
```
6) Typically you call the batch job script with the tools the batch system provides.
   For example for SLURM
   ```shell
   sbatch mybatchscript.sh
   ```

### Quick set up of a production environment:
1. Create a singularity image from a docker container as explained in § 2.
   Let's call it `ldmx-tests.simg`
2. Copy the `ldmx-img` script distributed in this git repo to your cluster
2.1. Modify the `ldmx-img` wrapper script to accomodate the folders you want to mount
   on the cluster. Make sure all paths are correct and match your cluster.
4. Using the `examples/ldmx-tests.sh` file, create your production task script.
5. Using the `examples/SLURM/testbatch.sh` file, create your own batch job script.
6. Use the batch system commands to run the script. For example, for SLURM:
```
   sbatch myowntestbatch.sh
```

## 4.3 Developing against the container

To develop using the container one must override the container ldmx-sw-install location.

Have a copy of the code in your home folder or in some Aurora shared folder,
start the container and redefine the install paths accordingly.

>  NOTE: before starting make sure you DID NOT SOURCE ANY `ldmx-setup-env.sh`. It 
         is reported to screw up all the build folders in the container. Start with a clean
         environment. If you have env vars in your ~/.bashrc or ~/.bash_profile please remove
         or comment them out and relogin.

For example, if you want to have ldmx sources in your home and you want to install
in your home, you can do the following:

```shell
   # go to your home folder
   cd ~
   # get the ldmx software
   git clone https://github.com/LDMXAnalysis/ldmx-sw.git
   # move into ldmx-sw sources
   cd ldmx-sw
   # create a folder for the build and move inside it
   mkdir build; cd build
   # start an interactive session inside the container, it will create the developer environment
   /projects/hep/fs7/shared/containers/ldmx-img bash
   # required because CMAKE SUCKS - it will force it to detect the correct python location
   PYTHON_EXECUTABLE=`which python`
   # the actual cmake command, make sure you change the install location!
   cmake -DPYTHON_EXECUTABLE=/usr/bin/python -DGeant4_DIR=$G4DIR/lib64/Geant4-10.2.3/ \
    -DROOT_DIR=$ROOTDIR -DXercesC_DIR=$XercesC_DIR \
    -DCMAKE_INSTALL_PREFIX=/home/pflorido/ldmx-sw-install ..
   # do the actual build and installation
   make install
```
In other words call the LDMX container before the cmake step to recreate the build
environment.

### To use the installed stuff in an interactive session:
```shell
  /projects/hep/fs7/shared/containers/ldmx-img bash
  source /home/pflorido/ldmx-sw-install/bin/ldmx-setup-env.sh
```
Note that the env script is the one from your new home install and NOT the one inside 
the container. But all other libraries (Xerces, ROOT, GEANT4) will still be in the 
container.

### To use the installed stuff in a script: 
one just has to change the environment initialization in the script.

```shell
-------------------------
mycustomldmxjob.sh

  # source the env from home instead of container
  source /home/pflorido/ldmx-sw-install/bin/ldmx-setup-env.sh
  # run your stuff
  doldmxstuff
--------------------------
```
you can call the script with
```shell
    /projects/hep/fs7/shared/containers/ldmx-img mycustomldmxjob.sh
```

