# README for analysis and plotting code associated with Bushinsky et al. XXXX, Timing and amplitude biases in modeled Southern Ocean dissolved inorganic carbon and temperature produce out of phase pCO2 and CO2 fluxes in CMIP models and state estimates

## Needed data files:
Carbon_mapped_product_analysis_output_2024_04_15.mat - average of mapped Landschützer and Rödenbeck CO2 fluxes/pCO2.
gdap_and_argo_gridded_2024_Sep_06.mat - 1x1 gridded float and GLODAP data

## Data preprocessing scripts:
cmip_processing.yml - set up python environment for notebooks
model_file_concatenation.ipynb - Concatenation of different model years

Regridding, interpolating, unifying calendars, removing bad data, etc:
- CMIP5_processing.sh
- CMIP6_processing.sh
- SOSE_regrid.sh
- CMIP5_thetao_so.sh
- checking_for_unprocessed_model_output.ipynb
  
MLD_calc_offline.ipynb - MLD calculation for models

## Analysis scripts:
CMIP5_plotting_v2.m (should rename)

## Subfunctions called by preprocessing or analysis scripts:
functions\CO2SYSSOCCOM_smb.m		
functions\MLD_4grp_cmip.py		
functions\fit_cosine.m			
functions\mld_calculations.py
functions\fit_harmonics.m			

## Plotting scripts:
Bushinsky_et_al_CMIP_SO_C_flux_figure_plotting.m
Figure_1.ipynb
supplemental_map_plotting.ipynb

