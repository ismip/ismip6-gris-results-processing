#!/bin/bash
# nccopy and compress a number of files

set -x 
set -e

# location of input Archive
outp=/home/hgoelzer/Projects/ISMIP6/Archive/Data

# location of output Archive
outp05=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data

# labs list
declare -a labs=(VUB)
# models list
declare -a models=(GISMSIAv1)

## labs list
#declare -a labs=(ILTS_PIK ILTS_PIK LSCE MUN MUN VUB)
## models list
#declare -a models=(SICOPOLIS2 SICOPOLIS3 GRISLI GSM2501 GSM2511 GISMSIAv1)


# variables
#vars="lithk"
#vars="sftgrf"
#vars="orog topg sftflf sftgif sftgrf"
vars="lithk orog topg sftgif sftgrf sftflf "

# array sizes match
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi

##### 
echo "------------------"
echo  Copy files 
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do

    echo ${labs[$counter]} ${models[$counter]}
    # 1. Set exps manually
    #exps_res=asmb_05
    #exps_res="ctrl_05 hist_05"
    exps_res="exp05_05"
    #exps_res="hist_05"
    echo "###"
    echo ${exps_res}

    ## 2. Or find experiments
    #dexps=`find ${outp}/${labs[$counter]}/${models[$counter]}/* -maxdepth 0 -type d `
    #exps_res=`basename -a ${dexps}`
    #echo "###"
    #echo ${exps_res}
    
    # loop trough experiments    
    for exp_res in ${exps_res}; do

	cd ${outp}/${labs[$counter]}/${models[$counter]}/${exp_res}/
	#   # loop trough vars
	for var in ${vars}; do

	    # strip resolution suffix from exp
	    exp=${exp_res%???}
	    # Add target res suffix
	    expresout=${exp}_05
	    # target dir
	    mkdir -p ${outp05}/${labs[$counter]}/${models[$counter]}/${expresout}
	    # input and output file names are the same
	    anc=${var}_GIS_${labs[$counter]}_${models[$counter]}_${exp}.nc

	    pwd
	    echo ${anc}

	    # copying
	    nccopy -d1 ${anc} ${outp05}/${labs[$counter]}/${models[$counter]}/${expresout}/${anc} 

	done
	#   # end vars loop

    done
#   # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

