#!/bin/bash
# Calculate scalar differences proj-control for a number of models/experiments
# Subtract first entry from entire time series
# requires a full scalar archive with ctrl_proj and exps 

set -x
set -e

# Destination for 2d files
outpsc=/home/hgoelzer/Projects/ISMIP6/Archive_sc/Data/SC_GIC1_OBS0

## Settings
ares=05

## Remove bias
flg_rb=true

# or source default labs list
source ./set_default_cr.sh

# Override default
#declare -a labs=(LSCE)
#declare -a models=(GRISLI2)
#exps_res="expb04_05"

#declare -a labs=(UCIJPL)
#declare -a models=(ISSM1)
#exps_res="expa01_05 expa02_05 expa03_05 expb01_05 expb02_05 expb03_05"

#declare -a labs=(VUW)
#declare -a models=(PISM)
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05"

#declare -a labs=(JPL)
#declare -a models=(ISSM)
#exps_res="expb04_05"

declare -a labs=(UAF)
declare -a models=(PISM1)
exps_res="expa03_05"

# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

# Define files to process
#files="scalars_mm"
files="scalars_mm scalars_rm scalars_zm"

##### 
echo "------------------"
echo  netcdf calculations
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    echo ${labs[$counter]} ${models[$counter]}

    # A. set exps manually
    #exps_res=asmb_${ares}
    #exps_res="ctrl_${ares} historical_${ares}"
    #exps_res="exp05_${ares} ctrl_proj_${ares}"
    #exps_res="historical_${ares}"
    #exps_res="ctrl_${ares}"
    #exps_res="ctrl_proj_${ares} historical_${ares} exp05_${ares}"
    #exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"

    #exps_res="expa01_05 expa02_05 expa03_05"
    
    #exps_res="expb01_05 expb02_05 expb03_05 expb04_05 expb05_05"

    # B. find experiments automatically
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name exp*`
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name *_${ares}`
    #exps_res=`basename -a ${dexps}`

    echo "###"
    echo ${exps_res}

    # loop trough experiments
    for exp_res in ${exps_res}; do

	# strip resolution suffix from exp
	exp=${exp_res%???}
	
	# output dir
	ctrlpath=${outpsc}/${prefix}/${labs[$counter]}/${models[$counter]}/ctrl_proj_${ares}
	destpath=${outpsc}/${prefix}/${labs[$counter]}/${models[$counter]}/${exp_res}
	#mkdir -p ${destpath}
	
	# loop through files
	for afile in ${files}; do

	    anc_ctrl=${ctrlpath}/${afile}_GIS_${labs[$counter]}_${models[$counter]}_ctrl_proj.nc
	    anc_exp=${destpath}/${afile}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	    anc_diff=${destpath}/${afile}_cr_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc

	    if [ -f "$anc_ctrl" -a -f "$anc_exp" ]; then
		# difference to ctrl_proj
		ncdiff -O ${anc_exp} ${anc_ctrl} anc_cr_tmp.nc
		
		if ($flg_rb); then
		    # Remove offset
		    /bin/cp anc_cr_tmp.nc anc_cr_tmp0.nc
		    
		    # Get vars
		    vars=`ncks -m anc_cr_tmp0.nc  | grep "1 dimension" | grep -v time | awk -F ':' '{print $1}'`
		    echo $vars
		    for avar in $vars; do
			ncap2 -O -s "*var_tmp=${avar}(0); ${avar}=float(${avar}-var_tmp)" anc_cr_tmp0.nc anc_cr_tmp0.nc
		    done
		    /bin/mv anc_cr_tmp0.nc anc_cr_tmp.nc
		fi

		# add back constants
		ncks -A -v oarea,rhof,rhoi,rhow,dx,dy ${anc_exp} anc_cr_tmp.nc
		# move to Archive
		[ -f anc_cr_tmp.nc ] && /bin/mv anc_cr_tmp.nc ${anc_diff}

	    fi

	done
	# end file loop

    done
    # end exp loop
    
    counter=$(( counter+1 )) 
    
done
# end lab/model loop

