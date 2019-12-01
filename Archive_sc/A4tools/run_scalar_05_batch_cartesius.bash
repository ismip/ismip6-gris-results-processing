#!/bin/bash
##SBATCH -p short -N 1 -t 0:10:00
#SBATCH -p normal -N 1 -t 1:00:00
##SBATCH -p normal -N 1 -t 3:00:00

# For interactive use:
# srun -t 10 -N 1 --pty bash -il
# ./run_scalar_cartesius.bash

#set -x 
set -e

# setting up
exppath=`realpath ./` 
scrpath=/scratch/shared/$USER/ISMIP6

# working on /scratch 
if [ -d "$scrpath" ]; then rm -rf $scrpath; fi
mkdir -p $scrpath
cd $scrpath

# get scripts
/bin/cp ${exppath}/meta_scalar_05_batch.sh ./
/bin/cp ${exppath}/scalar_05_batch_func.sh ./
/bin/cp ${exppath}/scalars_basin.sh ./
/bin/cp ${exppath}/set_default.sh ./
/bin/cp ${exppath}/set_exps.sh ./

# run the model
./meta_scalar_05_batch.sh

# clean up
#/bin/rm -rf $scrpath

echo ''
echo '  FINISHED '
echo ''

echo 'The meta script was:'
echo '#####'
cat meta_scalar_05_batch.sh
echo 'The function script was:'
echo '#####'
cat scalar_05_batch_func.sh
echo 'The run script was:'
echo '#####'
cat scalars_basin.sh
echo 'The model set was:'
echo '#####'
cat set_default.sh
echo '#####'
echo 'The exps set was:'
echo '#####'
cat set_exps.sh
echo '#####'
