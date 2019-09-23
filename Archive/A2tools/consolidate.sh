#!/bin/bash
# Checks and corrections

# add correct _FillValue flag 

#set -x

# location of Archive
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive/Data
outp=/home/hgoelzer/Projects/ISMIP6/Archive/Data


declare -a labs=(AWI AWI AWI)
declare -a models=(ISSM1 ISSM2 ISSM3)

# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

##### 
echo "------------------"
echo  netcdf corrections
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    echo ${labs[$counter]} ${models[$counter]}

    # 1. Set exps manually
    #exps_res=asmb_05
    #exps_res="ctrl_05 hist_05"
    #exps_res="exp05_05"
    #exps_res="hist_05"
    
    # 2. Or find all experiments in directory
    dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name exp*`
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name *_05`
    exps_res=`basename -a ${dexps}`

    echo "###"
    echo ${exps_res}

    
    # loop trough experiments 
    for exp_res in ${exps_res}; do

	apath=${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}
	# strip resolution suffix from exp
	exp=${exp_res%???}

	# input file name
	anc=${apath}/lithk_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	# fix missing value flag
	ncatted -a _FillValue,lithk,o,f,NaN ${anc}
	ncatted -a _FillValue,lithk,o,f,0. ${anc}
	ncatted -a _FillValue,lithk,d,, ${anc}

	# input file name
	anc=${apath}/orog_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	# fix missing value flag
	ncatted -a _FillValue,orog,o,f,NaN ${anc}
	ncatted -a _FillValue,orog,o,f,0. ${anc}
	ncatted -a _FillValue,orog,d,, ${anc}
	
	echo ${anc}

    done
    # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

