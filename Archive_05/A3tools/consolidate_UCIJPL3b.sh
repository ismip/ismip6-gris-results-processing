#!/bin/bash
# checks and corrections

# re-calculate masks

#set -x

# location of Archive
#outp=/Volumes/ISMIP6/ISMIP6-Greenland/Archive_05/Data
outp=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data

declare -a labs=(UCIJPL)
declare -a models=(ISSM1)

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
    #exps_res="historical_05"
    
    exps_res="expa01_05 expa02_05 expa03_05"

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

	# Get sftgif from lithk
	anc=${apath}/sftgif_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	anc_lithk=${apath}/lithk_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -O -v lithk ${anc_lithk} sftgif_tmp.nc
	ncap2 -O -s 'sftgif = lithk*0; where(lithk>10) sftgif=1' sftgif_tmp.nc sftgif_tmp.nc
	ncks -O -v sftgif sftgif_tmp.nc sftgif_tmp2.nc
	# move file back 
	/bin/mv sftgif_tmp2.nc ${anc}
	echo ${anc}

	# Fix sftgrf difference between sftgif and sftflf
	anc=${apath}/sftgrf_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	anc_fl=${apath}/sftflf_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	anc_li=${apath}/sftgif_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc
	ncks -O -v sftflf  ${anc_fl} sftgrf_tmp.nc
	ncks -A -v sftgif  ${anc_li} sftgrf_tmp.nc
	ncap2 -O -s 'sftgrf = sftgif-sftflf' sftgrf_tmp.nc sftgrf_tmp.nc
	ncap2 -O -s 'where(sftgrf<1) sftgrf=0' sftgrf_tmp.nc sftgrf_tmp.nc	
	ncks -A -v sftgrf sftgrf_tmp.nc sftgrf_tmp2.nc	
	# move file back 
	/bin/mv sftgrf_tmp2.nc ${anc}

	
	echo ${anc}
    done
    # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

