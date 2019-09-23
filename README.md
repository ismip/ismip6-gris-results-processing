# ismip6-gris-results-processing
Collection of scripts to process ISMIP6 Greenland model projections

# Archive setup

### On server
A1 --> /projects/grid/ghub/ISMIP6/Projections/GrIS/output

### Local processing root
Archive            # local copy of A1 with fixed file names

Archive_05         # consolidated at 5 km

Archive_sc         # recalculated scalar output


Grids              # cdo descriptions, remapping weights, area factors
Data               # BM3, masks, regions


Downloaded files in ../Archive are regridded and compressed into Archive_05

