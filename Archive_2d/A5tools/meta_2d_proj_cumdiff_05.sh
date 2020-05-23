#!/bin/bash
# Calculate 2d differences for a number of models/experiments
# double difference lithk-cumulative acabf 
# requires proj to be extracted before: use meta_2d_proj_05.sh
# requires cumulative acabf to be extracted before: use meta_2d_proj_cum_05.sh

set -x
#set -e

# location of Archive
outp=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data

# Destination for 2d files
outp2d=/home/hgoelzer/Projects/ISMIP6/Archive_2d/Data

## Settings
ares=05

#declare -a labs=(AWI  AWI AWI BGC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE UCIJPL)
#declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI ISSM1)

#declare -a labs=(BGC GSFC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE UCIJPL)
#declare -a models=(BISICLES ISSM SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI ISSM1)


# labs/models lists
#declare -a labs=(BGC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE UCIJPL)
#declare -a models=(BISICLES SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI ISSM1)

# labs/models lists
#declare -a labs=(GSFC)
#declare -a models=(ISSM)


# or source default labs list
source ./set_default.sh

#declare -a labs=(UAF)
#declare -a models=(PISM1)


# Needed
#vars="dd_lithk iacabf"


# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

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
    #exps_res="exp05_${ares}"
    #exps_res="exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"

    #exps_res="exp05_05 exp06_05 exp07_05 exp08_05 exp09_05"

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

	# dirs
	apath=${outp2d}/${prefix}/${labs[$counter]}/${models[$counter]}/${exp_res}

	# loop through years
	for ayr in 2100; do
	#for ayr in 2040 2060 2100; do
	    anc_dyn=${apath}/dd_lithk_${ayr}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	    anc_smb=${apath}/iacabf_${ayr}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	    ncks -O -v lithk ${anc_dyn} dyn_tmp.nc
	    ncks -A -v iacabf ${anc_smb} dyn_tmp.nc
	    # Add model params
            ncks -A ${outp}/${labs[$counter]}/${models[$counter]}/params.nc dyn_tmp.nc

	    # difference
	    #ncdiff ${anc_dyn} ${anc_smb} dyncon_${ayr}.nc
	    ncap2 -O -s 'dyncon=lithk-(iacabf/rhoi)' -v dyn_tmp.nc dyncon_${ayr}.nc 

	    # move to Archive
	    [ -f ./dyncon_${ayr}.nc ] && /bin/mv ./dyncon_${ayr}.nc ${apath}/dyncon_${ayr}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	done
	# end year loop

    done
    # end exp loop
    
    counter=$(( counter+1 )) 
    
    # back to top level directory
    cd ../
done
# end lab/model loop

