#!/bin/bash
# Calculate scalar variables from 3D model output
# Heiko Goelzer 2019 (h.goelzer@uu.nl)

# Scalars
# multiply with masks, multiply with area factors integrate spatially


set -x
#set -e

# Resolution
ares=05
#ares=01

# area factors
af2file=/Volumes/ISMIP6/Grids/GrIS/SFs/af2_ISMIP6_GrIS_${ares}000m.nc
# af2
# Ellesmere mask
emfile=/Volumes/ISMIP6/ISMIP6-Greenland/Data/maxmask1_05000m.nc
# maxmask1
# PROMICE Mask
piinput=/Volumes/ISMIP6/Data/GrIS/PROMICE/Ready/CitteroMask_e${ares}000m.nc
pifile=maskPI.nc
# GIC
# BM3 for masks
bminput=/Volumes/ISMIP6/Data/GrIS/MorlighemBedmachine/BedMachinev3.10/Ready/BM3_GrIS_nn_e${ares}000m.nc
bmfile=masksBM.nc

# Model data
infile=./model.nc
# shelf sftflf
# grounded ice sftgrf
# ice sftgif
# thi lithk

# sanity check model file
# replace NaN in AWI files
#ncatted -a _FillValue,lithk,o,f,NaN model.nc

# output files
scfile=scalars_model_${ares}.nc

# Make a netcdf file with parameters
ncks -O -v x,y ${af2file} tmp.nc
# BM3 numbers for density, use Cogley (2012) for ocean area
#ncap2 -A -s 'rhoi=916.7; rhow=1027.0; rhof=1000.0; oarea=3.618e14' -v tmp.nc params.nc
ncap2 -A -s 'rhoi=916.7; rhow=1027.0; rhof=1000.0; oarea=3.625e14' -v tmp.nc params.nc
# Resolution
ncap2 -A -s 'dx=x(2)-x(1); dy=y(2)-y(1)' -v tmp.nc params.nc
ncks -C -O -x -v x,y params.nc params.nc
nc_clean.sh params.nc
/bin/rm tmp.nc
# Make a dummy container for scalar output
ncks -O params.nc ${scfile}

# prepare BM masks
ncks -O -v sftgif ${bminput} ${bmfile} 
ncks -A -v sftgrf ${bminput} ${bmfile}
ncks -A -v sftflf ${bminput} ${bmfile}
ncrename -v sftgif,sftgif_BM ${bmfile}
ncrename -v sftgrf,sftgrf_BM ${bmfile}
ncrename -v sftflf,sftflf_BM ${bmfile}

# Prepare GIC masks; deselect level 0 and 1 glaciers
ncap2 -O -s 'gicm=GIC==0' -v ${piinput} ${pifile} 


# Make master netcdf file 
ncks -O -v sftgif ${infile} tmp_mod.nc
ncks -A -v sftgrf ${infile} tmp_mod.nc
ncks -A -v sftflf ${infile} tmp_mod.nc
ncks -A -v maxmask1 ${emfile} tmp_mod.nc
ncks -A -v gicm ${pifile} tmp_mod.nc
ncks -A -v sftgif_BM ${bmfile} tmp_mod.nc
ncks -A -v sftgrf_BM ${bmfile} tmp_mod.nc
ncks -A -v sftflf_BM ${bmfile} tmp_mod.nc
ncks -A -v af2 ${af2file} tmp_mod.nc
ncks -A -v lithk ${infile} tmp_mod.nc
ncks -A -v topg ${infile} tmp_mod.nc
# Add porameters
ncks -A params.nc tmp_mod.nc

# Ice area Model
# sftgif
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=sftgif*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'iarea=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v iarea tmpsc.nc ${scfile} 
/bin/rm tmpaf.nc tmpsc.nc 

# Grounded ice area Model
# sftgrf
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=sftgrf*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'iareagr=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v iareagr tmpsc.nc ${scfile}
/bin/rm tmpaf.nc tmpsc.nc 

# Floating ice area Model
# sftflf
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=sftflf*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'iareafl=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v iareafl tmpsc.nc ${scfile}
/bin/rm tmpaf.nc tmpsc.nc 


# Ice area on BM mask
# sftgif
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=sftgif*sftgif_BM*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'iarea_BM=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v iarea_BM tmpsc.nc ${scfile}
/bin/rm tmpaf.nc tmpsc.nc

# Grounded ice area BM masked
# sftgrf
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=sftgrf*sftgrf_BM*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'iareagr_BM=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v iareagr_BM tmpsc.nc ${scfile}
/bin/rm tmpaf.nc tmpsc.nc 

# Floating ice area BM masked
# sftflf
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=sftflf*sftflf_BM*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'iareafl_BM=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v iareafl_BM tmpsc.nc ${scfile}
/bin/rm tmpaf.nc tmpsc.nc 


# Ice area without PROMICE GIC
# sftgif
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=sftgif*sftgif_BM*maxmask1*af2*gicm' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'iarea_noGIC=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v iarea_noGIC tmpsc.nc ${scfile}
/bin/rm tmpaf.nc tmpsc.nc

# Grounded ice area without PROMICE GIC
# sftgrf
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=sftgrf*sftgrf_BM*maxmask1*af2*gicm' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'iareagr_noGIC=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v iareagr_noGIC tmpsc.nc ${scfile}
/bin/rm tmpaf.nc tmpsc.nc 

# Floating ice area without PROMICE GIC
# sftflf
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=sftflf*sftflf_BM*maxmask1*af2*gicm' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'iareafl_noGIC=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v iareafl_noGIC tmpsc.nc ${scfile}
/bin/rm tmpaf.nc tmpsc.nc 


# Ice volume model
# sftgif
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=lithk*sftgif*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'ivol=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v ivol tmpsc.nc ${scfile}
/bin/rm tmpaf.nc tmpsc.nc 

# Grounded ice volume model
# sftgrf
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=lithk*sftgrf*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'ivolgr=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v ivolgr tmpsc.nc ${scfile}
/bin/rm tmpaf.nc tmpsc.nc 

# Floating ice vol model
# sftflf
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=lithk*sftflf*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'ivolfl=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v ivolfl tmpsc.nc ${scfile}
/bin/rm tmpaf.nc tmpsc.nc 


# Ice vol BM mask
# sftgif
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=lithk*sftgif*sftgif_BM*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'ivol_BM=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v ivol_BM tmpsc.nc ${scfile}
/bin/rm tmpaf.nc tmpsc.nc

# Grounded ice vol BM mask
# sftgrf
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=lithk*sftgrf*sftgrf_BM*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'ivolgr_BM=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v ivolgr_BM tmpsc.nc ${scfile}
/bin/rm tmpaf.nc tmpsc.nc 

# Floating ice vol BM mask
# sftflf
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=lithk*sftflf*sftflf_BM*maxmask1*af2' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'ivolfl_BM=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v ivolfl_BM tmpsc.nc ${scfile}
/bin/rm tmpaf.nc tmpsc.nc 


# Ice vol without PROMICE GIC
# sftgif
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=lithk*sftgif*sftgif_BM*maxmask1*af2*gicm' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'ivol_noGIC=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v ivol_noGIC tmpsc.nc ${scfile}
/bin/rm tmpaf.nc tmpsc.nc

# Grounded ice vol without PROMICE GIC
# sftgrf
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=lithk*sftgrf*sftgrf_BM*maxmask1*af2*gicm' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'ivolgr_noGIC=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v ivolgr_noGIC tmpsc.nc ${scfile}
/bin/rm tmpaf.nc tmpsc.nc 

# Floating ice vol without PROMICE GIC
# sftflf
/bin/cp params.nc tmpaf.nc
ncap2 -A -s 'af=lithk*sftflf*sftflf_BM*maxmask1*af2*gicm' -v tmp_mod.nc tmpaf.nc
ncap2 -O -s 'ivolfl_noGIC=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v ivolfl_noGIC tmpsc.nc ${scfile}
/bin/rm tmpaf.nc tmpsc.nc 


# Volume above flotation model
# sftgif
ncks -A params.nc tmp.nc
# thickness at flotation
ncap2 -A -s 'thif=-(rhow/rhoi)*topg; thif=thif>>0' tmp_mod.nc tmp.nc
# thickness above flotation
ncap2 -O -s 'af=(lithk-thif)*sftgif*maxmask1*af2; af=af>>0' tmp.nc tmpaf.nc
ncap2 -O -s 'ivaf=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v ivaf tmpsc.nc ${scfile}
/bin/rm tmp.nc tmpaf.nc tmpsc.nc 


# Volume above flotation BM mask
# sftgif
ncks -A params.nc tmp.nc
# thickness at flotation
ncap2 -A -s 'thif=-(rhow/rhoi)*topg; thif=thif>>0' tmp_mod.nc tmp.nc
# thickness above flotation
ncap2 -O -s 'af=(lithk-thif)*sftgif*sftgif_BM*maxmask1*af2; af=af>>0' tmp.nc tmpaf.nc
ncap2 -O -s 'ivaf_BM=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v ivaf_BM tmpsc.nc ${scfile}
/bin/rm tmp.nc tmpaf.nc tmpsc.nc 


# Volume above flotation without PROMICE GIC
# sftgif
ncks -A params.nc tmp.nc
# thickness at flotation
ncap2 -A -s 'thif=-(rhow/rhoi)*topg; thif=thif>>0' tmp_mod.nc tmp.nc
# thickness above flotation
ncap2 -O -s 'af=(lithk-thif)*sftgif*sftgif_BM*gicm*maxmask1*af2; af=af>>0' tmp.nc tmpaf.nc
ncap2 -O -s 'ivaf_noGIC=af.total($x,$y)*dx^2' -v tmpaf.nc tmpsc.nc
ncks -A -v ivaf_noGIC tmpsc.nc ${scfile}
/bin/rm tmp.nc tmpaf.nc tmpsc.nc 


# Ice mass lim
ncap2 -A -s "lim=ivol*rhoi" ${scfile} ${scfile} 
ncap2 -A -s "limgr=ivolgr*rhoi" ${scfile} ${scfile} 
ncap2 -A -s "limfl=ivolfl*rhoi" ${scfile} ${scfile} 

ncap2 -A -s "lim_BM=ivol_BM*rhoi" ${scfile} ${scfile} 
ncap2 -A -s "limgr_BM=ivolgr_BM*rhoi" ${scfile} ${scfile} 
ncap2 -A -s "limfl_BM=ivolfl_BM*rhoi" ${scfile} ${scfile} 

ncap2 -A -s "lim_noGIC=ivol_noGIC*rhoi" ${scfile} ${scfile} 
ncap2 -A -s "limgr_noGIC=ivolgr_noGIC*rhoi" ${scfile} ${scfile} 
ncap2 -A -s "limfl_noGIC=ivolfl_noGIC*rhoi" ${scfile} ${scfile} 

# Ice mass above flotation
ncap2 -A -s "limaf=ivaf*rhoi" ${scfile} ${scfile} 
ncap2 -A -s "limaf_BM=ivaf_BM*rhoi" ${scfile} ${scfile} 
ncap2 -A -s "limaf_noGIC=ivaf_noGIC*rhoi" ${scfile} ${scfile} 

# Ice mass above flotation
ncap2 -A -s "sle=ivaf*rhoi/oarea/rhof" ${scfile} ${scfile} 
ncap2 -A -s "sle_BM=ivaf_BM*rhoi/oarea/rhof" ${scfile} ${scfile} 
ncap2 -A -s "sle_noGIC=ivaf_noGIC*rhoi/oarea/rhof" ${scfile} ${scfile} 

# Clean up
/bin/rm tmp_mod.nc 
nc_clean.sh ${scfile}

