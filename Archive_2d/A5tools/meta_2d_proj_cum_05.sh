#!/bin/bash
# Calculate 2d values for a number of models/experiments
# cumulate acabf difference to ctrl_proj

set -x
set -e

# location of Archive
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive_05/Data
outp=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data

# Destination for scalar files
outp2d=/home/hgoelzer/Projects/ISMIP6/Archive_2d/Data

## Settings
ares=05


### labs/models lists
#declare -a labs=(IMAU)
#declare -a models=(IMAUICE1)


### labs/models lists
#declare -a labs=(AWI  AWI AWI BGC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE UCIJPL)
#declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI ISSM1)


# or source default labs list
source ./set_default.sh

#declare -a labs=(UAF)
#declare -a models=(PISM1)


# Needed:
#vars="acabf"


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

	apath_ctrl=${outp}/${labs[$counter]}/${models[$counter]}/ctrl_proj_05
	apath=${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}
	# strip resolution suffix from exp
	exp=${exp_res%???}

	# output dir
	destpath=${outp2d}/${prefix}/${labs[$counter]}/${models[$counter]}/${exp_res}
	mkdir -p ${destpath}

	# calculate difference
	anc_ctrl=${apath_ctrl}/acabf_GIS_${labs[$counter]}_${models[$counter]}_ctrl_proj.nc
	ima_ctrl=${apath_ctrl}/sftgrf_GIS_${labs[$counter]}_${models[$counter]}_ctrl_proj.nc
	anc=${apath}/acabf_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ima=${apath}/sftgrf_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -3 -O -v acabf ${anc_ctrl} acabf_ctrl.nc
	# masking
	ncks -3 -A -v sftgrf ${ima_ctrl} acabf_ctrl.nc
	ncap2 -O -s 'acabf = acabf*sftgrf' acabf_ctrl.nc acabf_ctrl.nc

	ncks -3 -O -v acabf ${anc} acabf_exp.nc
	# masking
	ncks -3 -A -v sftgrf ${ima} acabf_exp.nc
	ncap2 -O -s 'acabf = acabf*sftgrf' acabf_exp.nc acabf_exp.nc
	ncdiff -O acabf_exp.nc acabf_ctrl.nc acabf_anom.nc
	
	# cumulate in time
	#ncra -F -d time,1,86 acabf_anom.nc iacabf_2100.nc
	ncap2 -O -C -s 'iacabf = acabf.total($time) * 31556926' -v acabf_anom.nc iacabf_2100.nc
	ncatted -a units,iacabf,o,c,"kg m-2" iacabf_2100.nc
	ncatted -a long_name,iacabf,o,c,"cumulated land_ice_surface_specific_mass_balance_flux anomaly" iacabf_2100.nc

	# move to Archive
	[ -f ./iacabf_2100.nc ] && /bin/mv ./iacabf_2100.nc ${destpath}/iacabf_2100_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc

    done
    # end exp loop
    
    counter=$(( counter+1 )) 
    
    # back to top level directory
    cd ../
done
# end lab/model loop

