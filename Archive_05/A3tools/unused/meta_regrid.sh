#!/bin/bash
# Regrid a number of files

set -x 
set -e

# location of input Archive
outp=/home/hgoelzer/Projects/ISMIP6/Archive/Data

# location of output Archive
outp05=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data

# location of tools
ptool=${outp05}/../A3tools

## labs list
#declare -a labs=(JPL JPL)
## models list
#declare -a models=(ISSM ISSMPALEO)

## labs list
#declare -a labs=(JPL)
## models list
#declare -a models=(ISSM)

## labs list
#declare -a labs=(UCIJPL)
## models list
#declare -a models=(ISSM)

## labs list
#declare -a labs=(IMAU)
## models list
#declare -a models=(IMAUICE1)

## labs list
#declare -a labs=(GSFC)
## models list
#declare -a models=(ISSM)

## labs list
#declare -a labs=(GSFC JPL JPL UCIJPL)
## models list
#declare -a models=(ISSM ISSM ISSMPALEO ISSM)

# labs list
declare -a labs=(UAF)
# models list
declare -a models=(PISM1)
explist="expb02_01"


# variables
#vars="lithk"
#vars="sftgrf"
#vars="lithk orog topg sftflf sftgif sftgrf"
vars="acabf"

# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

##### 
echo "------------------"
echo  Regrid files 
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    # find experiments
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d `
    #exps_res=`basename -a ${dexps}`
    #echo "###"
    #echo ${exps_res}

    # specify exps manually
    exps_res=${explist}
    echo ${exps_res}


    # loop trough experiments    
    for exp_res in ${exps_res}; do

	cd ${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}/
	#   # loop trough vars
	for var in ${vars}; do

	    # strip resolution suffix from exp
	    exp=${exp_res%???}
	    # Add target res suffix
	    expresout=${exp}_05
	    # target dir
	    mkdir -p ${outp05}/${labs[$counter]}/${models[$counter]}/${expresout}
	    # input and output file names are the same
	    anc=${var}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc

	    pwd
	    echo ${anc}

	    # regridding
	    ${ptool}/regrid_func.sh ${anc} ${outp05}/${labs[$counter]}/${models[$counter]}/${expresout}/${anc} 

	done
	#   # end vars loop

    done
#   # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

