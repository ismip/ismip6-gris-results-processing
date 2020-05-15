#!/bin/bash
# Remap between different ISMIP6 GrIS grids

set -e

# Path to GDFs
gdfs=/home/hgoelzer/Projects/ISMIP6/Grids/GrIS/GDFs

# Path to SFs
sfs=/home/hgoelzer/Projects/ISMIP6/Grids/GrIS/SFs

# path to weights
pwgts=/home/hgoelzer/Projects/ISMIP6/Grids/GrIS/weights


# resolution
res=01
#res=16
resin=${res}000m
resout=05000m

# input/output files
infile=$1
outfile=$2

# input/output grid description files
ingdf=grid_ISMIP6_GrIS_${resin}.nc
outgdf=grid_ISMIP6_GrIS_${resout}.nc


#### Overwrite x,y
ncks -C -O -x -v x,y ${infile} ${infile}
ncks -A -v x,y ${sfs}/af2_ISMIP6_GrIS_${res}000m.nc ${infile}


#####################################################################################
# Conservative
#####################################################################################

#### All in one 
cdo remapycon,${gdfs}/${outgdf} -setmisstoc,0 -setgrid,${gdfs}/${ingdf} ${infile} ${outfile}

### With weights file
#wgts=weights_ycon_e${resin}_e${resout}.nc
## produce remap weights file
#cdo genycon,${gdfs}/${outgdf} -setmisstoc,0 -setgrid,${gdfs}/${ingdf} ${infile} ${pwgts}/${wgts}
## remap with predefined weights
#cdo remap,${gdfs}/${outgdf},${pwgts}/${wgts} -setmisstoc,0 -setgrid,${gdfs}/${ingdf} ${infile} ${outfile}

# clean up 
ncks -C -O -x -v lat,lon,lat_bnds,lon_bnds ${outfile} ${outfile}
