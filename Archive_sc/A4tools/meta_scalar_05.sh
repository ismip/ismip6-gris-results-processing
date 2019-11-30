#!/bin/bash
# Calculate scalar values for a number of models/experiments

set -x
set -e

# location of Archive
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive_05/Data
outp=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data

# Destination for scalar files
outpsc=/home/hgoelzer/Projects/ISMIP6/Archive_sc/Data

## Settings
# Remove GIC contribution? 
#flg_GICmask=false # [Default true!]
flg_GICmask=true # [Default true!]
# Remove ice outside observed ice mask (can be combined with GIC masking) 
flg_OBSmask=false # [Default false!]

ares=05

declare -a labs=(AWI AWI)
declare -a models=(ISSM2 ISSM3)

## labs/models lists
#declare -a labs=(ILTS_PIK)
#declare -a models=(SICOPOLIS2)

# labs/models lists
#declare -a labs=(IMAU)
#declare -a models=(IMAUICE1)

# labs/models lists
#declare -a labs=(JPL)
#declare -a models=(ISSM)

# labs/models lists
#declare -a labs=(MUN)
#declare -a models=(GSM2371)

# labs/models lists
#declare -a labs=(UCIJPL)
#declare -a models=(ISSM)

# labs/models lists
#declare -a labs=(VUB)
#declare -a models=(GISMSIAv1)

## labs/models lists
#declare -a labs=(LSCE)
#declare -a models=(GRISLI)




# labs/models lists
#declare -a labs=(LSCE)
#declare -a models=(GRISLI)

# labs/models lists
#declare -a labs=(IMAU LSCE)
#declare -a models=(IMAUICE2 GRISLI)

# labs/models lists
#declare -a labs=(ILTS_PIK IMAU LSCE)
#declare -a models=(SICOPOLIS2 IMAUICE2 GRISLI)

# labs/models lists
#declare -a labs=(AWI AWI AWI ILTS_PIK ILTS_PIK IMAU JPL JPL)
#declare -a models=(ISSM1 ISSM2 ISSM3 SICOPOLIS2 SICOPOLIS3 IMAUICE1 ISSM ISSMPALEO)

# labs/models lists
#declare -a labs=(GSFC  ILTS_PIK ILTS_PIK  JPL JPL  LSCE  MUN MUN  UCIJPL)
#declare -a models=(ISSM SICOPOLIS2 SICOPOLIS3 ISSM ISSMPALEO GRISLI GSM2501 GSM2511 ISSM)

# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

##### 
echo "------------------"
echo  netcdf calculations
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    echo ${labs[$counter]} ${models[$counter]}

    proc=${labs[$counter]}_${models[$counter]}
    mkdir -p ${proc}
    cd ${proc}

    # A. set exps manually
    #exps_res=asmb_05
    #exps_res="ctrl_05 historical_05"
    #exps_res="exp05_05"
    #exps_res="historical_05"
    #exps_res="ctrl_05"
    exps_res="historical_05 ctrl_proj_05 exp05_05"
    
    # B. find experiments automatically
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name exp*`
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name *_05`
    #exps_res=`basename -a ${dexps}`

    echo "###"
    echo ${exps_res}

    
    # loop trough experiments to calculate scalars
    for exp_res in ${exps_res}; do

	apath=${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}
	# strip resolution suffix from exp
	exp=${exp_res%???}
	# input file name
	anc=${apath}/lithk_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -3 -O -v lithk ${anc} model_pre.nc
	anc=${apath}/topg_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -3 -A -v topg ${anc} model_pre.nc

	anc=${apath}/sftflf_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -3 -A -v sftflf ${anc} model_pre.nc
	anc=${apath}/sftgif_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -3 -A -v sftgif ${anc} model_pre.nc
	anc=${apath}/sftgrf_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -3 -A -v sftgrf ${anc} model_pre.nc

	# set missing to zero like during interpolation 
	cdo -setmisstoc,0.0  model_pre.nc model.nc 

	# Add model params
	ncks -3 -A ${outp}/${labs[$counter]}/${models[$counter]}/params.nc model.nc

	### scalar calculations; expect model input in model.nc
	../scalars_basin.sh $flg_GICmask $flg_OBSmask 05

	# Make settings specific output paths
	prefix=SC
	# Remove GIC contribution? 
	if $flg_GICmask; then
	    prefix=${prefix}_GIC1
	else
	    prefix=${prefix}_GIC0
	fi
	# Mask to observed?
	if $flg_OBSmask; then
	    prefix=${prefix}_OBS1
	else
	    prefix=${prefix}_OBS0
	fi
	destpath=${outpsc}/${prefix}/${labs[$counter]}/${models[$counter]}/${exp_res}
	mkdir -p ${destpath}
	### move output ./scalars_??_05.nc to Archive
	[ -f ./scalars_mm_05.nc ] && /bin/mv ./scalars_mm_05.nc ${destpath}/scalars_mm_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	[ -f ./scalars_rm_05.nc ] && /bin/mv ./scalars_rm_05.nc ${destpath}/scalars_rm_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	[ -f ./scalars_zm_05.nc ] && /bin/mv ./scalars_zm_05.nc ${destpath}/scalars_zm_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	#/bin/rm model.nc
    done
    # end exp loop
    
    counter=$(( counter+1 )) 
    
    # back to top level directory
    cd ../
done
# end lab/model loop

