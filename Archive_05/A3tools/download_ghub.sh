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
RPATH=/projects/grid/ghub/ISMIP6/Projections/GrIS/output

## labs list
#declare -a labs=(ILTS_PIK ILTS_PIK)
#declare -a models=(SICOPOLIS2 SICOPOLIS3)
#explist="ctrl_proj_05 exp05_05"
##explist="historical_05 ctrl_proj_05 exp05_05"
##explist="historical_05"

## labs list
#declare -a labs=(LSCE)
#declare -a models=(GRISLI)
#explist="historical_05 ctrl_proj_05 exp05_05"

## labs list
#declare -a labs=(MUN MUN)
#declare -a models=(GSM2601 GSM2611)
#explist="historical_05 ctrl_proj_05 exp05_05"

## labs list
#declare -a labs=(VUB)
#declare -a models=(GISMSIAv2)
#explist="hist_05"
##explist="hist_05 ctrl_proj_05 exp05_05"
##explist="historical_05 ctrl_proj_05 exp05_05"



# labs list
declare -a labs=(ILTS_PIK ILTS_PIK LSCE MUN MUN)
declare -a models=(SICOPOLIS2 SICOPOLIS3 GRISLI GSM2601 GSM2611)
#explist="ctrl_proj_05 exp05_05"
#explist="historical_05 ctrl_proj_05 exp05_05"
#explist="historical_05"
explist="exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"


# variables
#vars="xvelmean yvelmean"
#vars="sftgrf"
#vars="lithk orog topg sftflf sftgif sftgrf"
#vars="xvelmean yvelmean acabf"
#vars="lithk"
#vars="orog topg sftflf sftgif sftgrf"
vars="lithk orog topg sftflf sftgif sftgrf xvelmean yvelmean acabf"

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

