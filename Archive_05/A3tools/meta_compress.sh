#!/bin/bash
# process a number of files

# Environment
module load netcdf

# location of Archive
outp=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data

# Path to SFs
sfs=/home/hgoelzer/Projects/ISMIP6/Grids/GrIS/SFs


## labs/models lists
#declare -a labs=(AWI AWI AWI ILTS_PIK)
#declare -a models=(ISSM1 ISSM2 ISSM3 SICOPOLIS2)

## labs/models lists
#declare -a labs=(MUN)
#declare -a models=(GSM2371)

# labs/models lists
#declare -a labs=(JPL JPL)
#declare -a models=(ISSM ISSMPALEO)

## labs/models lists
#declare -a labs=(JPL)
#declare -a models=(ISSMPALEO)

## labs/models lists
#declare -a labs=(VUB)
#declare -a models=(GISMSIAv1)

# labs/models lists
declare -a labs=(IMAU)
declare -a models=(IMAUICE1)

# variables
#vars="lithk"
vars="lithk orog topg sftflf sftgif sftgrf"

# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

##### 
echo "------------------"
echo  Compress files 
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    # find experiments
    dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d `
    exps_res=`basename -a ${dexps}`
    echo "###"
    echo ${exps_res}
    # loop trough experiments    
    for exp_res in ${exps_res}; do

	cd ${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}/
	#   # loop trough vars
	for var in ${vars}; do

	    # strip resolution suffix from exp
	    exp=${exp_res%???}
	    # input and output file names are the same
	    anc=${var}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	    tmpnc=${var}_tmp.nc

	    pwd
	    echo ${anc}

	    # remove unused variables
	    ncks -C -O -x -v lat,lon ${anc} ${anc}
	    # add xy 
	    ncks -A -v x,y ${sfs}/af2_ISMIP6_GrIS_05000m.nc ${anc}
	    # compressing
	    nccopy -d1 -s ${anc} ${tmpnc}
	    # mv over
	    /bin/mv ${tmpnc} ${anc}

	done
	#   # end vars loop

    done
#   # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

