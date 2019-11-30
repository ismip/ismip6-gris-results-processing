#!/bin/bash
# Calculate scalar values for a models/experiment

if [[ $# -ne 8 ]]; then
    echo "Illegal number of parameters. Need 8 got $#"
    exit 2
fi

set -x
set -e

# parameters

outp=$1
lab=$2
model=$3
exp_res=$4
flg_GICmask=$5
flg_OBSmask=$6
res=$7
outpsc=$8

##############################

## wherever we are, use a unique directory to run in, created by meta
proc=${lab}_${model}_${exp_res}
cd ${proc}

apath=${outp}/${lab}/${model}/${exp_res}
# strip resolution suffix from exp
exp=${exp_res%???}
# input file name
anc=${apath}/lithk_GIS_${lab}_${model}_${exp}.nc
ncks -3 -O -v lithk ${anc} model_pre.nc
anc=${apath}/topg_GIS_${lab}_${model}_${exp}.nc
ncks -3 -A -v topg ${anc} model_pre.nc

anc=${apath}/sftflf_GIS_${lab}_${model}_${exp}.nc
ncks -3 -A -v sftflf ${anc} model_pre.nc
anc=${apath}/sftgif_GIS_${lab}_${model}_${exp}.nc
ncks -3 -A -v sftgif ${anc} model_pre.nc
anc=${apath}/sftgrf_GIS_${lab}_${model}_${exp}.nc
ncks -3 -A -v sftgrf ${anc} model_pre.nc
# acabf
anc=${apath}/acabf_GIS_${lab}_${model}_${exp}.nc
ncks -3 -A -v acabf ${anc} model_pre.nc

# set missing to zero like during interpolation 
cdo -setmisstoc,0.0  model_pre.nc model.nc 

# Add model params
ncks -3 -A ${outp}/${lab}/${model}/params.nc model.nc

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
destpath=${outpsc}/${prefix}/${lab}/${model}/${exp_res}
mkdir -p ${destpath}
### move output ./scalars_??_05.nc to Archive
[ -f ./scalars_mm_05.nc ] && /bin/mv ./scalars_mm_05.nc ${destpath}/scalars_mm_GIS_${lab}_${model}_${exp}.nc
[ -f ./scalars_rm_05.nc ] && /bin/mv ./scalars_rm_05.nc ${destpath}/scalars_rm_GIS_${lab}_${model}_${exp}.nc
[ -f ./scalars_zm_05.nc ] && /bin/mv ./scalars_zm_05.nc ${destpath}/scalars_zm_GIS_${lab}_${model}_${exp}.nc

# clean up
#cd ../
#/bin/rm -rf ${proc}
