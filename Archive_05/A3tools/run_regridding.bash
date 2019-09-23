#!/bin/bash
#SBATCH -p short -n 24 -t 0:30:00

# For interactive use:
# srun -n 1 -t 1:00:00 --pty bash -il
# ./run_regridding.bash

# setting up
exppath=`realpath ./` 

# working in home 
./meta_regrid.sh


echo ''
echo '  FINISHED '
echo ''

echo 'The meta script was:'
echo '#####'
cat meta_regrid.sh
echo 'The run script was:'
echo '#####'
cat regrid_func.sh
echo '#####'
