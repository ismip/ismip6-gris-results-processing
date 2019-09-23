#!/bin/bash
# Check directory and file names

# location of Archive
outp=/home/hgoelzer/Projects/ISMIP6/Archive/Data


## labs list
declare -a labs=(GSFC ILTS_PIK ILTS_PIK JPL JPL  LSCE  MUN MUN UCIJPL)
# models list
declare -a models=(ISSM SICOPOLIS2 SICOPOLIS3 ISSM ISSMPALEO GRISLI GSM2501 GSM2511 ISSM)

# variables
vars="lithk orog topg sftflf sftgif sftgrf"
#vars="tendlifmassbf tendlibmassbffl tendlibmassbf tendacabf tendlicalvf limnsw iareagr iareafl lim"



# check array sizes match models
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

##### 
echo "------------------"
echo  Checking file names 
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do
    
    # find experiments
    dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d `
    exps_res=`basename -a ${dexps}`
    echo "###"
    echo ${exps_res}
    # loop trough experiments    
    for exp_res in ${exps_res}; do

	# strip resolution suffix from exp
	exp=${exp_res%???}
	# go into exp dir and rename files
	outdir=${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}
	echo ${outdir}
	#   # loop trough vars
	for var in ${vars}; do

	    # target name 
	    ancout=${var}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc

	    # rename file
	    if [ -e ${outdir}/$ancout ]; then
		echo $ancout
	    else
		echo Error: ${outdir}/$ancout not found
		exit 1
	    fi
	done
	#   # end vars loop
	
    done
#   # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

