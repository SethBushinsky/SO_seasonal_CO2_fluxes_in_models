% 2022_04_14 - Cleaning up code and only copying actively used sections
% from CMIP5_plotting.m

%% Note - might correct for area when averaging, but not essential and probably doesn't make a difference really..
% setting colors for consistency b/t plots

color_model = {'CanESM2' 1 ; ...
    'BLANK' 2; ...
    'MPI_ESM_LR' 3; ...
    'MPI_ESM_MR' 4 ; ...
    'NorESM1_ME' 5 ; ...
    'MIROC_ESM_CHEM' 6 ; ...
    'MIROC_ESM' 7 ; ...
    'HadGEM2_CC' 8; ...
    'HadGEM2_ES' 9 ; ...
    'GFDL_ESM2M' 10 ; ...
    'GFDL_ESM2G' 11 ; ...
    'CMCC_CESM' 12 ; ...
    'CESM1_BGC' 13 ; ...
    'bcc_csm1_1_m' 14 ; ...
    'inmcm4' 15 ; ...
    'MRI_ESM1' 16 ; ...
    'CNRM_CM5' 17 ; ...
    'BLANK' 18 ; ...
    'GISS_E2_H_CC' 19 ; ...
    'GISS_E2_R_CC' 20; ...
    'CESM2_WACCM_6' 21;...
    'CESM2_6' 22;...
    'CNRM_ESM2_1_6' 23;...
    'CanESM5_6' 24;...
    'MIROC_ES2L_6' 25 ;...
    'UKESM1_0_LL_6' 26; ...
    'GISS_E2_R' 27; ...
    'ACCESS_ESM1_5_6' 28; ...
    'BCC_CSM2_MR_6' 29; ...
    'GFDL_CM4_6' 30;...
    'GFDL_ESM4_6' 31; ...
    'INM_CM4_8_6' 32; ...
    'INM_CM5_0_6' 33; ...
    'MPI_ESM1_2_HR_6' 34; ...
    'MPI_ESM1_2_LR_6' 35; ...
    'NorESM2_LM_6' 36; ...
    'NorESM2_MM_6' 37;
    'IPSL_CM5B_LR' 38; ...
    'IPSL_CM5A_LR' 39; ...
    'IPSL_CM5A_MR' 40; ...
    'MRI_ESM2_0_6' 41; ...
    'SOSE_i133' 42; ...
    'SOSE_i122' 43; ...
    'IPSL_CM6A_LR_6' 44; ...
    'CMCC_ESM2_6' 45};

cmap = distinguishable_colors(length(color_model));

% obs will always be black.

Plot_out_dir = [home_dir 'Work/Projects/2019_05 SO_C_flux_model_comparison/Plots/'];
%
% % model_type_1
% model_group_names.good_mag_good_phase = {'MIROC_ESM', 'MIROC_ESM_CHEM', ...
%      'CESM1_BGC', 'GFDL_ESM4_6'};
% % 2
% model_group_names.large_mag_good_phase = {'MPI_ESM_LR', 'MPI_ESM_MR', 'NorESM1_ME', 'MPI_ESM1_2_HR_6', 'GISS_E2_H_CC'};
% %3
%
% model_group_names.bad_phase = {'IPSL_CM5A_LR', 'IPSL_CM5A_MR', 'IPSL_CM5B_LR', 'MRI_ESM1', 'CNRM_CM5','GFDL_ESM2G', ...
%      'CNRM_ESM2_1_6', 'CanESM5_6', 'MIROC_ES2L_6', ...
%     'INM_CM5_0_6','INM_CM4_8_6', 'ACCESS_ESM1_5_6', 'GFDL_CM4_6', 'SOSE_i133', 'SOSE_i122', 'bcc_csm1_1_m'};
% %4
% model_group_names.double_peak = {'CanESM2', 'CMCC_CESM', 'GFDL_ESM2M'};
% % 5
% model_group_names.other = {'NorESM2_LM_6', 'NorESM2_MM_6', 'CESM2_WACCM_6', 'CESM2_6','MPI_ESM1_2_LR_6', 'HadGEM2_CC', 'HadGEM2_ES',  'GISS_E2_R_CC', ...
%     'GISS_E2_R',  'BCC_CSM2_MR_6', 'inmcm4', 'MRI_ESM2_0_6', 'UKESM1_0_LL_6', 'IPSL_CM6A_LR_6'};
% %
% model_types = fieldnames(model_group_names);
% lat_lims = [-62 -45];

poleward_lat_lim = -62;
%%
model_group_colors = brewermap(10, 'dark2');
model_group_colors(1,:) = [0.105882352941176,0.619607843137255,0.8];
model_group_colors(4,:) = model_group_colors(8,:);
%
% plot color test
clf
subplot(1,1,1)
hold on
plot([0 0], [1 2], 'color', model_group_colors(1,:), 'linewidth', 2)
plot([-1 0], [1 2], 'color', model_group_colors(2,:), 'linewidth', 2)
plot([-2 0], [1 2], 'color', model_group_colors(3,:), 'linewidth', 2)
plot([-3 0], [1 2], 'color', model_group_colors(4,:), 'linewidth', 2)
plot([-4 0], [1 2], 'color', model_group_colors(5,:), 'linewidth', 2)


%%
clear CMIP cmip_names var_type var_lims


%%% removing this, using C_input loaded from "Carbon_mapped_product_analysis.m"
%%% Neural Network fCO2 load
% neural_dir = [data_dir 'Data_Products/CO2_fluxes/Landshuster_Neural/2018_08_30/'];
% load([neural_dir 'neural_network_results_v2.mat'])

% clear neural_dir
%% Multi var load CMIP
variables = {'spco2';'intpp'; 'psl';'mlotst';'tos';'sos'; 'dissic'; 'talk'; 'fgco2';'wmo'; 'dissic_yr'; 'talk_yr'; 'thetao'};
var_type = {'Omon'; 'Omon'; 'Amon';'Omon';'Omon';'Omon'; 'Omon'; 'Omon'; 'Omon'; 'Omon'; 'Oyr'; 'Oyr'; 'Omon'};
var_lims = [350 450 ;  0 7e2; 980 1020 ; 0 500 ; -1 25; 29 35.5; 1950 2300;2200 2500;-5e-2 5e-2;-3e7 3e7;1950 2300; 2200 2500; -1 25];
%%
% 2022_04_14 - in the process of "fixing" CESM2_6 - found a processing
% error with any variables that have depth. I'm concatenating along the
% depth axis, not time, when I add historical runs. Need to fix. 2022_06_24
% - checked, this is now fixed
plot_ver = '_v12'; % fixed gaps in SAF_mask 

% int_levels = [12,25,50,75,100,125,150,175,200,250,300,350,400];
% bgc_levels = [10,25,50,75,100,125,150,175,200,300,400,500,600,700,800,900,1000,1200,1400,1600,1800,2000];

for v= 1:length(variables)
    disp([ '     <strong> Starting ' variables{v} ' processing </strong>' ])
    
    if  (strcmp(variables{v}, 'dissic') || strcmp(variables{v}, 'talk')) && strcmp(var_type{v}, 'Omon')
        CMIP_dir = [data_dir 'Model_Output/CMIP5/' variables{v} '/monthly/regrid/'];
        var_load = variables{v};
    elseif strcmp(variables{v}, 'dissic_yr') || strcmp(variables{v}, 'talk_yr')
        var_load = variables{v}(1:end-3);
        CMIP_dir = [data_dir 'Model_Output/CMIP5/' var_load '/regrid/'];
    else
        var_load = variables{v};
        CMIP_dir = [data_dir 'Model_Output/CMIP5/' variables{v} '/regrid/'];
        
    end
    
    % CMIP5 load %%%

    cmip_files = dir([CMIP_dir '*.nc']);
    
    CMIP.(variables{v}) = [];
    
    cmip_names.(variables{v}) = cell(length(cmip_files),1);
    %
    time_offset = 0; % differing time stamps is now fixed using cdo commands
    
    for f=1:length(cmip_files)
        
        % finding model name by looking between frequency indicator and
        % rcp85
        % also want to save out the ensemble member to make sure everything
        % agrees as close as possible
        first_index = strfind(cmip_files(f).name, var_type{v});
        second_index = strfind(cmip_files(f).name, 'rcp85');
        third_index = strfind(cmip_files(f).name, '_2');
        
        if strcmp(var_type{v}, 'Oyr')
            mod_name = cmip_files(f).name(first_index+4:second_index-2);
        else
            mod_name = cmip_files(f).name(first_index+5:second_index-2);
        end
        disp([mod_name ' started'])
        
        mod_name = strrep(mod_name, '-', '_');
        
        CMIP.(variables{v}).(mod_name).ensemble_member = cmip_files(f).name(second_index+6:third_index-1);
        
        time_temp = ncread([CMIP_dir cmip_files(f).name], 'time');
        
        temp_Matlab_time = time_temp + time_offset;
        
        if f==1
            CMIP.(variables{v}).lon = ncread([CMIP_dir cmip_files(f).name], 'lon');
            CMIP.(variables{v}).lat = ncread([CMIP_dir cmip_files(f).name], 'lat');
        end
        
        CMIP.(variables{v}).(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time
        CMIP.(variables{v}).(mod_name).(variables{v}) = squeeze(ncread([CMIP_dir cmip_files(f).name], var_load));
        CMIP.(variables{v}).(mod_name).units = ncreadatt([CMIP_dir cmip_files(f).name], var_load, 'units');
        CMIP.(variables{v}).(mod_name).long_name = ncreadatt([CMIP_dir cmip_files(f).name], var_load, 'long_name');
        try
            CMIP.(variables{v}).(mod_name).standard_name = ncreadatt([CMIP_dir cmip_files(f).name], var_load, 'standard_name');
        catch
        end
        
        if numel(size(CMIP.(variables{v}).(mod_name).(variables{v})))==4 || strcmp(variables{v}, 'thetao')
            try
                CMIP.(variables{v}).(mod_name).depth = ncread([CMIP_dir cmip_files(f).name], 'zlev');
            catch
                CMIP.(variables{v}).(mod_name).depth = ncread([CMIP_dir cmip_files(f).name], 'lev');
            end
        end
        
        cmip_names.(variables{v}){f} = mod_name;
        
        clear mod_name time_temp first_index second_index
    end
    
    clear cmip_files CMIP_dir
    
    % CMIP 6 load %%%
    % ssp585 first
    if  (strcmp(variables{v}, 'dissic') || strcmp(variables{v}, 'talk')) && strcmp(var_type{v}, 'Omon')
        CMIP_dir = [data_dir 'Model_Output/CMIP6/' variables{v} '/monthly/regrid/ssp585_download/'];
    elseif strcmp(variables{v}, 'dissic_yr') || strcmp(variables{v}, 'talk_yr')
        CMIP_dir = [data_dir 'Model_Output/CMIP6/' var_load '/regrid/ssp585_download/'];
    else
        CMIP_dir = [data_dir 'Model_Output/CMIP6/' variables{v} '/regrid/ssp585_download/'];
    end
    CMIP_dir_hist = [CMIP_dir '../historical_download/'];
    
    cmip_files = dir([CMIP_dir '*.nc']);
    cmip_files_hist = dir([CMIP_dir_hist '*.nc']);
    
    
    cmip6_model_names = cell(length(cmip_files),1);
    time_offset = 0; % time and calendar has been set in CDO
    
    
    for f=1:length(cmip_files)
        
        first_index = strfind(cmip_files(f).name, var_type{v});
        second_index = strfind(cmip_files(f).name, 'ssp585');
        third_index = strfind(cmip_files(f).name, '_2');
        
        if strcmp(var_type{v}, 'Oyr')
            mod_name_orig = cmip_files(f).name(first_index+4:second_index-2);
        else
            mod_name_orig = cmip_files(f).name(first_index+5:second_index-2);
        end
        
        
        disp([mod_name_orig ' started'])
        
        mod_name = strrep(mod_name_orig, '-', '_');
        mod_name = [mod_name '_6'];
        
        CMIP.(variables{v}).(mod_name).ensemble_member = cmip_files(f).name(second_index+7:third_index-1);
        
        time_temp = ncread([CMIP_dir cmip_files(f).name], 'time');
        temp_Matlab_time = time_temp + time_offset;
        
        CMIP.(variables{v}).(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time time_temp
        CMIP.(variables{v}).(mod_name).(variables{v}) = squeeze(ncread([CMIP_dir cmip_files(f).name], var_load));
        CMIP.(variables{v}).(mod_name).units = ncreadatt([CMIP_dir cmip_files(f).name], var_load, 'units');
        CMIP.(variables{v}).(mod_name).long_name = ncreadatt([CMIP_dir cmip_files(f).name], var_load, 'long_name');
        CMIP.(variables{v}).(mod_name).standard_name = ncreadatt([CMIP_dir cmip_files(f).name], var_load, 'standard_name');
        
        
        if numel(size(CMIP.(variables{v}).(mod_name).(variables{v})))==4 || strcmp(variables{v}, 'thetao')
            try
                CMIP.(variables{v}).(mod_name).depth = ncread([CMIP_dir cmip_files(f).name], 'zlev');
                CMIP.(variables{v}).(mod_name).depth_units_orig = ncreadatt([CMIP_dir cmip_files(f).name], 'zlev', 'units');
                
            catch
                try
                    CMIP.(variables{v}).(mod_name).depth = ncread([CMIP_dir cmip_files(f).name], 'lev');
                    try
                        CMIP.(variables{v}).(mod_name).depth_units_orig = ncreadatt([CMIP_dir cmip_files(f).name], 'lev', 'units');
                    catch
                        disp(['No units for ' cmip_files(f).name ' lev'])
                    end
                catch
                    CMIP.(variables{v}).(mod_name).depth = ncread([CMIP_dir cmip_files(f).name], 'olevel');
                    CMIP.(variables{v}).(mod_name).depth_units_orig = ncreadatt([CMIP_dir cmip_files(f).name], 'olevel', 'units');
                    
                end
            end
        end
                        % 2022_06_24 - removing as this should be fixed in cdo now
%         % check units and adjust if centimeters (CESM2_6 only so far)
%         if isfield(CMIP.(variables{v}).(mod_name), 'depth_units_orig') && strcmp(CMIP.(variables{v}).(mod_name).depth_units_orig, 'centimeters')
%             CMIP.(variables{v}).(mod_name).depth =  CMIP.(variables{v}).(mod_name).depth./100;
%             CMIP.(variables{v}).(mod_name).depth_units =  'm';
%             
%         end
        
        % 2022_06_24 - removing, as this should be fixed in CDO now
%         % if there are more than 13 depths and var is thetao, the file has not been
%         % interpolated already in depth.
%         % Perform an interpolation at each grid cell
%         if strcmp(variables{v}, 'thetao') && length(CMIP.(variables{v}).(mod_name).depth)>13 %%|| ...
%             % 				(strcmp(variables{v}, 'dissic') && length(CMIP.(variables{v}).(mod_name).depth)>1) || ...
%             % 				(strcmp(variables{v}, 'talk') && length(CMIP.(variables{v}).(mod_name).depth)>1)
%             CMIP.(variables{v}).(mod_name).([variables{v} '_raw']) = CMIP.(variables{v}).(mod_name).(variables{v});
%             
%             CMIP.(variables{v}).(mod_name).(variables{v}) = NaN(length(CMIP.(variables{v}).lon), length(CMIP.(variables{v}).lat), length(int_levels));
%             for lo = 1:length(CMIP.(variables{v}).lon)
%                 for la = 1:length(CMIP.(variables{v}).lat)
%                     CMIP.(variables{v}).(mod_name).(variables{v})(lo, la, :) = ...
%                         interp1(CMIP.(variables{v}).(mod_name).depth, squeeze(CMIP.(variables{v}).(mod_name).([variables{v} '_raw'])(lo, la, :)), int_levels);
%                 end
%             end
%             % save original depth:
%             CMIP.(variables{v}).(mod_name).depth_orig = CMIP.(variables{v}).(mod_name).depth;
%             
%             % put int_levels into depth vector:
%             CMIP.(variables{v}).(mod_name).depth = int_levels;
%             clear lo la
%         end


        % try to load historical
        % check if the correct file exists
        hh=[];
        for g = 1:length(cmip_files_hist)
            
            first_index = strfind(cmip_files_hist(g).name, var_type{v});
            second_index = strfind(cmip_files_hist(g).name, 'historical');
            
            if strcmp(var_type{v}, 'Oyr')
                mod_name_hist = cmip_files_hist(g).name(first_index+4:second_index-2);
            else
                mod_name_hist = cmip_files_hist(g).name(first_index+5:second_index-2);
            end
            
            if strcmp(mod_name_hist, mod_name_orig) % make sure the model name matches between historical and ssp585
                hh = g;
                break
            end
        end
        
        clear mod_name_hist
        % if historical run exists, load and concatenate or average
        if ~isempty(hh)
            time_temp = ncread([CMIP_dir_hist cmip_files_hist(hh).name], 'time');
            temp_Matlab_time = time_temp + time_offset;
            
            second_index = strfind(cmip_files_hist(hh).name, 'historical');
            third_index = strfind(cmip_files_hist(hh).name, '_1');
            if isempty(third_index)
                third_index = strfind(cmip_files_hist(hh).name, '_2');
            end
            if isempty(third_index)
                disp(['Missing ensemble name ' (mod_name) ' historical'])
            end
            
            CMIP.(variables{v}).(mod_name).ensemble_member_hist = cmip_files_hist(hh).name(second_index+11:third_index-1);
            CMIP.(variables{v}).(mod_name).GMT_Matlab = [temp_Matlab_time;  CMIP.(variables{v}).(mod_name).GMT_Matlab];
            
            
            if ~strcmp(variables{v}, 'thetao')
                time_dimension = find(size(CMIP.(variables{v}).(mod_name).(variables{v}))==length(time_temp));
                CMIP.(variables{v}).(mod_name).(variables{v}) = cat(time_dimension,squeeze(ncread([CMIP_dir_hist cmip_files_hist(hh).name], var_load)), ...
                    CMIP.(variables{v}).(mod_name).(variables{v}));
                
                clear time_dimension
            else
                % for thetao, you only have one temporal mean, so you don't
                % want to concatenate, you want to average. Except that you
                % first need to check if there should be interpolation:
                temp_var_hist = ncread([CMIP_dir_hist cmip_files_hist(hh).name], var_load);
                if strcmp(variables{v}, 'thetao')
                    try
                        CMIP.(variables{v}).(mod_name).depth_hist = ncread([CMIP_dir_hist cmip_files_hist(hh).name], 'zlev');
                        CMIP.(variables{v}).(mod_name).depth_units_orig_hist = ncreadatt([CMIP_dir_hist cmip_files_hist(hh).name], 'zlev', 'units');
                        
                    catch
                        try
                            CMIP.(variables{v}).(mod_name).depth_hist = ncread([CMIP_dir_hist cmip_files_hist(hh).name], 'lev');
                            try
                                CMIP.(variables{v}).(mod_name).depth_units_orig_hist = ncreadatt([CMIP_dir_hist cmip_files_hist(hh).name], 'lev', 'units');
                                
                            catch
                                disp(['No units for ' cmip_files(f).name ' lev'])
                                
                            end
                        catch
                            CMIP.(variables{v}).(mod_name).depth_hist = ncread([CMIP_dir_hist cmip_files_hist(hh).name], 'olevel');
                            CMIP.(variables{v}).(mod_name).depth_units_orig_hist = ncreadatt([CMIP_dir_hist cmip_files_hist(hh).name], 'olevel', 'units');
                            
                        end
                    end
                end
                
                                % 2022_06_24 - removing as this should be fixed in cdo now

%                 % check units and adjust if centimeters (CESM2_6 only so far)
%                 if isfield(CMIP.(variables{v}).(mod_name), 'depth_units_orig') && strcmp(CMIP.(variables{v}).(mod_name).depth_units_orig, 'centimeters')
%                     CMIP.(variables{v}).(mod_name).depth_hist =  CMIP.(variables{v}).(mod_name).depth_hist./100;
%                     CMIP.(variables{v}).(mod_name).depth_hist_units =  'm';
%                     
%                 end
                
                % 2022_06_24 - removing as this should be fixed in cdo now
%                 % if there are more than 13 depths and var is thetao, the file has not been
%                 % interpolated already in depth. Perform an interpolation at each
%                 % grid cell.
%                 if length(CMIP.(variables{v}).(mod_name).depth_hist)>13 && strcmp(variables{v}, 'thetao')
%                     %                 CMIP.(variables{v}).(mod_name).([variables{v} '_raw_hist']) = temp_var; clear temp_var
%                     
%                     temp_var_hist_interp = NaN(length(CMIP.(variables{v}).lon), length(CMIP.(variables{v}).lat), length(int_levels));
%                     for lo = 1:length(CMIP.(variables{v}).lon)
%                         for la = 1:length(CMIP.(variables{v}).lat)
%                             temp_var_hist_interp(lo, la, :) = ...
%                                 interp1(CMIP.(variables{v}).(mod_name).depth_hist, squeeze(temp_var_hist(lo, la, :)), int_levels);
%                         end
%                     end
%                     clear lo la
%                     temp_var_hist = temp_var_hist_interp;
%                 end
                
                % first concatenate thetao datasets, then take the mean
                % along the new time dimension, leaving a lon x lat x depth
                % array
                CMIP.(variables{v}).(mod_name).(variables{v}) = ...
                    nanmean(cat(4, CMIP.(variables{v}).(mod_name).(variables{v}), temp_var_hist),4);
                
                clear temp_var_hist_interp temp_var_hist
            end
            
            
            
            clear temp_Matlab_time time_temp
        else
            disp(['No historical run for ' mod_name])
        end
        
        cmip6_model_names{f} = mod_name;
        
        clear mod_name time_temp first_index second_index temp_Matlab_time hh g
    end
    clear f
    % Now check the historical directory to see if any models had a
    % historical run only:
    % go through each cmip file name, find the model  name, and compare to
    % the list of cmip6_model names (cmip6_model_names)
    
    for g = 1:length(cmip_files_hist)
        hh=0;
        
        first_index = strfind(cmip_files_hist(g).name, var_type{v});
        second_index = strfind(cmip_files_hist(g).name, 'historical');
        
        if strcmp(var_type{v}, 'Oyr')
            mod_name_orig = cmip_files_hist(g).name(first_index+4:second_index-2);
        else
            mod_name_orig = cmip_files_hist(g).name(first_index+5:second_index-2);
        end
        mod_name = strrep(mod_name_orig, '-', '_');
        mod_name = [mod_name '_6'];
        
        for mm = 1:length(cmip6_model_names)
            if strcmp(mod_name, cmip6_model_names{mm})
                hh=1;
            end
            
        end
        if hh~=1
            disp([mod_name ' Model not found in cmip6 list, adding historical run alone'])
            
            second_index = strfind(cmip_files_hist(g).name, 'historical');
            third_index = strfind(cmip_files_hist(g).name, '_1');
            if isempty(third_index)
                third_index = strfind(cmip_files_hist(g).name, '_2');
            end
            if isempty(third_index)
                disp(['Missing ensemble name ' (mod_name) ' historical'])
            end
            
            CMIP.(variables{v}).(mod_name).ensemble_member_hist = cmip_files_hist(g).name(second_index+11:third_index-1);
            
            time_temp = ncread([CMIP_dir_hist cmip_files_hist(g).name], 'time');
            temp_Matlab_time = time_temp + time_offset;
            
            
            CMIP.(variables{v}).(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time time_temp
            CMIP.(variables{v}).(mod_name).(variables{v}) = squeeze(ncread([CMIP_dir_hist cmip_files_hist(g).name], var_load));
            CMIP.(variables{v}).(mod_name).units = ncreadatt([CMIP_dir_hist cmip_files_hist(g).name], var_load, 'units');
            CMIP.(variables{v}).(mod_name).long_name = ncreadatt([CMIP_dir_hist cmip_files_hist(g).name], var_load, 'long_name');
            
            if numel(size(CMIP.(variables{v}).(mod_name).(variables{v})))==4
                try
                    CMIP.(variables{v}).(mod_name).depth = ncread([CMIP_dir_hist cmip_files_hist(g).name], 'zlev');
                catch
                    CMIP.(variables{v}).(mod_name).depth = ncread([CMIP_dir_hist cmip_files_hist(g).name], 'lev');
                end
            end
            
            cmip6_model_names{end+1} = mod_name;
        end
    end
    
    clear f cmip_files cmip_files_hist g hh
    
    cmip_names.(variables{v}) = [cmip_names.(variables{v}) ; cmip6_model_names];
    
    
    
    clear q cmip6_talk_names time_offset CMIP_dir cmip6_model_names var_load
    
end
clear f cmip_files v first_index second_index third_index

adjust_list = {'spco2'; 'psl'; 'intpp'; 'dissic'; 'talk'; 'dissic_yr'; 'talk_yr'};
scale_factor = [1./101325 .*10^6;  1./100  ; 1000*12*24*60*60 ; 1000; 1000; 1000; 1000; ];
new_units = {'uatm'; 'mbar'; 'mgC m-2 d-1'; 'umol l-1'; 'umol l-1'; 'umol l-1'; 'umol l-1'};
for aa = 1:length(adjust_list)
    v = find(strcmp(variables, adjust_list{aa}));
    if ~isfield(cmip_names, variables{v})
        continue
    end
    
    for m=1:length(cmip_names.(variables{v}))
        if isfield(CMIP.(variables{v}).(cmip_names.(variables{v}){m}), 'units_old')
            continue
        end
        
        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units_old = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units;
        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}).*scale_factor(aa); % Pa to uatm
        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units = new_units{aa};
        
    end
end
clear aa v m scale_factor adjust_list new_units
% % unit adjustment
% %adjusting spco2 into atmospheres:
% scale_factor = 1./101325 .*10^6;  % atm per pascale times uatm per atm
% v = find(strcmp(variables, 'spco2'));
%
% for m=1:length(cmip_names.(variables{v}))
%     if isfield(CMIP.(variables{v}).(cmip_names.(variables{v}){m}), 'units_old')
%         continue
%     end
%     %        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).([variables{v} '_old']) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v});
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units_old = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units;
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}).*scale_factor; % Pa to uatm
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units = 'uatm';
% end
% clear scale_factor

% CMIP5 tos is in Kelvin, check unit and convert - leave TOS separate b/c
% it uses addition and I don't want to deal with including it in the loop
v = find(strcmp(variables, 'tos'));
if isfield(cmip_names, variables{v})
    for m=1:length(cmip_names.(variables{v}))
        if isfield(CMIP.(variables{v}).(cmip_names.(variables{v}){m}), 'units_old')
            continue
        end
        
        if strcmp(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units, 'K')
            %         CMIP.(variables{v}).(cmip_names.(variables{v}){m}).([variables{v} '_old']) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v});
            CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units_old = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units;
            CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})-273.15; % Kelvin to C
            CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units = 'degC';
        end
    end
    CMIP.tos.INM_CM4_8_6.tos(CMIP.tos.INM_CM4_8_6.tos==0) = nan;
end
clear v m

v = find(strcmp(variables, 'thetao'));
if isfield(cmip_names, variables{v})
    for m=1:length(cmip_names.(variables{v}))
        if isfield(CMIP.(variables{v}).(cmip_names.(variables{v}){m}), 'units_old')
            continue
        end
        
        if strcmp(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units, 'K')
            %         CMIP.(variables{v}).(cmip_names.(variables{v}){m}).([variables{v} '_old']) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v});
            CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units_old = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units;
            CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})-273.15; % Kelvin to C
            CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units = 'degC';
        end
    end
    %     CMIP.tos.INM_CM4_8_6.tos(CMIP.tos.INM_CM4_8_6.tos==0) = nan;
end
clear v m
% v = find(strcmp(variables, 'psl'));
% for m=1:length(cmip_names.(variables{v}))
%     if isfield(CMIP.(variables{v}).(cmip_names.(variables{v}){m}), 'units_old')
%         continue
%     end
%     %        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).([variables{v} '_old']) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v});
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units_old = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units;
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})./100; % Pa to mbar
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units = 'mbar';
% end

% npp_scale_factor = 1000*12*24*60*60; %
% v = find(strcmp(variables, 'intpp'));
% for m=1:length(cmip_names.(variables{v}))
%     if isfield(CMIP.(variables{v}).(cmip_names.(variables{v}){m}), 'units_old')
%         continue
%     end
%     %        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).([variables{v} '_old']) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v});
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units_old = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units;
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}).*npp_scale_factor; % mol m-2 s-1 to mg C m-2 d-1
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units = 'mgC m-2 d-1';
% end
% clear npp_scale_factor
%
% scale_factor = 1000; %
% v = find(strcmp(variables, 'dissic'));
% for m=1:length(cmip_names.(variables{v}))
%     if isfield(CMIP.(variables{v}).(cmip_names.(variables{v}){m}), 'units_old')
%         continue
%     end
%     %        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).([variables{v} '_old']) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v});
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units_old = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units;
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}).*scale_factor; % mol m-3 to umol l-1
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units = 'umol l-1';
% end
% clear scale_factor

%
% scale_factor = 1000; %
% v = find(strcmp(variables, 'talk'));
% for m=1:length(cmip_names.(variables{v}))
%     if isfield(CMIP.(variables{v}).(cmip_names.(variables{v}){m}), 'units_old')
%         continue
%     end
%     %        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).([variables{v} '_old']) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v});
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units_old = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units;
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}).*scale_factor; % mol m-3 to umol l-1
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units = 'umol l-1';
% end
% clear scale_factor

% scale_factor = 1000; %
% v = find(strcmp(variables, 'dissic_yr'));
% for m=1:length(cmip_names.(variables{v}))
%     if isfield(CMIP.(variables{v}).(cmip_names.(variables{v}){m}), 'units_old')
%         continue
%     end
%     %        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).([variables{v} '_old']) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v});
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units_old = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units;
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}).*scale_factor; % mol m-3 to umol l-1
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units = 'umol l-1';
% end
% clear scale_factor
%
% scale_factor = 1000; %
% v = find(strcmp(variables, 'talk_yr'));
% for m=1:length(cmip_names.(variables{v}))
%     if isfield(CMIP.(variables{v}).(cmip_names.(variables{v}){m}), 'units_old')
%         continue
%     end
%     %        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).([variables{v} '_old']) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v});
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units_old = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units;
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}).*scale_factor; % mol m-3 to umol l-1
%     CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units = 'umol l-1';
% end
% clear scale_factor

% leave fgco2 alone b/c it uses area scaling

v = find(strcmp(variables, 'fgco2'));
if isfield(cmip_names, variables{v})
    s_per_year = 3600*24*365;
    Pg_per_kg = 1e-12;
    scale_factor = -1.*s_per_year.*Pg_per_kg./12.*1000;  % kg m2 s-1 into the ocean to Tg C m-2 mon-1 out of the ocean
    
    scale_factor_molC_m2_yr = -1.*s_per_year.*10^3.*1./12.0107; % kg m2 s-1 into the ocean to mol C m-2 yr-1 out of the ocean
    for m=1:length(cmip_names.(variables{v}))
        if isfield(CMIP.(variables{v}).(cmip_names.(variables{v}){m}), 'units_old')
            continue
        end
        %        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).([variables{v} '_old']) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v});
        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units_old = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units;
        % first save flux in units of mol C m-2 yr-1
        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).([variables{v} '_mol_C_m2_yr']) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}).*scale_factor_molC_m2_yr;  %mol C m-2 yr-1 out of the ocean from kg m-2 s-1into the ocean
        
        % then save in Tg C mon-1
        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}).*scale_factor.*C_input.Neur.y2021.area';  %Tg C mon-1 out of the ocean from kg m-2 s-1into the ocean
        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units = 'Tg C mon-1';
    end
    clear scale_factor Pg_per_kg s_per_year scale_factor_molC_m2_yr
end
% a few manual adjustments:
% CMIP.mlotst.MRI_ESM1.mlotst(CMIP.mlotst.MRI_ESM1.mlotst==0) = nan;
% CMIP.spco2.MRI_ESM1.spco2(CMIP.spco2.MRI_ESM1.spco2==0) = nan;

clear m v mm mod_name mod_name_orig

[lon_grid, lat_grid] = meshgrid(CMIP.spco2.lon, CMIP.spco2.lat);

CMIP.lon_grid = lon_grid';
CMIP.lat_grid = lat_grid';
clear lon_grid lat_grid

%% put model ensemble numbers into a table to save out
clear ensemble_table
ensemble_table = table();
for m = 1:length(cmip_names.fgco2)
    ensemble_table.model_name(m) = cmip_names.fgco2(m);
    
end
for v = 1:length(variables)
    for m = 1:length(cmip_names.fgco2) % use fgco2 as your reference list of models
        
        if ~isfield(CMIP.(variables{v}), cmip_names.fgco2{m})
            continue
        end
        
        try
            ensemble_table.(variables{v}){m} = CMIP.(variables{v}).(cmip_names.fgco2{m}).ensemble_member;
        catch
        end
        
        if isfield(CMIP.(variables{v}).(cmip_names.fgco2{m}), 'ensemble_member_hist')
            ensemble_table.([variables{v} '_hist']){m} = CMIP.(variables{v}).(cmip_names.fgco2{m}).ensemble_member_hist;
        end
    end
end

clear v m
%% Read in SOSE

time_offset = 15;  % for some reason SOSE dates are close to 15 days off

SOSE_its = {'i133' ; 'i122'};
year_range = {'2013to2018' ; '2013to2017'};
var_load = {'BLGCFLX'; 'BLGPCO2'; 'TRAC02'; 'TRAC01'; 'THETA'; 'SALT'; 'THETA'; 'BLGNPP' ; 'BLGMLD' }; % theta is in here twice, once for "TOS", once for "THETAO"

for w = 1% 1:2
    
    mod_name = ['SOSE_' SOSE_its{w}];
    
    if w==1
        SOSE_dir = [data_dir 'Model_Output/SOSE/2013-2018_ITER133_1_6deg/regrid/'];
        
    elseif w==2
        SOSE_dir = [data_dir 'Model_Output/SOSE/2013-2017v2_ITER122_1_6deg/regrid/'];
        
    end
    sose_file = {['bsose_' SOSE_its{w} '_' year_range{w} '_monthly_surfCO2flx.nc']; ['bsose_' SOSE_its{w} '_' year_range{w} '_monthly_pCO2.nc']; ...
        ['bsose_' SOSE_its{w} '_' year_range{w} '_monthly_Alk.nc']; ['bsose_' SOSE_its{w} '_' year_range{w} '_monthly_DIC.nc'];...
        ['bsose_' SOSE_its{w} '_' year_range{w} '_monthly_Theta.nc'] ;['bsose_' SOSE_its{w} '_' year_range{w} '_monthly_Salt.nc' ];...
        ['bsose_' SOSE_its{w} '_' year_range{w} '_monthly_Theta.nc'] ;...
        ['bsose_' SOSE_its{w} '_' year_range{w} '_monthly_NPP.nc'] ;...
        ['bsose_' SOSE_its{w} '_' year_range{w} '_30day_MLD.nc']};
    
    sose_vars =  [9 1 8 7 5 6 13 2 4];
    % CO2 flux:
    for sv = 1:length(sose_vars)
        
        v = sose_vars(sv);
        
        time_temp = ncread([SOSE_dir sose_file{sv}], 'time');
        temp_Matlab_time = time_temp - time_offset;
        
        CMIP.(variables{v}).(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time time_temp
        CMIP.(variables{v}).(mod_name).(variables{v}) = squeeze(ncread([SOSE_dir sose_file{sv}], var_load{sv}));
        CMIP.(variables{v}).(mod_name).units = ncreadatt([SOSE_dir sose_file{sv}], var_load{sv}, 'units');
        CMIP.(variables{v}).(mod_name).long_name = ncreadatt([SOSE_dir sose_file{sv}], var_load{sv}, 'long_name');
        
        if numel(size(CMIP.(variables{v}).(mod_name).(variables{v})))==4 && (v==8 || v==7 || v==5 || v==6)
            temp_var = CMIP.(variables{v}).(mod_name).(variables{v}) ;
            surface_var = squeeze(temp_var(:,:,1,:));
            CMIP.(variables{v}).(mod_name).(variables{v}) = surface_var; % sets the monthly resolved surface variable to match CMIP models
            
            if (v==8 || v==7)
                % calculate annual averages from temp_var:
                mod_vec = datevec(CMIP.(variables{v}).(mod_name).GMT_Matlab);
                
                temp_yr_mean = NaN(length(CMIP.(variables{v}).lon), length(CMIP.(variables{v}).lat), size(temp_var,3), numel(unique(mod_vec(:,1))));
                
                ind = 0;
                for yr = min(mod_vec(:,1)):max(mod_vec(:,1))
                    ind = ind+1;
                    yr_index = mod_vec(:,1)==yr;
                    temp_yr_mean(:,:,:,ind) = nanmean((temp_var(:,:,:,yr_index)),4);
                    
                end
                
                CMIP.([variables{v} '_yr']).(mod_name).GMT_Matlab = datenum(unique(mod_vec(:,1)), 7,1);
                CMIP.([variables{v} '_yr']).(mod_name).([variables{v} '_yr']) = temp_yr_mean;
                CMIP.([variables{v} '_yr']).(mod_name).units = CMIP.(variables{v}).(mod_name).units;
                CMIP.([variables{v} '_yr']).(mod_name).long_name = CMIP.(variables{v}).(mod_name).long_name;
                CMIP.([variables{v} '_yr']).(mod_name).depth = ncread([SOSE_dir sose_file{sv}], 'Z').*-1;
                
                
                if sum(strcmp(cmip_names.([variables{v} '_yr']), mod_name))==0
                    cmip_names.([variables{v} '_yr']){end+1} = mod_name;
                end
            end
            
            clear temp_var surface_var temp_yr_mean mod_vec ind yr mod_vec yr_index
            
        end
        
        % for thetao
        if v==13
            % first take the mean in time
            temp_var = nanmean(CMIP.(variables{v}).(mod_name).(variables{v}),4);
            % then select the 400m depth
            CMIP.([variables{v}]).(mod_name).depth = ncread([SOSE_dir sose_file{sv}], 'Z').*-1;
            target_depth = 400;
            depth_index = min(abs(CMIP.([variables{v}]).(mod_name).depth - target_depth)) == abs(CMIP.([variables{v}]).(mod_name).depth - target_depth);
            
            % create a new temporary variable that is 360 x 180 x 13;
            % fill the new depth # 13 with bSOSE theta at 400 m
            
            temp_var_matched_depths = NaN(360, 180, 13);
            temp_var_matched_depths(:,:,13) = temp_var(:,:, depth_index);
            
            % put the new array back into the thetao spot
            CMIP.(variables{v}).(mod_name).(variables{v}) = temp_var_matched_depths;
            
            % and save the new depth scale as well:
            CMIP.([variables{v}]).(mod_name).depth = CMIP.([variables{v}]).(cmip_names.(variables{v}){1}).depth;
            
            % overwrite the time with a mean time value
            CMIP.([variables{v}]).(mod_name).GMT_Matlab = nanmean(CMIP.([variables{v}]).(mod_name).GMT_Matlab);
            clear target_depth temp_var temp_var_matched_depths depth_index
        end
        
        % for NPP, calculate the vertical integral to match CMIP models
        if v==2
            temp_var = CMIP.(variables{v}).(mod_name).(variables{v}) ;
            
            CMIP.([variables{v}]).(mod_name).depth = ncread([SOSE_dir sose_file{sv}], 'Z').*-1;
            
            % create a new array to store your individual column averaged
            % months:
            col_intg_mol_C_m2_s = NaN(360,180, size(temp_var,4));
            
            % for each time step
            for tt = 1:size(temp_var,4)
                
                % for each depth,
                % create a NaN array for that day:
                month_temp = zeros(360, 180);
                for dd = 1:length(CMIP.([variables{v}]).(mod_name).depth)
                    single_depth = temp_var(:,:,dd,tt);
                    
                    if dd==1
                        d_z = CMIP.([variables{v}]).(mod_name).depth(dd) - 0;
                    else
                        d_z = CMIP.([variables{v}]).(mod_name).depth(dd) - CMIP.([variables{v}]).(mod_name).depth(dd-1);
                    end
                    npp_mol_m2_s = single_depth.*d_z;
                    month_temp = nansum(cat(3, month_temp, npp_mol_m2_s),3); % in mol C m-2 s-1
                    clear single_depth npp_mol_m2_s d_z
                end
                month_temp(month_temp==0) = nan;
                % save month into new array
                col_intg_mol_C_m2_s(:,:,tt) = month_temp;
                
                clear month_temp
            end
            
            s_per_day = 60*60*24;
            gC_per_mol = 12.0107;
            mg_per_g = 1e3;
            
            
            CMIP.(variables{v}).(mod_name).units_old = CMIP.(variables{v}).(mod_name).units;
            
            % save column integral back into CMIP structure
            CMIP.(variables{v}).(mod_name).(variables{v}) = col_intg_mol_C_m2_s.*s_per_day.*gC_per_mol.*mg_per_g;
            CMIP.(variables{v}).(mod_name).units = 'mg C m-2 d-1';
            
            clear s_per_day gC_per_mol mg_per_g tt dd temp_var col_intg_mol_C_m2_s
        end
        
        if v==9
            s_per_year = 3600*24*365;
            Tg_per_g = 1e-12;
            scale_factor = -1.*s_per_year.*12.0107.*C_input.Neur.y2021.area'./12.*Tg_per_g;
            CMIP.(variables{v}).(mod_name).([variables{v} '_mol_C_m2_yr']) = CMIP.(variables{v}).(mod_name).(variables{v}).*s_per_year.*-1; % saves original flux density as mol C m-2 yr-1 from mol C m-2 s-1
            
            CMIP.(variables{v}).(mod_name).(variables{v}) = CMIP.(variables{v}).(mod_name).(variables{v}).*scale_factor;
            CMIP.(variables{v}).(mod_name).units_old = CMIP.(variables{v}).(mod_name).units;
            CMIP.(variables{v}).(mod_name).units = 'Tg C mon-1';
            clear scale_factor s_per_year Tg_per_g
            
        end
        
        if v==1
            scale_factor = 10^6;  % atm to uatm
            CMIP.(variables{v}).(mod_name).(variables{v}) = CMIP.(variables{v}).(mod_name).(variables{v}).*scale_factor;
            CMIP.(variables{v}).(mod_name).units_old = CMIP.(variables{v}).(mod_name).units;
            CMIP.(variables{v}).(mod_name).units = 'uatm';
            clear scale_factor
            
        end
        
        if v==8 || v==7
            scale_factor = 10^3;  % mol / m-3 to umol/l
            CMIP.(variables{v}).(mod_name).(variables{v}) = CMIP.(variables{v}).(mod_name).(variables{v}).*scale_factor;
            CMIP.(variables{v}).(mod_name).units_old = CMIP.(variables{v}).(mod_name).units;
            CMIP.(variables{v}).(mod_name).units = 'umol -l';
            
            CMIP.([variables{v} '_yr']).(mod_name).([variables{v} '_yr']) = CMIP.([variables{v} '_yr']).(mod_name).([variables{v} '_yr']).*scale_factor;
            CMIP.([variables{v} '_yr']).(mod_name).units_old = CMIP.([variables{v} '_yr']).(mod_name).units;
            CMIP.([variables{v} '_yr']).(mod_name).units = 'umol -l';
            clear scale_factor
            
        end
        
        if sum(strcmp(cmip_names.(variables{v}), mod_name))==0
            cmip_names.(variables{v}){end+1} = mod_name;
        end
        
    end
    clear mod_name sv
end
clear w v
clear SOSE_dir sose_file SOSE_its sose_vars year_range var_load time_offset
%% Model Solubility

variables = [variables ; 'CO2_sol'];
var_type = [var_type ; 'Omon'];
var_lims(end+1,:) = [3e4 7e4];
% - adding Solubility to list of CMIP names
cmip_names.CO2_sol = {};

CMIP.CO2_sol.lat = CMIP.tos.lat;
CMIP.CO2_sol.lon = CMIP.tos.lon;

for m = 1:length(cmip_names.tos)
    disp(cmip_names.tos{m})
    
    sos_index = strmatch(cmip_names.tos{m}, cmip_names.sos, 'exact');
    
    if isempty(sos_index)
        continue
    end
    CMIP.CO2_sol.(cmip_names.tos{m}).GMT_Matlab = CMIP.tos.(cmip_names.tos{m}).GMT_Matlab;
    CMIP.CO2_sol.(cmip_names.tos{m}).CO2_sol = CO2_Sol(CMIP.tos.(cmip_names.tos{m}).tos, CMIP.sos.(cmip_names.sos{sos_index}).sos);
    CMIP.CO2_sol.(cmip_names.tos{m}).units = 'mmol m-3 atm-1';
    clear sos_index
    
    cmip_names.CO2_sol = [cmip_names.CO2_sol; cmip_names.tos{m}];
end

clear m v q

%% Calculation of monthly means and std using a mask based on potential temperature

% note that this expects a 2D variable will be run first to create a mask
% south of the SAF if one does not already exist
for v=[1:12 14] % skip thetao as it is only used for the mask
    if ~isfield(cmip_names, variables{v})
        continue
    end
    disp(['Starting ' variables{v}])
    
    lat_grid = repmat(CMIP.(variables{v}).lat', 360, 1);
    
    %     lat_index = CMIP.thetao.lat<=lat_lims(2) & CMIP.(variables{v}).lat>=lat_lims(1);
    
    if ~strcmp(var_type{v}, 'Oyr')
        
        if strcmp(var_type{v}, 'Omon') || strcmp(var_type{v}, 'Amon') % is there a seasonal cycle?
            
            if isfield(CMIP.(variables{v}).(cmip_names.(variables{v}){1}), 'depth')  % check first model for this variable to see if there is a depth variable
                
                num_depths = length(CMIP.(variables{v}).(cmip_names.(variables{v}){1}).depth);
                
                CMIP.(variables{v}).out_seasonal = NaN(length(cmip_names.(variables{v})),num_depths,12,2); % 4D out_seasonal variable if needed (num models, num depths, 12 months, mean and std)
                var4D = 1;
            else
                CMIP.(variables{v}).out_seasonal = NaN(length(cmip_names.(variables{v})),12,2); % 3D out_seasonal (num models, 12 months, mean and std)
                var4D = 0;
                num_depths = 1;
            end
        end % need to add an option for the annual variables
        
        for m = 1:length(cmip_names.(variables{v}))
            if ~isfield(CMIP.thetao,cmip_names.(variables{v}){m})
                continue
            end
            
            % only create a new mask if there isn't one already made
            if ~isfield(CMIP.thetao.(cmip_names.(variables{v}){m}), 'SAF_S_mask')
                SAF_S_mask = CMIP.thetao.(cmip_names.(variables{v}){m}).thetao(:,:,13)<=5 & lat_grid<-30  & lat_grid>poleward_lat_lim;
                CMIP.thetao.(cmip_names.(variables{v}){m}).SAF_S_mask = SAF_S_mask;
                clear SAF_S_mask
                
                 % Calculate a SAF based on the SAF mask (i.e. the northern-most lat included in the mask)
                % could probably use this to fill in SAF masks
                    
                    CMIP.thetao.(cmip_names.(variables{v}){m}).SAF = NaN(length(CMIP.thetao.lon),1);
                    for lon = 1:length(CMIP.thetao.lon)
                        temp_lat_vec = CMIP.thetao.lat(CMIP.thetao.(cmip_names.(variables{v}){m}).SAF_S_mask(lon,:));
                        if ~isempty(temp_lat_vec)
                            CMIP.thetao.(cmip_names.(variables{v}){m}).SAF(lon) = max(temp_lat_vec);
                        end
                    end
                    clear lon
                    % remove nans from SAF
                    old_SAF = CMIP.thetao.(cmip_names.(variables{v}){m}).SAF;
                    old_SAF_w_lon = [CMIP.thetao.lon old_SAF];
                    old_SAF_w_lon = old_SAF_w_lon(~isnan(old_SAF_w_lon(:,2)),:);
                    new_SAF = interp1(old_SAF_w_lon(:,1), old_SAF_w_lon(:,2), CMIP.thetao.lon);
                    CMIP.thetao.(cmip_names.(variables{v}){m}).SAF = new_SAF;
                    
                    clear old_SAF old_SAF_w_lon new_SAF
                    
                    % find points in SAF mask that are South of SAF and
                    % north of poleward_lat_lim and fill in
                    new_SAF_mask = false(size(CMIP.lat_grid));
                    for lon = 1:length(CMIP.thetao.lon)
                        lat_index = CMIP.thetao.lat<=CMIP.thetao.(cmip_names.(variables{v}){m}).SAF(lon) & ...
                            CMIP.thetao.lat>poleward_lat_lim;
                        new_SAF_mask(lon,:) = lat_index;
                    end
                    CMIP.thetao.(cmip_names.(variables{v}){m}).SAF_S_mask = new_SAF_mask;
                    
                    clear new_SAF_mask lon 
            end
            
            % load the SAF_S_mask
            SAF_S_mask = CMIP.thetao.(cmip_names.(variables{v}){m}).SAF_S_mask;
            
            for dd = 1:num_depths
                
                for mon = 1:12
                    mod_vec = datevec(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).GMT_Matlab); % create a date vector to use for filter
                    time_index = mod_vec(:,2)==mon; % find all months equal to mon
                    
                    if var4D==0
                        SO_var = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, :, time_index); % save correct months to SO_var
                        
                        if strcmp(variables{v}, 'fgco2')
                            
                            SO_var_mol_C_m2_yr = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).([variables{v} '_mol_C_m2_yr'])(:, :, time_index); % save correct months to SO_var
                        end
                    elseif var4D==1
                        SO_var = squeeze(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, :, dd, time_index)); % save correct months to SO_var
                    end
                    
                    if strcmp(variables{v}, 'fgco2')
                        % collapse all years into one mean map for each month
                        SO_fgco2_mean = nanmean(SO_var,3);
                        
                        % mask out nan values north of the SAF in each
                        % model
                        SO_fgco2_mean(~SAF_S_mask)=nan;
                        
                        % sum all grid cells to convert to total flux in the area
                        CMIP.(variables{v}).out_seasonal(m,mon,1) = nansum(reshape(SO_fgco2_mean,[],1)); % sum, not mean
                        
                        clear SO_fgco2_mean
                        
                        % calculate seasonal cycle from C flux density as
                        % well
                        SO_var_mean = nanmean(SO_var_mol_C_m2_yr,3); % average along the time dimension
                        % mask out nan values north of the SAF in each
                        % model
                        SO_var_mean(~SAF_S_mask)=nan;
                        
                        % get the area for each grid cell and mask the
                        % same as SO_var
                        temp_area = C_input.Neur.y2021.area';
                        temp_area(isnan(SO_var_mean)) = nan;
                        % creating an area weighting:
                        grid_weights = temp_area./nansum(reshape(temp_area,[],1));
                        
                        CMIP.(variables{v}).out_seasonal_mol_C_m2_yr(m,mon,1) = nansum(reshape(SO_var_mean.*grid_weights,[],1));
                        CMIP.(variables{v}).out_seasonal_mol_C_m2_yr(m,mon,2) = nanstd(reshape(SO_var_mean,[],1));
                        
                        clear SO_var_mol_C_m2_yr
                    else
                        if var4D ==0
                            SO_var_mean = nanmean(SO_var,3); % average along the time dimension
                            % mask out nan values north of the SAF in each
                            % model
                            SO_var_mean(~SAF_S_mask)=nan;
                            
                            % get the area for each grid cell and mask the
                            % same as SO_var
                            temp_area = C_input.Neur.y2021.area';
                            temp_area(isnan(SO_var_mean)) = nan;
                            % creating an area weighting:
                            grid_weights = temp_area./nansum(reshape(temp_area,[],1));
                            
                            CMIP.(variables{v}).out_seasonal(m,mon,1) = nansum(reshape(SO_var_mean.*grid_weights,[],1));  % nanmean(reshape(SO_var_mean,[],1));
                            CMIP.(variables{v}).out_seasonal(m,mon,2) = nanstd(reshape(SO_var_mean,[],1));
                        elseif var4D==1
                            SO_var_mean = nanmean(SO_var,3);
                            % mask out nan values north of the SAF in each
                            % model
                            SO_var_mean(~SAF_S_mask)=nan;
                            
                            % get the area for each grid cell and mask the
                            % same as SO_var
                            temp_area = C_input.Neur.y2021.area';
                            temp_area(isnan(SO_var_mean)) = nan;
                            % creating an area weighting:
                            grid_weights = temp_area./nansum(reshape(temp_area,[],1));
                            
                            % calculate the weighted mean, std is not
                            % weighted for now..
                            CMIP.(variables{v}).out_seasonal(m,dd,mon,1) = nansum(reshape(SO_var_mean.*grid_weights,[],1));  % nanmean(reshape(SO_var_mean,[],1));
                            CMIP.(variables{v}).out_seasonal(m,dd,mon,2) = nanstd(reshape(SO_var_mean,[],1));
                        end
                    end
                    clear time_index SO_var mod_vec SO_var_mean
                end % end months loop
            end % end depth loop
            clear SAF_S_mask
        end
        clear m mon num_depths var4D
    else
        
        num_depths = length(CMIP.(variables{v}).(cmip_names.(variables{v}){1}).depth);
        
        CMIP.(variables{v}).out_annual = NaN(length(cmip_names.(variables{v})),num_depths,2);
        
        for m = 1:length(cmip_names.(variables{v}))
            
            if ~isfield(CMIP.thetao,cmip_names.(variables{v}){m})
                continue
            end
            
            % only create a new mask if there isn't one already made
            if ~isfield(CMIP.thetao.(cmip_names.(variables{v}){m}), 'SAF_S_mask')
                SAF_S_mask = CMIP.thetao.(cmip_names.(variables{v}){m}).thetao(:,:,13)<=5 & lat_grid<-30  & lat_grid>poleward_lat_lim;
                CMIP.thetao.(cmip_names.(variables{v}){m}).SAF_S_mask = SAF_S_mask;
                clear SAF_S_mask
                
                 % Calculate a SAF based on the SAF mask (i.e. the northern-most lat included in the mask)
                % could probably use this to fill in SAF masks
                    
                    CMIP.thetao.(cmip_names.(variables{v}){m}).SAF = NaN(length(CMIP.thetao.lon),1);
                    for lon = 1:length(CMIP.thetao.lon)
                        temp_lat_vec = CMIP.thetao.lat(CMIP.thetao.(cmip_names.(variables{v}){m}).SAF_S_mask(lon,:));
                        if ~isempty(temp_lat_vec)
                            CMIP.thetao.(cmip_names.(variables{v}){m}).SAF(lon) = max(temp_lat_vec);
                        end
                    end
                    clear lon
                    % remove nans from SAF
                    old_SAF = CMIP.thetao.(cmip_names.(variables{v}){m}).SAF;
                    old_SAF_w_lon = [CMIP.thetao.lon old_SAF];
                    old_SAF_w_lon = old_SAF_w_lon(~isnan(old_SAF_w_lon(:,2)),:);
                    new_SAF = interp1(old_SAF_w_lon(:,1), old_SAF_w_lon(:,2), CMIP.thetao.lon);
                    CMIP.thetao.(cmip_names.(variables{v}){m}).SAF = new_SAF;
                    
                    clear old_SAF old_SAF_w_lon new_SAF
                    
                    % find points in SAF mask that are South of SAF and
                    % north of poleward_lat_lim and fill in
                    new_SAF_mask = false(size(CMIP.lat_grid));
                    for lon = 1:length(CMIP.thetao.lon)
                        lat_index = CMIP.thetao.lat<=CMIP.thetao.(cmip_names.(variables{v}){m}).SAF(lon) & ...
                            CMIP.thetao.lat>poleward_lat_lim;
                        new_SAF_mask(lon,:) = lat_index;
                    end
                    CMIP.thetao.(cmip_names.(variables{v}){m}).SAF_S_mask = new_SAF_mask;
                    
                    clear new_SAF_mask lon 
            end
            
            % load the SAF_S_mask
            SAF_S_mask = CMIP.thetao.(cmip_names.(variables{v}){m}).SAF_S_mask;
            
            for dd = 1:num_depths
                % mean value at different depths
                
                single_depth = squeeze(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:,:,dd,:));
                single_year = nanmean(single_depth,3); % take the mean along the year dimension
                
                % mask out nan values north of the SAF in each
                % model
                single_year(~SAF_S_mask)=nan;
                
                % get the area for each grid cell and mask the
                % same as SO_var
                temp_area = C_input.Neur.y2021.area';
                temp_area(isnan(single_year)) = nan;
                % creating an area weighting:
                grid_weights = temp_area./nansum(reshape(temp_area,[],1));
                
                CMIP.(variables{v}).out_annual(m, dd, 1) =  nansum(reshape(single_year.*grid_weights,[],1));  % nanmean(reshape(single_year,[],1));
                CMIP.(variables{v}).out_annual(m, dd, 2) = nanstd(reshape(single_year,[],1));
                
                %                 CMIP.(variables{v}).out_annual(m, dd, 1) = nanmean(reshape(squeeze(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, lat_index, dd, :)),[],1));
                %                 CMIP.(variables{v}).out_annual(m, dd, 2) = nanstd(reshape(squeeze(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, lat_index, dd, :)),[],1));
                
                clear temp_area grid_weights single_depth single_year
            end
        end
        clear m num_depths
    end
    clear lat_index
end
clear v dd m


%% plot vars w the SAF mask

Plot_out_dir = [home_dir 'Work/Projects/2019_05 SO_C_flux_model_comparison/Plots/'];
% v = 5;
for v=9%[1 2 4 5 6 7 8]%9%13:length(variables)
    if ~isfield(cmip_names, variables{v})
        continue
    end
    [lon_grid, lat_grid] = meshgrid(CMIP.(variables{v}).lon, CMIP.(variables{v}).lat);
    
    CMIP.lon_grid = lon_grid';
    CMIP.lat_grid = lat_grid';
    clear lon_grid lat_grid
    for m = 1%%length(cmip_names.(variables{v}))
        
        if isfield(CMIP.(variables{v}).(cmip_names.(variables{v}){m}), 'depth')
            num_depths = length(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).depth);
        else
            num_depths =1;
        end
        
        for dd = [1 num_depths]
            
            clf
            set(gcf, 'units', 'inches')
            paper_w = 16; paper_h =9;
            set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
            colormap(parula(70))
            %             set(gcf, 'colormap', var_cmaps.(variables{v}));
            
            %         SO_var = nanmean(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}),3);
            
            if num_depths==1
                SO_var = mean(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, :, :),3, 'omitnan');
            else
                SO_var = mean(squeeze(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, :, dd, :)),3, 'omitnan');
            end
            
            subplot(2,1,1)
            pcolor(CMIP.lon_grid, CMIP.lat_grid, SO_var); shading flat
            xlabel('Longitude')
            ylabel('Latitude')
            c1 = colorbar;
            ylabel(c1, [variables{v} ' (' CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units ')'], 'interpreter', 'none')
            
            if num_depths==1
                title([cmip_names.(variables{v}){m} ' ' variables{v}], 'interpreter', 'none')
            else
                title([cmip_names.(variables{v}){m} ' ' variables{v} ' depth: ' num2str(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).depth(dd))], 'interpreter', 'none')
            end
            set(gca, 'ylim', [-85 -35])
            set(gca, 'fontsize', 20)
            caxis(var_lims(v,:))
            hold on
            plot([1 360], [poleward_lat_lim poleward_lat_lim], 'm-', 'linewidth', 2)
            
            try
                plot(1:360, CMIP.thetao.(cmip_names.(variables{v}){m}).SAF, 'm-', 'linewidth', 2)
                
                subplot(2,1,2)
                
                
                SO_var(~CMIP.thetao.(cmip_names.(variables{v}){m}).SAF_S_mask)=nan;
                pcolor(CMIP.lon_grid, CMIP.lat_grid, SO_var); shading flat
                hold on
                plot(1:360, CMIP.thetao.(cmip_names.(variables{v}){m}).SAF, 'm-', 'linewidth', 2)
                plot([1 360], [poleward_lat_lim poleward_lat_lim], 'm-', 'linewidth', 2)
                
                
                xlabel('Longitude')
                ylabel('Latitude')
                c1 = colorbar;
                ylabel(c1, [variables{v} ' (' CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units ')'], 'interpreter', 'none')
                
                if num_depths==1
                    title([cmip_names.(variables{v}){m} ' ' variables{v}], 'interpreter', 'none')
                else
                    title([cmip_names.(variables{v}){m} ' ' variables{v} ' depth: ' num2str(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).depth(dd))], 'interpreter', 'none')
                end
                set(gca, 'ylim', [-85 -35])
                set(gca, 'fontsize', 20)
                caxis(var_lims(v,:))
                
            catch
            end
            if num_depths==1
                plot_filename = [variables{v} '_Surface_' cmip_names.(variables{v}){m}];
                
            else
                plot_filename = [variables{v} '_' cmip_names.(variables{v}){m} '_' num2str(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).depth(dd)) 'm' ];
            end
            saveas(gcf, [Plot_out_dir variables{v} '/surface/' plot_filename plot_ver], 'png')
            
            clear SO_var SO_mean_var plot_filename SO_SSS time_index mod_vec
        end
    end
end

clear v
%% Read in monthly SST
clear NOAA_SST

SST_dir = [data_dir 'Data_Products/SST/NOAA_OI_SST_V2/'];
SST_file = 'sst.mnmean.nc';

sst_time = ncread([SST_dir SST_file], 'time');
NOAA_SST.Matlab_time_orig = sst_time + datenum('jan-15-1800');
NOAA_SST.SST_orig = ncread([SST_dir SST_file], 'sst');
NOAA_SST.sst_lat = ncread([SST_dir SST_file], 'lat');
NOAA_SST.sst_lon = ncread([SST_dir SST_file], 'lon');

date_select = NOAA_SST.Matlab_time_orig>datenum('jan-0-2010') & NOAA_SST.Matlab_time_orig<datenum('jan-0-2020');

NOAA_SST.Matlab_time = NOAA_SST.Matlab_time_orig(date_select);
NOAA_SST.SST = NOAA_SST.SST_orig(:,:,date_select);

NOAA_SST.SST_flipped = NaN(360, 180, 120);
NOAA_SST.SST_land_mask = NaN(360, 180, 120);
load topo


% for mon = 1:12
for dd = 1:length(NOAA_SST.Matlab_time)
    %     date_index = sst_vec(:,2)==mon;
    
    temp_sst = NOAA_SST.SST(:,:, dd);
    
    %     temp_mean = nanmean(temp_sst,3);
    % this should create an SST map that matches the lat/lon of the model output
    temp_mean_flipped = fliplr(temp_sst);
    NOAA_SST.SST_flipped(:,:,dd) = temp_mean_flipped;
    temp_mean_flipped(topo'>-1000) = nan;
    NOAA_SST.SST_land_mask(:,:,dd) = temp_mean_flipped;
    clear temp_sst temp_mean date_index temp_mean_flipped
end

clear sst_time date_select sst_vec SST_file SST_dir dd

NOAA_SST.SST_orig = [];
NOAA_SST.SST = [];
% [NOAA_SST.lon_grid, NOAA_SST.lat_grid] = meshgrid(NOAA_SST.sst_lon,
% NOAA_SST.sst_lat); % this lon/lat grid does not match the "flipped" sst


Lat_grid = -89.5:1:89.5;
Lon_grid = -179.5:1:179.5;
[NOAA_SST.X_lon_grid, NOAA_SST.Y_lat_grid] = meshgrid(Lon_grid, Lat_grid);
NOAA_SST.X_lon_grid = NOAA_SST.X_lon_grid';
NOAA_SST.Y_lat_grid = NOAA_SST.Y_lat_grid';

clear Lat_grid Lon_grid

% NOAA SST seasonal cycle

% create a real world mask for 0-360 longitude


NOAA_SST.SAF_mask = NaN(360,180);
NOAA_SST.SAF_mask_temp = C_input.Neur.y2021.index.pfz | C_input.Neur.y2021.index.asz | C_input.Neur.y2021.index.siz;
NOAA_SST.SAF_mask_temp = NOAA_SST.SAF_mask_temp';
NOAA_SST.SAF_mask(1:180,:) = NOAA_SST.SAF_mask_temp(181:end,:);
NOAA_SST.SAF_mask(181:end,:) = NOAA_SST.SAF_mask_temp(1:180,:);
NOAA_SST.SAF_mask = NOAA_SST.SAF_mask==1 & NOAA_SST.Y_lat_grid>poleward_lat_lim;

NOAA_SST.SAF_mask_temp = [];

%
obs.tos.out_seasonal = NaN(12,2);

% mod_vec = datevec(NOAA_SST.Matlab_time);
%
% lat_index = NOAA_SST.sst_lat<=lat_lims(2) & NOAA_SST.sst_lat>=lat_lims(1);
NOAA_SST.SST_land_mask_mean = NaN(360, 180, 12);

sst_vec = datevec(NOAA_SST.Matlab_time);

for mon = 1:12
    time_index = sst_vec(:,2)==mon;
    
    
    %     select correct months
    %     SO_var = NOAA_SST.SST(:, lat_index, time_index);
    SO_var = NOAA_SST.SST_land_mask(:,:,time_index);
    
    % save out 10-yr climatology for the purpose of CO2 SOL calc later
    NOAA_SST.SST_land_mask_mean(:,:,mon) = nanmean(SO_var, 3);
    
    % for each year, mask out the non SAF_S region and weight based on the
    % area
    for zz = 1:size(SO_var,3)
        TT = SO_var(:,:,zz);
        TT(~NOAA_SST.SAF_mask) = nan;
        temp_area = C_input.Neur.y2021.area';
        temp_area(isnan(TT)) = nan;
        
        % creating an area weighting:
        grid_weights = temp_area./nansum(reshape(temp_area,[],1));
        
        
        SO_var(:,:,zz) = TT.*grid_weights; % weight each value - now to get the annual mean you will sum these together
        clear TT
    end
    clear zz
    
    % sum each year into a single month, then take the mean and std:
    zonal_sum = nansum(SO_var,1);
    box_sum = squeeze(nansum(zonal_sum,2));
    obs.tos.out_seasonal(mon,1) = nanmean(box_sum);
    obs.tos.out_seasonal(mon,2) = nanstd(box_sum);
    %     SO_var(~NOAA_SST.SAF_mask)=nan;
    %
    %
    %     % get the area for each grid cell and mask the
    %     % same as SO_var
    %     temp_area = C_input.Neur.y2020.area';
    %     temp_area(isnan(SO_var)) = nan;
    %     % creating an area weighting:
    %     grid_weights = temp_area./nansum(reshape(temp_area,[],1));
    %
    
    % sum the product of grid_weights and SO_var to get the area weighted
    % mean
    %     obs.tos.out_seasonal(mon,1) = nansum(reshape(SO_var.*grid_weights,[],1));
    %     obs.tos.out_seasonal(mon,2) = nanstd(reshape(SO_var,[],1));
    
    clear time_index SO_var temp_area grid_weights zonal_sum
end

clear mod_vec lat_index mon
%
% Read in climatological SSS from WOA
clear WOA_SSS

SSS_dir = [data_dir 'Data_Products/SSS/WOA_2018/'];
WOA_SSS.lat = ncread([SSS_dir 'woa18_A5B7_s01_01.nc'], 'lat');
WOA_SSS.lon_orig = ncread([SSS_dir 'woa18_A5B7_s01_01.nc'], 'lon');
WOA_SSS.lon = NaN(360,1);
WOA_SSS.lon(1:180,1) = WOA_SSS.lon_orig(181:end);
WOA_SSS.lon(181:end,1) = WOA_SSS.lon_orig(1:180);
WOA_SSS.Month = NaN(12,1);
WOA_SSS.SSS = NaN(length(WOA_SSS.lon), length(WOA_SSS.lat), 12);
WOA_SSS.SSS_long_name = ncreadatt([SSS_dir 'woa18_A5B7_s01_01.nc'], 's_an', 'long_name');

for mon = 1:12
    WOA_SSS.Month(mon) = mon;
    
    month_text = num2str(mon);
    if length(month_text)<2
        month_text = ['0' month_text];
    end
    sal_temp = ncread([SSS_dir 'woa18_A5B7_s' month_text '_01.nc'], 's_an');
    
    WOA_SSS.SSS(1:180,:,mon) = sal_temp(181:end,:,1);
    WOA_SSS.SSS(181:end,:,mon) = sal_temp(1:180,:,1);
    
    clear sal_temp month_text
end

clear mon SSS_dir
% [WOA_SSS.lon_grid, WOA_SSS.lat_grid] = meshgrid(WOA_SSS.lon, WOA_SSS.lat);
% WOA SSS seasonal cycle

obs.sos.out_seasonal = NaN(12,2);

% lat_index = WOA_SSS.lat<=lat_lims(2) & WOA_SSS.lat>=lat_lims(1);

for mon = 1:12
    
    SO_var = WOA_SSS.SSS(:, :, mon);
    SO_var(~NOAA_SST.SAF_mask)=nan;
    
    % get the area for each grid cell and mask the
    % same as SO_var
    temp_area = C_input.Neur.y2021.area';
    temp_area(isnan(SO_var)) = nan;
    % creating an area weighting:
    grid_weights = temp_area./nansum(reshape(temp_area,[],1));
    
    % sum the product of grid_weights and SO_var to get the area weighted
    % mean
    obs.sos.out_seasonal(mon,1) =  nansum(reshape(SO_var.*grid_weights,[],1));
    obs.sos.out_seasonal(mon,2) = nanstd(reshape(SO_var,[],1));
    
    clear time_index SO_var temp_area grid_weights
end

clear lat_index mon
%
CO2_sol_obs = CO2_Sol(NOAA_SST.SST_land_mask_mean, WOA_SSS.SSS);
% CO2 sol seasonal cycle

obs.CO2_sol.out_seasonal = NaN(12,2);

% lat_index = WOA_SSS.lat<=lat_lims(2) & WOA_SSS.lat>=lat_lims(1);

for mon = 1:12
    
    SO_var = CO2_sol_obs(:, :, mon);
    SO_var(~NOAA_SST.SAF_mask)=nan;
    
    temp_area = C_input.Neur.y2021.area';
    temp_area(isnan(SO_var)) = nan;
    % creating an area weighting:
    grid_weights = temp_area./nansum(reshape(temp_area,[],1));
    
    
    % sum the product of grid_weights and SO_var to get the area weighted
    % mean
    obs.CO2_sol.out_seasonal(mon,1) = nansum(reshape(SO_var.*grid_weights,[],1));
    obs.CO2_sol.out_seasonal(mon,2) = nanstd(reshape(SO_var,[],1));
    
    clear time_index SO_var temp_area grid_weights
end

clear mon
clear topolatlim topolegend topolonlim topomap1 topomap2 v m lon lon_grid lat_grid
%% Can reload gridded datasets, reload here instead of re-running the next several cells
% currently saved in manuscript folder
% load([home_dir 'Work/Manuscripts/2019_06 SO CMIP Comparison/data/gdap_and_argo_gridded_2022_Apr_04.mat'])
load([home_dir 'Work/Manuscripts/2019_06 SO CMIP Comparison/data/gdap_and_argo_gridded_2022_Apr_22.mat'])
depth_levs = CMIP.dissic_yr.(cmip_names.dissic_yr{1}).depth;

%% Load SOCCOM
% 2021_08_01 changing lat lims and updaring to 2021 dataset
% no averaging is occuring in the creation of argo_SO and gdap_SO, so I
% think I should change lat_lims filter to -90 to -30, then grate a 1x1 monthly gridded dataset
% next and create area-weighted averages from this dataset
lat_lims_SO = [-90 -30];
% SOCCOM_float_directory = [data_dir 'ARGO_O2_Floats/Global/SOCCOM/2020_04_20_Snapshot_LoRes_LIAR/'];
SOCCOM_float_directory = [data_dir 'ARGO_O2_Floats/Global/SOCCOM/2021_05_05_Snapshot_LoRes_LIAR/'];

% SOCCOM_filename = 'SO_calc_03-Oct-2019_w_calc_param_co2.mat';
% SOCCOM_filename = 'SO_calc_14-May-2020_w_calc_param_pco2.mat';
SOCCOM_filename = 'SO_calc_30-Jul-2021_w_calc_param_pco2.mat';

load([SOCCOM_float_directory SOCCOM_filename])

for f = 1:length(SO_SNs)
    Argo.(SO_SNs{f}).in_situ_dens = sw_dens(Argo.(SO_SNs{f}).Sal, Argo.(SO_SNs{f}).Temp_C, Argo.(SO_SNs{f}).Press_db);
    
end
clear f
%
clear argo_SO
argo_fields = {'GMT_Matlab'; 'Lat'; 'Lon'; 'Press_db'; 'DIC_LIAR'; 'TALK_LIAR'; 'Temp_C'; 'Sal'; 'PDENS'; 'pCO2_LIAR'; 'in_situ_dens'};
argo_ML_fields = {'GMT_Matlab'; 'Lat'; 'Lon'; 'MLD'};

depth_levs = CMIP.dissic_yr.(cmip_names.dissic_yr{1}).depth;
% create fields for each depth found in the annual output data.
for dd = 1:length(depth_levs)
    for a = 1:length(argo_fields)
        
        argo_SO.(['d' num2str(depth_levs(dd))]).(argo_fields{a}) = [];
        argo_SO.(['d' num2str(depth_levs(dd))]).(argo_fields{a}) = [];
    end
end

depth_names = fieldnames(argo_SO);
for a = 1:length(argo_ML_fields)
    argo_SO.ml.(argo_ML_fields{a}) = [];
end
clear dd a
%
for f = 1:length(SO_SNs)
    
    if isfield(Argo.(SO_SNs{f}), 'PDENS')
        temp_rep_lat = repmat( Argo.(SO_SNs{f}).Lat, 1,800);
        temp_rep_lon = repmat( Argo.(SO_SNs{f}).Lon, 1,800);
        
        temp_rep_GMT = repmat( Argo.(SO_SNs{f}).GMT_Matlab, 1,800);
        
        for dd = 1:length(depth_levs) % loop through each depth level
            
            % find a minimum and maxium depth to search for each depth
            % level
            if dd==1
                min_depth=0;
            else
                min_depth = depth_levs(dd)-(depth_levs(dd)-depth_levs(dd-1))/2;
            end
            if dd==length(depth_levs)
                max_depth = depth_levs(dd) + (depth_levs(dd)-depth_levs(dd-1))/2;
            else
                max_depth = depth_levs(dd) + abs((depth_levs(dd)-depth_levs(dd+1)))/2;
            end
            
            % index based on pressure and SO latitude cutoff
            argo_index = Argo.(SO_SNs{f}).Press_db>= min_depth & Argo.(SO_SNs{f}).Press_db<max_depth & (temp_rep_lat<=lat_lims_SO(2) & ...
                temp_rep_lat>=lat_lims_SO(1));
            %             if sum(argo_index(:))>0
            %                 disp(f)
            %                 break
            %             end
            %         surf_index = Argo.(SO_SNs{f}).Press_db<surf_depth & ~isnan(Argo.(SO_SNs{f}).DIC_LIAR) & (temp_rep_lat<=lat_lims(2) & ...
            %             temp_rep_lat>=lat_lims(1));
            %
            %         deep_index =( Argo.(SO_SNs{f}).Press_db>deep_depth-deep_depth_bnds & Argo.(SO_SNs{f}).Press_db<deep_depth+deep_depth_bnds) & ~isnan(Argo.(SO_SNs{f}).DIC_LIAR) & (temp_rep_lat<=lat_lims(2) & ...
            %             temp_rep_lat>=lat_lims(1));
            %
            %     if sum(reshape(surf_index,[],1))>0
            %         disp(f)
            %         break
            %     end
            %
            
            % create a SO specific record of argo
            argo_SO.(depth_names{dd}).GMT_Matlab = [argo_SO.(depth_names{dd}).GMT_Matlab ; reshape(temp_rep_GMT(argo_index),[],1)];
            %         argo_SO.deep.GMT_Matlab = [argo_SO.deep.GMT_Matlab ; reshape(temp_rep_GMT(deep_index),[],1)];
            
            argo_SO.(depth_names{dd}).Lat = [argo_SO.(depth_names{dd}).Lat ; reshape(temp_rep_lat(argo_index),[],1)];
            %         argo_SO.deep.Lat = [argo_SO.deep.Lat ; reshape(temp_rep_lat(deep_index),[],1)];
            
            argo_SO.(depth_names{dd}).Lon = [argo_SO.(depth_names{dd}).Lon ; reshape(temp_rep_lon(argo_index),[],1)];
            %         argo_SO.deep.Lon = [argo_SO.deep.Lon ; reshape(temp_rep_lon(deep_index),[],1)];
            
            for a = 4:length(argo_fields)
                argo_SO.(depth_names{dd}).(argo_fields{a}) = [argo_SO.(depth_names{dd}).(argo_fields{a}) ; reshape(Argo.(SO_SNs{f}).(argo_fields{a})(argo_index),[],1)];
                %             argo_SO.deep.(argo_fields{a}) = [argo_SO.deep.(argo_fields{a}) ; reshape(Argo.(SO_SNs{f}).(argo_fields{a})(deep_index),[],1)];
            end
            
            %             argo_SO.(depth_names{dd}).TALK_LIAR = argo_SO.(depth_names{dd}).TALK_LIAR.*argo_SO.(depth_names{dd}).PDENS./1000; % convert to umol / l
            
            clear argo_index max_depth min_depth
        end
        %         disp(f)
        
        % manually add MLD to the surface list, probably along with a
        % separate GMT that doesn't have a repeated field.
        
        ML_index = Argo.(SO_SNs{f}).Lat<=lat_lims_SO(2) & Argo.(SO_SNs{f}).Lat>=lat_lims_SO(1);
        
        argo_SO.ml.GMT_Matlab = [argo_SO.ml.GMT_Matlab ; Argo.(SO_SNs{f}).GMT_Matlab(ML_index)];
        argo_SO.ml.Lat = [argo_SO.ml.Lat ; Argo.(SO_SNs{f}).Lat(ML_index)];
        argo_SO.ml.Lon = [argo_SO.ml.Lon ; Argo.(SO_SNs{f}).Lon(ML_index)];
        argo_SO.ml.MLD = [argo_SO.ml.MLD ; Argo.(SO_SNs{f}).MLD(ML_index)];
        
        
        clear temp_rep_GMT temp_rep_lat temp_rep_lon surf_index deep_index ML_index
    else
        disp(['No Pdens: ' SO_SNs{f}])
    end
    
end

for dd = 1:length(depth_levs)
    argo_SO.(depth_names{dd}).DIC_LIAR = argo_SO.(depth_names{dd}).DIC_LIAR.*argo_SO.(depth_names{dd}).in_situ_dens./1000; % convert to umol / l
    argo_SO.(depth_names{dd}).TALK_LIAR = argo_SO.(depth_names{dd}).TALK_LIAR.*argo_SO.(depth_names{dd}).in_situ_dens./1000; % convert to umol / l
    
end

% argo_SO.deep.DIC_LIAR = argo_SO.deep.DIC_LIAR.*argo_SO.deep.PDENS./1000; % convert to umol / l
%
%
% argo_SO.deep.TALK_LIAR = argo_SO.deep.TALK_LIAR.*argo_SO.deep.PDENS./1000; % convert to umol / l

clear dd f a Argo SO_SNs temp_lat_vec
%%
% Load GLODAP

gdap_dir = [data_dir 'Data_Products/GLODAP/'];
gdap_filename = 'GLODAPv2.2021_Merged_Master_File.mat';

gdap = load([gdap_dir gdap_filename]);

clear gdap_dir gdap_filename gdap_SO

% Process Glodap

gdap.PDENS = sw_pden(gdap.G2salinity,gdap.G2temperature,gdap.G2pressure, 0);
gdap.in_situ_dens = sw_dens(gdap.G2salinity,gdap.G2temperature,gdap.G2pressure);
gdap.GMT_Matlab = datenum(gdap.G2year, gdap.G2month, gdap.G2day, gdap.G2hour, gdap.G2minute, zeros(size(gdap.G2minute)));


SO_gdap_index = find(gdap.G2latitude<-30 & gdap.G2tco2f==2);
gdap_SO.GMT_Matlab = gdap.GMT_Matlab(SO_gdap_index);
gdap_SO.PDENS = gdap.PDENS(SO_gdap_index);
gdap_SO.in_situ_dens = gdap.in_situ_dens(SO_gdap_index);

gdap_SO.G2oxygen = gdap.G2oxygen(SO_gdap_index);
gdap_SO.G2pressure = gdap.G2pressure(SO_gdap_index);
gdap_SO.G2latitude = gdap.G2latitude(SO_gdap_index);
gdap_SO.G2longitude = gdap.G2longitude(SO_gdap_index);
gdap_SO.G2cruise = gdap.G2cruise(SO_gdap_index);
gdap_SO.G2station = gdap.G2station(SO_gdap_index);
gdap_SO.G2temperature = gdap.G2temperature(SO_gdap_index);
gdap_SO.G2salinity = gdap.G2salinity(SO_gdap_index);
gdap_SO.G2tco2 = gdap.G2tco2(SO_gdap_index).*gdap_SO.in_situ_dens./1000; %%%% CONVERTING TO UNITS OF UMOL/l !!!!%%%
gdap_SO.G2talk = gdap.G2talk(SO_gdap_index).*gdap_SO.in_situ_dens./1000; %%%% CONVERTING TO UNITS OF Ueq/l !!!!%%%


% convert GLODAP longtidue to 0 - 360:
temp_lon = gdap_SO.G2longitude;
temp_lon(temp_lon<0) = temp_lon(temp_lon<0) + 360;
gdap_SO.G2longitude = temp_lon;
clear temp_lon

% gdap_SO.G2MLD = NaN(size(gdap_SO.GMT_Matlab));

clear SO_gdap_index gdap
gdap_SO_fields = fieldnames(gdap_SO);

% Filter Glodap
% depth_levs = CMIP.(variables{v}).(cmip_names.(variables{v}){1}).depth;
gdap_startdate = datenum('Jan-1-2010');
% deep_depth = 800;
% deep_depth_bnds = 25;
% % lat_lims = [-62 -45];
% surf_depth = 25;

% lat_index = gdap_SO.G2latitude<=lat_lims(2) & gdap_SO.G2latitude>=lat_lims(1);
%
%
% % remove data not within the latitude limits imposted earlier.
% for g = 1:length(gdap_SO_fields)
%     if ~isstruct(gdap_SO.(gdap_SO_fields{g}))
%         gdap_SO.filt.(gdap_SO_fields{g}) = gdap_SO.(gdap_SO_fields{g})(lat_index);
%     end
% end
% clear gdap_SO_fields

for dd = 1:length(depth_levs)
    if dd==1
        min_depth=0;
    else
        min_depth = depth_levs(dd)-(depth_levs(dd)-depth_levs(dd-1))/2;
    end
    if dd==length(depth_levs)
        max_depth = depth_levs(dd) + (depth_levs(dd)-depth_levs(dd-1))/2;
    else
        max_depth = depth_levs(dd) + abs((depth_levs(dd)-depth_levs(dd+1)))/2;
    end
    gdap_index = gdap_SO.G2latitude<=lat_lims_SO(2) & gdap_SO.G2latitude>=lat_lims_SO(1) & ... % filter by latitude bounds
        gdap_SO.G2pressure<max_depth & gdap_SO.G2pressure>=min_depth & gdap_SO.GMT_Matlab>=gdap_startdate; % and by depth
    
    % deep_index = gdap_SO.filt.G2pressure>deep_depth-deep_depth_bnds & gdap_SO.filt.G2pressure<deep_depth+deep_depth_bnds;
    % surf_index = gdap_SO.filt.G2pressure<surf_depth;
    
    % gdap_SO_fields = fieldnames(gdap_SO.filt);
    
    
    for g = 1:length(gdap_SO_fields)
        %         if ~isstruct(gdap_SO.(gdap_SO_fields{g}))
        gdap_SO.(depth_names{dd}).(gdap_SO_fields{g}) = gdap_SO.(gdap_SO_fields{g})(gdap_index);
        %             gdap_SO.deep.(gdap_SO_fields{g}) = gdap_SO.filt.(gdap_SO_fields{g})(deep_index);
        
        %         end
    end
    clear max_depth min_depth gdap_index
end
clear surf_index deep_index lat_index depth_index g gdap_startdate dd
%% Gridding in situ obs
% In order to area-weight observations, I need to first create 1 x 1 grids
% for each month. Only data post-2010 is used from Glodap so this seems
% reasonable.  do this at each depth level.
disp('argo started')
for dd = 1:length(depth_levs)
    disp(depth_names{dd})
    argo_SO.(depth_names{dd}).gridded = [];
    
    argo_vec = datevec(argo_SO.(depth_names{dd}).GMT_Matlab);
    for a = [5 6] %5:length(argo_fields) % ignore all variables except bgc parameters
        disp(argo_fields{a})
        argo_SO.(depth_names{dd}).gridded.(argo_fields{a}) = NaN(360,180,12);
        
        for mon = 1:12
            disp(mon)
            for lo = 1:length(CMIP.spco2.lon)
                for la = 1:61 % length(CMIP.spco2.lat) % only need to grid through to a latitude of ~30deg
                    
                    argo_index = argo_SO.(depth_names{dd}).Lat>= CMIP.spco2.lat(la)-0.5 & argo_SO.(depth_names{dd}).Lat< CMIP.spco2.lat(la)+0.5 & ...
                        argo_SO.(depth_names{dd}).Lon>= CMIP.spco2.lon(lo) & argo_SO.(depth_names{dd}).Lon< CMIP.spco2.lon(lo)+1 & ...
                        argo_vec(:,2)==mon;
                    
                    argo_SO.(depth_names{dd}).gridded.(argo_fields{a})(lo, la, mon) = nanmean(argo_SO.(depth_names{dd}).(argo_fields{a})(argo_index));
                    
                    clear argo_index
                end
            end
        end
    end
    clear argo_vec
end
clear a mon lo la dd
%%
% grid gdap
disp('gdap started')
for dd = 1:length(depth_levs)
    disp(depth_names{dd})
    
    gdap_SO.(depth_names{dd}).gridded = [];
    
    gdap_vec = datevec(gdap_SO.(depth_names{dd}).GMT_Matlab);
    for a = [12 13] %4:length(gdap_SO_fields) % ignore all variables except bgc parameters
        disp(gdap_SO_fields{a})
        gdap_SO.(depth_names{dd}).gridded.(gdap_SO_fields{a}) = NaN(360,180,12);
        
        for mon = 1:12
            disp(mon)
            for lo = 1:length(CMIP.spco2.lon)
                for la = 11:61 % length(CMIP.spco2.lat) % only need to grid through to a latitude of ~30deg
                    
                    gdap_index = gdap_SO.(depth_names{dd}).G2latitude>= CMIP.spco2.lat(la)-0.5 & gdap_SO.(depth_names{dd}).G2latitude< CMIP.spco2.lat(la)+0.5 & ...
                        gdap_SO.(depth_names{dd}).G2longitude>= CMIP.spco2.lon(lo) & gdap_SO.(depth_names{dd}).G2longitude< CMIP.spco2.lon(lo)+1 & ...
                        gdap_vec(:,2)==mon;
                    
                    gdap_SO.(depth_names{dd}).gridded.(gdap_SO_fields{a})(lo, la, mon) = nanmean(gdap_SO.(depth_names{dd}).(gdap_SO_fields{a})(gdap_index));
                    
                    clear gdap_index
                end
            end
        end
    end
    clear gdap_vec
end

clear lo la mon a dd
%% save gridded datasets, reload here instead of re-running the last several cells
% currently saved in manuscript folder
save([home_dir 'Work/Manuscripts/2019_06 SO CMIP Comparison/data/gdap_and_argo_gridded_' datestr(now, 'YYYY_mmm_dd') '.mat'], 'argo_SO', 'gdap_SO')


%% merge gridded datasets - nanmean:
depth_names = fieldnames(argo_SO);

for dd = 1:length(depth_levs)
    combined_SO.(depth_names{dd}).gridded.dissic = NaN(360,180,12);
    combined_SO.(depth_names{dd}).gridded.talk = NaN(360,180,12);
    
    for mon = 1:12
        combined_SO.(depth_names{dd}).gridded.dissic(:,:,mon) = nanmean(cat(3, gdap_SO.(depth_names{dd}).gridded.G2tco2(:,:,mon),  argo_SO.(depth_names{dd}).gridded.DIC_LIAR(:,:,mon)),3);
        combined_SO.(depth_names{dd}).gridded.talk(:,:,mon) = nanmean(cat(3, gdap_SO.(depth_names{dd}).gridded.G2talk(:,:,mon),  argo_SO.(depth_names{dd}).gridded.TALK_LIAR(:,:,mon)),3);
        
    end
    
end
clear dd mon
%% calculate a weighted mean for dissic and talk

% CO2 sol seasonal cycle
obs.dissic.out_seasonal = NaN(12,2,length(depth_levs));
obs.talk.out_seasonal = NaN(12,2,length(depth_levs));

for dd = 1:length(depth_levs)
    
    % lat_index = WOA_SSS.lat<=lat_lims(2) & WOA_SSS.lat>=lat_lims(1);
    
    
    for mon = 1:12
        
        SO_var = combined_SO.(depth_names{dd}).gridded.dissic(:, :, mon);
        SO_var(~NOAA_SST.SAF_mask)=nan;
        
        temp_area = C_input.Neur.y2021.area';
        temp_area(isnan(SO_var)) = nan;
        % creating an area weighting:
        grid_weights = temp_area./nansum(reshape(temp_area,[],1));
        
        
        % sum the product of grid_weights and SO_var to get the area weighted
        % mean
        obs.dissic.out_seasonal(mon,1,dd) = nansum(reshape(SO_var.*grid_weights,[],1));
        obs.dissic.out_seasonal(mon,2,dd) = nanstd(reshape(SO_var,[],1));
        
        clear time_index SO_var temp_area grid_weights
        
        
        SO_var = combined_SO.(depth_names{dd}).gridded.talk(:, :, mon);
        SO_var(~NOAA_SST.SAF_mask)=nan;
        
        temp_area = C_input.Neur.y2021.area';
        temp_area(isnan(SO_var)) = nan;
        % creating an area weighting:
        grid_weights = temp_area./nansum(reshape(temp_area,[],1));
        
        
        % sum the product of grid_weights and SO_var to get the area weighted
        % mean
        obs.talk.out_seasonal(mon,1,dd) = nansum(reshape(SO_var.*grid_weights,[],1));
        obs.talk.out_seasonal(mon,2,dd) = nanstd(reshape(SO_var,[],1));
        
        clear time_index SO_var temp_area grid_weights
    end
    
    clear mon
end

obs.talk.depth_levs = depth_levs;
obs.dissic.depth_levs = depth_levs;

%% Neural network pco2 load
% 2022_07_15 updating to use multiple products (and plan to use combined
% for paper)
% data must be loaded in "Carbon_mapped_product_analysis.m" - should have
% happened during CMIP load

% neural_dir = [data_dir 'Data_Products/CO2_fluxes/Landshuster_Neural/2018_08_30/'];
runs = C_input.runs;
product_names = C_input.product_names;
years = C_input.years;

% runs = {'SOCAT_only'; 'SOCCOM_SOCAT'};
% runs = {'SOCCOM_SOCAT'};

% run_filenames = {'MPI-SOM_FFN_GCB2018.nc'; 'MPI-SOM_FFN_SOCCOMv2018.nc'};

% for q = 1:length(runs)
%     Mapped_pCO2.Neur.(runs{q}) = double(ncread([neural_dir run_filenames{q}], 'spco2'));
%     Mapped_pCO2.Neur.(runs{q})(abs(Mapped_pCO2.Neur.(runs{q}))>1e5) = nan;
%     if q==1
%         lat_neur = ncread([neural_dir run_filenames{q}], 'lat');
%         lon_neur = ncread([neural_dir run_filenames{q}], 'lon');
%     end
% end
% Mapped_pCO2.Neur.units = 'muatm';
% time_neural =  ncread([neural_dir run_filenames{1}], 'time'); % 'seconds since 2000-01-01'
% 
% Mapped_pCO2.Neur.time_Matlab = double(time_neural)/60/60/24 + datenum('jan-01-2000');  % days since 2000-01-01
% lat_neur = double(lat_neur);
% lon_neur = double(lon_neur);
% 
% [X_lon_neur, Y_lat_neur] = meshgrid(lon_neur, lat_neur);
% 
% temp_lon_neur = X_lon_neur;
% temp_lon_neur(temp_lon_neur>180) = temp_lon_neur(temp_lon_neur>180)-360;
% 
% Mapped_pCO2.Neur.lon = lon_neur;
% Mapped_pCO2.Neur.lat = lat_neur;
% 
% Mapped_pCO2.Neur.lon_grid = temp_lon_neur';
% Mapped_pCO2.Neur.lat_grid = Y_lat_neur';
% 
% clear time_neural temp_lon_neur X_lon_neur Y_lat_neur lat_neur lon_neur q neural_dir

% %  Neural network pCO2 seasonal cycle
% % 2022_06_24 changing to a mean of NN and JCS, 2021 editions
% % runs = {'SOCAT_only'; 'SOCCOM_SOCAT'};
% % yr = 'y2018'; % using y2018 for now bc NN 2021 has fCO2 and I need matched SST - ask Peter
% 
% % average datasets
% TT = double(C_input.Neur.(yr).spco2.(runs{q}));
% QQ = C_input.Jena.(yr).spco2.(runs{q});

% Mapped_C_prods_ave
% create a neural network -180 - 180 S of SAF mask

C_input.Neur.y2021.index.SAF_S_mask = C_input.Neur.y2021.index.pfz | C_input.Neur.y2021.index.asz | C_input.Neur.y2021.index.siz ;
C_input.Neur.y2021.index.SAF_S_mask = C_input.Neur.y2021.index.SAF_S_mask';
C_input.Neur.y2021.index.SAF_S_mask = C_input.Neur.y2021.index.SAF_S_mask & C_input.Neur.y2021.lat_grid>poleward_lat_lim;
% lat_index = Mapped_pCO2.Neur.lat<=lat_lims(2) & Mapped_pCO2.Neur.lat>=lat_lims(1);

obs.spco2 = [];
% initialize seasonal arrays:
for p = 1:length(product_names)
    for y = 1:length(years)
        for q = 1:length(runs)
            if isfield(C_input.(product_names{p}).(years{y}).spco2, runs{q})
                obs.spco2.(product_names{p}).(years{y}).(runs{q}).out_seasonal = NaN(12,2);
            end
            % mod_vec = datevec(Mapped_pCO2.Neur.time_Matlab);
        end
    end
end
clear p y q

for p = 1:length(product_names)
    for y = 1:length(years)
        for q = 1:length(runs)
            if ~isfield(C_input.(product_names{p}).(years{y}).spco2, runs{q})
                continue
            end
            for mon=1:12
                time_index = C_input.(product_names{p}).(years{y}).date_vec(:,2)==mon & ...
                    C_input.(product_names{p}).(years{y}).date_vec(:,1)>=2015;
                
                SO_spco2 = C_input.(product_names{p}).(years{y}).spco2.(runs{q})(:, :, time_index);
                %             SO_spco2 = Mapped_pCO2.Neur.SOCCOM_SOCAT(:, :, time_index);
                % for each year, mask out the non SAF_S region:
                for zz = 1:size(SO_spco2,3)
                    TT = SO_spco2(:,:,zz);
                    TT(~C_input.Neur.y2021.index.SAF_S_mask) = nan;
                    
                    temp_area = C_input.Neur.y2021.area';
                    temp_area(isnan(TT)) = nan;
                    % creating an area weighting:
                    grid_weights = temp_area./nansum(reshape(temp_area,[],1));
                    
                    SO_spco2(:,:,zz) = TT.*grid_weights; % weight each value - now to get the annual mean you will sum these together
                    clear TT grid_weights temp_area
                end
                clear zz
                
                
                % sum each year into a single month, then take the mean and std:
                zonal_sum = nansum(SO_spco2,1);
                box_sum = squeeze(nansum(zonal_sum,2));
                
                obs.spco2.(product_names{p}).(years{y}).(runs{q}).out_seasonal(mon,1) = nanmean(box_sum);
                obs.spco2.(product_names{p}).(years{y}).(runs{q}).out_seasonal(mon,2) = nanstd(box_sum);
                
                %                 obs.spco2.out_seasonal (mon,1) = nanmean(box_sum);
                %                 obs.spco2.out_seasonal (mon,2) = nanstd(box_sum);
                
                clear SO_spco2 zonal_sum box_sum
            end
            
            clear lat_index mod_vec time_index mon
        end
    end
end
clear p q y

% Neural Network seasonal fgCO2 - 2021_02_08 updated to use the "C_input
% from "Carbon_mapped_product_analysis"

for p=1:length(product_names)
    % y=1;
    % q = 1;
    
    % mod_vec = datevec(Neur_input.time_Matlab);
    for y = 1:length(years)
        % for p = 1:2
        for q = 1:2
            %         lat_index = C_input.(product_names{p}).(years{y}).lat<=lat_lims(2) & C_input.(product_names{p}).(years{y}).lat>=lat_lims(1);
            obs.fgco2.(product_names{p}).(years{y}).(runs{q}).out_seasonal = NaN(12,2);
            obs.fgco2_mol_C_m2_yr.(product_names{p}).(years{y}).(runs{q}).out_seasonal = NaN(12,2);
            
            for mon=1:12
                time_index = C_input.(product_names{p}).(years{y}).date_vec(:,2)==mon & C_input.(product_names{p}).(years{y}).date_vec(:,1)>=2015;
                
                SO_fgco2 = C_input.(product_names{p}).(years{y}).Pg_mon.(runs{q})(:, :, time_index);
                
                
                % for each year, mask out the non SAF_S region:
                for zz = 1:size(SO_fgco2,3)
                    TT = SO_fgco2(:,:,zz);
                    TT(~C_input.Neur.y2021.index.SAF_S_mask) = nan;
                    SO_fgco2(:,:,zz) = TT;
                    clear tt grid_weights
                    
                end
                clear zz
                
                % sum each year into a single month, then take the mean and std:
                zonal_sum = nansum(SO_fgco2,1);
                box_sum = squeeze(nansum(zonal_sum,2));
                
                %     % collapse all years into one mean map for each month
                %     SO_fgco2_mean = nanmean(SO_fgco2,3);
                
                % sum all grid cells to calculate a total flux
                obs.fgco2.(product_names{p}).(years{y}).(runs{q}).out_seasonal(mon,1) = nanmean(box_sum)*1000; % Pg to Tg
                obs.fgco2.(product_names{p}).(years{y}).(runs{q}).out_seasonal(mon,2) = nanstd(box_sum)*1000;
                
                clear SO_fgco2 zonal_sum box_sum
                
                % separately calculate avg flux density
                SO_fgco2_mol_m2_yr = C_input.(product_names{p}).(years{y}).(runs{q})(:, :, time_index);
                
                % for each year, mask out the non SAF_S region:
                for zz = 1:size(SO_fgco2_mol_m2_yr,3)
                    TT = SO_fgco2_mol_m2_yr(:,:,zz);
                    TT(~C_input.Neur.y2021.index.SAF_S_mask) = nan;
                    
                    temp_area = C_input.Neur.y2021.area';
                    temp_area(isnan(TT)) = nan;
                    % creating an area weighting:
                    grid_weights = temp_area./nansum(reshape(temp_area,[],1));
                    
                    SO_fgco2_mol_m2_yr(:,:,zz) = TT.*grid_weights; % weight each value - now to get the annual mean you will sum these together
                    clear TT grid_weights temp_area
                end
                clear zz
                
                
                % sum each year into a single month, then take the mean and std:
                zonal_sum = nansum(SO_fgco2_mol_m2_yr,1);
                box_sum = squeeze(nansum(zonal_sum,2));
                
                obs.fgco2_mol_C_m2_yr.(product_names{p}).(years{y}).(runs{q}).out_seasonal(mon,1) = nanmean(box_sum);
                obs.fgco2_mol_C_m2_yr.(product_names{p}).(years{y}).(runs{q}).out_seasonal(mon,2) = nanstd(box_sum);
                
                clear SO_fgco2_mol_m2_yr zonal_sum box_sum
                
            end
            
            clear lat_index mod_vec time_index mon
        end
    end
end
%
% lat_index = Neur_input.lat<=lat_lims(2) & Neur_input.lat>=lat_lims(1);
% obs.fgco2.out_seasonal = NaN(12,2);
% mod_vec = datevec(Neur_input.time_Matlab);
%
%
% for mon=1:12
%     time_index = mod_vec(:,2)==mon & mod_vec(:,1)>=2015;
%
%     SO_fgco2 = Neur_input.Pg_mon.SOCCOM_SOCAT(:, lat_index, time_index);
%
%
%     % sum each year into a single month, then take the mean and std:
%     zonal_sum = nansum(SO_fgco2,1);
%     box_sum = squeeze(nansum(zonal_sum,2));
%
%     %     % collapse all years into one mean map for each month
%     %     SO_fgco2_mean = nanmean(SO_fgco2,3);
%
%     % sum all grid cells to calculate a total flux
%     obs.fgco2.out_seasonal(mon,1) = nanmean(box_sum)*1000; % Pg to Tg
%     obs.fgco2.out_seasonal(mon,2) = nanstd(box_sum)*1000;
%
%     clear SO_fgco2 zonal_sum box_sum
% end
%
% clear lat_index mod_vec time_index mon
clear y q p

%% looking at pCO2 seasonal cycles
c_map = brewermap(10, 'Set2');
clf
d1 = subplot(1,2,1); hold on; grid on;
d2 = subplot(1,2,2); hold on; grid on;
plot_handles = [];
plot_names = {};
line_index = 0;
for p = 1:length(product_names)
    for y = 1:length(years)
        for q = 1:length(runs)
            if ~isfield(C_input.(product_names{p}).(years{y}).spco2, runs{q})
                continue
            end
            line_index = line_index+1;
            p1 = plot(d1, 1:12, obs.spco2.(product_names{p}).(years{y}).(runs{q}).out_seasonal(:,1), 'linewidth', 2, ...
                'color', c_map(line_index,:));
            plot_handles = [plot_handles ; p1];
            plot_names = [plot_names; [product_names{p} '_' runs{q}]]; 
            
            plot(d2, 1:12, obs.spco2.(product_names{p}).(years{y}).(runs{q}).out_seasonal(:,1) - ...
                nanmean(obs.spco2.(product_names{p}).(years{y}).(runs{q}).out_seasonal(:,1)), 'linewidth', 2, ...
                'color', c_map(line_index,:));

        end
    end
end

legend(d1, plot_handles, plot_names, 'interpreter', 'none', 'location', 'southoutside')
legend(d2, plot_handles, plot_names, 'interpreter', 'none', 'location', 'southoutside')

%% Holte and talley climatology for MLD - Load and grid
disp('Starting H & T MLD Climatology load')
h_t = load([data_dir 'Data_Products/MLD/Holte_and_Talley/' 'Argo_mixedlayers_monthlyclim_03172021.mat']);

load([data_dir 'ARGO_O2_Floats/Front_definitions/Gray_5_regions/regional_boundaries_5zone_SMB.mat']);

% grid is the same as the Neural Network, so I can just use the existing NN
% mask
obs.mlotst.out_seasonal = NaN(12,2);
for mon=1:12
    
    
    TTT = squeeze(h_t.mld_da_mean(mon,:,:));
    TTT(~C_input.Neur.y2021.index.SAF_S_mask) = nan;
    
    temp_area = C_input.Neur.y2021.area';
    temp_area(isnan(TTT)) = nan;
    % creating an area weighting:
    grid_weights = temp_area./nansum(reshape(temp_area,[],1));
    
    
    obs.mlotst.out_seasonal(mon,1) =  nansum(reshape(TTT.*grid_weights,[],1));
    obs.mlotst.out_seasonal(mon,2) = nanstd(reshape(TTT,[],1));
    
    clear grid_weights temp_area
end

%% Loading NPP
disp('Startign  NPP load')

npp_types = {'CbPM', 'VGPM', 'CAFE'};
clear NPP_obs

for f = 1:length(npp_types)
    NPP_dir = [data_dir 'Data_Products/NPP/' npp_types{f} '/'];
    npp_files = dir([NPP_dir '*.hdf']);
    
    
    m = 1080;
    n = 2160;
    
    lat_step = (90--90)/(m-1);
    lon_step = (180--180)/(n-1);
    
    npp_lat = 90:-lat_step:-90;
    npp_lon = -180:lon_step:180;
    
    [X, Y] = meshgrid(npp_lon, npp_lat);
    
    NPP_obs.(npp_types{f}).Matlab_date = NaN(length(npp_files),1);
    NPP_obs.lat = npp_lat;
    NPP_obs.lon = npp_lon;
    NPP_obs.lat_grid = Y;
    NPP_obs.lon_grid = X;
    
    NPP_obs.(npp_types{f}).npp = NaN(m,n,length(npp_files));
    
    
    % read in individual npp files (currently 2008-2016)
    for q = 1:length(npp_files)
        
        BB = npp_files(q).name(6:12);
        NPP_obs.(npp_types{f}).Matlab_date(q) = datenum(BB(1:4), 'YYYY')-1 + str2double(BB(5:7)) + 15;
        
        month_npp = hdfread([NPP_dir npp_files(q).name], '/npp', 'Index', {[1  1],[1  1],[m  n]}); % mgC m-2 d-1
        month_npp = double(month_npp);
        month_npp(month_npp<-50)=nan;
        
        NPP_obs.(npp_types{f}).npp(:,:,q) = month_npp;
        clear month_npp BB
    end
    
    clear X Y npp_lat npp_lon lon_step lat_step m n NPP_dir npp_files q
end

% saving observation monthly means and std
clear f

% create an NPP mask for south of the SAF

NPP_obs.SAF_S_mask = inpolygon(NPP_obs.lat_grid, NPP_obs.lon_grid, five_region_bounds.lat_saf, five_region_bounds.lon_saf) & NPP_obs.lat_grid>poleward_lat_lim;

m_per_deg = 110.567.*10.^3;

lat_deg_step = NPP_obs.lat(1)-NPP_obs.lat(2);
lon_deg_step = NPP_obs.lon(2)-NPP_obs.lon(1);

% NPP_obs.area = (lon_deg_step.*ones(length(NPP_obs.lon),1).*m_per_deg)'*(lat_deg_step.*ones(length(NPP_obs.lat),1).*m_per_deg.*cosd(NPP_obs.lat'))';
NPP_obs.area = (lat_deg_step.*ones(length(NPP_obs.lat),1).*m_per_deg.*cosd(NPP_obs.lat'))*(lon_deg_step.*ones(length(NPP_obs.lon),1).*m_per_deg)';

% create seasonal cycles from each NPP product individually and an average
% of all three
for f = 1:length(npp_types)
    obs.intpp.(npp_types{f}).out_seasonal = NaN(12,2);
    
    % for m = 1:size(NPP_obs_out_seasonal,1)
    mod_vec = datevec(NPP_obs.(npp_types{f}).Matlab_date);
    
    for mon = 1:12
        time_index = mod_vec(:,2)==mon & mod_vec(:,1)>=2010;
        
        SO_pp = NPP_obs.(npp_types{f}).npp(:, :, time_index);
        
        % for each year, mask out the non SAF_S region:
        for zz = 1:size(SO_pp,3)
            TT = SO_pp(:,:,zz);
            TT(~NPP_obs.SAF_S_mask) = nan;
            temp_area = NPP_obs.area;
            
            temp_area(isnan(TT)) = nan;
            % creating an area weighting:
            grid_weights = temp_area./nansum(reshape(temp_area,[],1));
            
            SO_pp(:,:,zz) = TT.*grid_weights; % weight each value - now to get the annual mean you will sum these together
            clear TT grid_weights temp_area
        end
        clear zz
        
        % sum each year into a single month, then take the mean and std:
        zonal_sum = nansum(SO_pp,1);
        box_sum = squeeze(nansum(zonal_sum,2));
        
        % area weighted mean and std deviation (representing the time variance)
        obs.intpp.(npp_types{f}).out_seasonal(mon,1) = nanmean(box_sum);
        obs.intpp.(npp_types{f}).out_seasonal(mon,2) = nanstd(box_sum);
        
        clear  time_index  SO_pp zonal_sum box_sum
    end
end

clear mod_vec lat_index mon lat_deg_step lon_deg_step f

% combined intpp:
temp_intpp = NaN(length(npp_types), 12);
for f = 1:length(npp_types)
    temp_intpp(f,:) = obs.intpp.(npp_types{f}).out_seasonal(:,1);
end
obs.intpp.out_seasonal = mean(temp_intpp, 1, 'omitnan')';

clear f temp_intpp
%% calculate seasonal DIC-TALK cycles

% try to just add to "variables" and see if it causes havoc:
variables = [variables ; 'DIC_Alk'];
var_type = [var_type ; 'Omon'];
var_lims(end+1,:) = [-20 20];
%%

v = 15;
CMIP.(variables{v}).out_seasonal = NaN(2,12);
cmip_names.(variables{v}) = {};

model_index = 0;
for m = 1:length(cmip_names.dissic)
    
    % find the matching model talk
    mod_match = strcmp(cmip_names.talk, cmip_names.dissic{m});
    
    if sum(mod_match)==0
        continue
    end
    model_index = model_index + 1;
    CMIP.(variables{v}).out_seasonal(model_index,:) = CMIP.dissic.out_seasonal(m,:,1) - CMIP.talk.out_seasonal(mod_match,:,1);
    
    cmip_names.(variables{v}) = [cmip_names.(variables{v}) ; cmip_names.dissic{m}];
end
%
obs.DIC_Alk.out_seasonal = obs.dissic.out_seasonal(:,1,1) - obs.talk.out_seasonal(:,1,1);
CMIP.(variables{v}).(cmip_names.(variables{v}){1}).units = CMIP.dissic.(cmip_names.(variables{v}){1}).units;
clear m mod_match model_index v


%% plot all variable maps together, similar to the supplemental figures for your paper

% var_cmaps.fgco2 = %flipud(brewermap(30, 'RdBu'));
% var_cmaps.fgco2 = flipud(brewermap(30, 'RdBu'));

new_bounds = load([data_dir 'ARGO_O2_Floats/Front_definitions/Gray_5_regions/regional_boundaries_5zone.mat']);
new_bounds.lon_saf_360 = new_bounds.lon_saf;
new_bounds.lon_saf_360(new_bounds.lon_saf_360<0) = new_bounds.lon_saf_360(new_bounds.lon_saf_360<0)+360;
new_bounds.lon_lat_saf_360 = sortrows([new_bounds.lon_saf_360' new_bounds.lat_saf']);

title_size = 7;

for v=1:length(variables)
    
    for r = 1:2
        
        clf
        set(gcf, 'units', 'inches')
        paper_w = 11; paper_h = 8.5;
        set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
        
        d = NaN(20);
        p_index=0;
        
        if r==1
            first = 1;
            last = 20;
        elseif r==2
            first=24;
            last = length(cmip_names.(variables{v}));
        end
        plot_filename = ['Figure S2_Mean_Surface_CO2flux_all_models_' num2str(r) '_v2'];
        
        
        
        SO_lat_index = CMIP.(variables{v}).lat<=-35;
        [lon_grid, lat_grid] = meshgrid(CMIP.(variables{v}).lon, CMIP.(variables{v}).lat);
        
        CMIP.lon_grid = lon_grid';
        CMIP.lat_grid = lat_grid';
        clear lon_grid lat_grid
        
        
        set(gcf, 'colormap', flipud(brewermap(30, 'RdBu')))
        
        
        if v==9 % eventually should add your observed
            p_index = p_index+1;
            
            date_index =  C_input.Neur.y2021.Pg_mon.date_vec(:,1)>=2015;
            CC = C_input.Neur.y2021.Pg_mon.SOCCOM_SOCAT(:, SO_lat_index, date_index); % Pg mon-1
            
            annual_neur = nansum(CC,3)./(size(CC,3)./12); % Pg yr-1
            
            
            SO_mean_var_lon_shift = NaN(size(annual_neur,1), size(annual_neur,2), size(annual_neur,3));
            SO_mean_var_lon_shift(1:180, :, :) = annual_neur(181:end,:,:);
            SO_mean_var_lon_shift(181:end, :, :) = annual_neur(1:180,:,:);
            
            SO_mean_var_lon_shift = SO_mean_var_lon_shift./C_input.Neur.y2021.area(SO_lat_index,:)'.*10^15; % g C m-2 yr-1 from Pg C yr-1 ; %
            SO_mean_var_lon_shift = SO_mean_var_lon_shift./12./1000; %  Tg C mon-1 from Pg C yr-1
            
            d(p_index) = subplot(5,4,p_index);
            
            pcolor(CMIP.lon_grid(:,SO_lat_index), CMIP.lat_grid(:,SO_lat_index), SO_mean_var_lon_shift); shading flat; %colorbar
            hold on
            
            plot(new_bounds.lon_lat_saf_360(:,1), new_bounds.lon_lat_saf_360(:,2), 'k-', 'linewidth', 2)
            plot([1 360], [poleward_lat_lim poleward_lat_lim], 'k-', 'linewidth',2)
            
            caxis(var_lims(v,:))
            title('SOCCOM SOCAT', 'fontsize', title_size)
            set(gca, 'fontsize', 6)
            set(gca, 'ylim', [-80 -35])
            
        end
        
        for m = first:last % length(cmip_names.(variables{v}))
            if ~isfield(CMIP.thetao, (cmip_names.(variables{v}){m}))
                continue
            end
            p_index = p_index+1;
            
            if isfield(CMIP.(variables{v}).(cmip_names.(variables{v}){m}), 'depth')
                num_depths = length(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).depth);
            else
                num_depths =1;
            end
            
            for dd = [1 round(num_depths./2) num_depths]
                %             clf
                %             set(gcf, 'units', 'inches')
                %             paper_w = 16; paper_h =9;
                %             set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
                %             colormap(parula(70))
                %             set(gcf, 'colormap', var_cmaps.(variables{v}));
                mod_vec = datevec(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).GMT_Matlab);
                time_index = mod_vec(:,1)>=2010 & mod_vec(:,1)<2020;
                
                if num_depths==1
                    SO_var = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, SO_lat_index, time_index);
                else
                    SO_var = squeeze(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, SO_lat_index, dd, time_index));
                end
                
                SO_mean_var = mean(SO_var,3, 'omitnan'); % Tg C mon-1
                
                %             if v==9
                %             SO_mean_var = SO_mean_var./C_input.Neur.y2021.area(SO_lat_index,:)'.*12.*10^12; % g C m-2 yr-1 from Tg C mon-1
                %             end
                %             subplot(1,1,1)
                d(p_index) = subplot(5,4,p_index);
                
                
                pcolor(CMIP.lon_grid(:,SO_lat_index), CMIP.lat_grid(:,SO_lat_index), SO_mean_var); shading flat
                hold on
                plot(CMIP.thetao.lon, CMIP.thetao.(cmip_names.(variables{v}){m}).SAF, 'k-', 'linewidth', 2)
                plot([1 360], [poleward_lat_lim poleward_lat_lim], 'k-', 'linewidth',2)
                %             xlabel('Longitude')
                %             ylabel('Latitude')
                %             c1 = colorbar;
                %             ylabel(c1, [variables{v} ' (' CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units ')'], 'interpreter', 'none')
                
                title(cmip_names.(variables{v}){m}, 'interpreter', 'none', 'fontsize', title_size)
                
                %             if num_depths==1
                %                 title([cmip_names.(variables{v}){m} ' ' variables{v}], 'interpreter', 'none')
                %             else
                %                 title([cmip_names.(variables{v}){m} ' ' variables{v} ' depth: ' num2str(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).depth(dd))], 'interpreter', 'none')
                %             end
                set(gca, 'ylim', [-85 -35])
                set(gca, 'fontsize', 6)
                %             caxis(var_lims(v,:))
                caxis(var_lims(v,:))
                set(gca, 'ylim', [-80 -35])
                
                
            end
        end
        %     pause
        if num_depths==1
            plot_filename = ['All_models_' variables{v} '_Surface_' cmip_names.(variables{v}){m} '_' num2str(r)];
            
        else
            plot_filename = ['All_models_' variables{v} '_' cmip_names.(variables{v}){m} '_' num2str(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).depth(dd)) 'm' '_' num2str(r)];
        end
        
        print(gcf, '-dpdf', '-r400', [Plot_out_dir variables{v} '/' plot_filename '_v1.pdf'])
        
        
        if r==1
            c1 = colorbar;
            
            ylabel(c1, [variables{v} ' (' CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units ')'], 'interpreter', 'none')
            
            print(gcf, '-dpdf', '-r400', [Plot_out_dir variables{v} '/' plot_filename 'w_colorbar.pdf'])
        end
        clear SO_var SO_mean_var plot_filename SO_SSS time_index mod_vec
        
    end
    
    clear m c1 SO_lat_index paper_h paper_w dd num_depths
end
%% save out seasonal data / seasonal cycles so you don't have to re-read in observations

%% remove data from CMIP so that you have a reduced dataset to save / load

for v = 1:14%length(variables)
    for m = 1:length(cmip_names.(variables{v}))
        
        % find all large arrays:
        temp_fields = fieldnames(CMIP.(variables{v}).(cmip_names.(variables{v}){m}));
        
        for tt = 1:length(temp_fields)
            
            field_size = size(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(temp_fields{tt}));
            
            if length(field_size)>2 && field_size(1)==360 && field_size(2)==180
                % make arrays blank to reduce size prior to saving out
                CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(temp_fields{tt}) = [];
            end
        end
    end
end

%%
% save([home_dir 'Work/Manuscripts/2019_06 SO CMIP Comparison/data/seasonal_cycles_' datestr(now, 'YYYY_mmm_dd') '.mat'], 'CMIP', 'NPP_obs', 'combined_SO', 'Mapped_pCO2', 'NOAA_SST', 'WOA_SSS',...
%     'cmip_names', 'obs', 'color_model', 'variables', 'var_type', 'cmap', 'model_group_colors', ...
%     'var_lims', 'depth_levs', 'poleward_lat_lim', 'depth_names')
save([home_dir 'Work/Manuscripts/2019_06 SO CMIP Comparison/data/seasonal_cycles_' datestr(now, 'YYYY_mm_dd') '.mat'], 'CMIP', 'combined_SO', 'NOAA_SST', 'WOA_SSS',...
    'cmip_names', 'obs', 'color_model', 'variables', 'var_type', 'cmap', 'model_group_colors', ...
    'var_lims', 'depth_levs', 'poleward_lat_lim', 'depth_names', 'plot_ver')

%% Taylor diagrams:

%% Taylor calculations and diagram using Kathy Kelly's tools
q = 2; % SOCCOM SOCAT
p = 3; % Combined
y = 1; % 

years = C_input.years;
product_names = C_input.product_names;
run_names = C_input.run_names;
runs = C_input.runs;
regions = C_input.regions;

for v = 1:14%length(variables)
    
    % currently skipping psl and wmo
    if sum(strcmp(variables{v}, {'psl'; 'wmo';'dissic_yr';'talk_yr';'thetao'}))>0
        continue
    end
    % I believe this removes mean, but I can test that:
    obs.(variables{v}).correlation = NaN(size(CMIP.(variables{v}).out_seasonal,1),1);
    obs.(variables{v}).ratio = NaN(size(CMIP.(variables{v}).out_seasonal,1),1);
    obs.(variables{v}).norm_error = NaN(size(CMIP.(variables{v}).out_seasonal,1),1);
    
    if v==9
        obs.fgco2_mol_C_m2_yr.correlation = NaN(size(CMIP.(variables{v}).out_seasonal,1),1);
        obs.fgco2_mol_C_m2_yr.ratio = NaN(size(CMIP.(variables{v}).out_seasonal,1),1);
        obs.fgco2_mol_C_m2_yr.norm_error = NaN(size(CMIP.(variables{v}).out_seasonal,1),1);
        
    end
    
    for m = 1:length(cmip_names.(variables{v}))
        if v==9 || v==1
            % calculate fit for total flux (but different areas b/c of different SAFs,
            % so maybe not the best
            [obs.(variables{v}).correlation(m),obs.(variables{v}).ratio(m),obs.(variables{v}).norm_error(m)]=...
                taylor_eval(obs.(variables{v}).(product_names{p}).(years{y}).(runs{q}).out_seasonal(:,1), ...
                CMIP.(variables{v}).out_seasonal(m,:,1));
            
            % record which products are used:
            obs.(variables{v}).run_used = [(product_names{p}) '_' (years{y}) '_' (runs{q})];
            if v==9
                % calculate fit for flux density
                %             [obs.fgco2_mol_C_m2_yr.correlation(m),obs.fgco2_mol_C_m2_yr.ratio(m),obs.fgco2_mol_C_m2_yr.norm_error(m)]= ...
                %                 taylor_eval(obs.fgco2_mol_C_m2_yr.Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,1),CMIP.(variables{v}).out_seasonal_mol_C_m2_yr(m,:,1));
                [obs.fgco2_mol_C_m2_yr.correlation(m),obs.fgco2_mol_C_m2_yr.ratio(m), ...
                    obs.fgco2_mol_C_m2_yr.norm_error(m)]= ...
                    taylor_eval(obs.fgco2_mol_C_m2_yr.(product_names{p}).(years{y}).(runs{q}).out_seasonal(:,1), ...
                    CMIP.(variables{v}).out_seasonal_mol_C_m2_yr(m,:,1));
                
                 % record which products are used:
            obs.fgco2_mol_C_m2_yr.run_used = [(product_names{p}) '_' (years{y}) '_' (runs{q})];
            end
            
            % 		elseif sum(strcmp(variables{v}, {'dissic'; 'talk'}))>0
            % 			% surface only for dissic or talk
            % 			[obs.(variables{v}).correlation(m),obs.(variables{v}).ratio(m),obs.(variables{v}).norm_error(m)]=taylor_eval(squeeze(obs.(variables{v}).out_seasonal(1,:,1)),CMIP.(variables{v}).out_seasonal(m,:,1));
            
        else
            [obs.(variables{v}).correlation(m),obs.(variables{v}).ratio(m),obs.(variables{v}).norm_error(m)]=taylor_eval(obs.(variables{v}).out_seasonal(:,1,1), CMIP.(variables{v}).out_seasonal(m,:,1));
            
        end
    end
end
clear v m



%% Plotting taylor diagrams
rms_cutoff_for_good = .75;
out_of_phase_corr_cutoff = 0;

legend_on = 1;

% flux_density = 1;
seas_comp_vars = fieldnames(obs);

for sv =  6:8%:length(seas_comp_var)%9%[1 2 4 5 6 7 8 9 14 15]
    v = find(strncmp(seas_comp_vars{sv}, variables, 4));
    if length(v)>1 % cludge since dissic and dissic_yr were getting confused
        v = strmatch(seas_comp_vars{sv}, variables, 'exact');
    end
    
        if v == 1 || v==9
            plot_filename = ['Taylor ' seas_comp_vars{sv} ' ' obs.(seas_comp_vars{sv}).run_used];
        else
            plot_filename = ['Taylor ' seas_comp_vars{sv}];
        end
    clf
    set(gcf, 'units', 'inches')
    paper_w = 14; paper_h =8;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    
    if ~isempty(strfind(seas_comp_vars{sv}, 'fgco2'))
        %         if flux_density==0
        DDD = taylor_dist_smb(obs.(seas_comp_vars{sv}).correlation, obs.(seas_comp_vars{sv}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, ...
            rms_cutoff_for_good, out_of_phase_corr_cutoff);
        
        %         else
        %             DDD = taylor_dist_smb(obs.fgco2_mol_C_m2_yr.correlation, obs.fgco2_mol_C_m2_yr.ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, rms_cutoff_for_good, out_of_phase_corr_cutoff);
        %             DDD = taylor_dist_smb(obs.fgco2_mol_C_m2_yr.correlation, obs.fgco2_mol_C_m2_yr.ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, [], []);
        
        %         end
    else
        DDD = taylor_dist_smb(obs.(seas_comp_vars{sv}).correlation, obs.(seas_comp_vars{sv}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, [], []);
    end
    
    if v == 1 || v==9
        title([seas_comp_vars{sv} ' ' obs.(seas_comp_vars{sv}).run_used], 'interpreter', 'none')
        
    else
        
        title(seas_comp_vars{sv}, 'interpreter', 'none')
    end
    set(gca, 'fontsize', 12)
    
        print(gcf, '-dpng', [Plot_out_dir seas_comp_vars{sv} '/' plot_filename '_leg ' num2str(legend_on) plot_ver '.png'])
        
end

clear paper_w paper_h legend_on sv

%% plot looking at impact of product on flux relationships
clear temp

%% save data
for sv = [6 8]
    temp.(seas_comp_vars{sv}).(obs.(seas_comp_vars{sv}).run_used).correlation = obs.(seas_comp_vars{sv}).correlation;
    temp.(seas_comp_vars{sv}).(obs.(seas_comp_vars{sv}).run_used).ratio = obs.(seas_comp_vars{sv}).ratio;
    temp.(seas_comp_vars{sv}).(obs.(seas_comp_vars{sv}).run_used).norm_error = obs.(seas_comp_vars{sv}).norm_error;

end
%% plot change
sv = 8;
run_comparison = fieldnames(temp.fgco2_mol_C_m2_yr);
comparisons = {'correlation', 'ratio', 'norm_error'};
d = NaN(3,1);

clf
d(1) = subplot(1,3,1); hold on; grid on; title(d(1), 'Correlation')
d(2) = subplot(1,3,2);hold on; grid on; title(d(2), 'Ratio')
d(3) = subplot(1,3,3);hold on; grid on; title(d(3), 'Norm Error')
for m=1:length(temp.(seas_comp_vars{sv}).(run_comparison{1}).(comparisons{1}))
        if isnan(temp.(seas_comp_vars{sv}).(run_comparison{1}).correlation(m))
            continue
        end
    plot_order = find(sort(temp.(seas_comp_vars{sv}).(run_comparison{1}).correlation) == ...
        temp.(seas_comp_vars{sv}).(run_comparison{1}).correlation(m));
    

    for c = 1:length(comparisons)
   
        plot(d(c), [plot_order plot_order], [temp.(seas_comp_vars{sv}).(run_comparison{1}).(comparisons{c})(m) ...
            temp.(seas_comp_vars{sv}).(run_comparison{2}).(comparisons{c})(m)]);
        plot(d(c), plot_order, temp.(seas_comp_vars{sv}).(run_comparison{1}).(comparisons{c})(m), '^')
        plot(d(c), plot_order, temp.(seas_comp_vars{sv}).(run_comparison{2}).(comparisons{c})(m), 's');
        
    end
end

% find(sort(temp.(seas_comp_vars{sv}).(run_comparison{1}).correlation) == temp.(seas_comp_vars{sv}).(run_comparison{1}).(comparisons{c})(m))

%% choosing model groups based on taylor diagram
clear model_group_names

model_group_names.good_mag_good_phase = {};
model_group_names.bad_phase = {};
% model_group_names.large_mag_good_phase = {};
model_group_names.other = {};
for m = 1:length(cmip_names.fgco2)
    if isfield(CMIP.thetao, cmip_names.fgco2{m}) % only assigns a model if it has thetao, which is needed for the SAF mask
        if obs.fgco2_mol_C_m2_yr.norm_error(m)<rms_cutoff_for_good
            model_group_names.good_mag_good_phase{end+1} = cmip_names.fgco2{m};
        elseif obs.fgco2_mol_C_m2_yr.correlation(m)<out_of_phase_corr_cutoff
            model_group_names.bad_phase{end+1} = cmip_names.fgco2{m};
            %         elseif obs.fgco2.correlation(m)>0.5 && obs.fgco2.ratio(m)>2
            %             model_group_names.large_mag_good_phase{end+1} = cmip_names.fgco2{m};
        else
            model_group_names.other{end+1} = cmip_names.fgco2{m};
        end
    end
end

%% assigning model types
model_types = fieldnames(model_group_names);

for v = 1:length(variables)
    CMIP.(variables{v}).model_groups = [];
    for q = 1:length(model_types)
        CMIP.(variables{v}).model_groups.(model_types{q}) = find(contains(cmip_names.(variables{v}), model_group_names.(model_types{q})));
    end
end
clear v q

% add a column to color_model that has a number which corresponds to the
% model type:
mod_index=0;
for m=1:length(color_model)
    
    for q = 1:length(model_types)
        mod_index = strcmp(color_model{m,1}, model_group_names.(model_types{q}));
        if sum(mod_index)>0
            color_model{m,3} = q;
        end
    end
end

clear q m mod_index
%% Taylor diagram by model group

for sv =  10%:length(seas_comp_var)%9%[1 2 4 5 6 7 8 9 14 15]
    v = find(strncmp(seas_comp_vars{sv}, variables, 4));
    if length(v)>1 % cludge since dissic and dissic_yr were getting confused
        v = strmatch(seas_comp_vars{sv}, variables, 'exact');
    end
    plot_filename = ['Taylor ' seas_comp_vars{sv} ' by model group'];
    
    clf
    set(gcf, 'units', 'inches')
    paper_w = 14; paper_h =8;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h
    
    
    for q = length(model_types):-1:1
        model_list = CMIP.(variables{v}).model_groups.(model_types{q});
        
        % make a temp colormap that is all one model type's color
        temp_color_model = model_group_colors(q,:);
        temp_cmap = repmat(temp_color_model, length(cmap),1);
        
        taylor_dist_smb(obs.(seas_comp_vars{sv}).correlation(model_list), obs.(seas_comp_vars{sv}).ratio(model_list), [], cmip_names.(variables{v})(model_list), color_model, temp_cmap, 0, [], []);
        
    end
    title(variables{v})
    set(gca, 'fontsize', 16)
    
    print(gcf, '-dpng', [Plot_out_dir seas_comp_vars{sv} '/' plot_filename '_v8_theta.png'])
end
%% plotting Taylor RMS vs each other
% now also do the other comparisons (i.e. correlation vs. correlation)
filter_on=0;
if filter_on==1
    disp('Warning, some results filtered from regression analysis')
end
% example spco2 match vs. intpp
tests = {'norm_error';'correlation' ; 'ratio'};
% legend_on=0;
group_color = 2;

v3 = 4; % variable for harmonic fit scatter color

harm_comp = 'offset';
for sv = 4% [1 2 3 4 5 6 8 9 10] %1:length(seas_comp_vars)
    
    for tt = 1:length(tests)
        for qq = 1:length(tests)
            %             if strcmp(variables{v}, 'wmo') || strcmp(variables{v}, 'psl') || strcmp(variables{v}, 'dissic_yr') || strcmp(variables{v}, 'talk_yr') || strcmp(variables{v}, 'thetao')
            %                 continue
            %             end
            
            % find matching v
            v = find(strncmp(seas_comp_vars{sv}, variables, 4));
            if length(v)>1 % cludge since dissic and dissic_yr were getting confused
                v = strmatch(seas_comp_vars{sv}, variables, 'exact');
            end
            
            clf
            set(gcf, 'units', 'inches')
            paper_w = 15; paper_h =8;
            set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h
            
            plot_index = 0;
            
            plot_filename = ['Taylor ' seas_comp_vars{sv} ' ' tests{qq} ' vs. ' tests{tt} ' other vars_model_groups=' num2str(group_color) ' filter ' num2str(filter_on)];
            if group_color==2
            plot_filename = ['Taylor ' seas_comp_vars{sv} ' ' tests{qq} ' vs. ' tests{tt} ' other vars_model_groups=' num2str(group_color) '_' variables{v3} '_' ...
                harm_comp ' filter ' num2str(filter_on)];
                
            end
            for sv2 = [1 2 3 4 5 6 8 9 10]
                if sv2==sv
                    continue
                    %                 elseif strcmp(variables{v2}, 'wmo') || strcmp(variables{v2}, 'psl') || strcmp(variables{v2}, 'dissic_yr') || strcmp(variables{v2}, 'talk_yr') || strcmp(variables{v2}, 'thetao')
                    %                     continue
                end
                
                v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
                if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
                    v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
                end
                
                plot_index = plot_index+1;
                
                subplot(3,3,plot_index)
                
                hold on
                grid on
                
                %         legend_list = [];
                temp_array = [];
                temp_color = [];
                for m = 1:length(cmip_names.(variables{v}))
                    
                    
                    % find the matching model
                    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
                    
                    if sum(mod_match)>0
                        if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
                            
                            if group_color==1
                                plot_color = model_group_colors(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3},:);
                            elseif group_color==0
                                plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);
                                
                            end
                            
                            if group_color==0 || group_color==1
                            plot(obs.(variables{v}).(tests{qq})(m), obs.(variables{v2}).(tests{tt})(mod_match), '.', 'color', ...
                                plot_color, 'markersize', 20)
                            elseif group_color==2 % plotting color based on harmonic fit info
                                mod_match_2 = strcmp(cmip_names.(variables{v3}), cmip_names.(variables{v}){m});

                                if sum(mod_match_2)>0
                                    harm_diff = harm_mod.(variables{v3}).(harm_comp)(mod_match_2) - harm.(variables{v3}).(harm_comp); % difference in phase between model and obs
                                    
                                    scatter(obs.(variables{v}).(tests{qq})(m), obs.(variables{v2}).(tests{tt})(mod_match), 40, harm_diff, 'filled');
                                    c1 = colorbar;
                                    temp_color(end+1) = harm_diff;
                                else
                                    plot(obs.(variables{v}).(tests{qq})(m), obs.(variables{v2}).(tests{tt})(mod_match), 'o', 'color', ...
                                        'k', 'markersize', 7)
                                end
                                if plot_index==8
                                    ylabel(c1, ['Harmonic diff ' (variables{v3}) ' ' harm_comp])
                                end
                            end
                            %         legend_list = [legend_list ; {cmip_names.(variables{v}){m}}];
                            temp_array(end+1,1) = obs.(variables{v}).(tests{qq})(m);
                            temp_array(end,2) = obs.(variables{v2}).(tests{tt})(mod_match);
                            
                        end
                    end
                    clear plot_color
                end
                if group_color==2
                    c_lim = caxis;
%                     caxis([-max(abs(c_lim)) max(abs(c_lim))])
                    caxis([-nanstd(temp_color) nanstd(temp_color)]*1.5)
                end
                
                xlabel( [variables{v} ' ' tests{qq}], 'interpreter', 'none')
                ylabel([variables{v2} ' ' tests{tt}], 'interpreter', 'none')
                if filter_on==1
                    temp_array(temp_array(:,1)>3,1)=nan;
                    temp_array = temp_array(~isnan(temp_array(:,1)),:);
                    
                end
                
                [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
                x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
                y_plot = m.*x_plot+b;
                plot(x_plot, y_plot, 'k-')
                if filter_on==0
                    title(['r= ' num2str(r,2)])
                else
                    title(['filt r= ' num2str(r,2)])
                end
                if tt>1
                    plot(get(gca, 'xlim'), [1 1], '-k')
                end
                
                if tt==3
                    orig_y_lim = get(gca, 'ylim');
                    
                    if orig_y_lim(1)<0
                        orig_y_lim(1)=0;
                    end
                    
                    set(gca, 'ylim', orig_y_lim)
                end
                
                if tt==2
                    orig_y_lim = get(gca, 'ylim');
                    
                    if orig_y_lim(1)<-1
                        orig_y_lim(1)=-1;
                    end
                    if orig_y_lim(2)>1
                        orig_y_lim(2)=1;
                    end
                    
                    set(gca, 'ylim', orig_y_lim)
                end
                
                if qq>1
                    plot([1 1], get(gca, 'ylim'), '-k')
                end
            end
            if group_color==0 % only add the legend if plotting individual model colors
                subplot(3,3,9)
                hold on
                legend_names = {};
                
                for m = 1:length(cmip_names.fgco2)
                    if ~isempty(color_model{strcmp(cmip_names.fgco2{m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
                        
                        plot(0,0, '.', 'color', cmap(strcmp(cmip_names.fgco2{m}, color_model(:,1)),:), 'markersize', 25)
                        
                        legend_names{end+1,1} = cmip_names.fgco2{m};
                    end
                end
                l1 = legend(legend_names, 'numcolumns', 3, 'interpreter', 'none');
                leg_pos = get(l1, 'position');
                
                set(l1, 'position', leg_pos+[.07 0.02 0 0])
                
                % 				set(l1, 'interpreter', 'none', 'position', [0.8973    0.0801    0.1005    0.5704]);
            end
            %             subplot(3,3,9)
            %             hold on
            %             for m = 1:length(model_types)
            %                 plot(0,0, '.', 'color', model_group_colors(m,:), 'markersize', 25)
            %
            %             end
            %             if legend_on ==1
            
            %             end
            print(gcf, '-dpng', [Plot_out_dir variables{v} '/' plot_filename '_v8_test.png'])
        end
    end
end

%% Plotting variable seasonal cycles %%%%%%%%%%
% cmap = distinguishable_colors(20);
var_mean_lims = var_lims;

var_mean_lims(2,:) = [0 1200];
var_mean_lims(4,:) = [0 450];
var_mean_lims(5,:) = [-1 8.5];
var_mean_lims(6,:) = [33 34.5];
var_mean_lims(7,:) = [2070 2300];
var_mean_lims(8,:) = [2260 2440];
var_mean_lims(9,:) = [-250 250];
var_mean_lims(14,:) = [4e4 7.5e4];
var_mean_lims(15,:) = [-190 -100];

var_anom_lims(1,:) = [-30 25];
var_anom_lims(2,:) = [-600 900];
var_anom_lims(4,:) = [-150 300];
var_anom_lims(5,:) = [-2.6 3.5];
var_anom_lims(6,:) = [-.14 .14];

var_anom_lims(7,:) = [-45 45];
var_anom_lims(8,:) = [-15 15];
var_anom_lims(9,:) = [-350 350];
var_anom_lims(14,:) = [-6000 5000];
var_anom_lims(15,:) = [-40 40];


anomaly = 0;
if anomaly==1
    anomaly_text = 'anomaly ';
else
    anomaly_text=[];
end

sv =  9;
v = find(strncmp(seas_comp_vars{sv}, variables, 4));
if length(v)>1 % cludge since dissic and dissic_yr were getting confused
    v = strmatch(seas_comp_vars{sv}, variables, 'exact');
end

if strcmp(seas_comp_vars{sv}, 'fgco2_mol_C_m2_yr')
    seasonal_name = 'out_seasonal_mol_C_m2_yr';
else
    seasonal_name = 'out_seasonal';
end
plot_filename = ['Obs model Seasonal ' anomaly_text variables{v} '_v9'];
clf
set(gcf, 'units', 'inches')
paper_w = 14; paper_h =9;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

subplot(1,1,1)
hold on
legend_names = {};
for m =  1:length(cmip_names.(variables{v}))
    % [l, a] = boundedline(1:12, DIC_out_seasonal(m,:,1), DIC_out_seasonal(m,:,2));
    % a.FaceAlpha = 0.3;
    if anomaly==1
        plot(1:12, CMIP.(variables{v}).(seasonal_name)(m,:,1)-nanmean(CMIP.(variables{v}).(seasonal_name)(m,:,1)), 'color', cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:), 'linewidth', 3);
    else
        plot(1:12, CMIP.(variables{v}).(seasonal_name)(m,:,1), 'color', cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:), 'linewidth', 3);
    end
    
    legend_names{end+1,1} = cmip_names.(variables{v}){m};
end

if v==9
    if anomaly==1
        e1 = errorbar(1:12, obs.(seas_comp_vars{sv}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,1)-nanmean( obs.(seas_comp_vars{sv}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,1)), ...
            obs.(seas_comp_vars{sv}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 4, 'color', 'k', 'linestyle', '--');
    else
        e1 = errorbar(1:12, obs.(seas_comp_vars{sv}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,1), obs.(seas_comp_vars{sv}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 4, 'color', 'k', 'linestyle', '--');
    end
else
    if anomaly==1
        e1 = plot(1:12, obs.(seas_comp_vars{sv}).out_seasonal(:,1)-nanmean( obs.(seas_comp_vars{sv}).out_seasonal(:,1)), 'linewidth', 4, 'color', 'k', 'linestyle', '--');
    else
        e1 = plot(1:12, obs.(seas_comp_vars{sv}).out_seasonal(:,1), 'linewidth', 4, 'color', 'k', 'linestyle', '--');
    end
end

if strcmp(seas_comp_vars{sv}, 'fgco2_mol_C_m2_yr')
    ylabel([seas_comp_vars{sv} ' ' anomaly_text ' (mol C m-2 yr-1)'], 'interpreter', 'none')
    
else
    ylabel([seas_comp_vars{sv} ' ' anomaly_text ' (' (CMIP.(variables{v}).(cmip_names.(variables{v}){1}).units) ')'], 'interpreter', 'none')
end
xlabel('Month')
l1 = legend([legend_names ; 'Obs'], 'interpreter', 'none', 'location', 'eastoutside');
set(gca, 'fontsize', 18)
set(l1, 'fontsize', 10)
title(['Seasonal ' variables{v}])
% print(gcf, '-dtiff', [Plot_out_dir variables{v} '/' plot_filename '.tif'])
print(gcf, '-dpng', [Plot_out_dir seas_comp_vars{sv} '/' plot_filename '.png'])

% Separate seasonal plots by model group
clear m plot_filename

clf
set(gcf, 'units', 'inches')
paper_w = 14; paper_h =8;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

plot_filename = ['Obs model Seasonal ' anomaly_text '_' seas_comp_vars{sv} 'split_by_model_types_v9'];

for q = 1:length(model_types)
    
    
    subplot(2,2,q)
    hold on
    
    grid on; set(gca, 'gridalpha', .4)
    
    model_list = CMIP.(variables{v}).model_groups.(model_types{q});
    for m = 1: length(model_list)
        % [l, a] = boundedline(1:12, DIC_out_seasonal(m,:,1), DIC_out_seasonal(m,:,2));
        % a.FaceAlpha = 0.3;
        if anomaly==1
            plot(1:12, CMIP.(variables{v}).(seasonal_name)(model_list(m),:,1) - nanmean(CMIP.(variables{v}).(seasonal_name)(model_list(m),:,1)), ...
                'color', cmap(strcmp(cmip_names.(variables{v}){model_list(m)}, color_model(:,1)),:), 'linewidth', 2);
        else
            plot(1:12, CMIP.(variables{v}).(seasonal_name)(model_list(m),:,1), 'color', cmap(strcmp(cmip_names.(variables{v}){model_list(m)}, color_model(:,1)),:), 'linewidth', 2);
        end
    end
    
    if v==9
        if anomaly==1
            e1 = errorbar(1:12, obs.(seas_comp_vars{sv}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,1)-nanmean(obs.(seas_comp_vars{sv}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,1)), obs.(seas_comp_vars{sv}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
        else
            e1 = errorbar(1:12, obs.(seas_comp_vars{sv}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,1), obs.(seas_comp_vars{sv}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
        end
    else
        if anomaly==1
            e1 = plot(1:12, obs.(seas_comp_vars{sv}).out_seasonal(:,1)-nanmean(obs.(seas_comp_vars{sv}).out_seasonal(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
        else
            e1 = plot(1:12, obs.(seas_comp_vars{sv}).out_seasonal(:,1), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
        end
        
    end
    
    if strcmp(seas_comp_vars{sv}, 'fgco2_mol_C_m2_yr')
        ylabel([seas_comp_vars{sv} ' ' anomaly_text ' (mol C m-2 yr-1)'], 'interpreter', 'none')
        
    else
        ylabel([seas_comp_vars{sv} ' ' anomaly_text ' (' (CMIP.(variables{v}).(cmip_names.(variables{v}){1}).units) ')'], 'interpreter', 'none')
    end    %     xlabel('Month')
    set(gca, 'fontsize', 16)
    
    if strcmp(seas_comp_vars{sv}, 'fgco2_mol_C_m2_yr')
        
    elseif anomaly==1
        set(gca, 'ylim', var_anom_lims(v,:))
    else
        set(gca, 'ylim', var_mean_lims(v,:))
        
    end
    set(gca , 'xtick', [1 3 5 7 9 11])
    set(gca, 'xticklabel',{'Jan.', 'Mar.', 'May', 'July', 'Sept.', 'Nov.'} )
    
    l1 = legend([cmip_names.(variables{v})(model_list) ; 'Obs'], 'interpreter', 'none', 'location', 'eastoutside');
    set(l1, 'fontsize', 10)
    title(['Seasonal ' variables{v} ': ' model_types{q}], 'interpreter', 'none')
    
    % pause
    clear m
end
print(gcf, '-dpng', '-r300', [Plot_out_dir seas_comp_vars{sv} '/' plot_filename '.png'])
clear  plot_filename
%% Needed %% - fit a harmonic to data
clear harm
year_days = datenum(2012,1:12,15)-datenum(2012,1,0);
nharm=1;cutoff=10;L=365.25;

%% Fit Harmonics for all models
% year_days = datenum(2012,1:12,15)-datenum(2012,1,0);

for v = [7 5 1 8 15 6 4 2]
    harm_mod.(variables{v}).amp = NaN(length(cmip_names.(variables{v})),1);
    harm_mod.(variables{v}).phase = NaN(length(cmip_names.(variables{v})),1);
    harm_mod.(variables{v}).frac = NaN(length(cmip_names.(variables{v})),1);
    harm_mod.(variables{v}).offset = NaN(length(cmip_names.(variables{v})),1);
    harm_mod.(variables{v}).residual = NaN(length(cmip_names.(variables{v})),12);
    
    harm_mod.(variables{v}).seasonal_fit = NaN(length(cmip_names.(variables{v})), 12);
    
    for m = 1:length(cmip_names.(variables{v}))
        
        if ~isnan(CMIP.(variables{v}).out_seasonal(m,1,1))
            [harm_mod.(variables{v}).amp(m), harm_mod.(variables{v}).phase(m), harm_mod.(variables{v}).frac(m), harm_mod.(variables{v}).offset(m), harm_mod.(variables{v}).residual(m,:)]= ...
                fit_harmonics(CMIP.(variables{v}).out_seasonal(m,:,1), year_days, nharm, L, cutoff);
            
            % recreate the seasonal cycle from the initial harmonic fit
            yt = harm_mod.(variables{v}).offset(m).*ones(12,1);
            yt=yt+(harm_mod.(variables{v}).amp(m).*cos(2.*pi.*j.*[year_days]./L + harm_mod.(variables{v}).phase(m)))';
            
            harm_mod.(variables{v}).seasonal_fit(m,:) = yt;
            
        end
    end
end

%% Needed %% - creating a seasonal dic that is internally consistent with pCO2 and TALK 

[harm.spco2.amp,harm.spco2.phase,harm.spco2.frac,harm.spco2.offset,harm.spco2.residual]= ...
    fit_harmonics(obs.spco2.Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1), year_days, nharm, L, cutoff);

yt = harm.spco2.offset.*ones(12,1);
for j=1:nharm
    yt=yt+(harm.spco2.amp(j).*cos(2.*pi.*j.*[year_days]./L + harm.spco2.phase(j)))';
end
seasonal_pco2 = yt;


[harm.talk.amp,harm.talk.phase,harm.talk.frac,harm.talk.offset,harm.talk.residual]= ...
    fit_harmonics(obs.talk.out_seasonal(:,1,1), year_days, nharm, L, cutoff);

yt = harm.talk.offset.*ones(12,1);
for j=1:nharm
    yt=yt+(harm.talk.amp(j).*cos(2.*pi.*j.*[year_days]./L + harm.talk.phase(j)))';
end

seasonal_talk = yt;


[harm.tos.amp,harm.tos.phase,harm.tos.frac,harm.tos.offset,harm.tos.residual]= ...
    fit_harmonics(obs.tos.out_seasonal(:,1), year_days, nharm, L, cutoff);

yt = harm.tos.offset.*ones(12,1);
for j=1:nharm
    yt=yt+(harm.tos.amp(j).*cos(2.*pi.*j.*[year_days]./L + harm.tos.phase(j)))';
end

seasonal_tos = yt;


[harm.sos.amp,harm.sos.phase,harm.sos.frac,harm.sos.offset,harm.sos.residual]= ...
    fit_harmonics(obs.sos.out_seasonal(:,1), year_days, nharm, L, cutoff);

% [harm.DIC_Alk.amp,harm.DIC_Alk.phase,harm.DIC_Alk.frac,harm.DIC_Alk.offset,harm.DIC_Alk.residual]= ...
%     fit_harmonics(obs.DIC_Alk.out_seasonal(:,1), year_days, nharm, L, cutoff);



% Maybe undo this b/c of new way of doing things... to be seen

% because pCO2 is from mapping method and DIC/Talk are from obs, if we just
% used the harmonic fits as is then they would not be internally
% consistent.  This approach creates a seasonal dic that is consistent with
% pCO2 and Talk and has a correlation of 0.96, and amplitude ratio of 1.09
% and a normalized error of 0.29 to the original obs.dissic.out_seasonal
% record.  Seems like the best compromise.
SI= 5;
PO4=1.8;

[DATA,~,~]=CO2SYSSOCCOM_smb(seasonal_talk, ...
    seasonal_pco2, ...
    1,4, obs.sos.out_seasonal(:,1), seasonal_tos, seasonal_tos,...
    1,1,SI,PO4,1,10,3);
dic_from_pco2_alk = DATA(:,2);

[harm.dissic.amp,harm.dissic.phase,harm.dissic.frac,harm.dissic.offset,harm.dissic.residual]= ...
    fit_harmonics(dic_from_pco2_alk, year_days, nharm, L, cutoff);


[harm.mlotst.amp,harm.mlotst.phase,harm.mlotst.frac,harm.mlotst.offset,harm.mlotst.residual]= ...
    fit_harmonics(obs.mlotst.out_seasonal(:,1), year_days, nharm, L, cutoff);


[harm.intpp.amp,harm.intpp.phase,harm.intpp.frac,harm.intpp.offset,harm.intpp.residual]= ...
    fit_harmonics(obs.intpp.out_seasonal(:,1), year_days, nharm, L, cutoff);

clear j yt seasonal_pco2 seasonal_tos seasonal_talk dic_from_pco2_alk
%% Needed %% 2022_03_14 test plots for pCO2 tests

% recreate harmonic of obs DIC and T:
for v = [7 5 1 8 6 4]
    yt = harm.(variables{v}).offset.*ones(12,1);
    for j=1:nharm
        yt=yt+(harm.(variables{v}).amp(j).*cos(2.*pi.*j.*[year_days]./L + harm.(variables{v}).phase(j)))';
    end
    harm.(variables{v}).seasonal_fit = yt;
    clear yt
end
%% Sensitivity tests for individual models - can we fix models by adjusting certain parameters

dDICdT_lims = [-25 5];

for m = 1:length(cmip_names.spco2) % spco2 model number
    end_plot = 0;
    
    n_rows = 9;
    n_cols = 4;
    
    plot_filename = ['Sensitivity_tests_' cmip_names.spco2{m} '_v2'];
    
    % test_out_table = table(dissic_phase, dissic_amp);
    
    clf
    set(gcf, 'units', 'inches')
    paper_w = 12; paper_h =18;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    
    subplot_index = 0;
    
    clear modeled_var
    
    % check to see if models have required variables for this analysis:
    for v = [7 5 8 15 1 6]
        mod_match_index = strcmp(cmip_names.(variables{v}), cmip_names.spco2{m});
        
        if sum(mod_match_index)==0
            disp([cmip_names.spco2{m} ' missing ' variables{v}])
            end_plot = 1;
            break
        end
    end
    % check for end_plot being set to
    if end_plot==1
        continue
    end
    sn = NaN(n_cols,1);
    
    for v = [7 5 8 1 6] %[7 5 8 15 16 1 6]
        if v~=16
            mod_match_index = strcmp(cmip_names.(variables{v}), cmip_names.spco2{m});
        end
        if v~=6 % want to have Salinity seasonal cycle but not plot it
            subplot_index = subplot_index+1;
            
            sn(subplot_index) = subplot(n_rows,n_cols,subplot_index);
            
            if v==16
                continue
            end
            
            plot(obs.(variables{v}).out_seasonal(:,1,1)-nanmean(obs.(variables{v}).out_seasonal(:,1,1)), 'k-', 'linewidth', 2)
            hold on
            %         plot(harm.(variables{v}).seasonal_fit-nanmean(harm.(variables{v}).seasonal_fit),
            %         'g-', 'linewidth', 2) % plotting harmonic fit if you decide to go
            %         that way instead of original mean obs
            
            plot(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1) - nanmean(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1)), 'b', 'linewidth', 2)
            
            title(variables{v})
            
        end
        % plot harmonic fits :
        % DIC timing (phase):
        
        phase_adjust = 1;
        amp_adjust = 1;
        offset_adjust = 0;
        % rebuild
        
        yt = harm_mod.(variables{v}).offset(mod_match_index).*ones(12,1)+offset_adjust;
        
        modeled_var.(variables{v}) =yt+(harm_mod.(variables{v}).amp(mod_match_index).*amp_adjust.*cos(2.*pi.*j.*[year_days]./L + harm_mod.(variables{v}).phase(mod_match_index).*phase_adjust))';
        
        if v==6 && strncmp(cmip_names.spco2{m}, 'CESM1_BGC', 8)
            modeled_var.(variables{v}) = harm.sos.seasonal_fit;
        end
        
        if v~=6
            plot(modeled_var.(variables{v}) - nanmean(modeled_var.(variables{v})), 'b--', 'linewidth', 2)
        end
        
        if subplot_index==1
            y_lim = get(gca, 'ylim');
            
            text( -5, y_lim(2)+10, cmip_names.spco2{m}, 'interpreter', 'none', 'fontweight', 'bold')
        end
    end
    
    % recalculate pCO2 based on harmonic fits for dic and alk
    
    [DATA,~,~]=CO2SYSSOCCOM_smb(modeled_var.talk, ...
        modeled_var.dissic, ...
        1,2, modeled_var.sos, modeled_var.tos, modeled_var.tos,...
        1,1,SI,PO4,1,10,3);
    pco2_test = DATA(:,4);
    
    
    %     plot(pco2_test - nanmean(pco2_test), 'r-', 'linewidth', 2) %
    %     commenting out first pco2_test plot, since it is confusing
    % taylor calc on pco2_test
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1),pco2_test);
    y_lim = get(gca, 'ylim');
    text(2, y_lim(1)+4, ['E: ' num2str(test_out.norm_error, 2) '; C: ' num2str(test_out.correlation, 2) '; R: ' num2str(test_out.ratio, 2)], 'fontsize', 12, 'fontweight', 'bold')
    clear pco2_test
    
    %     % plot delta dic/delta t
    %     plot(sn(5), diff(harm.dissic.seasonal_fit)./diff(harm.tos.seasonal_fit), 'k', 'linewidth', 2)
    %     hold(sn(5), 'on')
    %
    %     title(sn(5), 'dDIC/dT')
    %     plot(sn(5), diff(modeled_var.dissic)./diff(modeled_var.tos), 'b--', 'linewidth', 2)
    %     set(sn(subplot_index-1), 'ylim', dDICdT_lims);
    
    % tests:
    % difference between model and real phase, can just look at difference?
    % DIC phase adjustment
    modeled_var.adjust = [];
    v = 7;
    
    mod_match_index = strcmp(cmip_names.(variables{v}), cmip_names.spco2{m});
    
    offset_adjust = 0;
    phase_shift = harm_mod.(variables{v}).phase(mod_match_index) - harm.(variables{v}).phase;
    
    phase_shift_days = phase_shift.*365.25./(2*pi);
    amp_adjust = 1;
    
    yt = harm_mod.(variables{v}).offset(mod_match_index).*ones(12,1)+offset_adjust;
    
    modeled_var.adjust.(variables{v}) =yt+(harm_mod.(variables{v}).amp(mod_match_index).*amp_adjust.*cos(2.*pi.*j.*[year_days]./L + (harm_mod.(variables{v}).phase(mod_match_index)-phase_shift)))';
    
    [DATA,~,~]=CO2SYSSOCCOM_smb(modeled_var.talk, ...
        modeled_var.adjust.dissic, ...
        1,2, modeled_var.sos, modeled_var.tos, modeled_var.tos,...
        1,1,SI,PO4,1,10,3);
    pco2_test = DATA(:,4);
    
    modeled_var.adjust.DIC_Alk = modeled_var.adjust.dissic - modeled_var.talk;
    modeled_var.adjust.spco2 = pco2_test;
    
    
    for v = [7 5 8 1]% [7 5 8 15 16 1]
        
        if v~=6 % want to have Salinity seasonal cycle but not plot it
            subplot_index = subplot_index+1;
            sn(subplot_index) = subplot(n_rows,n_cols,subplot_index);
            
            if v==16
                continue
            end
            
            plot(obs.(variables{v}).out_seasonal(:,1,1)-nanmean(obs.(variables{v}).out_seasonal(:,1,1)), 'k-', 'linewidth', 2)
            
            
            hold on
            
            %         plot(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1) - nanmean(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1)), 'b', 'linewidth', 2)
            
            title(variables{v})
            
        end
        
        plot(modeled_var.(variables{v}) - nanmean(modeled_var.(variables{v})), 'b--', 'linewidth', 2)
        
        
        if v==7
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
            title([num2str(phase_shift_days,2), ' days'])
        elseif v==15
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
        end
    end
    
    plot(modeled_var.adjust.spco2 - nanmean(modeled_var.adjust.spco2), 'r-', 'linewidth', 2)
    % taylor calc on pco2_test
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1),pco2_test);
    y_lim = get(gca, 'ylim');
    text(2, y_lim(1)+4, ['E: ' num2str(test_out.norm_error, 2) '; C: ' num2str(test_out.correlation, 2) '; R: ' num2str(test_out.ratio, 2)], 'fontsize', 12, 'fontweight', 'bold')
    clear pco2_test
    
    %     % plot delta dic/delta t
    %     plot(sn(subplot_index - 1), diff(harm.dissic.seasonal_fit)./diff(harm.tos.seasonal_fit), 'k', 'linewidth', 2)
    %     hold(sn(subplot_index - 1), 'on')
    %
    %     title(sn(subplot_index - 1), 'dDIC/dT')
    %     plot(sn(subplot_index - 1), diff(modeled_var.dissic)./diff(modeled_var.tos), 'b--', 'linewidth', 2)
    %
    %     plot(sn(subplot_index - 1), diff(modeled_var.adjust.dissic)./diff(modeled_var.tos), 'r-', 'linewidth', 2)
    %     set(sn(subplot_index-1), 'ylim', dDICdT_lims);
    %
    %
    
    % difference between model and real phase, can just look at difference?
    % DIC amplitude adjustment
    modeled_var.adjust = [];
    v = 7;
    
    mod_match_index = strcmp(cmip_names.(variables{v}), cmip_names.spco2{m});
    
    offset_adjust = 0;
    phase_shift = 0;
    
    % phase_shift_days = phase_shift.*365.25./(2*pi);
    amp_shift = harm_mod.(variables{v}).amp(mod_match_index) - harm.(variables{v}).amp;
    
    yt = harm_mod.(variables{v}).offset(mod_match_index).*ones(12,1)+offset_adjust;
    
    modeled_var.adjust.(variables{v}) =yt+((harm_mod.(variables{v}).amp(mod_match_index)-amp_shift).*cos(2.*pi.*j.*[year_days]./L + (harm_mod.(variables{v}).phase(mod_match_index)-phase_shift)))';
    
    [DATA,~,~]=CO2SYSSOCCOM_smb(modeled_var.talk, ...
        modeled_var.adjust.dissic, ...
        1,2, modeled_var.sos, modeled_var.tos, modeled_var.tos,...
        1,1,SI,PO4,1,10,3);
    pco2_test = DATA(:,4);
    
    modeled_var.adjust.DIC_Alk = modeled_var.adjust.dissic - modeled_var.talk;
    modeled_var.adjust.spco2 = pco2_test;
    
    for v = [7 5 8 1]% [7 5 8 15 16 1]
        
        if v~=6 % want to have Salinity seasonal cycle but not plot it
            subplot_index = subplot_index+1;
            sn(subplot_index) = subplot(n_rows,n_cols,subplot_index);
            
            if v==16
                continue
            end
            
            plot(obs.(variables{v}).out_seasonal(:,1,1)-nanmean(obs.(variables{v}).out_seasonal(:,1,1)), 'k-', 'linewidth', 2)
            
            hold on
            
            %         plot(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1) - nanmean(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1)), 'b', 'linewidth', 2)
            
            title(variables{v})
            
        end
        plot(modeled_var.(variables{v}) - nanmean(modeled_var.(variables{v})), 'b--', 'linewidth', 2)
        
        if v==7
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
            title([num2str(amp_shift,2), ' umol/kg'])
        elseif v==15
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
        end
    end
    plot(modeled_var.adjust.spco2 - nanmean(modeled_var.adjust.spco2), 'r-', 'linewidth', 2)
    % taylor calc on pco2_test
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1),pco2_test);
    y_lim = get(gca, 'ylim');
    text(2, y_lim(1)+4, ['E: ' num2str(test_out.norm_error, 2) '; C: ' num2str(test_out.correlation, 2) '; R: ' num2str(test_out.ratio, 2)], 'fontsize', 12, 'fontweight', 'bold')
    clear pco2_test
    %
    %     % plot delta dic/delta t
    %     plot(sn(subplot_index - 1), diff(harm.dissic.seasonal_fit)./diff(harm.tos.seasonal_fit), 'k', 'linewidth', 2)
    %     hold(sn(subplot_index - 1), 'on')
    %
    %     title(sn(subplot_index - 1), 'dDIC/dT')
    %     plot(sn(subplot_index - 1), diff(modeled_var.dissic)./diff(modeled_var.tos), 'b--', 'linewidth', 2)
    %
    %     plot(sn(subplot_index - 1), diff(modeled_var.adjust.dissic)./diff(modeled_var.tos), 'r-', 'linewidth', 2)
    %     set(sn(subplot_index-1), 'ylim', dDICdT_lims);
    %
    
    % DIC amplitude and phase adjustment together
    modeled_var.adjust = [];
    v = 7;
    
    mod_match_index = strcmp(cmip_names.(variables{v}), cmip_names.spco2{m});
    
    offset_adjust = 0;
    phase_shift = harm_mod.(variables{v}).phase(mod_match_index) - harm.(variables{v}).phase;
    
    phase_shift_days = phase_shift.*365.25./(2*pi);
    amp_shift = harm_mod.(variables{v}).amp(mod_match_index) - harm.(variables{v}).amp;
    
    yt = harm_mod.(variables{v}).offset(mod_match_index).*ones(12,1)+offset_adjust;
    
    modeled_var.adjust.(variables{v}) =yt+((harm_mod.(variables{v}).amp(mod_match_index)-amp_shift).*cos(2.*pi.*j.*[year_days]./L + (harm_mod.(variables{v}).phase(mod_match_index)-phase_shift)))';
    
    [DATA,~,~]=CO2SYSSOCCOM_smb(modeled_var.talk, ...
        modeled_var.adjust.dissic, ...
        1,2, modeled_var.sos, modeled_var.tos, modeled_var.tos,...
        1,1,SI,PO4,1,10,3);
    pco2_test = DATA(:,4);
    
    modeled_var.adjust.DIC_Alk = modeled_var.adjust.dissic - modeled_var.talk;
    modeled_var.adjust.spco2 = pco2_test;
    
    
    for v = [7 5 8 1]% [7 5 8 15 16 1]
        
        if v~=6 % want to have Salinity seasonal cycle but not plot it
            subplot_index = subplot_index+1;
            sn(subplot_index) = subplot(n_rows,n_cols,subplot_index);
            
            if v==16
                continue
            end
            
            plot(obs.(variables{v}).out_seasonal(:,1,1)-nanmean(obs.(variables{v}).out_seasonal(:,1,1)), 'k-', 'linewidth', 2)
            
            
            hold on
            
            %         plot(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1) - nanmean(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1)), 'b', 'linewidth', 2)
            
            title(variables{v})
            
        end
        plot(modeled_var.(variables{v}) - nanmean(modeled_var.(variables{v})), 'b--', 'linewidth', 2)
        
        if v==7
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
            title([num2str(phase_shift_days,2), ' days and ' num2str(amp_shift,2), ' umol/kg'])
        elseif v==15
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
        end
    end
    plot(modeled_var.adjust.spco2 - nanmean(modeled_var.adjust.spco2), 'r-', 'linewidth', 2)
    % taylor calc on pco2_test
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1),pco2_test);
    y_lim = get(gca, 'ylim');
    text(2, y_lim(1)+4, ['E: ' num2str(test_out.norm_error, 2) '; C: ' num2str(test_out.correlation, 2) '; R: ' num2str(test_out.ratio, 2)], 'fontsize', 12, 'fontweight', 'bold')
    clear pco2_test
    
    %
    %     % plot delta dic/delta t
    %     plot(sn(subplot_index - 1), diff(harm.dissic.seasonal_fit)./diff(harm.tos.seasonal_fit), 'k', 'linewidth', 2)
    %     hold(sn(subplot_index - 1), 'on')
    %
    %     title(sn(subplot_index - 1), 'dDIC/dT')
    %     plot(sn(subplot_index - 1), diff(modeled_var.dissic)./diff(modeled_var.tos), 'b--', 'linewidth', 2)
    %
    %     plot(sn(subplot_index - 1), diff(modeled_var.adjust.dissic)./diff(modeled_var.tos), 'r-', 'linewidth', 2)
    %     set(sn(subplot_index-1), 'ylim', dDICdT_lims);
    %
    
    % TOS amplitude adjustment
    modeled_var.adjust = [];
    v = 5;
    
    mod_match_index = strcmp(cmip_names.(variables{v}), cmip_names.spco2{m});
    
    offset_adjust = 0;
    phase_shift = 0;
    
    % phase_shift_days = phase_shift.*365.25./(2*pi);
    amp_shift = harm_mod.(variables{v}).amp(mod_match_index) - harm.(variables{v}).amp;
    
    yt = harm_mod.(variables{v}).offset(mod_match_index).*ones(12,1)+offset_adjust;
    
    modeled_var.adjust.(variables{v}) =yt+((harm_mod.(variables{v}).amp(mod_match_index)-amp_shift).*cos(2.*pi.*j.*[year_days]./L + (harm_mod.(variables{v}).phase(mod_match_index)-phase_shift)))';
    
    [DATA,~,~]=CO2SYSSOCCOM_smb(modeled_var.talk, ...
        modeled_var.dissic, ...
        1,2, modeled_var.sos, modeled_var.adjust.tos, modeled_var.adjust.tos,...
        1,1,SI,PO4,1,10,3);
    pco2_test = DATA(:,4);
    
    % modeled_var.adjust.DIC_Alk = modeled_var.adjust.dissic - modeled_var.talk;
    modeled_var.adjust.spco2 = pco2_test;
    
    
    for v = [7 5 8 1]% [7 5 8 15 16 1]
        
        if v~=6 % want to have Salinity seasonal cycle but not plot it
            subplot_index = subplot_index+1;
            sn(subplot_index) = subplot(n_rows,n_cols,subplot_index);
            
            if v==16
                continue
            end
            
            plot(obs.(variables{v}).out_seasonal(:,1,1)-nanmean(obs.(variables{v}).out_seasonal(:,1,1)), 'k-', 'linewidth', 2)
            
            
            hold on
            
            %         plot(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1) - nanmean(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1)), 'b', 'linewidth', 2)
            
            title(variables{v})
            
        end
        plot(modeled_var.(variables{v}) - nanmean(modeled_var.(variables{v})), 'b--', 'linewidth', 2)
        
        if v==5
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
            title([num2str(amp_shift,2), ' \circC'])
        end
    end
    plot(modeled_var.adjust.spco2 - nanmean(modeled_var.adjust.spco2), 'r-', 'linewidth', 2)
    
    
    % taylor calc on pco2_test
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1),pco2_test);
    y_lim = get(gca, 'ylim');
    text(2, y_lim(1)+4, ['E: ' num2str(test_out.norm_error, 2) '; C: ' num2str(test_out.correlation, 2) '; R: ' num2str(test_out.ratio, 2)], 'fontsize', 12, 'fontweight', 'bold')
    clear pco2_test
    
    
    %     % plot delta dic/delta t
    %     plot(sn(subplot_index - 1), diff(harm.dissic.seasonal_fit)./diff(harm.tos.seasonal_fit), 'k', 'linewidth', 2)
    %     hold(sn(subplot_index - 1), 'on')
    %
    %     title(sn(subplot_index - 1), 'dDIC/dT')
    %     plot(sn(subplot_index - 1), diff(modeled_var.dissic)./diff(modeled_var.tos), 'b--', 'linewidth', 2)
    %
    %     plot(sn(subplot_index - 1), diff(modeled_var.dissic)./diff(modeled_var.adjust.tos), 'r-', 'linewidth', 2)
    %     set(sn(subplot_index-1), 'ylim', dDICdT_lims);
    
    
    % DIC amplitude, phase and TOS amplitude adjustment together
    modeled_var.adjust = [];
    % DIC amp and phase
    v = 7;
    
    mod_match_index = strcmp(cmip_names.(variables{v}), cmip_names.spco2{m});
    
    offset_adjust = 0;
    phase_shift = harm_mod.(variables{v}).phase(mod_match_index) - harm.(variables{v}).phase;
    % phase_shift = 0;
    
    phase_shift_days = phase_shift.*365.25./(2*pi);
    amp_shift(v) = harm_mod.(variables{v}).amp(mod_match_index) - harm.(variables{v}).amp;
    
    yt = harm_mod.(variables{v}).offset(mod_match_index).*ones(12,1)+offset_adjust;
    
    modeled_var.adjust.(variables{v}) =yt+((harm_mod.(variables{v}).amp(mod_match_index)-amp_shift(v)).*cos(2.*pi.*j.*[year_days]./L + (harm_mod.(variables{v}).phase(mod_match_index)-phase_shift)))';
    
    % TOS amp
    v = 5;
    
    mod_match_index = strcmp(cmip_names.(variables{v}), cmip_names.spco2{m});
    
    offset_adjust = 0;
    phase_shift = 0;
    
    % phase_shift_days = phase_shift.*365.25./(2*pi);
    amp_shift(v) = harm_mod.(variables{v}).amp(mod_match_index) - harm.(variables{v}).amp;
    
    yt = harm_mod.(variables{v}).offset(mod_match_index).*ones(12,1)+offset_adjust;
    
    modeled_var.adjust.(variables{v}) =yt+((harm_mod.(variables{v}).amp(mod_match_index)-amp_shift(v)).*cos(2.*pi.*j.*[year_days]./L + (harm_mod.(variables{v}).phase(mod_match_index)-phase_shift)))';
    
    
    [DATA,~,~]=CO2SYSSOCCOM_smb(modeled_var.talk, ...
        modeled_var.adjust.dissic, ...
        1,2, modeled_var.sos, modeled_var.adjust.tos, modeled_var.adjust.tos,...
        1,1,SI,PO4,1,10,3);
    pco2_test = DATA(:,4);
    
    modeled_var.adjust.DIC_Alk = modeled_var.adjust.dissic - modeled_var.talk;
    modeled_var.adjust.spco2 = pco2_test;
    
    
    for v = [7 5 8 1]% [7 5 8 15 16 1]
        
        if v~=6 % want to have Salinity seasonal cycle but not plot it
            subplot_index = subplot_index+1;
            sn(subplot_index) = subplot(n_rows,n_cols,subplot_index);
            
            if v==16
                continue
            end
            
            plot(obs.(variables{v}).out_seasonal(:,1,1)-nanmean(obs.(variables{v}).out_seasonal(:,1,1)), 'k-', 'linewidth', 2)
            
            
            hold on
            
            %         plot(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1) - nanmean(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1)), 'b', 'linewidth', 2)
            
            title(variables{v})
            
        end
        plot(modeled_var.(variables{v}) - nanmean(modeled_var.(variables{v})), 'b--', 'linewidth', 2)
        
        if v==7
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
            title([num2str(phase_shift_days,2), ' days and ' num2str(amp_shift(v),2), ' umol/kg'])
        elseif v==5
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
            title([num2str(amp_shift(v),2), ' \circC'])
            
        elseif v==15
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
        end
    end
    plot(modeled_var.adjust.spco2 - nanmean(modeled_var.adjust.spco2), 'r-', 'linewidth', 2)
    % taylor calc on pco2_test
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1),pco2_test);
    y_lim = get(gca, 'ylim');
    text(2, y_lim(1)+4, ['E: ' num2str(test_out.norm_error, 2) '; C: ' num2str(test_out.correlation, 2) '; R: ' num2str(test_out.ratio, 2)], 'fontsize', 12, 'fontweight', 'bold')
    clear pco2_test
    
    
    %     % plot delta dic/delta t
    %     plot(sn(subplot_index - 1), diff(harm.dissic.seasonal_fit)./diff(harm.tos.seasonal_fit), 'k', 'linewidth', 2)
    %     hold(sn(subplot_index - 1), 'on')
    %
    %     title(sn(subplot_index - 1), 'dDIC/dT')
    %     plot(sn(subplot_index - 1), diff(modeled_var.dissic)./diff(modeled_var.tos), 'b--', 'linewidth', 2)
    %
    %     plot(sn(subplot_index - 1), diff(modeled_var.adjust.dissic)./diff(modeled_var.adjust.tos), 'r-', 'linewidth', 2)
    %     set(sn(subplot_index-1), 'ylim', dDICdT_lims);
    
    
    % Alk phase adjustment
    modeled_var.adjust = [];
    v = 8;
    
    mod_match_index = strcmp(cmip_names.(variables{v}), cmip_names.spco2{m});
    
    offset_adjust = 0;
    phase_shift = harm_mod.(variables{v}).phase(mod_match_index) - harm.(variables{v}).phase;
    
    phase_shift_days = phase_shift.*365.25./(2*pi);
    amp_adjust = 1;
    
    yt = harm_mod.(variables{v}).offset(mod_match_index).*ones(12,1)+offset_adjust;
    
    modeled_var.adjust.(variables{v}) =yt+(harm_mod.(variables{v}).amp(mod_match_index).*amp_adjust.*cos(2.*pi.*j.*[year_days]./L + (harm_mod.(variables{v}).phase(mod_match_index)-phase_shift)))';
    
    [DATA,~,~]=CO2SYSSOCCOM_smb(modeled_var.adjust.talk, ...
        modeled_var.dissic, ...
        1,2, modeled_var.sos, modeled_var.tos, modeled_var.tos,...
        1,1,SI,PO4,1,10,3);
    pco2_test = DATA(:,4);
    
    modeled_var.adjust.DIC_Alk = modeled_var.dissic - modeled_var.adjust.talk;
    modeled_var.adjust.spco2 = pco2_test;
    
    
    for v = [7 5 8 1]% [7 5 8 15 16 1]
        
        if v~=6 % want to have Salinity seasonal cycle but not plot it
            subplot_index = subplot_index+1;
            sn(subplot_index) = subplot(n_rows,n_cols,subplot_index);
            
            if v==16
                continue
            end
            
            
            plot(obs.(variables{v}).out_seasonal(:,1,1)-nanmean(obs.(variables{v}).out_seasonal(:,1,1)), 'k-', 'linewidth', 2)
            
            
            hold on
            
            %         plot(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1) - nanmean(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1)), 'b', 'linewidth', 2)
            
            title(variables{v})
            
        end
        
        plot(modeled_var.(variables{v}) - nanmean(modeled_var.(variables{v})), 'b--', 'linewidth', 2)
        
        
        if v==8
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
            title([num2str(phase_shift_days,2), ' days'])
        elseif v==15
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
        end
    end
    plot(modeled_var.adjust.spco2 - nanmean(modeled_var.adjust.spco2), 'r-', 'linewidth', 2)
    
    % taylor calc on pco2_test
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1),pco2_test);
    y_lim = get(gca, 'ylim');
    text(2, y_lim(1)+4, ['E: ' num2str(test_out.norm_error, 2) '; C: ' num2str(test_out.correlation, 2) '; R: ' num2str(test_out.ratio, 2)], 'fontsize', 12, 'fontweight', 'bold')
    clear pco2_test
    
    %     % plot delta dic/delta t
    %     plot(sn(subplot_index - 1), diff(harm.dissic.seasonal_fit)./diff(harm.tos.seasonal_fit), 'k', 'linewidth', 2)
    %     hold(sn(subplot_index - 1), 'on')
    %
    %     title(sn(subplot_index - 1), 'dDIC/dT')
    %     plot(sn(subplot_index - 1), diff(modeled_var.dissic)./diff(modeled_var.tos), 'b--', 'linewidth', 2)
    %
    %     % plot(sn(subplot_index - 1), diff(modeled_var.adjust.dissic)./diff(modeled_var.tos), 'r-', 'linewidth', 2)
    %     set(sn(subplot_index-1), 'ylim', dDICdT_lims);
    %
    
    % Alk amplitude adjustment
    modeled_var.adjust = [];
    v = 8;
    
    mod_match_index = strcmp(cmip_names.(variables{v}), cmip_names.spco2{m});
    
    offset_adjust = 0;
    phase_shift = 0;
    
    % phase_shift_days = phase_shift.*365.25./(2*pi);
    amp_shift = harm_mod.(variables{v}).amp(mod_match_index) - harm.(variables{v}).amp;
    
    yt = harm_mod.(variables{v}).offset(mod_match_index).*ones(12,1)+offset_adjust;
    
    modeled_var.adjust.(variables{v}) =yt+((harm_mod.(variables{v}).amp(mod_match_index)-amp_shift).*cos(2.*pi.*j.*[year_days]./L + (harm_mod.(variables{v}).phase(mod_match_index)-phase_shift)))';
    
    [DATA,~,~]=CO2SYSSOCCOM_smb(modeled_var.adjust.talk, ...
        modeled_var.dissic, ...
        1,2, modeled_var.sos, modeled_var.tos, modeled_var.tos,...
        1,1,SI,PO4,1,10,3);
    pco2_test = DATA(:,4);
    
    modeled_var.adjust.DIC_Alk = modeled_var.dissic - modeled_var.adjust.talk;
    modeled_var.adjust.spco2 = pco2_test;
    
    
    for v = [7 5 8 1]% [7 5 8 15 16 1]
        
        if v~=6 % want to have Salinity seasonal cycle but not plot it
            subplot_index = subplot_index+1;
            sn(subplot_index) = subplot(n_rows,n_cols,subplot_index);
            
            if v==16
                continue
            end
            
            plot(obs.(variables{v}).out_seasonal(:,1,1)-nanmean(obs.(variables{v}).out_seasonal(:,1,1)), 'k-', 'linewidth', 2)
            
            
            hold on
            
            %         plot(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1) - nanmean(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1)), 'b', 'linewidth', 2)
            
            title(variables{v})
            
        end
        plot(modeled_var.(variables{v}) - nanmean(modeled_var.(variables{v})), 'b--', 'linewidth', 2)
        
        if v==8
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
            title([num2str(amp_shift,2), ' umol/kg'])
        elseif v==15
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
        end
    end
    plot(modeled_var.adjust.spco2 - nanmean(modeled_var.adjust.spco2), 'r-', 'linewidth', 2)
    % taylor calc on pco2_test
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1),pco2_test);
    y_lim = get(gca, 'ylim');
    text(2, y_lim(1)+4, ['E: ' num2str(test_out.norm_error, 2) '; C: ' num2str(test_out.correlation, 2) '; R: ' num2str(test_out.ratio, 2)], 'fontsize', 12, 'fontweight', 'bold')
    clear pco2_test
    
    %     % plot delta dic/delta t
    %     plot(sn(subplot_index - 1), diff(harm.dissic.seasonal_fit)./diff(harm.tos.seasonal_fit), 'k', 'linewidth', 2)
    %     hold(sn(subplot_index - 1), 'on')
    %
    %     title(sn(subplot_index - 1), 'dDIC/dT')
    %     plot(sn(subplot_index - 1), diff(modeled_var.dissic)./diff(modeled_var.tos), 'b--', 'linewidth', 2)
    %
    %     % plot(sn(subplot_index - 1), diff(modeled_var.adjust.dissic)./diff(modeled_var.tos), 'r-', 'linewidth', 2)
    %     set(sn(subplot_index-1), 'ylim', dDICdT_lims);
    
    
    % DIC amplitude, phase TOS amplitude, % Alk phase, amp adjustment all together
    modeled_var.adjust = [];
    % DIC amp and phase
    v = 7;
    
    mod_match_index = strcmp(cmip_names.(variables{v}), cmip_names.spco2{m});
    
    offset_adjust = 0;
    phase_shift = harm_mod.(variables{v}).phase(mod_match_index) - harm.(variables{v}).phase;
    % phase_shift = 0;
    
    phase_shift_days(v) = phase_shift.*365.25./(2*pi);
    amp_shift(v) = harm_mod.(variables{v}).amp(mod_match_index) - harm.(variables{v}).amp;
    
    yt = harm_mod.(variables{v}).offset(mod_match_index).*ones(12,1)+offset_adjust;
    
    modeled_var.adjust.(variables{v}) =yt+((harm_mod.(variables{v}).amp(mod_match_index)-amp_shift(v)).*cos(2.*pi.*j.*[year_days]./L + (harm_mod.(variables{v}).phase(mod_match_index)-phase_shift)))';
    
    % TOS amp
    v = 5;
    
    mod_match_index = strcmp(cmip_names.(variables{v}), cmip_names.spco2{m});
    
    offset_adjust = 0;
    phase_shift = 0;
    
    % phase_shift_days = phase_shift.*365.25./(2*pi);
    amp_shift(v) = harm_mod.(variables{v}).amp(mod_match_index) - harm.(variables{v}).amp;
    
    yt = harm_mod.(variables{v}).offset(mod_match_index).*ones(12,1)+offset_adjust;
    
    modeled_var.adjust.(variables{v}) =yt+((harm_mod.(variables{v}).amp(mod_match_index)-amp_shift(v)).*cos(2.*pi.*j.*[year_days]./L + (harm_mod.(variables{v}).phase(mod_match_index)-phase_shift)))';
    
    % Talk amp and phase
    v = 8;
    
    mod_match_index = strcmp(cmip_names.(variables{v}), cmip_names.spco2{m});
    
    offset_adjust = 0;
    phase_shift = harm_mod.(variables{v}).phase(mod_match_index) - harm.(variables{v}).phase;
    % phase_shift = 0;
    
    phase_shift_days(v) = phase_shift.*365.25./(2*pi);
    amp_shift(v) = harm_mod.(variables{v}).amp(mod_match_index) - harm.(variables{v}).amp;
    
    yt = harm_mod.(variables{v}).offset(mod_match_index).*ones(12,1)+offset_adjust;
    
    modeled_var.adjust.(variables{v}) =yt+((harm_mod.(variables{v}).amp(mod_match_index)-amp_shift(v)).*cos(2.*pi.*j.*[year_days]./L + (harm_mod.(variables{v}).phase(mod_match_index)-phase_shift)))';
    
    
    [DATA,~,~]=CO2SYSSOCCOM_smb(modeled_var.adjust.talk, ...
        modeled_var.adjust.dissic, ...
        1,2, modeled_var.sos, modeled_var.adjust.tos, modeled_var.adjust.tos,...
        1,1,SI,PO4,1,10,3);
    pco2_test = DATA(:,4);
    
    modeled_var.adjust.DIC_Alk = modeled_var.adjust.dissic - modeled_var.talk;
    modeled_var.adjust.spco2 = pco2_test;
    
    
    for v = [7 5 8 1]% [7 5 8 15 16 1]
        
        if v~=6 % want to have Salinity seasonal cycle but not plot it
            subplot_index = subplot_index+1;
            sn(subplot_index) = subplot(n_rows,n_cols,subplot_index);
            
            if v==16
                continue
            end
            
            plot(obs.(variables{v}).out_seasonal(:,1,1)-nanmean(obs.(variables{v}).out_seasonal(:,1,1)), 'k-', 'linewidth', 2)
            
            
            hold on
            
            %         plot(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1) - nanmean(CMIP.(variables{v}).out_seasonal(mod_match_index,:,1)), 'b', 'linewidth', 2)
            
            title(variables{v})
            
        end
        plot(modeled_var.(variables{v}) - nanmean(modeled_var.(variables{v})), 'b--', 'linewidth', 2)
        
        if v==7
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
            title([num2str(phase_shift_days(v),2), ' days and ' num2str(amp_shift(v),2), ' umol/kg'])
        elseif v==5
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
            title([num2str(amp_shift(v),2), ' \circC'])
        elseif v==8
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
            title([num2str(phase_shift_days(v),2), ' days and ' num2str(amp_shift(v),2), ' umol/kg'])
        elseif v==15
            plot(modeled_var.adjust.(variables{v}) - nanmean(modeled_var.adjust.(variables{v})), 'r-', 'linewidth', 2)
        end
    end
    plot(modeled_var.adjust.spco2 - nanmean(modeled_var.adjust.spco2), 'r-', 'linewidth', 2)
    % taylor calc on pco2_test
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1),pco2_test);
    y_lim = get(gca, 'ylim');
    text(2, y_lim(1)+4, ['E: ' num2str(test_out.norm_error, 2) '; C: ' num2str(test_out.correlation, 2) '; R: ' num2str(test_out.ratio, 2)], 'fontsize', 12, 'fontweight', 'bold')
    clear pco2_test
    
    
    %     % plot delta dic/delta t
    %     plot(sn(subplot_index - 1), diff(harm.dissic.seasonal_fit)./diff(harm.tos.seasonal_fit), 'k', 'linewidth', 2)
    %     hold(sn(subplot_index - 1), 'on')
    %
    %     title(sn(subplot_index - 1), 'dDIC/dT')
    %     plot(sn(subplot_index - 1), diff(modeled_var.dissic)./diff(modeled_var.tos), 'b--', 'linewidth', 2)
    %
    %     plot(sn(subplot_index - 1), diff(modeled_var.adjust.dissic)./diff(modeled_var.adjust.tos), 'r-', 'linewidth', 2)
    %     set(sn(subplot_index-1), 'ylim', dDICdT_lims);
    %
    %
    
    print(gcf, '-dpdf', [Plot_out_dir 'Sensitivity_tests/' plot_filename])
end

%% Needed %% Parallel attempt: Starting from correct model, recalculating pCO2 for different test cases 
% clf
% idealized_test_out = table;
tic
% clear test_data adjust
test_index = 0;
var_list = [7 5 8 6];
v1 = 7;
v2 = 5;
v3 = 8;
v4 = 6;

% test_data_start = NaN(length(var_list),12);
% 
% test_data_start_dissic = harm.(variables{7}).seasonal_fit;
% test_data_start_talk = harm.(variables{8}).seasonal_fit;
% test_data_start_tos = harm.(variables{5}).seasonal_fit;
% test_data_start_sos = harm.(variables{6}).seasonal_fit;
% 
% test_data_dissic = test_data_start_dissic;
% test_data_talk = test_data_start_talk;
% test_data_tos = test_data_start_tos;
% test_data_sos = test_data_start_sos;

% for v = var_list
%     test_index = test_index+1;
%     test_data_start(test_index,:) = harm.(variables{v}).seasonal_fit;
%     
% %     adjust.(variables{v}).offset = 0;
% %     adjust.(variables{v}).phase_shift_days = 0;
% %     adjust.(variables{v}).amp_percent      = 0;
% %     
% end

adjust_dissic_phase_shift_days =-50:10:50;
adjust_dissic_amp_percent =-100:10:100;
% adjust.dissic.amp_percent = 0;
% adjust.dissic.phase_shift_days = 0 ;
% 
% % adjust.talk.phase_shift_days   = -75:25:75;
% adjust_talk_phase_shift_days   = -75:25:75;
adjust_talk_phase_shift_days   = 0;

adjust_talk_amp_percent   =-80:20:20;%[-30 0]; %-80:20:80;
% adjust_talk_amp_percent   =0;%[-30 0]; %-80:20:80;


% adjust.talk.amp_percent   =0;

% adjust.tos.phase_shift_days    = -10:5:10;

adjust_tos_phase_shift_days    = 0;
% adjust_tos_phase_shift_days    = -10:5:10;

adjust_tos_amp_percent    =-100:50:100;

% adjust.tos.amp_percent    = 0;

% adjust.sos.phase_shift_days    =-40:20:40;
% adjust.sos.amp_percent    =-250:50:250;
% 
adjust_sos_phase_shift_days    =0;
adjust_sos_amp_percent    =0;

% saving for later ease of plotting
adjust_vars.adjust_dissic_phase_shift_days = adjust_dissic_phase_shift_days;
adjust_vars.adjust_dissic_amp_percent = adjust_dissic_amp_percent;
adjust_vars.adjust_talk_phase_shift_days = adjust_talk_phase_shift_days;
adjust_vars.adjust_talk_amp_percent = adjust_talk_amp_percent;
adjust_vars.adjust_tos_phase_shift_days = adjust_tos_phase_shift_days;
adjust_vars.adjust_tos_amp_percent = adjust_tos_amp_percent;
adjust_vars.adjust_sos_phase_shift_days = adjust_sos_phase_shift_days;
adjust_vars.adjust_sos_amp_percent = adjust_sos_amp_percent;


offset_adjust = 0; % not varying this for now

% table_index = 0;
% v=7;
% test_data = test_data_start;

% adjust_dissic_phase_shift_days = adjust.(variables{v}).phase_shift_days;

% phase_shift_var1 = NaN(length(adjust.(variables{v}).phase_shift_days),1);

% pco2_corr_out = NaN(length(adjust.dissic.phase_shift_days).*length(adjust.dissic.amp_percent).* ...
%     length(adjust.talk.amp_percent).*length(adjust.talk.phase_shift_days).* ...
%     length(adjust.tos.amp_percent).*length(adjust.tos.phase_shift_days ).* ...
%     length(adjust.sos.phase_shift_days).*length(adjust.sos.amp_percent), 1);

% pco2_corr_out_all = NaN(NaN(length(adjust.dissic.phase_shift_days).*length(adjust.dissic.amp_percent).* ...
%     length(adjust.talk.amp_percent).*length(adjust.talk.phase_shift_days).* ...
%     length(adjust.tos.amp_percent).*length(adjust.tos.phase_shift_days ).* ...
%     length(adjust.sos.phase_shift_days).*length(adjust.sos.amp_percent), 1);


% idealized_test_out = [];
% NaN(length(adjust.dissic.phase_shift_days).*length(adjust.dissic.amp_percent).* ...
%     length(adjust.talk.amp_percent).*length(adjust.talk.phase_shift_days).* ...
%     length(adjust.tos.amp_percent).*length(adjust.tos.phase_shift_days ).* ...
%     length(adjust.sos.phase_shift_days).*length(adjust.sos.amp_percent), 11);

idealized_test_out_2 = NaN(length(adjust_dissic_phase_shift_days), length(adjust_dissic_amp_percent), ...
    length(adjust_tos_phase_shift_days ), length(adjust_tos_amp_percent), ...
    length(adjust_talk_phase_shift_days), length(adjust_talk_amp_percent),  ...
    length(adjust_sos_phase_shift_days), length(adjust_sos_amp_percent), 3);

[s1, s2, s3, s4, s5, s6, s7, s8, s9] = size(idealized_test_out_2);
dic_idealized = NaN(s1, s2, s3, s4, s5, s6, s7, s8, 12);

tos_idealized = NaN(s1, s2, s3, s4, s5, s6, s7, s8, 12);

sos_idealized = NaN(s1, s2, s3, s4, s5, s6, s7, s8, 12);

talk_idealized = NaN(s1, s2, s3, s4, s5, s6, s7, s8, 12);

pco2_idealized = NaN(s1, s2, s3, s4, s5, s6, s7, s8, 12);
% pco2_corr_out_all = [];

parfor dd = 1:length(adjust_dissic_phase_shift_days)
    phase_shift_days = adjust_dissic_phase_shift_days(dd);
    phase_shift_var1 = phase_shift_days.*2.*pi./365.25;
    
    tt = NaN(length(adjust_dissic_amp_percent),...
        length(adjust_tos_phase_shift_days), length(adjust_tos_amp_percent), ...
        length(adjust_talk_phase_shift_days), length(adjust_talk_amp_percent),  ...
        length(adjust_sos_phase_shift_days), length(adjust_sos_amp_percent), 3);
    
    dicv = NaN(s2, s3, s4, s5, s6, s7, s8, 12);
    tosv = NaN(s2, s3, s4, s5, s6, s7, s8, 12);
    sosv = NaN(s2, s3, s4, s5, s6, s7, s8, 12);
    talkv = NaN(s2, s3, s4, s5, s6, s7, s8, 12);
    pco2v = NaN(s2, s3, s4, s5, s6, s7, s8, 12);

    for a = 1:length(adjust_dissic_amp_percent)
        
        %          table_index = (dd-1)+1 + ...
        %              (a-1)*length(adjust.(variables{v}).phase_shift_days)
        
        amp_adjust_percent = adjust_dissic_amp_percent(a);
        amp_adjust_v1 = amp_adjust_percent/100 + 1;
        
        % calculate a new test data for variable v
        yt = harm.dissic.offset.*ones(12,1)+offset_adjust;
        test_data_dissic = yt+(harm.dissic.amp.*amp_adjust_v1.*cos(2.*pi.*j.*[year_days]./L + (harm.dissic.phase+phase_shift_var1)))';
        
        %         tos_phase_out = NaN(length(adjust_tos_phase_shift_days),1);
        for ddv2 =  1:length(adjust_tos_phase_shift_days)
            phase_shift_days = adjust_tos_phase_shift_days(ddv2);
            phase_shift_var2 = phase_shift_days.*2.*pi./365.25;
            
            %             pco2_corr_out = NaN(length(adjust_dissic_amp_percent),1);
            %             av2=1;
            for av2 = 1:length(adjust_tos_amp_percent)
                amp_adjust_percent = adjust_tos_amp_percent(av2);
                amp_adjust_var2 = amp_adjust_percent/100 + 1;
                
                % calculate a new test data for variable v2
                yt = harm.tos.offset.*ones(12,1)+offset_adjust;
                test_data_tos = yt+(harm.tos.amp.*amp_adjust_var2.*cos(2.*pi.*j.*[year_days]./L + (harm.tos.phase+phase_shift_var2)))';
                
                 for ddv3 =  1:length(adjust_talk_phase_shift_days)
                     phase_shift_days = adjust_talk_phase_shift_days(ddv3);
                     phase_shift_var3 = phase_shift_days.*2.*pi./365.25;
                     
                     %             pco2_corr_out = NaN(length(adjust_dissic_amp_percent),1);
                     %             av2=1;
                     for av3 = 1:length(adjust_talk_amp_percent)
                         amp_adjust_percent = adjust_talk_amp_percent(av3);
                         amp_adjust_var3 = amp_adjust_percent/100 + 1;
                         
                         % calculate a new test data for variable v2
                         yt = harm.talk.offset.*ones(12,1)+offset_adjust;
                         test_data_talk = yt+(harm.talk.amp.*amp_adjust_var3.*cos(2.*pi.*j.*[year_days]./L + (harm.talk.phase+phase_shift_var3)))';
                         
                         
                         for ddv4 =  1:length(adjust_sos_phase_shift_days)
                             phase_shift_days = adjust_sos_phase_shift_days(ddv4);
                             phase_shift_var4 = phase_shift_days.*2.*pi./365.25;
                             
                             %             pco2_corr_out = NaN(length(adjust_dissic_amp_percent),1);
                             %             av2=1;
                             for av4 = 1:length(adjust_sos_amp_percent)
                                 amp_adjust_percent = adjust_sos_amp_percent(av4);
                                 amp_adjust_var4 = amp_adjust_percent/100 + 1;
                                 
                                 % calculate a new test data for variable v2
                                 yt = harm.sos.offset.*ones(12,1)+offset_adjust;
                                 test_data_sos = yt+(harm.sos.amp.*amp_adjust_var4.*cos(2.*pi.*j.*[year_days]./L + (harm.sos.phase+phase_shift_var4)))';
                                 
                                 
                                 [DATA,~,~]=CO2SYSSOCCOM_smb(test_data_talk, ...
                                     test_data_dissic, ...
                                     1,2, test_data_sos, test_data_tos, test_data_tos,...
                                     1,1,SI,PO4,1,10,3);
                                 pco2_test = DATA(:,4);
                                 
                                 % taylor calc on pco2_test
                                 [test_out_correlation, test_out_ratio, test_out_norm_error]=taylor_eval(harm.spco2.seasonal_fit, pco2_test);
                                 
                                 %                 pco2_corr_out(a) = test_out_correlation;
                                 %         idealized_test_out(table_index,10) = test_out_ratio;
                                 %         idealized_test_out(table_index,11) = test_out_norm_error;
                                 %             end
                               
                                 tt(a, ddv2, av2, ddv3, av3, ddv4, av4, :) = [test_out_correlation test_out_ratio test_out_norm_error];
                                 dicv(a, ddv2, av2, ddv3, av3, ddv4, av4, :) = test_data_dissic;
                                 tosv(a, ddv2, av2, ddv3, av3, ddv4, av4, :) = test_data_tos;
                                 sosv(a, ddv2, av2, ddv3, av3, ddv4, av4, :) = test_data_sos;
                                 talkv(a, ddv2, av2, ddv3, av3, ddv4, av4, :) = test_data_talk;
                                 pco2v(a, ddv2, av2, ddv3, av3, ddv4, av4, :) = pco2_test;

                             end
                         end
                         %         tt(a,:) = tos_phase_out;
                     end
                     
                 end
            end
        end
    end
    idealized_test_out_2(dd, :, :, :, :, :, :, :, :) = tt;
    dic_idealized(dd, :, :, :, :, :, :, :, :) = dicv;
    tos_idealized(dd, :, :, :, :, :, :, :, :) = tosv;
    sos_idealized(dd, :, :, :, :, :, :, :, :) = sosv;
    talk_idealized(dd, :, :, :, :, :, :, :, :) = talkv;
    pco2_idealized(dd, :, :, :, :, :, :, :, :) = pco2v;

end

toc


%% Needed for Figures %% Contour plots of pCO2 correlation against DISSIC amplitude and phase shifts
set(gcf, 'colormap', brewermap(30, 'Spectral'))


v = 7;
main_var = 'dissic';

sub_v = 5;
sub_var_name = 'adjust_tos_amp_percent';

sub_var_3_name = 'adjust_talk_amp_percent';
model_plot = 1;
% first, find all points with the correct sub_v amplitude and shift, then put
% into a matric of ampl rows and phase columns

% copied idealized test_out_2 to know order of indexes
% idealized_test_out_2 = NaN(length(adjust_dissic_phase_shift_days), length(adjust_dissic_amp_percent), ...
%     length(adjust_tos_phase_shift_days ), length(adjust_tos_amp_percent), ...
%     length(adjust_talk_phase_shift_days), length(adjust_talk_amp_percent),  ...
%     length(adjust_sos_phase_shift_days), length(adjust_sos_amp_percent), 3);

for ta = 1:length(adjust_vars.(sub_var_3_name))
    subplot_index = 0;
    clf
    set(gcf, 'units', 'inches')
    paper_w = 10; paper_h =15;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

    plot_filename = ['Contour_correlation ' variables{v} ' subplots by ' variables{sub_v} ' and ' sub_var_3_name '_' num2str(adjust_vars.(sub_var_3_name)(ta))];

    if model_plot==1
        plot_filename = [plot_filename '_model_overlay'];
    end
    for tt = 1:length(adjust_vars.(sub_var_name))
        
        sub_v_amp_percent=adjust_vars.(sub_var_name)(tt);
        sub_v_shift_days = 0;
        
        subplot_index = subplot_index+1;
        if tt==2
            subplot_index = subplot_index+1;
        end
        subplot(3,2,subplot_index)
        
        pCO2_grid = NaN(length(adjust_vars.(['adjust_' main_var '_amp_percent'])), length(adjust_vars.(['adjust_' main_var '_phase_shift_days'])));
        
        for dd =1: length(adjust_vars.(['adjust_' main_var '_amp_percent']))
            %         var_amp_index = idealized_test_out.([variables{v} '_amp_adjust_percent'])==adjust.(variables{v}).amp_percent(dd) & ...
            %             idealized_test_out.([variables{sub_v} '_amp_adjust_percent'])==sub_v_amp_percent & ...
            %             idealized_test_out.([variables{sub_v} '_phase_shift_days'])==sub_v_shift_days & idealized_test_out.talk_amp_adjust_percent==-30;
            %
            %           var_amp_index = idealized_test_out.([variables{v} '_amp_adjust_percent'])==adjust.(variables{v}).amp_percent(dd) & ...
            %             idealized_test_out.([variables{sub_v} '_amp_adjust_percent'])==sub_v_amp_percent & ...
            %             idealized_test_out.([variables{sub_v} '_phase_shift_days'])==sub_v_shift_days & idealized_test_out.talk_amp_adjust_percent==-30;
            
            
            %         pCO2_grid(dd,:) = idealized_test_out.pco2_corr(var_amp_index);
            pCO2_grid(dd,:) = idealized_test_out_2(:,dd,1,tt,1,ta,1,1,1);
        end
        
        [C, h] = contourf( adjust_vars.(['adjust_' main_var '_phase_shift_days']), adjust_vars.(['adjust_' main_var '_amp_percent']),pCO2_grid, 'levellist', -1:0.05:1, 'linestyle', 'none'); colorbar; caxis([-1 1])
        hold on
        [C1, h1] = contour( adjust_vars.(['adjust_' main_var '_phase_shift_days']),adjust_vars.(['adjust_' main_var '_amp_percent']), pCO2_grid, 'levellist', [-0.5:0.5:0.5], 'linestyle', '-', 'linewidth', 2, 'color', 'k');
        clabel(C1, h1)
        xlabel([variables{v} ' Shift (days)'])
        ylabel([variables{v} ' Amplitude (% diff)'])
        title([(variables{sub_v}) ' amplitude percent ' num2str(sub_v_amp_percent)]);
        
        if model_plot==0
            continue
        end
        
        % overlay scatter plots with models that fit into different sub_v
        % amplitude bins
        % will need to adjust bin ranges if you modify the number of bins here:
        sub_v_amp_bin = 25;
        
        for m = 1:length(cmip_names.spco2)
            mod_talk_index = strcmp(cmip_names.talk, cmip_names.spco2{m});
            
            if sum(mod_talk_index)==0 % if there is no talk, then it is hard to know if talk is at all reasonable and not causing issues
                continue
            end
            
            mod_sub_v_index = strcmp(cmip_names.(variables{sub_v}), cmip_names.spco2{m});
            sub_v_amp_per_diff = (harm_mod.(variables{sub_v}).amp(mod_sub_v_index) - harm.(variables{sub_v}).amp)./harm.(variables{sub_v}).amp*100;
            
            if isempty(sub_v_amp_per_diff)
                continue
            end
            % only plot models that fall in each sub_v amplitude range
            if sub_v_amp_per_diff>=sub_v_amp_percent - sub_v_amp_bin && sub_v_amp_per_diff<sub_v_amp_percent + sub_v_amp_bin
                
                mod_var_index = strcmp(cmip_names.(variables{v}), cmip_names.spco2{m});
                
                
                
                var_phase_shift_days = (harm_mod.(variables{v}).phase(mod_var_index) - harm.(variables{v}).phase )*365.25./(2*pi);
                var_amp_per_diff = (harm_mod.(variables{v}).amp(mod_var_index) - harm.(variables{v}).amp)./harm.(variables{v}).amp*100;
                
                if isempty(var_phase_shift_days)
                    continue
                end
                mod_pco2_corr = obs.spco2.correlation(m);
                
                scatter(var_phase_shift_days, var_amp_per_diff, 200, mod_pco2_corr, 'filled', 'markeredgecolor', 'k')
                
                disp(cmip_names.spco2{m})
                disp(m)
                disp(var_phase_shift_days)
                disp(var_amp_per_diff)
                
                disp(mod_pco2_corr)
                
                %                                 pause
            end
        end
        
    end
    

    print(gcf, '-dpdf', [Plot_out_dir 'Sensitivity_tests/' plot_filename plot_ver])
end
%% Needed for Figures %% Example plots of pCO2 shifts due to DIC and SST changes

% copied idealized test_out_2 to know order of indexes
% idealized_test_out_2 = NaN(length(adjust_dissic_phase_shift_days), length(adjust_dissic_amp_percent), ...
%     length(adjust_tos_phase_shift_days ), length(adjust_tos_amp_percent), ...
%     length(adjust_talk_phase_shift_days), length(adjust_talk_amp_percent),  ...
%     length(adjust_sos_phase_shift_days), length(adjust_sos_amp_percent), 3);
% legend_names = {};

%indexes for different scenarios
tap = 3;
talk_ap = 5;

dpsd = 6;
dap = 11;

pco2_orig = squeeze(pco2_idealized(dpsd,dap,1,tap,1,talk_ap,1,1,:));
dic_orig = squeeze(dic_idealized(dpsd,dap,1,tap,1,talk_ap,1,1,:));
tos_orig = squeeze(tos_idealized(dpsd,dap,1,tap,1,talk_ap,1,1,:));

% now test plots to run
dpsd = [3 9 6 6 6 6];
dap = [11 11 8 14 11 11];
tap = [3 3 3 3 2 4];

for qq = 1:length(dpsd)
    clf
     set(gcf, 'units', 'inches')
    paper_w = 5; paper_h =6;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

    
    pco2_test = squeeze(pco2_idealized(dpsd(qq),dap(qq),1,tap(qq),1,talk_ap,1,1,:));
    dic_test = squeeze(dic_idealized(dpsd(qq),dap(qq),1,tap(qq),1,talk_ap,1,1,:));
    tos_test = squeeze(tos_idealized(dpsd(qq),dap(qq),1,tap(qq),1,talk_ap,1,1,:));
    
    pco2_correlation = idealized_test_out_2(dpsd(qq),dap(qq),1,tap(qq),1,talk_ap,1,1,1);
    
    test_name = ['DIC shift ' num2str(adjust_vars.adjust_dissic_phase_shift_days(dpsd(qq))) ...
        ' DIC Amp change ' num2str(adjust_vars.adjust_dissic_amp_percent(dap(qq))) ...
        ' TOS Amp Change ' num2str(adjust_vars.adjust_tos_amp_percent(tap(qq)))];
%     legend_names = [legend_names test_name];
    
    d1 = subplot(3,1,1);
    hold on
    p1 = plot(pco2_orig, '-k', 'linewidth', 3);
    ylabel('pCO_2 (\muatm)')
        set(d1, 'ylim', [360 440])

    d2 = subplot(3,1,2);
    hold on
    plot(dic_orig, '-k', 'linewidth', 3)
    ylabel('DIC (\mumol kg^-^1)')
    set(d2, 'ylim', [2175 2230])

   
    d3 = subplot(3,1,3);
    hold on
    plot(tos_orig, '-k', 'linewidth', 3)
    ylabel('SST (\circC)')
    xlabel('Month')
            set(d3, 'ylim', [1 6])

    plot_filename = 'Toy model pCO2';
    if qq==1
        legend(d1, p1, 'Original', 'location', 'northwest')

        print(gcf, '-dpng', '-r400', [Plot_out_dir 'Sensitivity_tests/' plot_filename plot_ver])
    end
    
    p2 = plot(d1, pco2_test,'--r', 'linewidth', 2);
    title(d1, ['Test pCO_2 correlation: ' num2str(pco2_correlation,2)])
    plot(d2, dic_test,'--r', 'linewidth', 2);
    title(d2, ['DIC shift ' num2str(adjust_vars.adjust_dissic_phase_shift_days(dpsd(qq))) ' Days'...
        '; DIC Amp change ' num2str(adjust_vars.adjust_dissic_amp_percent(dap(qq))) ' %'])
    
    plot(d3, tos_test,'--r', 'linewidth', 2)
    title(d3, [' SST Amp Change ' num2str(adjust_vars.adjust_tos_amp_percent(tap(qq))) ' %'])
    %     taylor_eval(harm.spco2.seasonal_fit, pco2_test)
    %         taylor_eval(pco2_orig, pco2_test)
    
    legend(d1, [p1 p2], 'Original', 'Test', 'location', 'northwest')
    plot_filename = [plot_filename ' ' test_name];
    print(gcf, '-dpng', '-r400', [Plot_out_dir 'Sensitivity_tests/' plot_filename plot_ver])
    
    pause
end
% legend(d1, legend_names, 'location', 'northwest')
% plot(d1, harm.spco2.seasonal_fit, 'k--')

%% Starting from correct model, recalculating pCO2 for different test cases - non parallel (old??)
% clf
tic
idealized_test_out = table;

clear test_data adjust test_data_start
% for v = [5 6 7 8]
%     test_data_start.(variables{v}) = harm.(variables{v}).seasonal_fit;
%     
% %     adjust.(variables{v}).offset = 0;
% %     adjust.(variables{v}).phase_shift_days = 0;
% %     adjust.(variables{v}).amp_percent      = 0;
% %     
% end

% adjust.dissic.phase_shift_days =-50:10:50;
% adjust.dissic.amp_percent =-100:10:100;
adjust.dissic.phase_shift_days =-50:50:50;
adjust.dissic.amp_percent =-100:200:100;
% adjust.dissic.amp_percent = 0;
% adjust.dissic.phase_shift_days = 0 ;
% 
% adjust.talk.phase_shift_days   = -75:25:75;
% adjust.talk.amp_percent   =[-30 0]; %-80:20:80;

adjust.talk.phase_shift_days   = -75:25:75;
adjust.talk.amp_percent   =[-30 0];

% adjust.tos.phase_shift_days    = -10:5:10;
% adjust.tos.amp_percent    =-100:200:100;
% adjust.tos.amp_percent    =-100:50:100;

adjust.tos.phase_shift_days    =  -10:5:10;
adjust.tos.amp_percent    = -100:200:100;

% adjust.sos.phase_shift_days    =-40:20:40;
% adjust.sos.amp_percent    =-250:50:250;
% 
adjust.sos.phase_shift_days    =0;
adjust.sos.amp_percent    =0;





offset_adjust = 0; % not varying this for now

table_index = 0;
v=7;
% test_data = test_data_start;

for dd = 1:length(adjust.(variables{v}).phase_shift_days)
    
    %     for a = 1:length(adjust.(variables{v}).amp_percent)
    
    
    % calculate a new test_data for this variable, just using the new
    % phase shift
    phase_shift_days = adjust.(variables{v}).phase_shift_days(dd);
    phase_shift.(variables{v}) = phase_shift_days.*2.*pi./365.25;
    
    % also step through range of amplitude percentages for this
    % variable
    for a = 1:length(adjust.(variables{v}).amp_percent)
        
        amp_adjust_percent = adjust.(variables{v}).amp_percent(a);
        amp_adjust.(variables{v}) = amp_adjust_percent/100 + 1;
        
        % calculate a new test data for variable v
        yt = harm.(variables{v}).offset.*ones(12,1)+offset_adjust;
        test_data.(variables{v}) = yt+(harm.(variables{v}).amp.*amp_adjust.(variables{v}).*cos(2.*pi.*j.*[year_days]./L + (harm.(variables{v}).phase+phase_shift.(variables{v}))))';
        
        v2 = 5;
        for ddv2 =  1:length(adjust.(variables{v2}).phase_shift_days)
            phase_shift_days = adjust.(variables{v2}).phase_shift_days(ddv2);
            phase_shift.(variables{v2}) = phase_shift_days.*2.*pi./365.25;
            
            for av2 = 1:length(adjust.(variables{v2}).amp_percent)
                amp_adjust_percent = adjust.(variables{v2}).amp_percent(av2);
                amp_adjust.(variables{v2}) = amp_adjust_percent/100 + 1;
                
                % calculate a new test data for variable v2
                yt = harm.(variables{v2}).offset.*ones(12,1)+offset_adjust;
                test_data.(variables{v2}) = yt+(harm.(variables{v2}).amp.*amp_adjust.(variables{v2}).*cos(2.*pi.*j.*[year_days]./L + (harm.(variables{v2}).phase+phase_shift.(variables{v2}))))';
                
                % add a new set of variables for alkalinity:
                
                v3 = 8;
                for ddv3 =  1:length(adjust.(variables{v3}).phase_shift_days)
                    phase_shift_days = adjust.(variables{v3}).phase_shift_days(ddv3);
                    phase_shift.(variables{v3}) = phase_shift_days.*2.*pi./365.25;
                    
                    for av3 = 1:length(adjust.(variables{v3}).amp_percent)
                        amp_adjust_percent = adjust.(variables{v3}).amp_percent(av3);
                        amp_adjust.(variables{v3}) = amp_adjust_percent/100 + 1;
                        
                        % calculate a new test data for variable v3
                        yt = harm.(variables{v3}).offset.*ones(12,1)+offset_adjust;
                        test_data.(variables{v3}) = yt+(harm.(variables{v3}).amp.*amp_adjust.(variables{v3}).*cos(2.*pi.*j.*[year_days]./L + ...
                            (harm.(variables{v3}).phase+phase_shift.(variables{v3}))))';
                        
                        % final set of variables for salinity:
                        v4 = 6;
                        for ddv4 =  1:length(adjust.(variables{v4}).phase_shift_days)
                            phase_shift_days = adjust.(variables{v4}).phase_shift_days(ddv4);
                            phase_shift.(variables{v4}) = phase_shift_days.*2.*pi./365.25;
                            
                            for av4 = 1:length(adjust.(variables{v4}).amp_percent)
                                amp_adjust_percent = adjust.(variables{v4}).amp_percent(av4);
                                amp_adjust.(variables{v4}) = amp_adjust_percent/100 + 1;
                                
                                % calculate a new test data for variable v3
                                yt = harm.(variables{v4}).offset.*ones(12,1)+offset_adjust;
                                test_data.(variables{v4}) = yt+(harm.(variables{v4}).amp.*amp_adjust.(variables{v4}).*cos(2.*pi.*j.*[year_days]./L + ...
                                    (harm.(variables{v4}).phase+phase_shift.(variables{v4}))))';
                                
                                
                                table_index = table_index+1;
                                
                                idealized_test_out.([variables{v} '_phase_shift_days'])(table_index) = adjust.(variables{v}).phase_shift_days(dd);
                                idealized_test_out.([variables{v} '_amp_adjust_percent'])(table_index) = adjust.(variables{v}).amp_percent(a);
                                
                                idealized_test_out.([variables{v2} '_phase_shift_days'])(table_index) = adjust.(variables{v2}).phase_shift_days(ddv2);
                                idealized_test_out.([variables{v2} '_amp_adjust_percent'])(table_index) = adjust.(variables{v2}).amp_percent(av2);
                                
                                idealized_test_out.([variables{v3} '_phase_shift_days'])(table_index) = adjust.(variables{v3}).phase_shift_days(ddv3);
                                idealized_test_out.([variables{v3} '_amp_adjust_percent'])(table_index) = adjust.(variables{v3}).amp_percent(av3);
                                
                                
                                idealized_test_out.([variables{v4} '_phase_shift_days'])(table_index) = adjust.(variables{v4}).phase_shift_days(ddv4);
                                idealized_test_out.([variables{v4} '_amp_adjust_percent'])(table_index) = adjust.(variables{v4}).amp_percent(av4);
                                
                                
                                % for now, other variables stay the same
                                [DATA,~,~]=CO2SYSSOCCOM_smb(test_data.talk, ...
                                    test_data.dissic, ...
                                    1,2, test_data.sos, test_data.tos, test_data.tos,...
                                    1,1,SI,PO4,1,10,3);
                                pco2_test = DATA(:,4);
                                
                                % taylor calc on pco2_test
                                [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(harm.spco2.seasonal_fit, pco2_test);
                                
                                idealized_test_out.pco2_corr(table_index) = test_out.correlation;
                                idealized_test_out.pco2_ratio(table_index) = test_out.ratio;
                                idealized_test_out.pco2_norm_error(table_index) = test_out.norm_error;
                            end
                        end
                    end
                end
            end
        end
    end
end
toc
%%  Trying to evaluate intpp magnitude vs. vars (rather than using taylor evaluation for intpp)
clf
set(gcf, 'units', 'inches')
paper_w = 7; paper_h =5;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h

subplot(1,1,1);
hold on

seas_amplitude = 0;
dissic_vert_gradient=1;
dd = 12;
mon = 9;

wmo_on = 0;

if wmo_on==0
sv = 9;
v = find(strncmp(seas_comp_vars{sv}, variables, 4));
if length(v)>1 % cludge since dissic and dissic_yr were getting confused
    v = strmatch(seas_comp_vars{sv}, variables, 'exact');
end
else
    v=10;
end

alt_x=0;

sv2 = 4;
tests = {'norm_error';'correlation' ; 'ratio'};
tt = 3;

v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
    v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
end

temp_array =[];
temp_names = {};
for m = 1:length(cmip_names.(variables{v}))
    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
    
    if sum(mod_match)>0
        if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
            plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);
            
            if seas_amplitude ==1
                var_2 = max(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) - min(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) ;
            else
                var_2 = obs.(variables{v2}).(tests{tt})(mod_match);
                
            end
            
            if dissic_vert_gradient==1
                if CMIP.dissic_yr.out_annual(m,1,1)==0 % there is an error in CESM2_6 depth coordinate so the interpolation is not working properly
                    continue
                end
                var_1 = CMIP.dissic_yr.out_annual(m,1,1) - CMIP.dissic_yr.out_annual(m,dd,1) ;
                
            else
                if wmo_on==1
                    var_1 = CMIP.wmo.out_seasonal(m,dd,mon,1) ;
                elseif alt_x==0
                    var_1 = CMIP.(variables{v}).out_seasonal(m,mon,1);
                else
                    var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
                end
            end
            if isnan(var_1) || isnan(var_2)
                continue
            end
            plot(var_1,	var_2 , '.', 'color', ...
                plot_color, 'markersize', 50)
            if alt_x==1 && var_1>20
                disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
                continue
            end
            temp_names{end+1,1} = cmip_names.(variables{v}){m};
            temp_array(end+1,1) = var_1;
            temp_array(end,2) = var_2;
        end
    end
    
    
    
end

if seas_amplitude~=1 && tt~=1 % if plotting correlation or ratio, "obs" equals 1.
    obs_y = 1;
elseif seas_amplitude~=1 % if plotting normalized error, "obs" equals 0
    obs_y=0;
elseif seas_amplitude==1
    obs_y = max(obs.(variables{v2}).out_seasonal(:,1)) - min(obs.(variables{v2}).out_seasonal(:,1));
end

if wmo_on==0
if dissic_vert_gradient==1
    obs_annual_mean = squeeze(nanmean(obs.dissic.out_seasonal(:,1,:),1));
    var_1_obs = obs_annual_mean(1,1) - obs_annual_mean(dd,1);
elseif alt_x==1 
    var_1_obs = max(obs.(variables{v}).out_seasonal(:,1))./(min(obs.(variables{v}).out_seasonal(:,1)));
elseif alt_x==0
    var_1_obs = obs.(variables{v}).out_seasonal(mon,1);
end

    plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10)
end

if seas_amplitude==1
    comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
else
    comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
end

if dissic_vert_gradient==1
    x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
elseif wmo_on==1
    x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
else
    if alt_x==0
        x_label = [variables{v} ' value from Month= ' num2str(mon)];
    else
        x_label = [variables{v} ' max divided by min'];
    end
end
xlabel( x_label, 'interpreter', 'none')
ylabel([comp_label], 'interpreter', 'none')

[m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
y_plot = m.*x_plot+b;
plot(x_plot, y_plot, 'k-')
title(['r= ' num2str(r,2)])

set(gca, 'fontsize', 16)
plot_filename = ['Var_comparison ' x_label ' vs. ' comp_label ];

print(gcf, '-dpng', [Plot_out_dir variables{v} '/' plot_filename '.png'])

%%
clear mon seas_amplitude m b r x_plot y_plot var_2 var_1 temp_array temp_names v2 v sv sv2
%% plotting vertical DIC gradients
v=11;
clf
subplot(1,1,1)
hold on

v2 = 4; %MLD
wint_mon = 8;
for m = 1:length(cmip_names.(variables{v}))
    if CMIP.dissic_yr.out_annual(m,1,1)==0 % there is an error in CESM2_6 depth coordinate so the interpolation is not working properly
        continue
    end
    
    plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);
    
    plot(CMIP.(variables{v}).out_annual(m,:,1) - CMIP.(variables{v}).out_annual(m,1,1), depth_levs, 'color', plot_color)
    
    % find the winter MLD and plot as well
    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
    if sum(mod_match)>0
        
        
        mod_MLD = CMIP.(variables{v2}).out_seasonal(mod_match, wint_mon,1) ;
        
        matched_DIC = interp1(depth_levs, CMIP.(variables{v}).out_annual(m,:,1), mod_MLD);
        
        plot(matched_DIC - CMIP.(variables{v}).out_annual(m,1,1), mod_MLD, 'x', 'linewidth', 3, 'color', plot_color, 'markersize', 10)
    end
    clear mod_match matched_DIC mod_MLD
end
obs_annual_mean = squeeze(nanmean(obs.dissic.out_seasonal(:,1,:),1));

plot(obs_annual_mean - obs_annual_mean(1), depth_levs, 'k-', 'linewidth', 2)

matched_obs_DIC = interp1(depth_levs, obs_annual_mean, obs.mlotst.out_seasonal(wint_mon,1));
plot(matched_obs_DIC - obs_annual_mean(1), obs.mlotst.out_seasonal(wint_mon,1), 'x', 'linewidth', 3, 'color', 'k')
set(gca, 'ydir', 'reverse', 'ylim', [0 400])
xlabel('DIC relative to surface value')
ylabel('Depth')

plot_filename = ['DIC Profile w month ' num2str(wint_mon) ' overlaid' ];

print(gcf, '-dpng', [Plot_out_dir variables{v2} '/' plot_filename '.png'])

%% Can we learn anything more from plotting harmonic fits against each other?
fits = {'amp'; 'phase'; 'offset'};

harm_mod_vars = fieldnames(harm_mod);

for hv = 1:length(harm_mod_vars)
    if strcmp(harm_mod_vars{hv}, 'DIC_Alk')
        continue 
    end
    v = find(strncmp(harm_mod_vars{hv}, variables, 4));
    if length(v)>1 % cludge since dissic and dissic_yr were getting confused
        v = strmatch(harm_mod_vars{hv}, variables, 'exact');
    end
    
    for tt = 1:length(fits)
        for qq = 1:length(fits)
            clf
            set(gcf, 'units', 'inches')
            paper_w = 15; paper_h =8;
            set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h
            
            plot_index = 0;
            plot_filename = ['Harmonic_fits ' harm_mod_vars{hv} ' ' fits{qq} ' vs. ' fits{tt}];
            for hv2 = 1:length(harm_mod_vars)
                if hv2==hv || strcmp(harm_mod_vars{hv2}, 'DIC_Alk')
                    continue
                end
                v2 = find(strncmp(harm_mod_vars{hv2}, variables, 4));
                if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
                    v2 = strmatch(harm_mod_vars{hv2}, variables, 'exact');
                end
                plot_index = plot_index+1;
                
                subplot(2,3,plot_index)
                hold on
                grid on
                temp_array = [];
                for m = 1:length(cmip_names.(variables{v}))
                    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
                    
                    if sum(mod_match)>0
                        if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
                            plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);
                          
                            plot(harm_mod.(variables{v}).(fits{qq})(m), harm_mod.(variables{v2}).(fits{tt})(mod_match), '.', 'color', ...
                                plot_color, 'markersize', 15)
                            
                            temp_array(end+1,1) = harm_mod.(variables{v}).(fits{qq})(m);
                            temp_array(end,2) = harm_mod.(variables{v2}).(fits{tt})(mod_match);
                            clear plot_color
                            
                        end
                        
                    end
                end
                xlabel( [variables{v} ' ' fits{qq}], 'interpreter', 'none')
                ylabel([variables{v2} ' ' fits{tt}], 'interpreter', 'none')
                
                [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
                x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
                y_plot = m.*x_plot+b;
                plot(x_plot, y_plot, 'k-')
                
                title(['r= ' num2str(r,2)])

                % add obs
                plot(harm.(variables{v}).(fits{qq}), harm.(variables{v2}).(fits{tt}), 'xk', 'markersize', 30)
            end
            print(gcf, '-dpng', [Plot_out_dir variables{v} '/' plot_filename '.png'])

        end
    end
end