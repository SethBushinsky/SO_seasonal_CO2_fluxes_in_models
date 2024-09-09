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

def time_index_to_string(tt):
    tt_str = str(tt)
    if len(tt_str)==3:
        tt_out = tt_str
    elif len(tt_str)==1:
        tt_out = '00' + tt_str
    elif len(tt_str)==2:
        tt_out = '0' + tt_str
    
    return tt_out


def cmip_mld_calc(cmip_dir, out_dir, model_name, dir_add_on, sal_name, theta_name, 
                      tt, thetao_n, so_n, so_factor, depth_factor, depth_vals, thetao_n_offset, sig_threshold, so_filename):
    print(thetao_n)
    # mld_array = np.zeros((len(thetao_n['lat']), len(thetao_n['lon'])))
    mld_array =  np.zeros((len(thetao_n['lat']), len(thetao_n['lon'])))

    mld_array[:] = np.NaN
    
    for lo in range(0,360):
        for la in range(10, 60):
            if sum(~np.isnan(thetao_n.isel(lon=lo, lat=la).values))<=1:
                continue
            pot_dens = sigma0(so_n.isel(lon=lo, lat=la).values*so_factor, 
                        thetao_n.isel(lon=lo, lat=la).values+thetao_n_offset, 
                        thetao_n['lon'][lo].values, thetao_n['lat'][la].values, depth_vals*depth_factor)
            if sum(~np.isnan(pot_dens))<=1: 
                continue
            mld = fl_mld.calc_mld(pot_dens, depth_vals*depth_factor, ref_depth=10, sigma_theta_crit=sig_threshold)
            mld_array[la, lo] = mld

    
    ds = xr.Dataset({})
    ds['thetao'] = thetao_n
    ds['mld'] = (('lat','lon'), mld_array)
    ds['mld'] = ds['mld'].assign_attrs(units="m",long_name='MLD calculated from monthly output, 0.03 sig theta from 10 m', standard_name ='MLD')

    d_mld_only = ds.drop_vars('thetao')

    tt_str = time_index_to_string(tt)

    d_mld_only.to_netcdf(cmip_dir + out_dir + dir_add_on +  tt_str + 'mld' + so_filename[2:])
    print(model_name + ' ' + dir_add_on + ' completed')

    return