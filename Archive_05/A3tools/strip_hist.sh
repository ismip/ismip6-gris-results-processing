#!/bin/bash
# checks and corrections

# remove assumed first hist entry from proejctions if record is longer than 86 

#set -x

# location of Archive
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive_05/Data
outp=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data

## labs list
#declare -a labs=(BGC)
#declare -a models=(BISICLES)

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

vars="lithk orog topg sftgif sftgrf sftflf acabf xvelmean yvelmean"

##### 
echo "------------------"
echo  netcdf corrections
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    echo "###"
    echo ${labs[$counter]} ${models[$counter]}
    # set exps manually
    #exps_res="exp05_05"
    #exps_res="ctrl_proj_05 exp05_05"
    exps_res="exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"
    
    # find experiments
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name *_05`
#    dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name exp*_05`
    #exps_res=`basename -a ${dexps}`

    echo ${exps_res}
    echo "#"

    
    # loop trough experiments 
    for exp_res in ${exps_res}; do

	apath=${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}
	# strip resolution suffix from exp
	exp=${exp_res%???}

        # loop through variables
	for avar in ${vars}; do

	    # input file name
	    anc=${apath}/${avar}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
#	    echo ${anc}
	    # get length of record
	    ll=`ncap2 -v -O -s 'print(time.size(),"%ld\n");' ${anc} foo.nc`
	    # remove first entry if ll>86
	    if [ "$ll" -gt 86 ]; then
		echo "ll = ${ll}: removing hist entry from ${anc}"
		ncks -F -O -d time,2,-1 ${anc} ${anc}
	    else
		echo "ll = ${ll}: nothing done "
	    fi

	done
	# end var loop

    done
    # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

