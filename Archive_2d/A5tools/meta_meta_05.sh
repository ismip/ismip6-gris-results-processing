#!/bin/bash
# run some scripts
# remember to update 
# set_default.sh  set_vars.sh  set_exps.sh

./meta_2d_hist_05.sh
./meta_2d_proj_05.sh
# proj-hist
./meta_2d_proj_diff_05.sh
# proj-control
./meta_2d_proj_diffcr_05.sh


# velocities
./meta_2d_hist_proc_05.sh
./meta_2d_proj_proc_05.sh

# cumulative acabf
./meta_2d_proj_cum_05.sh
./meta_2d_proj_cumdiff_05.sh
