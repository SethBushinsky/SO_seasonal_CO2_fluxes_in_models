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

def cmip_mld_calc(cmip_dir, out_dir, model_name, dir_add_on, sal_name, theta_name, model_run):

    print(model_name + ' ' + dir_add_on + ' started')    
    for file in os.listdir(cmip_dir + 'so/regrid_for_MLD/' + dir_add_on):
        # print(file)
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

    # find the depth levels without knowing the coordinate name:
    for k in so_n[sal_name].indexes.keys():
        v = so_n[sal_name][k]
        axis = v.attrs.get('axis')
        # print(axis)
        if axis=='Z':
            depth_vals = v.values
            break

    if model_name=='CESM1-BGC': # error in CESM1-BGC
        so_factor = 1000
    else:
        so_factor = 1

    if thetao_n[theta_name].units=='K':
        thetao_n_offset = -273.15
    else:
        thetao_n_offset = 0

    if model_run.__contains__('SOSE'): # error in CESM1-BGC
        depth_factor = -1
    else:
        depth_factor = 1
        
    for tt in range(0, len(thetao_n['time'])):
        for lo in range(0,360):
            for la in range(10, 60):
                if sum(~np.isnan(thetao_n[theta_name].isel(time=tt, lon=lo, lat=la).values))<=1:
                    continue
                pot_dens = sigma0(so_n[sal_name].isel(time=tt, lon=lo, lat=la).values*so_factor, 
                            thetao_n[theta_name].isel(time=tt, lon=lo, lat=la).values+thetao_n_offset, 
                            thetao_n['lon'][lo].values, thetao_n['lat'][la].values, depth_vals*depth_factor)
                if sum(~np.isnan(pot_dens))<=1: 
                    continue
                mld = fl_mld.calc_mld(pot_dens, depth_vals*depth_factor, ref_depth=10, sigma_theta_crit=sig_threshold)
                mld_array[tt, la, lo] = mld

    
    ds = xr.Dataset({})
    ds['thetao'] = thetao_n[theta_name]
    ds['mld'] = (( 'time', 'lat','lon'), mld_array)
    ds['mld'] = ds['mld'].assign_attrs(units="m",long_name='MLD calculated from monthly output, 0.03 sig theta from 10 m', standard_name ='MLD')

    d_mld_only = ds.drop_vars('thetao')
    d_mld_only.to_netcdf(cmip_dir + out_dir + dir_add_on +  'mld' + so_filename[2:])
    print(model_name + ' ' + dir_add_on + ' completed')

    return