#!/bin/bash
# checks and corrections

# add missing value flag

#set -x

# location of Archive
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive_05/Data
outp=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data

declare -a labs=(UCIJPL)
declare -a models=(ISSM1)

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
    # set exps manually
    #exps_res=asmb_05
    #exps_res="ctrl_05 hist_05"
    #exps_res="exp05_05"
    #exps_res="hist_05"
    
    # find experiments
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name exp*`
    dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name *_05`
    exps_res=`basename -a ${dexps}`

    echo "###"
    echo ${exps_res}

    
    # loop trough experiments to calculate scalars
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

	anc=${apath}/orog_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	# fix missing value flag
	ncatted -a _FillValue,orog,o,f,NaN ${anc}
	ncatted -a _FillValue,orog,o,f,0. ${anc}
	ncatted -a _FillValue,orog,d,, ${anc}
	
	anc=${apath}/topg_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	# fix missing value flag
	ncatted -a _FillValue,topg,o,f,NaN ${anc}
	ncatted -a _FillValue,topg,o,f,-4000. ${anc}
	ncatted -a _FillValue,topg,d,, ${anc}
	
	echo ${anc}

    done
    # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

