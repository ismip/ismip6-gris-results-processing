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
#declare -a labs=(AWI AWI AWI)
#declare -a models=(ISSM1 ISSM2 ISSM3)
#explist="historical_05 ctrl_proj_05 exp05_05"
#explist="historical_05"

### labs list
#declare -a labs=(BGC )
#declare -a models=(BISICLES )
#explist="historical_05"

#declare -a labs=(GSFC)
#declare -a models=(ISSM)
#explist="historical_05 ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"

### labs list
#declare -a labs=(IMAU)
#declare -a models=(IMAUICE1)
#explist="exp05_05"

## labs list
#declare -a labs=(JPL)
#declare -a models=(ISSMPALEO)
#explist="ctrl_proj_05  exp01_05"
#explist="historical_05 ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"

#declare -a labs=(NCAR)
#declare -a models=(CISM)
##explist="historical_05 ctrl_proj_05 exp05_05"
##explist="exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"
#explist="historical_05 ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"

#### labs list
#declare -a labs=(UAF)
#declare -a models=(PISM1)
#explist="historical_05 ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"
#explist="exp10_05"

## labs list
#declare -a labs=(UCIJPL)
#declare -a models=(ISSM1)
##explist="historical_05 ctrl_proj_05 exp05_05"
#explist="historical_05 ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"

#declare -a labs=(VUW)
#declare -a models=(PISM)
#explist="historical_05 ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05"


#declare -a labs=(UAF)
#declare -a models=(PISM2)
#explist="historical_05 ctrl_proj_05 exp01_05 exp02_05 exp03_05 exp04_05"

#declare -a labs=(UCIJPL)
#declare -a models=(ISSM2)
#explist="historical_05"
#explist="historical_05 ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05"


### labs list
#declare -a labs=(BGC GSFC IMAU JPL JPL UAF UAF UCIJPL UCIJPL)
#declare -a models=(BISICLES ISSM IMAUICE1 ISSM ISSMPALEO PISM1 PISM2 ISSM1 ISSM2)
##explist="ctrl_proj_05 exp05_05"
#explist="historical_05"

#declare -a labs=(AWI AWI AWI BGC IMAU IMAU JPL JPL NCAR UAF UCIJPL)
#declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES IMAUICE1 IMAUICE2 ISSM ISSMPALEO CISM PISM1 ISSM1)
##explist="historical_05 ctrl_proj_05 exp05_05"
#explist="exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"

###########################################################
#declare -a labs=(AWI AWI AWI BGC GSFC IMAU JPL NCAR UAF UAF UCIJPL)
#declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES ISSM IMAUICE2 ISSM CISM PISM1 PISM2 ISSM1)
#explist="expa01_05 expa02_05 expa03_05 "

#declare -a labs=(GSFC)
#declare -a models=(ISSM)
#explist="expa01_05 expa02_05 expa03_05 "

# b
# AWI-ISSM b12345
# NCAR-CISM b12345

# UAF-PISM b1235
# IMAU2 b1235

# BGC b123
# UCIJPL-ISSM b123

# GSFC-ISSM b12
# JPL-ISSM b12

#declare -a labs=(AWI AWI AWI NCAR)
#declare -a models=(ISSM1 ISSM2 ISSM3 CISM)
#explist="expb01_05 expb02_05 expb03_05 expb04_05 expb05_05"
#
#
declare -a labs=(IMAU UAF UAF)
declare -a models=(IMAUICE2 PISM1 PISM2)
explist="expb01_05 expb02_05 expb03_05 expb05_05"

#declare -a labs=(BGC UCIJPL)
#declare -a models=(BISICLES ISSM1)
#explist="expb01_05 expb02_05 expb03_05"

#declare -a labs=(GSFC JPL)
#declare -a models=(ISSM ISSM)
#explist="expb01_05 expb02_05"





#declare -a labs=(AWI AWI AWI BGC GSFC IMAU JPL NCAR UAF UAF UCIJPL)
#declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES ISSM IMAUICE2 ISSM CISM PISM1 PISM2 ISSM1)
#explist="expb01_05 expb02_05 expb03_05 expb04_05 expb05_05"




# variables
vars="lithk orog topg sftflf sftgif sftgrf xvelmean yvelmean acabf"

#vars="sftgrf"
#vars="lithk orog topg sftflf sftgif sftgrf"
#vars="xvelmean yvelmean acabf"
#vars="lithk"
#vars="orog topg sftflf sftgif sftgrf"
#vars="sftflf sftgif sftgrf"

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
	    # NCAR workaround
	    #scp -i ~/.ssh/id_rsa_ghub ${HOST}:${RPATH}/${labs[$counter]}/${expname}/${var}_*.nc ${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}/${anc}

	    scp -i ~/.ssh/id_rsa_ghub ${HOST}:${RPATH}/${labs[$counter]}/${models[$counter]}/${expname}/${var}_*.nc ${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}/${anc}

	    
	done
	#   # end vars loop

    done
#   # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

