#!/bin/bash
# Calculate 2d differences proj-control for a number of models/experiments
# requires differences for ctrl_proj to be extracted before: use meta_2d_proj_diff_05.sh
# requires differences for exp to be extracted before: use meta_2d_proj_diff_05.sh

set -x
set -e

# Destination for 2d files
outp2d=/home/hgoelzer/Projects/ISMIP6/Archive_2d/Data

## Settings
ares=05


### labs/models lists
#declare -a labs=(AWI  AWI AWI BGC GSFC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE UCIJPL)
#declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES ISSM SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI ISSM1)

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

#vars="lithk orog topg sftgif sftgrf sftflf"
#vars="lithk orog sftgif sftgrf sftflf"
#vars="lithk orog  sftgrf sftflf"
#vars="lithk orog topg sftgif sftgrf sftflf xvelmean yvelmean acabf"
# or source default vars list
source ./set_vars.sh


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
    #exps_res=asmb_${ares}
    #exps_res="ctrl_${ares} historical_${ares}"
    #exps_res="exp05_${ares} ctrl_proj_${ares}"
    #exps_res="historical_${ares}"
    #exps_res="ctrl_${ares}"
    #exps_res="ctrl_proj_${ares} historical_${ares} exp05_${ares}"

    #exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"

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
	ctrlpath=${outp2d}/${prefix}/${labs[$counter]}/${models[$counter]}/ctrl_proj_${ares}
	destpath=${outp2d}/${prefix}/${labs[$counter]}/${models[$counter]}/${exp_res}
	mkdir -p ${destpath}

	# loop through variables
	for avar in ${vars}; do

	    # loop through years
	    for ayr in 2100; do
	    #for ayr in 2040 2060 2100; do
		anc_ctrl=${ctrlpath}/d_${avar}_${ayr}_GIS_${labs[$counter]}_${models[$counter]}_ctrl_proj.nc
		anc=${destpath}/d_${avar}_${ayr}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	    # double difference
		ncdiff ${anc} ${anc_ctrl} dd_${avar}_${ayr}.nc
		# move to Archive
		[ -f ./dd_${avar}_${ayr}.nc ] && /bin/mv ./dd_${avar}_${ayr}.nc ${destpath}/dd_${avar}_${ayr}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	    done
	    # end year loop
	done
	# end var loop

    done
    # end exp loop
    
    counter=$(( counter+1 )) 
    
    # back to top level directory
    cd ../
done
# end lab/model loop

