#!/bin/bash
# integrate all basins, to be compared to sle in scalars_mm

ncap2 -O -s "sle = sle_no+sle_ne+sle_se+sle_sw+sle_cw+sle_nw" -v scalars_mm_imb_05.nc integrals.nc
