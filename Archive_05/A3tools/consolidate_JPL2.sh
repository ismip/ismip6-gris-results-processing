#!/bin/bash
# checks and corrections

# recalculate sftgrf

set -x

# location of Archive
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive_05/Data
outp=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data


declare -a labs=(JPL)
declare -a models=(ISSMPALEO)

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
    #exps_res="ctrl_proj_05 exp05_05"
    #exps_res="ctrl_proj_05"
    #exps_res="exp07_05"
    exps_res="historical_05 ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"
    
    # find experiments
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name exp*`
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name *_05`
    #exps_res=`basename -a ${dexps}`

    echo "###"
    echo ${exps_res}

    
    # loop trough experiments to calculate scalars
    for exp_res in ${exps_res}; do

	apath=${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}
	# strip resolution suffix from exp
	exp=${exp_res%???}


	anc_gif=${apath}/sftgif_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	anc_flf=${apath}/sftflf_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	anc_grf=${apath}/sftgrf_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc

	# copy over
	/bin/cp ${anc_gif} gif_tmp.nc
	/bin/cp ${anc_flf} flf_tmp.nc
	#/bin/cp ${anc_grf} grf_tmp.nc

	# rename and diff
	ncrename -v sftgif,sftgrf gif_tmp.nc
	ncrename -v sftflf,sftgrf flf_tmp.nc	
	ncdiff -O gif_tmp.nc flf_tmp.nc grf_tmp.nc
	ncatted -a standard_name,sftgrf,o,c,"grounded_ice_sheet_area_fraction" grf_tmp.nc
	ncatted -a long_name,sftgrf,o,c,"grounded ice sheet area fraction" grf_tmp.nc

	# move back in place
	/bin/mv grf_tmp.nc ${anc_grf} 
	
	# clean up 
	/bin/rm flf_tmp.nc gif_tmp.nc
	    
	echo ${anc_grf}
    done
    # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop
