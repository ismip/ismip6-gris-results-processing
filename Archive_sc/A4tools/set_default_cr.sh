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

#declare -a labs=(VUW)
#declare -a models=(PISM)

#declare -a labs=(JPL)
#declare -a models=(ISSMPALEO)

#declare -a labs=(JPL JPL)
#declare -a models=(ISSM ISSMPALEO)

#declare -a labs=(BGC)
#declare -a models=(BISICLES)

#declare -a labs=(UCIJPL UCIJPL)
#declare -a models=(ISSM1 ISSM2)

#declare -a labs=(UCIJPL)
#declare -a models=(ISSM2)

#declare -a labs=(UAF)
#declare -a models=(PISM1)

#declare -a labs=(GSFC UAF)
#declare -a models=(ISSM PISM1)

#declare -a labs=(GSFC)
#declare -a models=(ISSM)

# open 
#declare -a labs=(UAF UCIJPL VUW)
#declare -a models=(PISM1 ISSM2 PISM)

#declare -a labs=(UCIJPL)
#declare -a models=(ISSM1)

#declare -a labs=(VUB)
#declare -a models=(GISMHOMv1)
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05   expa01_05 expa02_05 expa03_05   expb01_05 expb02_05 expb03_05 expb04_05 expb05_05"

#declare -a labs=(VUW)
#declare -a models=(PISM)
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05"

# NOISM
#declare -a labs=(ISMIP6 ISMIP6 ISMIP6 ISMIP6)
#declare -a models=(NOISM_adog NOISM_adg NOISM_ag NOISM_og)

##################################

#exps_res="historical_05"

# core scalars
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"

# open core scalars
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05"


# NOISM run scalars
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05 expa01_05 expa02_05 expa03_05"

# core meta_scalar_proj_diffcr_05.sh
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05"

# core meta_scalar_proj_diffcr_05.sh PISM
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05


##################################
## Processing A - CMIP5
#declare -a labs=(AWI AWI AWI BGC GSFC ILTS_PIK ILTS_PIK IMAU JPL LSCE NCAR UAF UAF UCIJPL VUB)
#declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES ISSM SICOPOLIS2 SICOPOLIS3 IMAUICE2 ISSM GRISLI2 CISM PISM1 PISM2 ISSM1 GISMSIAv3)

#declare -a labs=(JPL JPL)
#declare -a models=(ISSM ISSMPALEO)

#declare -a labs=(UAF AWI)
#declare -a models=(PISM1 ISSM1)

#
## A extension scalars
#exps_res="expa01_05 expa02_05 expa03_05"
#
## B extension scalars
#exps_res="expb01_05 expb02_05 expb03_05 expb04_05 expb05_05"
#exps_res="expb01_05 expb02_05 expb03_05 expb05_05"


##############################
## All in
#declare -a labs=(AWI AWI AWI BGC GSFC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE MUN MUN NCAR UAF UAF UCIJPL UCIJPL VUB VUW)
#declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES ISSM SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI2 GSM2601 GSM2611 CISM PISM1 PISM2 ISSM1 ISSM2 GISMSIAv3 PISM)
#exps_res="historical_05"
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05    expa01_05 expa02_05 expa03_05    expb01_05 expb02_05 expb03_05 expb04_05 expb05_05"

### Individual submissions
#declare -a labs=(GSFC)
#declare -a models=(ISSM)
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05   expa01_05 expa02_05 expa03_05   expb01_05 expb02_05"

#declare -a labs=(UCIJPL)
#declare -a models=(ISSM1)
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05 expa01_05 expa02_05 expa03_05 expb01_05 expb02_05 expb03_05"

#declare -a labs=(UCIJPL)
#declare -a models=(ISSM2)
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05"

#declare -a labs=(JPL)
#declare -a models=(ISSM)
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05   expa01_05 expa02_05 expa03_05   expb01_05 expb02_05 expb03_05 expb05_05"

#declare -a labs=(JPL)
#declare -a models=(ISSMPALEO)
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05   expb01_05 expb02_05 expb03_05 expb05_05"


#### New kappa
#declare -a labs=(IMAU)
#declare -a models=(IMAUICE1)
##exps_res="expe01_05 expe02_05 expe03_05 expe04_05 expe05_05 expe06_05 expe07_05 expe08_05 expe09_05 expe10_05 expe11_05 expe12_05 expe13_05 expe15_05 expe16_05 expe17_05 expe21_05 expe22_05 expe23_05"
#exps_res="expe14_05 expe18_05 expe22_05 expe24_05"


#### Final archive
## All in
declare -a labs=(AWI AWI AWI BGC GSFC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE MUN MUN NCAR UAF UAF UCIJPL UCIJPL VUB VUW)
declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES ISSM SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI2 GSM2601 GSM2611 CISM PISM1 PISM2 ISSM1 ISSM2 GISMHOMv1 PISM)
exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05    expa01_05 expa02_05 expa03_05    expb01_05 expb02_05 expb03_05 expb04_05 expb05_05"
