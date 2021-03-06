#!/bin/bash
# checks and corrections

# rename files, remove res suffix from files

#set -x

# location of Archive
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive_05/Data
outp=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data


declare -a labs=(VUB)
declare -a models=(GISMHOMv1)

# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

vars="lithk orog topg sftgif sftgrf sftflf xvelmean yvelmean acabf"
#vars="acabf"

##### 
echo "------------------"
echo  netcdf corrections
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    echo ${labs[$counter]} ${models[$counter]}
    # set exps manually
    #exps_res="ctrl_proj_05"

    exps_res="historical_05 ctrl_proj_05  exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05   expa01_05 expa02_05 expa03_05   expb01_05 expb02_05 expb03_05 expb04_05 expb05_05"

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

	# loop through variables
	for avar in ${vars}; do

	    # File names
	    anc=${apath}/${avar}_GIS_${labs[$counter]}_${models[$counter]}_${exp_res}.nc
	    anc_target=${apath}/${avar}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	    # Rename
	    /bin/mv ${anc} ${anc_target}
	    echo ${anc}

	done
    done
    # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop
