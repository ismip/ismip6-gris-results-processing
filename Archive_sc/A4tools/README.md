## ismip6-gris-results-processing

# A4tools

### Scalar calculations 

meta_scalar.sh <br>
meta_scalar_05.sh (same but specific for 5 km archive)<br>

calling <br>

scalars_basin.sh <br>

# Main options in meta_scalar:
# Mask out glaciers and ice caps (so far only possible for 05 km) 
flg_GICmask=true # [Default true!]
# Remove ice outside observed ice mask (can be combined with GIC masking option) 
flg_OBSmask=false # [Default false!]
# Results are written in differnet output dirs according to these options:
# ../Data/SC_GIC0_OBS0, SC_GIC1_OBS0
# Resolution of input files
ares=05 # [Default 05] 
#
# Within scalars_basin.sh one can set what is calculated
# Integrals on model mask and basin intgrals over two different basin sets
# Default should be to do all three, but for testing this may be changed
#flg_mm=true  # Integrals on model mask
#flg_rm=true  # IMBIE2-Rignot basins
#flg_zm=true  # IMBIE2-Zwally basins


### Integrated basins to compare to total scalars 
check_basin_integrals_05.sh <br>

### batch scripts for job submission on different platforms
run_scalar_lisa.bash <br>
run_scalar_cartesius.bash <br>

### Other utilities
consolidate.sh
update_archive.sh
name_remapping.sh
