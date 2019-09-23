#!/bin/bash
# remap directory names

# location of tools
ptool=/home/hgoelzer/Projects/ISMIP6/Archive_sc/tools/

# location of Archive
outp=/home/hgoelzer/Projects/ISMIP6/Archive_sc

### labs list
#declare -a labs=(AWI AWI AWI)
## models list
#declare -a models=(ISSM1 ISSM2 ISSM3)
## exp mapping 
#declare -a inexps=(historical MIROC5-rcp85_Rmed NorESM1-rcp85_Rmed MIROC5-rcp26_Rmed HadGEM2-ES-rcp85_Rmed MIROC5-rcp85_Rhigh MIROC5-rcp85_Rlow)
#declare -a outexps=(hist exp05 exp06 exp07 exp08 exp09 exp10)

## labs list
#declare -a labs=(MUN)
## models list
#declare -a models=(GSM2371)
## exp mapping 
#declare -a inexps=(historical)
#declare -a outexps=(hist)

## labs list
#declare -a labs=(UCIJPL)
## models list
#declare -a models=(ISSM)
## exp mapping 
#declare -a inexps=(historical)
#declare -a outexps=(hist)

# labs list
declare -a labs=(JPL JPL)
# models list
declare -a models=(ISSM ISSMPALEO)
# exp mapping 
declare -a inexps=(historical MIROC5-rcp85-Rmed NorESM1-rcp85-Rmed MIROC5-rcp26-Rmed HadGEM2-ES-rcp85-Rmed MIROC5-rcp85-Rhigh MIROC5-rcp85-Rlow)
declare -a outexps=(hist exp05 exp06 exp07 exp08 exp09 exp10)

## labs list
#declare -a labs=(VUB)
## models list
#declare -a models=(GISMSIAv1)
## exp mapping 
#declare -a inexps=(MIROC5_asmb MIROC5_ctrl MIROC5_histo MIROC5-rcp85_Rhigh MIROC5-rcp85_Rlow MIROC5-rcp85_Rmed)
#declare -a outexps=(asmb ctrl hist exp09 exp10 exp05)

# variables
vars="tendlifmassbf tendlibmassbffl tendlibmassbf tendacabf tendlicalvf limnsw iareagr iareafl lim"



# check array sizes match models
if [ ${#labs[@]} -eq ${#models[@]} ]; then 
    count=${#models[@]}
else
    echo Error: length of labs and models has to match  
    exit 1
fi
# check array sizes match exps
if [ ${#inexps[@]} -eq ${#outexps[@]} ]; then 
    expnum=${#outexps[@]}
else
    echo Error: length of inexps and outexps has to match  
    exit 1
fi

##### 
echo "------------------"
echo  Remapping file names 
echo "------------------"

# loop trough labs/models
counter=0
while [ $counter -lt ${count} ]; do
    
    cexp=0
    # loop trough experiments    
    while [ $cexp -lt ${expnum} ]; do

	# go into exp dir and rename files
	indir=${outp}/${labs[$counter]}/${models[$counter]}/${inexps[$cexp]}
	outdir=${outp}/${labs[$counter]}/${models[$counter]}/${outexps[$cexp]}
	echo ${indir}
	cd ${indir}
	#   # loop trough vars
	for var in ${vars}; do

	    # this is the target name, but the file on the ftp may be different
	    ancin=${var}_GIS_${labs[$counter]}_${models[$counter]}_${inexps[$cexp]}.nc
	    ancout=${var}_GIS_${labs[$counter]}_${models[$counter]}_${outexps[$cexp]}.nc

	    # rename file
	    mv ${ancin} ${ancout}
	done
	#   # end vars loop
	
	# Now rename the dir itself
	mv ${indir} ${outdir}

	cexp=$(( cexp+1 )) 
    done
#   # end exp loop
    
    counter=$(( counter+1 )) 
done
# end lab/model loop

