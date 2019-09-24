#!/bin/bash
# process a number of files

set -x

ares=01

# location of Archive
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive_${ares}/Data
#outp=/home/hgoelzer/Projects/ISMIP6/Archive_${ares}/Data

outp=/home/hgoelzer/Projects/ISMIP6/Archive/Data

#declare -a labs=(AWI)
#declare -a models=(ISSM2)

# labs/models lists
#declare -a labs=(UCIJPL)
#declare -a models=(ISSM)

# labs/models lists
declare -a labs=(JPL)
declare -a models=(ISSM)

# labs/models lists
#declare -a labs=(AWI AWI AWI JPL JPL)
#declare -a models=(ISSM1 ISSM2 ISSM3 ISSM ISSMPALEO)

# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

##### 
echo "------------------"
echo  netcdf calculations
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    echo ${labs[$counter]} ${models[$counter]}
    # set exps manually
    #exps_res=asmb_${ares}
    #exps_res="ctrl_${ares} hist_${ares}"
    exps_res="exp${ares}_${ares}"
    #exps_res="hist_${ares}"
    
    # find experiments
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name exp*`
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name *_${ares}`
    #exps_res=`basename -a ${dexps}`

    echo "###"
    echo ${exps_res}

    
    # loop trough experiments to calculate scalars
    for exp_res in ${exps_res}; do

	apath=${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}
	# strip resolution suffix from exp
	exp=${exp_res%???}
	# input file name
	anc=${apath}/lithk_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -O -v lithk ${anc} model.nc
	anc=${apath}/topg_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -A -v topg ${anc} model.nc

	anc=${apath}/sftflf_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -A -v sftflf ${anc} model.nc
	anc=${apath}/sftgif_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -A -v sftgif ${anc} model.nc
	anc=${apath}/sftgrf_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -A -v sftgrf ${anc} model.nc

	### scalar calculations; expect model input in model.nc
	./scalars_basin_hires.sh

	### move output ./scalars_??_${ares}.nc to Archive
	/bin/mv ./scalars_mm_${ares}.nc ${apath}/scalars_mm_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	/bin/mv ./scalars_bm_${ares}.nc ${apath}/scalars_bm_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	/bin/mv ./scalars_ng_${ares}.nc ${apath}/scalars_ng_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	/bin/mv ./scalars_mm_imb_${ares}.nc ${apath}/scalars_mm_imb_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	#/bin/rm model.nc
    done
    # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

