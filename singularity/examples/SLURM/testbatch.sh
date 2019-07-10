#!/bin/bash
#
# On some systems one has to pass an allocation
#SBATCH -A hep2016-1-4
# This is the SLURM partition where the job will be ran
#SBATCH -p hep 
#

# load the container wrapper and pass the job script as an argument
srun /projects/hep/fs7/shared/containers/ldmx-img ./ldmx-tests.sh

