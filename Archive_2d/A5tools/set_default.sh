#!/bin/bash
## set default ensemble

## 2019 12 21
#declare -a labs=(AWI AWI AWI BGC GSFC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE MUN MUN NCAR UAF UAF UCIJPL UCIJPL VUB VUW ISMIP6 ISMIP6 ISMIP6 ISMIP6)
#declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES ISSM SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI2 GSM2601 GSM2611 CISM PISM1 PISM2 ISSM1 ISSM2 GISMSIAv3 PISM NOISM_adog NOISM_adg NOISM_ag NOISM_og)


#declare -a labs=(AWI AWI AWI BGC GSFC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE MUN MUN NCAR)
#declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES ISSM SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI GSM2601 GSM2611 CISM)

#declare -a labs=(UAF)
#declare -a models=(PISM2)

#declare -a labs=(UCIJPL UCIJPL)
#declare -a models=(ISSM1 ISSM2)

#declare -a labs=(UCIJPL)
#declare -a models=(ISSM1)

#declare -a labs=(JPL)
#declare -a models=(ISSMPALEO)

#declare -a labs=(GSFC)
#declare -a models=(ISSM)

#declare -a labs=(MUN MUN)
#declare -a models=(GSM2601 GSM2611)


#declare -a labs=(JPL LSCE)
#declare -a models=(ISSMPALEO GRISLI2)

#declare -a labs=(ISMIP6)
#declare -a models=(NOISM_adog)

#declare -a labs=(ISMIP6)
#declare -a models=(NOISM_ag)


#declare -a labs=(ISMIP6 ISMIP6 ISMIP6 ISMIP6) 
#declare -a models=(NOISM_adog NOISM_adg NOISM_og NOISM_ag)

#declare -a labs=(ISMIP6 ISMIP6) 
#declare -a models=(NOISM_adog NOISM_adg)



## Individual submissions woth exps specified; comment in set_exps.sh!
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

#declare -a labs=(VUB)
#declare -a models=(GISMHOMv1)
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05   expa01_05 expa02_05 expa03_05   expb01_05 expb02_05 expb03_05 expb04_05 expb05_05"

#declare -a labs=(VUW)
#declare -a models=(PISM)
#exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05"


# Use like this in script
# source ./set_default.sh

#### Final archive v7
## All in
declare -a labs=(AWI AWI AWI BGC GSFC ILTS_PIK ILTS_PIK IMAU IMAU JPL JPL LSCE MUN MUN NCAR UAF UAF UCIJPL UCIJPL VUB VUW)
declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES ISSM SICOPOLIS2 SICOPOLIS3 IMAUICE1 IMAUICE2 ISSM ISSMPALEO GRISLI2 GSM2601 GSM2611 CISM PISM1 PISM2 ISSM1 ISSM2 GISMHOMv1 PISM)
exps_res="ctrl_proj_05 exp05_05 exp06_05 exp07_05 exp08_05 exp09_05 exp10_05    expa01_05 expa02_05 expa03_05    expb01_05 expb02_05 expb03_05 expb04_05 expb05_05"
