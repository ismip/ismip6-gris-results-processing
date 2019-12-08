#!/bin/bash

set -x
set -e

# versioning
aversion=v2

HOST='transfer.ccr.buffalo.edu'

# Remote path
RPATH=/projects/grid/ghub/ISMIP6/hgoelzer/sc

# local path
apath=../Data/SC_GIC1_OBS0

# Source labs list and exps
source ./set_upload.sh

# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

######

# Make sftp batch file then call for entire transfer 
echo "cd ${RPATH}/${aversion}/" > sftpbatch.tmp

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    # make target dir
    ssh hgoelzer@transfer.ccr.buffalo.edu mkdir -p ${RPATH}/${aversion}/${labs[$counter]}/${models[$counter]} 

    for exp_res in ${exps_res}; do

	# strip resolution suffix from exp
	exp=${exp_res%???}

	# make target dir
	ssh hgoelzer@transfer.ccr.buffalo.edu mkdir -p ${RPATH}/${aversion}/${labs[$counter]}/${models[$counter]}/${exp_res}

	# register files for transfer
	echo  "cd ${RPATH}/${aversion}/${labs[$counter]}/${models[$counter]}/${exp_res}/" >> sftpbatch.tmp
	echo  "put ${apath}/${labs[$counter]}/${models[$counter]}/${exp_res}/scalars_mm_cr_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc" >> sftpbatch.tmp
	echo  "put ${apath}/${labs[$counter]}/${models[$counter]}/${exp_res}/scalars_rm_cr_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc" >> sftpbatch.tmp
		
    done
    # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

echo "exit" >> sftpbatch.tmp

# Upload files as ftp batch
sftp -b sftpbatch.tmp ${HOST}
