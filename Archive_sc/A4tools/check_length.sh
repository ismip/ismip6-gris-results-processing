#!/bin/bash
# checks record length across the ensemble

#set -x

# location of Archive
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive_sc/Data
outp=/home/hgoelzer/Projects/ISMIP6/Archive_sc/Data/SC_GIC1_OBS0

# or source default labs list
source ./set_default.sh

#declare -a labs=(LSCE)
#declare -a models=(GRISLI2)

#declare -a labs=(UAF)
#declare -a models=(PISM1)

#declare -a labs=(UAF)
#declare -a models=(PISM2)

#declare -a labs=(VUB)
#declare -a models=(GISMSIAv3)

## Individual submissions
#declare -a labs=(GSFC)
#declare -a models=(ISSM)
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05   expa01_05 expa02_05 expa03_05   expb01_05 expb02_05"

#declare -a labs=(UCIJPL)
#declare -a models=(ISSM1)
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05 expa01_05 expa02_05 expa03_05 expb01_05 expb02_05 expb03_05"

#declare -a labs=(UCIJPL)
#declare -a models=(ISSM2)
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05"

#declare -a labs=(JPL)
#declare -a models=(ISSM)
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05   expa01_05 expa02_05 expa03_05   expb01_05 expb02_05 expb03_05 expb05_05"

#declare -a labs=(JPL)
#declare -a models=(ISSMPALEO)
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05   expb01_05 expb02_05 expb03_05 expb05_05"

#declare -a labs=(JPL)
#declare -a models=(ISSM)
#exps_res="expb04_05"

#declare -a labs=(UAF)
#declare -a models=(PISM1)


# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

vars="scalars_mm"

##### 
echo "------------------"
echo  netcdf corrections
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    echo "###"
    echo ${labs[$counter]} ${models[$counter]}
    # set exps manually
    #exps_res="exp05_05"
    #exps_res="ctrl_proj_05 exp05_05"
    #exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"
    #exps_res="expa01_05 expa02_05 expa03_05 expb01_05 expb02_05 expb03_05"
    #exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05"
    #exps_res="expa01_05 expa02_05 expa03_05"
    #exps_res="expb01_05 expb02_05 expb03_05 expb04_05 expb05_05"
    
    # find experiments
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name *_05`
    dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d -name exp*_05`
    exps_res=`basename -a ${dexps}`

    echo ${exps_res}
    echo "#"

    
    # loop trough experiments 
    for exp_res in ${exps_res}; do

	apath=${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}
	# strip resolution suffix from exp
	exp=${exp_res%???}

        # loop through variables
	for avar in ${vars}; do

	    # input file name
	    #scalars_mm_GIS_VUB_GISMHOMv1_expb01.nc
	    anc=${apath}/${avar}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	    #echo ${anc}
	    # get length of record
	    ll=`ncap2 -v -O -s 'print(time.size(),"%ld\n");' ${anc} foo.nc`
	    # remove first entry if ll>86
	    echo "ll = ${ll} "
	    if [ "$ll" -ne 86 ]; then
		echo ${anc}
	    fi

	done
	# end var loop

    done
    # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

