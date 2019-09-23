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

### labs list
#declare -a labs=(VUB)
## models list
#declare -a models=(GISMSIAv1)

### labs list
#declare -a labs=(IMAU)
## models list
#declare -a models=(IMAUICE1)

## labs list
#declare -a labs=(JPL JPL)
## models list
#declare -a models=(ISSM ISSMPALEO)
#explist="MIROC5-rcp85-Rmed_01"

## labs list
#declare -a labs=(LSCE)
## models list
#declare -a models=(GRISLI)
#explist="exp05_05"

# labs list
declare -a labs=(MUN MUN)
# models list
declare -a models=(GSM2501 GSM2511)
explist="exp05"

## labs list
#declare -a labs=(JPL)
## models list
#declare -a models=(ISSM)
#explist="MIROC5-rcp85-Rmed_01"

## labs list
#declare -a labs=(GSFC)
## models list
#declare -a models=(ISSM)
#explist="exp05_01"

## labs list
#declare -a labs=(UCIJPL)
## models list
#declare -a models=(ISSM1)
#explist="exp05_01"


# strip resolution suffix
flg_strip=true
#flg_strip=false # for models that do not have res suffix: MUN

# variables
#vars="sftgrf"
vars="lithk orog topg sftflf sftgif sftgrf"
#vars="lithk"
#vars="orog topg sftflf sftgif sftgrf"

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

    ## find experiments
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d `
    #echo ${dexps}
    #exps_res=`basename -a ${dexps}`
    #echo "###"
    #echo ${exps_res}

    # specify exps manually
    exps_res=${explist}
    echo ${exps_res}

    # loop trough experiments    
    for exp_res in ${exps_res}; do

	mkdir -p ${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}/
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
	    anc=${var}_GIS_${labs[$counter]}_${models[$counter]}\*_${exp}.nc

	    echo ${afile}

	    # ftp transaction; Allow generous interpretation of filename
	    # as long the the varname is correct
	    scp -i ~/.ssh/id_rsa_ghub ${HOST}:${RPATH}/${labs[$counter]}/${models[$counter]}/${exp_res}/${var}_*.nc ${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}/

	    
	done
	#   # end vars loop

    done
#   # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

