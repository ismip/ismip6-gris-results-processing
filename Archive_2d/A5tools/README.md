## ismip6-gris-results-processing

# A5tools

### 2D snapshot extraction and calculations

## Initial model state 2014 and end of projection 2100
meta_2d_hist_05.sh
- Ice masks
- Surface elevation
- Ice thickness
- Bedrock

meta_2d_proj_05.sh
- Ice masks
- Surface elevation
- Ice thickness
- Bedrock
and differences



# TODO
## Initial model state end 2014
- SMB
- BMB
- applied MB
- Mass above flotation
- Velocity magnitude
- Log velocity magnitude

## Projection (For all scenarios/models, including control). Snapshots at 2040, 2060 and 2100. Differences/changes relative to end 2014. 
- SMB (2021-2040, 2041-2060, 2081-2100)
- integrated dSMB (2015-2040, 2015-2060, 2015-2100)
- dynamic contribution (Modelled thickness change - integrated dSMB, same dates)



# Processing order
./meta_2d_proj_05.sh
./meta_2d_hist_05.sh
./meta_2d_proj_diff_05.sh
