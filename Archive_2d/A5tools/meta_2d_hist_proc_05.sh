#!/bin/bash
# Calculate 2d values for a number of models/experiments
# Velocities
# requires hist to be extracted before: use meta_2d_hist_05.sh

set -x
set -e

# location of Archive
# Destination for 2d files
outp2d=/home/hgoelzer/Projects/ISMIP6/Archive_2d/Data

## Settings
ares=05

#declare -a labs=(AWI)
#declare -a models=(ISSM1)

## labs/models lists
#declare -a labs=(ILTS_PIK)
#declare -a models=(SICOPOLIS2)

# labs/models lists
#declare -a labs=(IMAU)
#declare -a models=(NOISM05)

# labs/models lists
#declare -a labs=(JPL)
#declare -a models=(ISSM)

# labs/models lists
#declare -a labs=(MUN)
#declare -a models=(GSM2371)

# labs/models lists
#declare -a labs=(UCIJPL)
#declare -a models=(ISSM)

# labs/models lists
#declare -a labs=(VUB)
#declare -a models=(GISMSIAv1)

## labs/models lists
#declare -a labs=(LSCE)
#declare -a models=(GRISLI)



# labs/models lists
#declare -a labs=(BGC GSFC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE UCIJPL)
#declare -a models=(BISICLES ISSM SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI ISSM1)

#declare -a labs=(AWI  AWI AWI BGC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE UCIJPL)
#declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI ISSM1)



# or source default labs list
source ./set_default.sh

#declare -a labs=(UAF)
#declare -a models=(PISM1)


# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

# Required:
#vars="xvelmean yvelmean"

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
    exps_res="historical_${ares}"

    echo "###"
    echo ${exps_res}

    
    # loop trough experiments
    for exp_res in ${exps_res}; do

	# strip resolution suffix from exp
	exp=${exp_res%???}

	# output dir
	apath=${outp2d}/${prefix}/${labs[$counter]}/${models[$counter]}/${exp_res}

	# extract snapshots
	ancx=${apath}/xvelmean_2014_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ancy=${apath}/yvelmean_2014_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	anc=${apath}/velmean_2014_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc

	ncks -O -v xvelmean ${ancx} vel_tmp.nc
	ncks -A -v yvelmean ${ancy} vel_tmp.nc
	ncap2 -O -s 'velmean = (xvelmean^2 + yvelmean^2)^0.5' -v vel_tmp.nc vel.nc 

	# move to Archive
	[ -f ./vel.nc ] && /bin/mv ./vel.nc ${anc}
	/bin/rm vel_tmp.nc 

    done
    # end exp loop
    
    counter=$(( counter+1 )) 
    
    # back to top level directory
    cd ../
done
# end lab/model loop

