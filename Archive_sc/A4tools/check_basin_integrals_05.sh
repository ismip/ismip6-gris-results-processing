#!/bin/bash
# integrate all basins, to be compared to sle in scalars_mm

set -x
set -e

ncmodel="../Data/SC_GIC0_OBS0/ILTS_PIK/SICOPOLIS2/exp05_05/scalars_mm_GIS_ILTS_PIK_SICOPOLIS2_exp05.nc"
ncrignot="../Data/SC_GIC0_OBS0/ILTS_PIK/SICOPOLIS2/exp05_05/scalars_rm_GIS_ILTS_PIK_SICOPOLIS2_exp05.nc"
nczwally="../Data/SC_GIC0_OBS0/ILTS_PIK/SICOPOLIS2/exp05_05/scalars_zm_GIS_ILTS_PIK_SICOPOLIS2_exp05.nc"

ncap2 -O -s "sle = sle_no+sle_ne+sle_se+sle_sw+sle_cw+sle_nw" -v ${ncrignot} integrals_rignot.nc

ncap2 -O -s "sle = sle_z11+ sle_z12+ sle_z13+ sle_z14 + sle_z21+ sle_z22+ sle_z31+ sle_z32+ sle_z33+ sle_z41+ sle_z42+ sle_z43+ sle_z50+ sle_z61+ sle_z62+ sle_z71+ sle_z72+ sle_z81+ sle_z82" -v ${nczwally} integrals_zwally.nc

ncdump -v sle ${ncmodel}
ncdump -v sle integrals_rignot.nc 
ncdump -v sle integrals_zwally.nc 


