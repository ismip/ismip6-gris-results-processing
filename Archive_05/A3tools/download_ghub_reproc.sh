#!/bin/bash
# Download files from Archive A1

# We try to correct minor filename problems by specifying the correct target name
# See alos setting <flg_resadd> for cases where the resolution suffix is missing

# Can be run to depends on a directory structure already in place. 
# In that case we update files in the existing directory structure 

# Or specify groups/models manually 


# UB credentials
HOST='transfer.ccr.buffalo.edu'
USER='hgoelzer'

# location of Archive
# Mac Heiko
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive/Data
# Lisa/Cartesius
outp=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data

# Remote path
RPATH=/projects/grid/ghub/ISMIP6/Projections/Reprocessed/GIS/Archive_05

## labs list
#declare -a labs=(BGC )
#declare -a models=(BISICLES )
##explist="ctrl_proj_05 exp05_05"
#explist="ctrl_proj_05 historical"

### labs list
#declare -a labs=(IMAU)
#declare -a models=(IMAUICE1)
#explist="exp05_05"

## labs list
declare -a labs=(UAF)
declare -a models=(PISM2)
explist="ctrl_proj_05  exp01_05"

### labs list
#declare -a labs=(BGC GSFC IMAU JPL JPL UAF UAF UCIJPL UCIJPL)
#declare -a models=(BISICLES ISSM IMAUICE1 ISSM ISSMPALEO PISM1 PISM2 ISSM1 ISSM2)
##explist="ctrl_proj_05 exp05_05"
#explist="historical_05"


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
echo  Downloading files 
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    echo ${labs[$counter]}
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
	
	# strip resolution suffix from exp
	exp=${exp_res%???}

	# exname is directory on server
	if [ "$flg_resadd" = true ]; then
	    expname=${exp}
	else
	    expname=${exp_res}
	fi
	#   # loop trough vars
	for var in ${vars}; do

	    # this is the target name, but the file on the ftp may be different
	    anc=${var}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc

	    echo ${anc}

	    # ftp transaction; Allow generous interpretation of filename
	    # as long the the varname is correct
	    scp -i ~/.ssh/id_rsa_ghub ${HOST}:${RPATH}/${labs[$counter]}/${models[$counter]}/${expname}/${var}_*.nc ${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}/${anc}

	    
	done
	#   # end vars loop

    done
#   # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

