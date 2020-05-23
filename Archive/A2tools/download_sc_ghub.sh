#!/bin/bash
# download specific files recursively
# Depends on a directory structure already in place. Can be created by starting
# an ftp download and interupt after first file starts loading.

# NASA credentials
HOST='transfer.ccr.buffalo.edu'
USER='hgoelzer'

# location of Archive
outp=/home/hgoelzer/Projects/ISMIP6/Archive/Data

# Remote path
RPATH=/projects/grid/ghub/ISMIP6/Projections/GrIS/output

## labs list
#declare -a labs=(VUB)
## models list
#declare -a models=(GISMSIAv1)

## labs list
#declare -a labs=(IMAU)
# models list
#declare -a models=(IMAUICE1)

#### Final archive
## All in
#declare -a labs=(AWI AWI AWI BGC GSFC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE MUN MUN NCAR UAF UAF UCIJPL UCIJPL VUB VUW)
#declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES ISSM SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI2 GSM2601 GSM2611 CISM PISM1 PISM2 ISSM1 ISSM2 GISMHOMv1 PISM)
## All available
#declare -a labs=(ILTS_PIK ILTS_PIK IMAU IMAU LSCE MUN MUN NCAR UCIJPL UCIJPL VUB VUW)
#declare -a models=(SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 GRISLI2 GSM2601 GSM2611 CISM ISSM1 ISSM2 GISMHOMv1 PISM)

declare -a labs=(NCAR)
declare -a models=(CISM)

# strip resolution suffix
flg_strip=true
#flg_strip=false # for models that do not have res suffix: MUN

# variables
vars="tendacabf limnsw iareagr iareafl lim"

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

	# strip resolution suffix from exp
	if [ "$flg_strip" = true ]; then
	    exp=${exp_res%???}
	else
	    exp=${exp_res}
	fi

	cd ${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}/
	#   # loop trough vars
	for var in ${vars}; do

	    # this is the target name, but the file on the ftp may be different
	    anc=${var}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc

	    echo ${anc}

	    # scp transaction; Allow generous interpretation of filename
	    # as long the the varname is correct
	    scp -i ~/.ssh/id_rsa_ghub ${HOST}:${RPATH}/${labs[$counter]}/${models[$counter]}/${exp_res}/${var}_*.nc ${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}/

	    
	done
	#   # end vars loop

    done
#   # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

