import xarray as xr
import functions.MLD_4grp_cmip as fl_mld
import numpy as np
import gsw
import os


def sigma0(salinity,temperature,lon,lat,pressure):
    SA = gsw.SA_from_SP(salinity,
                        pressure,
                        lon,
                        lat)

    CT = gsw.CT_from_t(SA,
                       temperature,
                       pressure)

    sigma = gsw.sigma0(SA,CT)
    
    return sigma

def cmip_mld_calc(cmip_dir, out_dir, model_name, dir_add_on):
    
    for file in os.listdir(cmip_dir + 'so/regrid_for_MLD/' + dir_add_on):
        if '_' + model_name + '_' in file:
            so_filename = file

    for file in os.listdir(cmip_dir + 'thetao/regrid_for_MLD/' + dir_add_on):
            if '_' + model_name + '_' in file:
                thetao_filename = file

    so_n = xr.open_dataset(cmip_dir + 'so/regrid_for_MLD/' + dir_add_on + so_filename)
    thetao_n = xr.open_dataset(cmip_dir + 'thetao/regrid_for_MLD/' + dir_add_on + thetao_filename)

    sig_threshold = 0.03

    mld_array = np.zeros((len(thetao_n['time']), len(thetao_n['lat']), len(thetao_n['lon'])))
    mld_array[:] = np.NaN
    # la = 30

    for tt in range(0, len(thetao_n['time'])):
        for lo in range(0,360):
            for la in range(10, 60):
                if sum(~np.isnan(so_n['so'].isel(time=tt, lon=lo, lat=la).values))==0:
                    continue
                pot_dens = sigma0(so_n['so'].isel(time=tt, lon=lo, lat=la).values, 
                                thetao_n['thetao'].isel(time=tt, lon=lo, lat=la).values-273.15, 
                                thetao_n['lon'][lo].values, thetao_n['lat'][la].values, thetao_n['lev'].values)
                
                mld = fl_mld.calc_mld(pot_dens, thetao_n['lev'].values, ref_depth=10, sigma_theta_crit=sig_threshold)
                mld_array[tt, la, lo] = mld

    
    ds = xr.Dataset({})
    ds['thetao'] = thetao_n['thetao']
    ds['mld'] = (( 'time', 'lat','lon'), mld_array)
    ds['mld'] = ds['mld'].assign_attrs(units="m",long_name='MLD calculated from monthly output, 0.03 sig theta from 10 m')

    d_mld_only = ds.drop_vars('thetao')
    d_mld_only.to_netcdf(cmip_dir + out_dir + 'mld' + dir_add_on + so_filename[2:])
    print(model_name + ' completed')

    return