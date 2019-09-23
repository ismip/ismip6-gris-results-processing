## ISMIP6 output processing in Archive_05

## A3tools

### Regrid from Archive to 5 km diagnostic grid
./meta_regrid.sh <br>
	regrid_func.sh

### submissions on 05 km can be copied. and then renamed and compressed e.g.
mkdir -p ../ILTS_PIK/SICOPOLIS2/ <br>
cp -r ../../Archive/ILTS_PIK/SICOPOLIS2/exp12_05/ ../ILTS_PIK/SICOPOLIS2/

mkdir -p  ../VUB/GISMSIAv1/ <br>
cp -r ../../Archive/VUB/GISMSIAv1/* ../VUB/GISMSIAv1/


### Pre-processing
meta_compress.sh

### Sanity check of submissions and updates
./consolidate.sh <br>


### Preliminary scalar calculations on 5 km

meta_scalar.sh <br>
scalars_opt.sh <br>

scalars_basin.sh <br>
check_basin_integrals.sh <br>

