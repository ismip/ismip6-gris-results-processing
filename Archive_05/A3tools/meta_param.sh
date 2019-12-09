#!/bin/bash
# Create model specific parameter file

set -x 
set -e

# location of input Archive
outp=/home/hgoelzer/Projects/ISMIP6/Archive/Data

# location of output Archive
outp05=/home/hgoelzer/Projects/ISMIP6/Archive_05/Data


alab=AWI
amodel=ISSM1
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=910.; rhow=1000.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 
amodel=ISSM2
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=910.; rhow=1000.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 
amodel=ISSM3
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=910.; rhow=1000.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 

alab=BGC
amodel=BISICLES
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=917.; rhow=1023.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 

alab=GSFC
amodel=ISSM
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=917.; rhow=1023.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 

alab=ILTS_PIK
amodel=SICOPOLIS2
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=910.; rhow=1028.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 
amodel=SICOPOLIS3
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=910.; rhow=1028.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 

alab=IMAU
amodel=IMAUICE1
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=910.; rhow=1028.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 
alab=IMAU
amodel=IMAUICE2
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=910.; rhow=1028.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 
alab=IMAU
amodel=CISM1
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=910.; rhow=1028.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 

alab=JPL
amodel=ISSM
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=917.; rhow=1023.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 

alab=JPL
amodel=ISSMPALEO
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
ncap2 -3 -A -s 'rhoi=917.; rhow=1023.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 

alab=LSCE
amodel=GRISLI
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=918; rhow=1028; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 
alab=LSCE
amodel=GRISLI2
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=918; rhow=1028; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 

alab=MUN
amodel=GSM2601
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=900; rhow=1028; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 
alab=MUN
amodel=GSM2611
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=900; rhow=1028; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 

alab=NCAR
amodel=CISM
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=917; rhow=1026; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 

alab=UAF
amodel=PISM1
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=910.; rhow=1028.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 
amodel=PISM2
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=910.; rhow=1028.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 

alab=UCIJPL
amodel=ISSM1
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=917.; rhow=1023.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 
alab=UCIJPL
amodel=ISSM2
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=917.; rhow=1023.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 

alab=VUB
amodel=GISMSIAv3
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=910; rhow=1028; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 

## review
alab=VUW
amodel=PISM
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=910; rhow=1028; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 

alab=ISMIP6
amodel=NOISM_adg
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=916.7; rhow=1027.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 
amodel=NOISM_adog
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=916.7; rhow=1027.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 
amodel=NOISM_og
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=916.7; rhow=1027.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 
amodel=NOISM_ag
apar=${outp}/${alab}/${amodel}/params.nc
apar05=${outp05}/${alab}/${amodel}/params.nc
mkdir -p `dirname ${apar}` `dirname ${apar05}` 
ncap2 -3 -A -s 'rhoi=916.7; rhow=1027.; rhof=1000.' templates/param_template.nc ${apar} 
/bin/cp ${apar} ${apar05} 

