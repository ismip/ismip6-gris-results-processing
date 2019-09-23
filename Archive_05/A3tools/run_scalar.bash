#!/bin/bash
#SBATCH -p short -n 24 -t 1:00:00

# For interactive use:
# srun -n 1 -t 1:00:00 --pty bash -il
# ./run_regridding.bash

# setting up
exppath=`realpath ./` 

# working in home 
./meta_scalar.sh


echo ''
echo '  FINISHED '
echo ''

echo 'The meta script was:'
echo '#####'
cat ./meta_scalar.sh
echo 'The run script was:'
echo '#####'
cat ./scalars_basin.sh
echo '#####'
