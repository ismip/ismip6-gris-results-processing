#!/bin/bash
# update Archive_sc from download Archive

# location of Archive
inp=/home/hgoelzer/Projects/ISMIP6/Archive/Data

# location of Archive_sc
outp=/home/hgoelzer/Projects/ISMIP6/Archive_sc/Data

## labs list
#declare -a labs=(AWI AWI AWI ILTS_PIK ILTS_PIK JPL JPL MUN UCIJPL VUB)
## models list
#declare -a models=(ISSM1 ISSM2 ISSM3 SICOPOLIS2 SICOPOLIS3 ISSM ISSMPALEO GSM2371 ISSM GISMSIAv1)

## labs list
#declare -a labs=(MUN)
## models list
#declare -a models=(GSM2371)

## labs list
#declare -a labs=(JPL JPL)
## models list
#declare -a models=(ISSM ISSMPALEO)

# labs list
declare -a labs=(IMAU)
# models list
declare -a models=(IMAUICE1)


# variables
vars="tendlifmassbf tendlibmassbffl tendlibmassbf tendacabf tendlicalvf limnsw iareagr iareafl lim"

# check array sizes match models
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

##### 
echo "------------"
echo  copy sc data
echo "------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do
    
    # find experiments
    dexps=`find ${inp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d `
    exps_res=`basename -a ${dexps}`
    echo "###"
    echo ${exps_res}
    # loop trough experiments    
    for exp_res in ${exps_res}; do

	# strip resolution suffix from exp
	exp=${exp_res%???}

	# set up dir names
	indir=${inp}/${labs[$counter]}/${models[$counter]}/${exp_res}
	outdir=${outp}/${labs[$counter]}/${models[$counter]}/${exp}

	# make target dir
	echo ${outdir}
	mkdir -p ${outdir}

	#   # loop trough vars
	for var in ${vars}; do

	    # target filename
	    anc=${var}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc

	    # copy file
#	    echo ${outdir}/${anc}
	    /bin/cp ${indir}/${anc} ${outdir}/${anc}
	done
	#   # end vars loop
	
    done
#   # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

