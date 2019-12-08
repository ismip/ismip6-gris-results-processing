#!/bin/bash
# checks and corrections

# add missing 2100

#set -x

# location of Archive
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive_05/Data
outp=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data


declare -a labs=(LSCE)
declare -a models=(GRISLI)

# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

vars="lithk orog topg sftgif sftgrf sftflf xvelmean yvelmean acabf"

##### 
echo "------------------"
echo  netcdf corrections
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    echo ${labs[$counter]} ${models[$counter]}
    # set exps manually
    #exps_res=asmb_05
    #exps_res="ctrl_05 hist_05"
    #exps_res="ctrl_proj_05 exp05_05"
    #exps_res="ctrl_proj_05"
    exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"
    #exps_res="hist_05"
    
    # find experiments
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

	# loop through variables
	for avar in ${vars}; do

	    # copy year 2099
	    anc=${apath}/${avar}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	    # get length of record
	    ll=`ncap2 -v -O -s 'print(time.size(),"%ld\n");' ${anc} foo.nc`
	    if [ "$ll" -lt 87 ]; then
		/bin/cp ${anc} ${avar}_tmp.nc
		# extract last and second to last time step
		ncks -d time,-1 ${avar}_tmp.nc ${avar}_tmp1.nc
		# change time +360 days
		ncap2 -O -s "time = time+360" ${avar}_tmp1.nc ${avar}_tmp1.nc
		# concat
		ncrcat ${avar}_tmp.nc  ${avar}_tmp1.nc ${avar}_full.nc
		# move back in place
		/bin/mv ${avar}_full.nc ${anc}
		# clean up 
		/bin/rm ${avar}_tmp1.nc ${avar}_tmp.nc
	    
		echo ${anc}
	    else
		echo "ll = ${ll}: nothing done "
	    fi
	done
    done
    # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop
