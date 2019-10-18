#!/bin/bash
# Calculate scalar variables from 3D model output
# Heiko Goelzer 2019 (h.goelzer@uu.nl)

# Scalars
# multiply with masks, multiply with area factors integrate spatially

if [[ $# -ne 3 ]]; then
    echo "Illegal number of parameters. Need 3 to specify masking for GIC and OBS and resolution"
    exit 3
fi

set -x
set -e

# Path to mask data
#datapath=/Volumes/ISMIP6/ISMIP6-Greenland/Data
datapath=/home/hgoelzer/Projects/ISMIP6/Data

## What output to process
#flg_mm=true  # Integrals on model mask
#flg_rm=false  # IMBIE2-Rignot basins
#flg_zm=false  # IMBIE2-Zwally basins

flg_mm=true  # Integrals on model mask
flg_rm=true  # IMBIE2-Rignot basins
flg_zm=true  # IMBIE2-Zwally basins


## What masking to apply If true, applied to all output
# Remove GIC contribution? 
#flg_GICmask=true # [Default true!]
flg_GICmask=${1} # [Default true!]
# Remove ice outside observed ice mask (can be combined with GIC masking) 
#flg_OBSmask=true # [Default false!]
flg_OBSmask=${2} # [Default false!]

# Resolution
ares=${3}

# area factors
af2input=$datapath/af2_ISMIP6_GrIS_${ares}000m.nc
af2file=af2.nc
# af2

# Ellesmere mask
emfile=$datapath/maxmask1_${ares}000m.nc
# maxmask1

# BM3 for observed masks
obsinput=$datapath/BM3_GrIS_nn_e${ares}000m.nc
obsfile=masksOBS.nc

# IMBIE2 Rignot extended masks
riginput=$datapath/GrIS_Basins_Rignot_extended_e${ares}000m_v1.nc
rigfile=masksRIG.nc

# IMBIE2 Zwally extended masks
zwainput=$datapath/GrIS_Basins_Zwally_extended_e${ares}000m_v1.nc
zwafile=masksZWA.nc

# GIC area factors
gicinput=$datapath/rgi60_connect01_iaf2_${ares}000m_v1.nc
gicfile=masksGIC.nc
# iaf2

# Model data
infile=./model.nc
maskfile=icemasks.nc
# shelf sftflf
# grounded ice sftgrf
# ice sftgif
# thi lithk

# sanity check model file
# replace NaN in AWI files
#ncatted -a _FillValue,lithk,o,f,NaN model.nc

# Possible output files
scfile_mm=scalars_mm_${ares}.nc
scfile_rm=scalars_rm_${ares}.nc
scfile_zm=scalars_zm_${ares}.nc

# Make a netcdf file with parameters
ncks -3 -O -v x,y ${af2input} tmp.nc
# BM3 numbers for density, use Cogley (2012) for ocean area
#ncap2 -A -s 'rhoi=916.7; rhow=1027.0; rhof=1000.0; oarea=3.618e14' -v tmp.nc params.nc
#ncap2 -3 -A -s 'rhoi=916.7; rhow=1027.0; rhof=1000.0; oarea=3.625e14' -v tmp.nc params.nc
# Model specific densities 
ncks -3 -A -v rhoi,rhow,rhof,oarea ${infile} params.nc

# Resolution
ncap2 -3 -A -s 'dx=x(2)-x(1); dy=y(2)-y(1)' -v tmp.nc params.nc
ncks -3 -C -O -x -v x,y params.nc params.nc
# clean up
ncatted -h -a history,global,d,, params.nc
ncatted -h -a history_of_appended_files,global,d,, params.nc
ncatted -h -a NCO,global,d,, params.nc
ncatted -h -a CDO,global,d,, params.nc
ncatted -h -a CDI,global,d,, params.nc

/bin/rm tmp.nc

# prepare BM masks
ncks -3 -O -v sftgif ${obsinput} ${obsfile} 
ncks -3 -A -v sftgrf ${obsinput} ${obsfile}
ncks -3 -A -v sftflf ${obsinput} ${obsfile}
ncrename -v sftgif,sftgif_BM ${obsfile}
ncrename -v sftgrf,sftgrf_BM ${obsfile}
ncrename -v sftflf,sftflf_BM ${obsfile}

# Prepare IMBIE2 Rignot masks, ID: From NO clockwise
if $flg_rm; then
    ncap2 -3 -O -s 'no=ID==1' -v ${riginput} ${rigfile} 
    ncap2 -3 -A -s 'ne=ID==2' -v ${riginput} ${rigfile} 
    ncap2 -3 -A -s 'se=ID==3' -v ${riginput} ${rigfile} 
    ncap2 -3 -A -s 'sw=ID==4' -v ${riginput} ${rigfile} 
    ncap2 -3 -A -s 'cw=ID==5' -v ${riginput} ${rigfile} 
    ncap2 -3 -A -s 'nw=ID==6' -v ${riginput} ${rigfile} 
fi

# Prepare IMBIE2 Zwally masks, IDs: From NO clockwise
if $flg_zm; then
    ncap2 -3 -O -s 'z11=ID==1'  -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z12=ID==2'  -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z13=ID==3'  -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z14=ID==4'  -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z21=ID==5'  -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z22=ID==6'  -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z31=ID==7'  -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z32=ID==8'  -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z33=ID==9'  -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z41=ID==10' -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z42=ID==11' -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z43=ID==12' -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z50=ID==13' -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z61=ID==14' -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z62=ID==15' -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z71=ID==16' -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z72=ID==17' -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z81=ID==18' -v ${zwainput} ${zwafile} 
    ncap2 -3 -A -s 'z82=ID==19' -v ${zwainput} ${zwafile} 
fi

# Prepare area factors
ncks -3 -O -v af2 ${af2input} ${af2file}
# inlcude GIC masking if requested
if $flg_GICmask; then
# Prepare GIC masking file
    ncks -3 -O -v iaf2 ${gicinput} ${gicfile}
    # Combine with area factors
    ncks -A -v iaf2 ${gicfile} ${af2file}
    ncap2 -O -s "af2 = af2*iaf2" ${af2file} ${af2file}
fi

# Prepare ice masks
ncks -3 -O -v sftgif ${infile} ${maskfile}
ncks -3 -A -v sftgrf ${infile} ${maskfile}
ncks -3 -A -v sftflf ${infile} ${maskfile}
# inlcude OBS masking if requested
if $flg_OBSmask; then
    ncks -3 -A -v sftgif_BM ${obsfile} ${maskfile}
    ncks -3 -A -v sftgrf_BM ${obsfile} ${maskfile}
    ncks -3 -A -v sftflf_BM ${obsfile} ${maskfile}
    ncap2 -3 -A -s "sftgif = sftgif*sftgif_BM" ${maskfile} ${maskfile}
    ncap2 -3 -A -s "sftgrf = sftgrf*sftgrf_BM" ${maskfile} ${maskfile}
    ncap2 -3 -A -s "sftflf = sftflf*sftflf_BM" ${maskfile} ${maskfile}
fi

# Make master netcdf file 
ncks -3 -O -v sftgif ${maskfile} tmp_mod.nc
ncks -3 -A -v sftgrf ${maskfile} tmp_mod.nc
ncks -3 -A -v sftflf ${maskfile} tmp_mod.nc
ncks -3 -A -v maxmask1 ${emfile} tmp_mod.nc
ncks -3 -A -v af2 ${af2file} tmp_mod.nc
ncks -3 -A -v lithk ${infile} tmp_mod.nc
ncks -3 -A -v topg ${infile} tmp_mod.nc
if $flg_rm; then
    ncks -3 -A  ${rigfile} tmp_mod.nc
fi
if $flg_zm; then
    ncks -3 -A  ${zwafile} tmp_mod.nc
fi
# Add porameters
ncks -3 -A params.nc tmp_mod.nc

##################################################################################
# Greenland wide integrals
##################################################################################

if $flg_mm; then

# Make dummy containers for scalar output
ncks -3 -O params.nc ${scfile_mm}

# Ice area Model
# sftgif
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=sftgif*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'iarea=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v iarea tmpsc.nc ${scfile_mm} 
/bin/rm tmpaf.nc tmpsc.nc 

# Grounded ice area Model
# sftgrf
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=sftgrf*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'iareagr=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v iareagr tmpsc.nc ${scfile_mm}
/bin/rm tmpaf.nc tmpsc.nc 

# Floating ice area Model
# sftflf
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=sftflf*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'iareafl=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v iareafl tmpsc.nc ${scfile_mm}
/bin/rm tmpaf.nc tmpsc.nc 

# Ice volume model
# sftgif
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=lithk*sftgif*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'ivol=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v ivol tmpsc.nc ${scfile_mm}
/bin/rm tmpaf.nc tmpsc.nc 

# Grounded ice volume model
# sftgrf
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=lithk*sftgrf*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'ivolgr=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v ivolgr tmpsc.nc ${scfile_mm}
/bin/rm tmpaf.nc tmpsc.nc 

# Floating ice vol model
# sftflf
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=lithk*sftflf*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'ivolfl=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v ivolfl tmpsc.nc ${scfile_mm}
/bin/rm tmpaf.nc tmpsc.nc 

# Volume above flotation model
# sftgif
ncks -A params.nc tmp.nc
# thickness at flotation
ncap2 -A -s 'thif=-(rhow/rhoi)*topg; thif=thif>>0' tmp_mod.nc tmp.nc
# thickness above flotation
ncap2 -O -s 'af=(lithk-thif)*sftgif*maxmask1*af2; af=af>>0' tmp.nc tmpaf.nc
ncap2 -O -s 'ivaf=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v ivaf tmpsc.nc ${scfile_mm}
/bin/rm tmp.nc tmpaf.nc tmpsc.nc 

# Ice mass lim
ncap2 -A -s "lim=ivol*rhoi" ${scfile_mm} ${scfile_mm} 
ncap2 -A -s "limgr=ivolgr*rhoi" ${scfile_mm} ${scfile_mm} 
ncap2 -A -s "limfl=ivolfl*rhoi" ${scfile_mm} ${scfile_mm} 
# Ice mass above flotation
ncap2 -A -s "limaf=ivaf*rhoi" ${scfile_mm} ${scfile_mm} 
# SLE
ncap2 -A -s "sle=ivaf*rhoi/oarea/rhof" ${scfile_mm} ${scfile_mm} 

# clean up
ncatted -h -a history,global,d,, ${scfile_mm}
ncatted -h -a history_of_appended_files,global,d,, ${scfile_mm}
ncatted -h -a NCO,global,d,, ${scfile_mm}
ncatted -h -a CDO,global,d,, ${scfile_mm}
ncatted -h -a CDI,global,d,, ${scfile_mm}

fi

##################################################################################
# IMBIE2 Rignot basins 
##################################################################################
if $flg_rm; then

# Make dummy containers for scalar output
ncks -O params.nc ${scfile_rm}

# Volume above flotation
# sftgif
ncks -A params.nc tmp.nc
# thickness at flotation
ncap2 -A -s "thif=-(rhow/rhoi)*topg; thif=thif>>0" tmp_mod.nc tmp.nc

for basin in no ne se sw cw nw; do
# thickness above flotation 
ncap2 -O -s "af=(lithk-thif)*sftgif*${basin}*maxmask1*af2; af=af>>0" tmp.nc tmpaf.nc
ncap2 -O -s "ivaf_${basin}=af.total(\$x,\$y)*dx^2" -v tmpaf.nc tmpsc.nc
ncks -A -v ivaf_${basin} tmpsc.nc ${scfile_rm}
/bin/rm tmpaf.nc tmpsc.nc 

# Ice mass above flotation
ncap2 -A -s "limaf_${basin}=ivaf_${basin}*rhoi" ${scfile_rm} ${scfile_rm} 
# SLE
ncap2 -A -s "sle_${basin}=ivaf_${basin}*rhoi/oarea/rhof" ${scfile_rm} ${scfile_rm} 

done
/bin/rm tmp.nc 

# clean up
ncatted -h -a history,global,d,, ${scfile_rm}
ncatted -h -a history_of_appended_files,global,d,, ${scfile_rm}
ncatted -h -a NCO,global,d,, ${scfile_rm}
ncatted -h -a CDO,global,d,, ${scfile_rm}
ncatted -h -a CDI,global,d,, ${scfile_rm}

fi

##################################################################################
# IMBIE2 Zwally basins 
##################################################################################
if $flg_zm; then

# Make dummy containers for scalar output
ncks -O params.nc ${scfile_zm}

# Volume above flotation 
# sftgif
ncks -A params.nc tmp.nc
# thickness at flotation
ncap2 -A -s "thif=-(rhow/rhoi)*topg; thif=thif>>0" tmp_mod.nc tmp.nc

for basin in z11 z12 z13 z14 z21 z22 z31 z32 z33 z41 z42 z43 z50 z61 z62 z71 z72 z81 z82 ; do
# thickness above flotation 
ncap2 -O -s "af=(lithk-thif)*sftgif*${basin}*maxmask1*af2; af=af>>0" tmp.nc tmpaf.nc
ncap2 -O -s "ivaf_${basin}=af.total(\$x,\$y)*dx^2" -v tmpaf.nc tmpsc.nc
ncks -A -v ivaf_${basin} tmpsc.nc ${scfile_zm}
/bin/rm tmpaf.nc tmpsc.nc 

# Ice mass above flotation
ncap2 -A -s "limaf_${basin}=ivaf_${basin}*rhoi" ${scfile_zm} ${scfile_zm} 
# SLE
ncap2 -A -s "sle_${basin}=ivaf_${basin}*rhoi/oarea/rhof" ${scfile_zm} ${scfile_zm} 

done
/bin/rm tmp.nc 

# clean up
ncatted -h -a history,global,d,, ${scfile_zm}
ncatted -h -a history_of_appended_files,global,d,, ${scfile_zm}
ncatted -h -a NCO,global,d,, ${scfile_zm}
ncatted -h -a CDO,global,d,, ${scfile_zm}
ncatted -h -a CDI,global,d,, ${scfile_zm}


fi

##################################################################################


# Clean up
/bin/rm tmp_mod.nc 

