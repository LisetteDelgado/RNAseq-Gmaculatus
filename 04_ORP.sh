#!/bin/bash

#run in Compute Canada

#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=0
#SBATCH --time=7-0:0:0
#SBATCH --mail-user=m.lisette.delgado@dal.ca
#SBATCH --mail-type=ALL

module load StdEnv/2020 singularity/3.7

# using an overlay beacuse trinity outputs too many files, reaching the file quota on ComputeCanada
# Modify these lines to point to your own files, if many samples are used for the assembly, first they need to be concatanated
OVERLAY=/scratch/ldelgado/big_overlay.img
READ1=/scratch/ldelgado/GillX.1.fq.gz
READ2=/scratch/ldelgado/GillX.2.fq.gz

# The overlay image file $OVERLAY must already exist and
# contain a filesystem initialized, e.g. with mkfs.ext3

# MEM parameter is ultimately used by Trinity and rnaspades. Unit is GB.
# Tell those apps they can have 90% of what we have reserved with Slurm,
# out of an abundance of caution.
#MEM=$((SLURM_MEM_PER_NODE*9/10))

# CPU parameter is similarly used by several applications.
CPU=${SLURM_CPUS_PER_TASK}

echo "$(date) Creating /work directory inside overlay f/s ..."
singularity exec --overlay ${OVERLAY} orp-2.3.3-docker.sif /usr/bin/mkdir /work

echo "$(date) Running oyster.mk in container ..."
singularity run -c -e \
  -B ${HOME} -B /project -B /scratch \
  -B ${SLURM_TMPDIR}:/tmp \
  --overlay ${OVERLAY} \
  orp-2.3.3-docker.sif \
  bash -c \
    "cd /work; /home/orp/Oyster_River_Protocol/oyster.mk \
       STRAND=RF \
       TPM_FILT=1 \
       MEM=150 \
       CPU=${CPU} \
       READ1=${READ1} \
       READ2=${READ2} \
       RUNOUT=Gill_assembly"
