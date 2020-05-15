#!/bin/bash
# Download files from Archive A1

# We try to correct minor filename problems by specifying the correct target name
# See alos setting <flg_resadd> for cases where the resolution suffix is missing

# Can be run to depend on a directory structure already in place. 
# In that case we update files in the existing directory structure 

# Or specify groups/models manually 


# UB credentials
HOST='transfer.ccr.buffalo.edu'
USER='hgoelzer'

# location of Archive
# Mac Heiko
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive/Data
# Lisa/Cartesius
outp=/home/hgoelzer/Projects/ISMIP6/Archive/Data

# Remote path
RPATH=/projects/grid/ghub/ISMIP6/Projections/GrIS/output


## labs list
#declare -a labs=(AWI)
## models list
#declare -a models=(ISSM1)
#explist="MIROC5-rcp85_Rmed_01"


## labs list
#declare -a labs=(GSFC)
## models list
#declare -a models=(ISSM)
#explist="exp05_01"


## labs list
#declare -a labs=(ILTS_PIK ILTS_PIK)
## models list
#declare -a models=(SICOPOLIS2 SICOPOLIS3)
#explist="exp05_05"


### labs list
#declare -a labs=(IMAU)
#declare -a models=(IMAUICE2)
#explist="historical_05 exp05_05 ctrl_proj_05"


## labs list
#declare -a labs=(JPL JPL)
## models list
#declare -a models=(ISSM ISSMPALEO)
#explist="MIROC5-rcp85-Rmed_01"


## labs list
#declare -a labs=(LSCE)
## models list
#declare -a models=(GRISLI)
#explist="exp05_05 hist_05 ctrl_proj_05"


## labs list
#declare -a labs=(MUN MUN)
## models list
#declare -a models=(GSM2501 GSM2511)
## specify with suffix even if missing on server. Set flg_resadd instead
#explist="exp05_05"
#flg_resadd=true # for models that do not have res suffix


## labs list
#declare -a labs=(UCIJPL)
## models list
#declare -a models=(ISSM1)
#explist="exp05_01"

### labs list
#declare -a labs=(VUB)
## models list
#declare -a models=(GISMSIAv1)

#declare -a labs=(UAF)
#declare -a models=(PISM1)
#explist="expb02_01"

declare -a labs=(VUW)
declare -a models=(PISM)
explist="historical ctrl_proj"
#explist="historical ctrl_proj exp05 exp06 exp07 exp08"


# variables
#vars="sftgrf"
#vars="lithk orog topg sftflf sftgif sftgrf"
#vars="lithk"
#vars="orog topg sftflf sftgif sftgrf"
#vars="acabf"
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

