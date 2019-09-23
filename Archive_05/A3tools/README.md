## ISMIP6 output processing in Archive_05

## A3tools

### Regrid from Archive to 5 km diagnostic grid
./meta_regrid.sh <br>
	regrid_func.sh

### Submissions on 05 km are copied and compressed
./meta_copy.sh

### Pre-processing
meta_compress.sh

### Sanity check of submissions and updates
./consolidate.sh <br>


### Preliminary scalar calculations on 5 km

./meta_scalar.sh <br>
scalars_opt.sh <br>
scalars_basin.sh <br>

### Integrated basins to compare to total scalars 
check_basin_integrals.sh <br>

