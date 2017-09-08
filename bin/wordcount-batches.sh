#!/bin/bash
#SBATCH --job-name=wordcount-batches
#SBATCH --output="argo-out/logs/argo-wordcount-%A_%a.out"
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lmullen@gmu.edu
#SBATCH --partition=all-HiPri
#SBATCH --export=NONE
#SBATCH --array=1-1600%120

## Load modules since we are not exporting our environment
module load R/3.4.1

## Get the file name associated with that line of the list of files
BATCH_LIST=./bin/chronam-batch-list.txt
BATCH=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $BATCH_LIST)
INPUT=argo-out/chronam-df/$BATCH.tar.bz2.feather
OUTPUT=argo-out/chronam-wordcounts/$BATCH.wordcount.feather

## Run the executable only if output does not exist
echo "Job details: BATCH=$BATCH TASKID: $SLURM_ARRAY_TASK_ID"
echo "Input files is $INPUT"
if [ -f "$OUTPUT" ]; then
  echo "SKIPPED: Not running task because $OUTPUT already exists"
else
  echo "RUNNING: Starting script to create $OUTPUT"
  Rscript ./bin/wordcount-batches.R \
    $INPUT \
    -o $OUTPUT && \
  echo "FINISHED: Finished script to create $OUTPUT"
fi