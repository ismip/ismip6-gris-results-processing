#!/bin/bash
## set default ensemble
#declare -a labs=(AWI AWI AWI BGC GSFC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE MUN MUN NCAR UAF UAF UCIJPL UCIJPL VUB VUW)
#declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES ISSM SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI2 GSM2601 GSM2611 CISM PISM1 PISM2 ISSM1 ISSM2 GISMSIAv3 PISM)

## v1 submission
#declare -a labs=(AWI AWI AWI BGC GSFC ILTS_PIK ILTS_PIK IMAU IMAU JPL LSCE NCAR UCIJPL)
#declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES ISSM SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM GRISLI1 CISM ISSM1)


#declare -a labs=(MUN MUN)
#declare -a models=(GSM2601 GSM2611)

#declare -a labs=(MUN MUN VUB)
#declare -a models=(GSM2601 GSM2611 GISMSIAv3)

#declare -a labs=(VUB)
#declare -a models=(GISMSIAv3)

#declare -a labs=(VUW)
#declare -a models=(PISM)

#declare -a labs=(JPL)
#declare -a models=(ISSMPALEO)

#declare -a labs=(BGC)
#declare -a models=(BISICLES)

#declare -a labs=(UCIJPL UCIJPL)
#declare -a models=(ISSM1 ISSM2)

declare -a labs=(UAF)
declare -a models=(PISM1)

#declare -a labs=(GSFC UAF)
#declare -a models=(ISSM PISM1)

# open 
#declare -a labs=(UAF UCIJPL VUW)
#declare -a models=(PISM1 ISSM2 PISM)

# NOISM
#declare -a labs=(ISMIP6 ISMIP6 ISMIP6 ISMIP6)
#declare -a models=(NOISM_adog NOISM_adg NOISM_ag NOISM_og)

##################################

#exps_res="historical_05 ctrl_proj_05"

# core scalars
exps_res="historical_05 ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"

# open core scalars
#exps_res="historical_05 ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05"


# NOISM run scalars
#exps_res="historical_05 ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05 expa01_05 expa02_05 expa03_05"

# core meta_scalar_proj_diffcr_05.sh
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"

# core meta_scalar_proj_diffcr_05.sh PISM
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05
