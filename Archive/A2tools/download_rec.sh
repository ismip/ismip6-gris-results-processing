#!/bin/bash
# download specific files recursively
# Depends on a directory structure already in place. Can be created by starting
# an ftp download and interupt after first file starts loading.

# NASA credentials
HOST='cryoftp1.gsfc.nasa.gov'
USER='searise'
PASSWD='3Uk,.*&^90#%'

# location of tools
ptool=/home/hgoelzer/Projects/ISMIP6/Archive/tools/

# location of Archive
outp=/home/hgoelzer/Projects/ISMIP6/Archive

# Remote path
RPATH=ISMIP6/Projections/GrIS/output

## labs list
#declare -a labs=(AWI AWI AWI ILTS_PIK)
## models list
#declare -a models=(ISSM1 ISSM2 ISSM3 SICOPOLIS2)

## labs list
#declare -a labs=(MUN)
## models list
#declare -a models=(GSM2371)

## labs list
#declare -a labs=(ILTS_PIK)
## models list
#declare -a models=(SICOPOLIS2)

## labs list
#declare -a labs=(UCIJPL)
## models list
#declare -a models=(ISSM)

# labs list
declare -a labs=(JPL JPL)
# models list
declare -a models=(ISSM ISSMPALEO)

## labs list
#declare -a labs=(JPL)
## models list
#declare -a models=(ISSMPALEO)

# strip resolution suffix
flg_strip=true
#flg_strip=false # for models that do not have res suffix: MUN

# variables
#vars="sftgrf"
vars="lithk orog topg sftflf sftgif sftgrf"

# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

##### 
echo "------------------"
echo  Download files for all exps
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    # find experiments
    dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d `
    echo ${dexps}
    exps_res=`basename -a ${dexps}`
    echo "###"
    echo ${exps_res}
    # loop trough experiments    
    for exp_res in ${exps_res}; do

	cd ${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}/
	#   # loop trough vars
	for var in ${vars}; do

	    # strip resolution suffix from exp
	    if [ "$flg_strip" = true ]; then
		exp=${exp_res%???}
	    else
		exp=${exp_res}
	    fi
	    # this is the target name, but the file on the ftp may be different
	    anc=${var}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc

	    echo ${afile}

	    # ftp transaction; Allow generous interpretation of filename
	    # as long the the varname is correct
	    wget --user=${USER} --password=${PASSWD} -O ${anc} ftp://${HOST}/${RPATH}/${labs[$counter]}/${models[$counter]}/${exp_res}/${var}_*.nc

	    
	done
	#   # end vars loop

    done
#   # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

