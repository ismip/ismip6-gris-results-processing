# ismip6-gris-results-processing
Collection of scripts to process ISMIP6 Greenland model projections

# Set paths in scripts to your local environment!!

# ISMIP6 archive
# Update from lisa with pre-processed submissions

# initial checkout and update
cd ../
rsync -avh --exclude 'tools' lisa:/home/hgoelzer/Projects/ISMIP6/Archive_05/ ./


# Sanity check of submissions and updates
./consolidate.sh


# Result processing

# All scalars recalculated
meta_scalar.sh
scalars_opt.sh
