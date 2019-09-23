#!/bin/bash
# remap directory names

# location of tools
ptool=/home/hgoelzer/Projects/ISMIP6/Archive/tools/

# location of Archive
outp=/home/hgoelzer/Projects/ISMIP6/Archive

## labs list
#declare -a labs=(AWI AWI AWI)
## models list
#declare -a models=(ISSM1 ISSM2 ISSM3)
## res
#res=01
## exp mapping 
#declare -a inexps=(historical MIROC5-rcp85_Rmed NorESM1-rcp85_Rmed MIROC5-rcp26_Rmed HadGEM2-ES-rcp85_Rmed MIROC5-rcp85_Rhigh MIROC5-rcp85_Rlow)
#declare -a outexps=(hist exp05 exp06 exp07 exp08 exp09 exp10)

## labs list
#declare -a labs=(MUN MUN)
## models list
#declare -a models=(GSM2501 GSM2511)
## res
#res=05
## exp mapping 
#declare -a inexps=(historical)
#declare -a outexps=(hist)

## labs list
#declare -a labs=(UCIJPL)
## models list
#declare -a models=(ISSM)
## res
#res=01
## exp mapping 
#declare -a inexps=(historical)
#declare -a outexps=(hist)

## labs list
#declare -a labs=(JPL)
## models list
#declare -a models=(ISSM)
## res
#res=01
## exp mapping 
##declare -a inexps=(historical MIROC5-rcp85-Rmed)
##declare -a outexps=(hist exp05)
#declare -a inexps=(MIROC5-rcp85-Rmed)
#declare -a outexps=(exp05)

# labs list
declare -a labs=(JPL)
# models list
declare -a models=(ISSMPALEO)
# res
res=01
# exp mapping 
#declare -a inexps=(historical MIROC5-rcp85-Rmed)
#declare -a outexps=(hist exp05)
declare -a inexps=(MIROC5-rcp85-Rmed)
declare -a outexps=(exp05)

# variables
vars="lithk orog topg sftflf sftgif sftgrf"
#vars="tendlifmassbf tendlibmassbffl tendlibmassbf tendacabf tendlicalvf limnsw iareagr iareafl lim"



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
	indir=${outp}/${labs[$counter]}/${models[$counter]}/${inexps[$cexp]}_${res}/
	outdir=${outp}/${labs[$counter]}/${models[$counter]}/${outexps[$cexp]}_${res}/
	echo ${indir}
	cd ${indir}
	#   # loop trough vars
	for var in ${vars}; do

	    # this is the target name, but the file on the ftp may be different
	    #ancin=${var}_${labs[$counter]}_${models[$counter]}_${inexps[$cexp]}.nc # for JPLPALEO with "_GIS"
	    ancin=${var}_GIS_${labs[$counter]}_${models[$counter]}_${inexps[$cexp]}.nc
	    ancout=${var}_GIS_${labs[$counter]}_${models[$counter]}_${outexps[$cexp]}.nc

	    # rename file
	    #ls $ancin
	    #ls $ancout
	    echo $ancin
	    echo $ancout
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

