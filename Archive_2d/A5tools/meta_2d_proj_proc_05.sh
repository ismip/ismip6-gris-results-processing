#!/bin/bash
# Calculate 2d values for a number of models/experiments
# Velocities
# requires proj to be extracted before: use meta_2d_proj_05.sh

set -x
set -e

# Destination for scalar files
outp2d=/home/hgoelzer/Projects/ISMIP6/Archive_2d/Data

## Settings
ares=05


# labs/models lists
#declare -a labs=(GSFC)
#declare -a models=(ISSM)

#declare -a labs=(AWI AWI AWI BGC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE UCIJPL)
#declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI ISSM1)


# or source default labs list
source ./set_default.sh

# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

# Required:
#vars="xvelmean yvelmean"

# default experiments
source ./set_exps.sh

##### 
echo "------------------"
echo  netcdf calculations
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    echo ${labs[$counter]} ${models[$counter]}

    proc=${labs[$counter]}_${models[$counter]}
    mkdir -p ${proc}
    cd ${proc}

    # A. set exps manually
    #exps_res=asmb_${ares}
    #exps_res="ctrl_${ares} historical_${ares}"
    #exps_res="exp05_${ares} ctrl_proj_${ares}"
    #exps_res="historical_${ares}"
    #exps_res="ctrl_${ares}"
    #exps_res="ctrl_proj_${ares} historical_${ares} exp05_${ares}"
    #exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05 "

    #exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05"

    # B. find experiments automatically
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name exp*`
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name *_${ares}`
    #exps_res=`basename -a ${dexps}`

    echo "###"
    echo ${exps_res}

    
    # loop trough experiments
    for exp_res in ${exps_res}; do

	# strip resolution suffix from exp
	exp=${exp_res%???}

	# output dir
	apath=${outp2d}/${prefix}/${labs[$counter]}/${models[$counter]}/${exp_res}

	# loop through years
	for ayr in 2100; do
        #for ayr in 2040 2060 2100; do

	    # extract snapshots
	    ancx=${apath}/xvelmean_${ayr}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	    ancy=${apath}/yvelmean_${ayr}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	    anc=${apath}/velmean_${ayr}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	    
	    ncks -O -v xvelmean ${ancx} vel_tmp.nc
	    ncks -A -v yvelmean ${ancy} vel_tmp.nc
	    ncap2 -O -s 'velmean = (xvelmean^2 + yvelmean^2)^0.5' -v vel_tmp.nc vel${ayr}.nc 
	    
	    # move to Archive
	    [ -f ./vel${ayr}.nc ] && /bin/mv ./vel${ayr}.nc ${anc}
	    /bin/rm vel_tmp.nc 

	done
	# end year loop

    done
    # end exp loop
    
    counter=$(( counter+1 )) 
    
    # back to top level directory
    cd ../
done
# end lab/model loop

