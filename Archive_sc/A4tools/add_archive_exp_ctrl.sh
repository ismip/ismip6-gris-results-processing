#!/bin/bash

set -x
#set -e

# versioning
aversion=v7

# local path
apath=../Data/SC_GIC1_OBS0

# Output archive

outpath=../Archives

# Source labs list and exps
source ./set_archive_ctrl.sh

# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

######

# Make archive directory
mkdir -p ${outpath}/${aversion}/

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    for exp_res in ${exps_res}; do

	# strip resolution suffix from exp
	exp=${exp_res%???}

	# make target dir
	exptarget=${outpath}/${aversion}/${labs[$counter]}/${models[$counter]}/${exp_res}

	# register files for inclusion
	afile=${apath}/${labs[$counter]}/${models[$counter]}/${exp_res}/scalars_mm_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	bfile=${apath}/${labs[$counter]}/${models[$counter]}/${exp_res}/scalars_rm_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	cfile=${apath}/${labs[$counter]}/${models[$counter]}/${exp_res}/scalars_zm_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	if [ -e ${afile} ]; then
	    mkdir -p ${exptarget}
	    /bin/cp ${afile} ${exptarget}
	fi
	if [ -e ${bfile} ]; then
	    mkdir -p ${exptarget}
	    /bin/cp ${bfile} ${exptarget}
	fi
	if [ -e ${cfile} ]; then
	    mkdir -p ${exptarget}
	    /bin/cp ${cfile} ${exptarget}
	fi
    done
    # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

