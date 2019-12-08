#!/bin/bash
# checks and corrections

# convert masks

#set -x

# location of Archive
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive_05/Data
outp=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data

declare -a labs=(UCIJPL)
declare -a models=(ISSM2)

# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

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
    #exps_res="exp05_05"
    exps_res="historical_05"
    
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

	# Fix sftgif which has wrong magnitude
	anc=${apath}/sftgif_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncap2 -O -s 'sftgif = sftgif*6.' ${anc} sftgif_tmp.nc
	ncap2 -O -s 'where(sftgif>1) sftgif=1' sftgif_tmp.nc sftgif_tmp.nc	
	# move file back 
	/bin/mv sftgif_tmp.nc ${anc}

	echo ${anc}
	# Fix sftgrf which has wrong magnitude
	anc=${apath}/sftgrf_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncap2 -O -s 'sftgrf = sftgrf*36.' ${anc} sftgrf_tmp.nc
	ncap2 -O -s 'where(sftgrf>1) sftgrf=1' sftgrf_tmp.nc sftgrf_tmp.nc	
	# move file back 
	/bin/mv sftgrf_tmp.nc ${anc}

	echo ${anc}
	# Fix sftflf which has wrong magnitude
	anc=${apath}/sftflf_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncap2 -O -s 'sftflf = sftflf*36.' ${anc} sftflf_tmp.nc
	ncap2 -O -s 'where(sftflf>1) sftflf=1' sftflf_tmp.nc sftflf_tmp.nc	
	# move file back 
	/bin/mv sftflf_tmp.nc ${anc}
	
	echo ${anc}
    done
    # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

