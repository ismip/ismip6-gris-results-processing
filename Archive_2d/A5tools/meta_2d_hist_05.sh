#!/bin/bash
# Calculate 2d values for a number of models/experiments

set -x
set -e

# location of Archive
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive_05/Data
outp=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data

# Destination for scalar files
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


# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi


#vars="lithk orog topg sftgif sftgrf sftflf"
#vars="xvelmean yvelmean acabf"
#vars="lithk orog topg sftgif sftgrf sftflf xvelmean yvelmean acabf"
# or source default vars list
source ./set_vars.sh

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

	apath=${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}
	# strip resolution suffix from exp
	exp=${exp_res%???}

	# output dir
	destpath=${outp2d}/${prefix}/${labs[$counter]}/${models[$counter]}/${exp_res}
	mkdir -p ${destpath}

	# loop through variables
	for avar in ${vars}; do

	    # extract snapshots
	    anc=${apath}/${avar}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	    ncks -F -3 -O -d time,-1 -v ${avar} ${anc} ${avar}_2014.nc

	    # move to Archive
	    [ -f ./${avar}_2014.nc ] && /bin/mv ./${avar}_2014.nc ${destpath}/${avar}_2014_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc

	done
	# end var loop

    done
    # end exp loop
    
    counter=$(( counter+1 )) 
    
    # back to top level directory
    cd ../
done
# end lab/model loop

