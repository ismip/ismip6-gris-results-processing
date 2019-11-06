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


## Useful commands

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
