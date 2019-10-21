#!/bin/bash
# checks and corrections

# remove coordinates

#set -x

# location of Archive
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive_05/Data
outp=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data


declare -a labs=(GSFC ILTS_PIK ILTS_PIK IMAU JPL JPL LSCE UAF UCIJPL)
declare -a models=(ISSM SICOPOLIS2 SICOPOLIS3 IMAUICE2 ISSM ISSMPALEO GRISLI PISM1 ISSM1)

# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

vars="lithk orog topg sftgif sftgrf sftflf"

##### 
echo "------------------"
echo  netcdf corrections
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    echo ${labs[$counter]} ${models[$counter]}
    # set exps manually
    #exps_res=asmb_05
    #exps_res="ctrl_05 hist_05"
    #exps_res="exp05_05"
    #exps_res="hist_05"
    
    # find experiments
    dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name *_05`
    exps_res=`basename -a ${dexps}`

    echo "###"
    echo ${exps_res}

    
    # loop trough experiments 
    for exp_res in ${exps_res}; do

	apath=${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}
	# strip resolution suffix from exp
	exp=${exp_res%???}

        # loop through variables
	for avar in ${vars}; do

	    # input file name
	    anc=${apath}/${avar}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	    echo ${anc}
	    # remove coordinates attribute 
	    ncatted -a coordinates,${avar},d,, ${anc}
	    # remove coordinates attribute 
	    ncks -O -C -x -v lat,lon,lat_bnds,lon_bnds ${anc} ${anc}
	
	done
	# end var loop

    done
    # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

