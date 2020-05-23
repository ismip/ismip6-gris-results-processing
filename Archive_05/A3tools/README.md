# ismip6-gris-results-processing
Collection of scripts to process ISMIP6 Greenland model projections

## ISMIP6 output processing in Archive_05

## A3tools

The scripts in this directory serve to produce a consistent archive at 5 km resolution. In the current processing approach, conservative interpolation to 5km is done elsewhere (UB server) and files are copied here. Some processing is then necessary to correct minor problems with the submissions and remove remaining inconsistencies. 

### Processing order
download_ghub_reproc.sh
download_ghub.sh
meta_param.sh
   consolidate*.sh (See below propagating bed has to come before stripping hist!)
strip_hist.sh
remove_coordinates.sh


# Consolidation
consolidate_AWI1.sh	# missing value flag 
consolidate_AWI2.sh	# propagate topg on time axis
#
consolidate_BGC1.sh	# variable name 
consolidate_BGC2.sh	# missing value flag
consolidate_BGC3.sh     # fix hist NaN in masks
#
consolidate_UAF.sh    # workaround, extrapolate last year
#
consolidate_UCIJPL.sh  # missing value flag
#
consolidate_VUB1.sh     # remove res suffix from file names
consolidate_VUB2.sh     # propogate bed


###############
Processing A - CMIP5 extensions

#declare -a labs=(ILTS_PIK ILTS_PIK LSCE VUB)
#declare -a models=(SICOPOLIS2 SICOPOLIS3 GRISLI2 GISMSIAv3)
##explist="expa01_05 expa02_05 expa03_05 "

#declare -a labs=(AWI AWI AWI BGC GSFC IMAU JPL NCAR UAF UAF UCIJPL)
#declare -a models=(ISSM1 ISSM2 ISSM3 BISICLES ISSM IMAUICE2 ISSM CISM PISM1 PISM2 ISSM1)
#explist="expa01_05 expa02_05 expa03_05 "

# a123
# AWI-ISSM1 
# AWI-ISSM2 
# AWI-ISSM3  
# BGC-BICICLES 
# GSFC-ISSM 
# ILTS_PIK-SICOPOLIS2 
# ILTS_PIK-SICOPOLIS3
# IMAU-IMAUICE2 
# JPL-ISSM 
# LSCE-GRISLI2
# NCAR-CISM 
# UAF-PISM1
# UAF-PISM2 
# UCIJPL-ISSM1 
# VUB-GISMSIAv3

# a12
# UAF-PISM1 


###############
Processing B - CMIP6 extensions

# b12345
# AWI-ISSM1 
# AWI-ISSM2 
# AWI-ISSM3  
# ILTS_PIK-SICOPOLIS2 
# ILTS_PIK-SICOPOLIS3
# LSCE-GRISLI2
# NCAR-CISM 
# VUB-GISMSIAv3

# b1235
# IMAU-IMAUICE2 
# UAF-PISM1 
# UAF-PISM2 
# JPL-ISSM 
# JPL-ISSMPALEO

# b123
# BGC-BICICLES 
# UCIJPL-ISSM1 

# b12
# GSFC-ISSM 

#declare -a labs=(LSCE)
#declare -a models=(GRISLI2)
#explist="expb01_05 expb02_05 expb03_05 expb05_05"



# Useful commands

### show a specific file in each model
ls -al  ../Data/*/*/exp05_05/lithk*.nc

### check something
./meta_check.sh > check_ll.txt

### list labs, models, exps
find ../Data/ -maxdepth 1 -mindepth 1 -type d
find ../Data/ -maxdepth 2 -mindepth 2 -type d
find ../Data/ -maxdepth 3 -mindepth 3 -type d

### clean up archive after processing
find ../Data/ -name *.tmp 
find ../Data/ -name *.tmp | xargs -I xxx /bin/rm xxx



# Unused

### Regrid from Archive to 5 km diagnostic grid
./meta_regrid.sh <br>
	regrid_func.sh

### Submissions on 05 km are copied and compressed
./meta_copy.sh

### Pre-processing
meta_compress.sh


