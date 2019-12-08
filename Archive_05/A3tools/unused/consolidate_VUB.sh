#!/bin/bash
# checks and corrections

# make missing sftflf

#set -x

# location of Archive
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive_05/Data
outp=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data


declare -a labs=(VUB)
declare -a models=(GISMSIAv2)

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
    exps_res="historical_05 ctrl_proj_05 exp05_05"
    #exps_res="historical_05"
    
    # find experiments
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name exp*`
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name *_05`
    #exps_res=`basename -a ${dexps}`

    echo "###"
    echo ${exps_res}

    
    # loop trough experiments 
    for exp_res in ${exps_res}; do

	apath=${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}
	# strip resolution suffix from exp
	exp=${exp_res%???}

	anc_temp=${apath}/sftgrf_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	anc=${apath}/sftflf_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	echo ${anc}
	/bin/cp ${anc_temp} ${anc}
	# rename var
	ncrename -v sftgrf,sftflf ${anc}
	# zero out var
	ncap2 -O -s "sftflf = float(sftflf*0.)" ${anc} ${anc}
	# attributes
	ncatted -a long_name,sftflf,o,c,"Floating ice shelf area fraction" ${anc}
	ncatted -a standard_name,sftflf,o,c,"floating_ice_shelf_area_fraction" ${anc}

    done
    # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

