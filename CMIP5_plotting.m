%% OLD - Transitioning to CMIP5_plotting_v2.m 
% no longer loading this output - using the cdo regridded data instead
% % after processing output on HPCC
% CMIP5_DIC_dir = [home_dir 'Data/Model_Output/CMIP5/DIC/'];
% %
% load([CMIP5_DIC_dir 'CMIP5_DIC_gridded_2019_10_03_21_56.mat'])

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
    'SOSE_i122' 43; 
    'IPSL_CM6A_LR_6' 44};

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
% neural_dir = [home_dir 'Data/Data_Products/CO2_fluxes/Landshuster_Neural/2018_08_30/'];
% load([neural_dir 'neural_network_results_v2.mat'])

% clear neural_dir
%% Multi var load CMIP
variables = {'spco2';'intpp'; 'psl';'mlotst';'tos';'sos'; 'dissic'; 'talk'; 'fgco2';'wmo'; 'dissic_yr'; 'talk_yr'; 'thetao'};
var_type = {'Omon'; 'Omon'; 'Amon';'Omon';'Omon';'Omon'; 'Omon'; 'Omon'; 'Omon'; 'Omon'; 'Oyr'; 'Oyr'; 'Omon'};
var_lims = [350 450 ;  0 7e2; 980 1020 ; 0 500 ; -1 25; 29 35.5; 1950 2300;2200 2500;-5e-2 5e-2;-3e7 3e7;1950 2300; 2200 2500; -1 25];
%%
for v=1:length(variables)
    disp([ '     <strong> Starting ' variables{v} ' processing </strong>' ])
    
    if  (strcmp(variables{v}, 'dissic') || strcmp(variables{v}, 'talk')) && strcmp(var_type{v}, 'Omon')
        CMIP_dir = [home_dir 'Data/Model_Output/CMIP5/' variables{v} '/monthly/regrid/'];
        var_load = variables{v};
    elseif strcmp(variables{v}, 'dissic_yr') || strcmp(variables{v}, 'talk_yr')
        var_load = variables{v}(1:end-3);
        CMIP_dir = [home_dir 'Data/Model_Output/CMIP5/' var_load '/regrid/'];
    else
        var_load = variables{v};
        CMIP_dir = [home_dir 'Data/Model_Output/CMIP5/' variables{v} '/regrid/'];
        
    end
    
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
    
    if  (strcmp(variables{v}, 'dissic') || strcmp(variables{v}, 'talk')) && strcmp(var_type{v}, 'Omon')
        CMIP_dir = [home_dir 'Data/Model_Output/CMIP6/' variables{v} '/monthly/regrid/ssp585_download/'];
    elseif strcmp(variables{v}, 'dissic_yr') || strcmp(variables{v}, 'talk_yr')
        CMIP_dir = [home_dir 'Data/Model_Output/CMIP6/' var_load '/regrid/ssp585_download/'];
    else
        CMIP_dir = [home_dir 'Data/Model_Output/CMIP6/' variables{v} '/regrid/ssp585_download/'];
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
        
        if numel(size(CMIP.(variables{v}).(mod_name).(variables{v})))==4
            try
                CMIP.(variables{v}).(mod_name).depth = ncread([CMIP_dir cmip_files(f).name], 'zlev');
            catch
                try
                    CMIP.(variables{v}).(mod_name).depth = ncread([CMIP_dir cmip_files(f).name], 'lev');
                catch
                    CMIP.(variables{v}).(mod_name).depth = ncread([CMIP_dir cmip_files(f).name], 'olevel');
                end
            end
        end

        % try to load historical
        %find the correct file:

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

            CMIP.(variables{v}).(mod_name).GMT_Matlab = [temp_Matlab_time;  CMIP.(variables{v}).(mod_name).GMT_Matlab]; clear temp_Matlab_time time_temp
            CMIP.(variables{v}).(mod_name).(variables{v}) = cat(3,squeeze(ncread([CMIP_dir_hist cmip_files_hist(hh).name], var_load)), CMIP.(variables{v}).(mod_name).(variables{v}));
         
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
clear f cmip_files v first_index second_index

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
    
    for m=1:length(cmip_names.(variables{v}))
        if isfield(CMIP.(variables{v}).(cmip_names.(variables{v}){m}), 'units_old')
            continue
        end
        %        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).([variables{v} '_old']) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v});
        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units_old = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units;
        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}) = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}).*scale_factor.*C_input.Neur.y2021.area';  %Tg C mon-1 out of the ocean from kg m-2 s-1into the ocean
        CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units = 'Tg C mon-1';
    end
    clear scale_factor Pg_per_kg s_per_year
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
%% Read in SOSE

time_offset = 15;  % for some reason SOSE dates are close to 15 days off

SOSE_its = {'i133' ; 'i122'};
year_range = {'2013to2018' ; '2013to2017'};
var_load = {'BLGCFLX'; 'BLGPCO2'; 'TRAC02'; 'TRAC01'; 'THETA'; 'SALT'; 'THETA'; 'BLGNPP' ; 'BLGMLD' }; % theta is in here twice, once for "TOS", once for "THETAO"

for w = 1% 1:2

mod_name = ['SOSE_' SOSE_its{w}];

if w==1
    SOSE_dir = [home_dir 'Data/Model_Output/SOSE/2013-2018_ITER133_1_6deg/regrid/'];

elseif w==2
    SOSE_dir = [home_dir 'Data/Model_Output/SOSE/2013-2017v2_ITER122_1_6deg/regrid/'];

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
%%
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



% v = find(strcmp(variables, 'CO2_sol'));

% for q = 1:length(model_types)
%     CMIP.(variables{v}).model_groups.(model_types{q}) = find(contains(cmip_names.(variables{v}), model_group_names.(model_types{q})));
% end

clear m v q
% %% put models into model groups
% for v = 1:length(variables)
%     for q = 1:length(model_types)
%         CMIP.(variables{v}).model_groups.(model_types{q}) = find(contains(cmip_names.(variables{v}), model_group_names.(model_types{q})));
%     end
% end
% clear v q
%%  OLD %%% saving monthly means and std
% for v=9%1:length(variables)
%     if ~isfield(cmip_names, variables{v})
%         continue
%     end
%     disp(['Starting ' variables{v}])
%     
%     lat_index = CMIP.(variables{v}).lat<=lat_lims(2) & CMIP.(variables{v}).lat>=lat_lims(1);
%     
%     if ~strcmp(var_type{v}, 'Oyr')
%         
%         if strcmp(var_type{v}, 'Omon') || strcmp(var_type{v}, 'Amon') % is there a seasonal cycle?
%             
%             if isfield(CMIP.(variables{v}).(cmip_names.(variables{v}){1}), 'depth')  % check first model for this variable to see if there is a depth variable
%                 
%                 num_depths = length(CMIP.(variables{v}).(cmip_names.(variables{v}){1}).depth);
%                 
%                 CMIP.(variables{v}).out_seasonal = NaN(length(cmip_names.(variables{v})),num_depths,12,2); % 4D out_seasonal variable if needed (num models, num depths, 12 months, mean and std)
%                 var4D = 1;
%             else
%                 CMIP.(variables{v}).out_seasonal = NaN(length(cmip_names.(variables{v})),12,2); % 3D out_seasonal (num models, 12 months, mean and std)
%                 var4D = 0;
%                 num_depths = 1;
%             end
%         end % need to add an option for the annual variables
%         
%         for m = 1:length(cmip_names.(variables{v}))
%             
%             for dd = 1:num_depths
%                 
%                 for mon = 1:12
%                     mod_vec = datevec(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).GMT_Matlab);
%                     time_index = mod_vec(:,2)==mon;
%                     
%                     if var4D==0
%                         SO_var = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, lat_index, time_index);
%                     elseif var4D==1
%                         SO_var = squeeze(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, lat_index, dd, time_index));
%                     end
%                     
%                     if strcmp(variables{v}, 'fgco2')
%                         % collapse all years into one mean map for each month
%                         SO_fgco2_mean = nanmean(SO_var,3);
%                         
%                         % sum all grid cells to convert to total flux in the area
%                         CMIP.(variables{v}).out_seasonal(m,mon,1) = nansum(reshape(SO_fgco2_mean,[],1)); % sum, not mean
%                         
%                         clear SO_fgco2_mean
%                     else
%                         if var4D ==0
%                             CMIP.(variables{v}).out_seasonal(m,mon,1) = nanmean(reshape(SO_var,[],1));
%                             CMIP.(variables{v}).out_seasonal(m,mon,2) = nanstd(reshape(SO_var,[],1));
%                         elseif var4D==1
%                             
%                             CMIP.(variables{v}).out_seasonal(m,dd,mon,1) = nanmean(reshape(SO_var,[],1));
%                             CMIP.(variables{v}).out_seasonal(m,dd,mon,2) = nanstd(reshape(SO_var,[],1));
%                         end
%                     end
%                     clear time_index SO_var mod_vec
%                 end % end months loop
%             end % end depth loop
%             
%         end
%         clear m mon num_depths var4D
%     else
%         
%         num_depths = length(CMIP.(variables{v}).(cmip_names.(variables{v}){1}).depth);
%         
%         CMIP.(variables{v}).out_annual = NaN(length(cmip_names.(variables{v})),num_depths,2);
%         
%         for m = 1:length(cmip_names.(variables{v}))
%             
%             for dd = 1:num_depths
%                 
%                 CMIP.(variables{v}).out_annual(m, dd, 1) = nanmean(reshape(squeeze(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, lat_index, dd, :)),[],1));
%                 CMIP.(variables{v}).out_annual(m, dd, 2) = nanstd(reshape(squeeze(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, lat_index, dd, :)),[],1));
%                 
%             end
%         end
%         clear m num_depths
%     end
%     clear lat_index 
% end
% clear v dd m
%% New calculation of monthly means and std using a mask based on potential temperature

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
            end
            
            % load the SAF_S_mask
            SAF_S_mask = CMIP.thetao.(cmip_names.(variables{v}){m}).SAF_S_mask;
            
            for dd = 1:num_depths
                
                for mon = 1:12
                    mod_vec = datevec(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).GMT_Matlab); % create a date vector to use for filter
                    time_index = mod_vec(:,2)==mon; % find all months equal to mon
                    
                    if var4D==0
                        SO_var = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, :, time_index); % save correct months to SO_var
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
                SAF_S_mask = CMIP.thetao.(cmip_names.(variables{v}){m}).thetao(:,:,13)<=5 & lat_grid<-30 & lat_grid>poleward_lat_lim;
                CMIP.thetao.(cmip_names.(variables{v}){m}).SAF_S_mask = SAF_S_mask;
                clear SAF_S_mask
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

% Calculate a SAF based on the SAF mask (i.e. the northern-most lat included in the mask)
v=13;

for m = 1:length(cmip_names.(variables{v}))
    
    CMIP.thetao.(cmip_names.(variables{v}){m}).SAF = NaN(length(CMIP.thetao.lon),1);
    for lon = 1:length(CMIP.thetao.lon)
        temp_lat_vec = CMIP.thetao.lat(CMIP.thetao.(cmip_names.(variables{v}){m}).SAF_S_mask(lon,:));
        if ~isempty(temp_lat_vec)
            CMIP.thetao.(cmip_names.(variables{v}){m}).SAF(lon) = max(temp_lat_vec);
        end
    end

end
clear m lon v
%% plot tos only using the SAF mask
Plot_out_dir = [home_dir 'Work/Projects/2019_05 SO_C_flux_model_comparison/Plots/'];
v = 5;

[lon_grid, lat_grid] = meshgrid(CMIP.(variables{v}).lon, CMIP.(variables{v}).lat);

CMIP.lon_grid = lon_grid';
CMIP.lat_grid = lat_grid';
clear lon_grid lat_grid
for m = 1:length(cmip_names.(variables{v}))
    % Southern Ocean surface DIC plot . time_range = 2010 to 2020

        num_depths =1;
    dd=1;
    
    clf
    set(gcf, 'units', 'inches')
    paper_w = 16; paper_h =9;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    colormap(parula(70))
    %             set(gcf, 'colormap', var_cmaps.(variables{v}));
    
        SO_var = nanmean(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v}),3);
   
    
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
    try
    plot(1:360, CMIP.thetao.(cmip_names.(variables{v}){m}).SAF, 'm-', 'linewidth', 2)
    
    subplot(2,1,2)
    
    
    SO_var(~CMIP.thetao.(cmip_names.(variables{v}){m}).SAF_S_mask)=nan;
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
    
    catch
    end
    if num_depths==1
        plot_filename = [variables{v} '_Surface_' cmip_names.(variables{v}){m}];
        
    else
        plot_filename = [variables{v} '_' cmip_names.(variables{v}){m} '_' num2str(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).depth(dd)) 'm' ];
    end
    saveas(gcf, [Plot_out_dir variables{v} '/surface/' plot_filename '_v8'], 'png')
    
    clear SO_var SO_mean_var plot_filename SO_SSS time_index mod_vec
    
end


%% Plotting surface values to check land and nan values
Plot_out_dir = [home_dir 'Work/Projects/2019_05 SO_C_flux_model_comparison/Plots/'];
% var_cmaps.fgco2 = %flipud(brewermap(30, 'RdBu'));
% var_cmaps.fgco2 = flipud(brewermap(30, 'RdBu'));

for v=9%[1 2 4 5 6 7 8 9] %length(variables)
    if ~isfield(cmip_names, variables{v})
        continue
    end
    SO_lat_index = CMIP.(variables{v}).lat<=-35;
    [lon_grid, lat_grid] = meshgrid(CMIP.(variables{v}).lon, CMIP.(variables{v}).lat);
    
    CMIP.lon_grid = lon_grid';
    CMIP.lat_grid = lat_grid';
    clear lon_grid lat_grid
    for m = 1:length(cmip_names.(variables{v}))
        % Southern Ocean surface DIC plot . time_range = 2010 to 2020
        
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
            mod_vec = datevec(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).GMT_Matlab);
            time_index = mod_vec(:,1)>=2010 & mod_vec(:,1)<2020;
            
            if num_depths==1
                SO_var = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, SO_lat_index, time_index);
            else
                SO_var = squeeze(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, SO_lat_index, dd, time_index));
            end
            
            SO_mean_var = nanmean(SO_var,3);
            
            subplot(1,1,1)
            pcolor(CMIP.lon_grid(:,SO_lat_index), CMIP.lat_grid(:,SO_lat_index), SO_mean_var(:,:)); shading flat
            hold on
            if isfield(CMIP.thetao, (cmip_names.(variables{v}){m}))
            plot(CMIP.thetao.lon, CMIP.thetao.(cmip_names.(variables{v}){m}).SAF, 'k-', 'linewidth', 2)
            end
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
            
            if num_depths==1
                plot_filename = [variables{v} '_Surface_' cmip_names.(variables{v}){m}];
                
            else
                plot_filename = [variables{v} '_' cmip_names.(variables{v}){m} '_' num2str(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).depth(dd)) 'm' ];
            end
            saveas(gcf, [Plot_out_dir variables{v} '/surface/' plot_filename '_v8'], 'png')
            
            clear SO_var SO_mean_var plot_filename SO_SSS time_index mod_vec
        end
    end
end

clear m c1 SO_lat_index paper_h paper_w dd num_depths

%% plot Neural flux
v = 9;

SO_lat_index = Neur_input.lat<=-35;

SO_var = Neur_input.recent.annual.Pg_mon.SOCCOM_SOCAT(:, SO_lat_index, :);

SO_mean_var = nanmean(SO_var,3);

SO_mean_var_lon_shift = NaN(size(SO_mean_var,1), size(SO_mean_var,2), size(SO_mean_var,3));
SO_mean_var_lon_shift(1:180, :, :) = SO_mean_var(181:end,:,:);
SO_mean_var_lon_shift(181:end, :, :) = SO_mean_var(1:180,:,:);


clf
set(gcf, 'units', 'inches')
paper_w = 16; paper_h =9;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
subplot(1,1,1)

set(gcf, 'colormap', var_cmaps.(variables{v}));


pcolor(CMIP.lon_grid(:,SO_lat_index), CMIP.lat_grid(:,SO_lat_index), SO_mean_var_lon_shift.*1000); shading flat

 c1 = colorbar;
 ylabel(c1, 'Tg C mon-1')
 set(gca, 'ylim', [-85 -35])
 set(gca, 'fontsize', 20)
 title('Neural Network SOCCOM + SOCAT')
 
 caxis(var_lims(v,:))
 saveas(gcf, [Plot_out_dir  'fgco2/surface/NN_SOCCOM_SOCAT'], 'png')

%% Plotting zonal sum for neural network - Work in progress
 % load output from Carbon_mapped_product_analysis
p=1; 
y = 1;

temp = NaN(180,12);
% will only work for models that are on a 360 x 180 degree grid
for m = 1:12
    time_index = C_input.(product_names{p}).(years{y}).Pg_mon.date_vec(:,2)==m & C_input.(product_names{p}).(years{y}).Pg_mon.date_vec(:,1)>=2015;

    temp(:,m) = nansum(C_input.(product_names{p}).(years{y}).Pg_mon.annual.SOCCOM_SOCAT(:,:,m),1)';
end
%%

[lat_mon_grid_X, lat_mon_grid_Y] = meshgrid(1:12, C_input.Neur.y2018.lat);

%%
clf

pcolor(lat_mon_grid_X, lat_mon_grid_Y, temp); shading flat
 
 
 %% for 4D seasonal variables plot seasonal cycles for all depths for each model

for v=1:length(variables)
    if ~isfield(cmip_names, variables{v})
        continue
    end
    for m = 1:length(cmip_names.(variables{v}))
        if ~isfield(CMIP.(variables{v}).(cmip_names.(variables{v}){m}), 'depth')
            continue
        end
        
        depth_colors = distinguishable_colors(length(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).depth));
        
        clf
        p = NaN(length(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).depth),1);
        d1 = subplot(1,1,1);
        hold on
        grid on
        
        for dd = 1:length(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).depth)
            
            p(dd) = plot(squeeze(CMIP.(variables{v}).out_seasonal(m,dd,:,1)), 'linewidth', 2, 'color', depth_colors(dd,:));
        end
        
        legend(p, num2str(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).depth))
        title([cmip_names.(variables{v}){m} ' ' CMIP.(variables{v}).(cmip_names.(variables{v}){m}).long_name ' ' variables{v}], 'interpreter', 'none')
        
        ylabel([variables{v} ' (' CMIP.(variables{v}).(cmip_names.(variables{v}){m}).units ')'])
        
        plot_filename = [variables{v} '_seasonal_depths_' cmip_names.(variables{v}){m}];
        
        if strcmp(variables{v}, 'wmo')
            set(gca, 'ylim', [0 2e7])
        end
        saveas(gcf, [Plot_out_dir variables{v} '/' plot_filename '_v1'], 'png')
        
        clear depth_colors d1 p
    end
end

clear v m dd


%% Read in monthly SST
clear NOAA_SST

SST_dir = [home_dir 'Data/Data_Products/SST/NOAA_OI_SST_V2/'];
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
    
    clear time_index SO_var temp_area grid_weights
end

clear mod_vec lat_index mon
%
% Read in climatological SSS from WOA
clear WOA_SSS

SSS_dir = [home_dir 'Data/Data_Products/SSS/WOA_2018/'];
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
%% Can reload gridded datasets, reload here instead of re-running the last several cells
% currently saved in manuscript folder
load([home_dir 'Work/Manuscripts/2019_06 SO CMIP Comparison/data/gdap_and_argo_gridded_2022_Apr_04.mat'])

%% Load SOCCOM
% 2021_08_01 changing lat lims and updaring to 2021 dataset
% no averaging is occuring in the creation of argo_SO and gdap_SO, so I
% think I should change lat_lims filter to -90 to -30, then grate a 1x1 monthly gridded dataset
% next and create area-weighted averages from this dataset
lat_lims_SO = [-90 -30];
% SOCCOM_float_directory = [home_dir 'Data/ARGO_O2_Floats/Global/SOCCOM/2020_04_20_Snapshot_LoRes_LIAR/'];
SOCCOM_float_directory = [home_dir 'Data/ARGO_O2_Floats/Global/SOCCOM/2021_05_05_Snapshot_LoRes_LIAR/'];

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

gdap_dir = [home_dir 'Data/Data_Products/GLODAP/'];
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
for dd = 1%:length(depth_levs)
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
%
% grid gdap
disp('gdap started')
for dd = 1%:length(depth_levs)
    disp(depth_names{dd})

    gdap_SO.(depth_names{dd}).gridded = [];
    
    gdap_vec = datevec(gdap_SO.(depth_names{dd}).GMT_Matlab);
    for a = [12 13] %4:length(gdap_SO_fields) % ignore all variables except bgc parameters
        disp(gdap_SO_fields{a})
        gdap_SO.(depth_names{dd}).gridded.(gdap_SO_fields{a}) = NaN(360,180,12);
        
        for mon = 1:12
            disp(mon)
            for lo = 1:length(CMIP.spco2.lon)
                for la = 1:61 % length(CMIP.spco2.lat) % only need to grid through to a latitude of ~30deg
                    
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

for dd = 1
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

obs.dissic.out_seasonal = NaN(12,2);
obs.talk.out_seasonal = NaN(12,2);

% lat_index = WOA_SSS.lat<=lat_lims(2) & WOA_SSS.lat>=lat_lims(1);

for mon = 1:12
    
    SO_var = combined_SO.d10.gridded.dissic(:, :, mon);
    SO_var(~NOAA_SST.SAF_mask)=nan;

    temp_area = C_input.Neur.y2021.area';
    temp_area(isnan(SO_var)) = nan;
    % creating an area weighting:
    grid_weights = temp_area./nansum(reshape(temp_area,[],1));
    
    
     % sum the product of grid_weights and SO_var to get the area weighted
    % mean
    obs.dissic.out_seasonal(mon,1) = nansum(reshape(SO_var.*grid_weights,[],1));
    obs.dissic.out_seasonal(mon,2) = nanstd(reshape(SO_var,[],1));
    
    clear time_index SO_var temp_area grid_weights
    
    
    SO_var = combined_SO.d10.gridded.talk(:, :, mon);
    SO_var(~NOAA_SST.SAF_mask)=nan;

    temp_area = C_input.Neur.y2021.area';
    temp_area(isnan(SO_var)) = nan;
    % creating an area weighting:
    grid_weights = temp_area./nansum(reshape(temp_area,[],1));
    
    
    % sum the product of grid_weights and SO_var to get the area weighted
    % mean
    obs.talk.out_seasonal(mon,1) = nansum(reshape(SO_var.*grid_weights,[],1));
    obs.talk.out_seasonal(mon,2) = nanstd(reshape(SO_var,[],1));
    
    clear time_index SO_var temp_area grid_weights
end

clear mon 


%% OLD mean annual values - OLD
% % disp('WARNING testing DIC from floats only!')
% gdap_SO.dissic_yr_mean = NaN(length(depth_levs),1);
% gdap_SO.talk_yr_mean= NaN(length(depth_levs),1);
% argo_SO.dissic_yr_mean = NaN(length(depth_levs),1);
% argo_SO.talk_yr_mean = NaN(length(depth_levs),1);
% 
% % first calculate GLODAP and SOCCOM separately
% for dd=1:length(depth_levs)
%         for g = 1:length(gdap_SO_fields)
%             gdap_SO.(depth_names{dd}).([gdap_SO_fields{g} '_mean']) = nanmean(gdap_SO.(depth_names{dd}).(gdap_SO_fields{g}));
%         end
%         
%         for g = 1:length(argo_fields)
%             argo_SO.(depth_names{dd}).([argo_fields{g} '_mean']) = nanmean(argo_SO.(depth_names{dd}).(argo_fields{g}));
%         end
%         gdap_SO.dissic_yr_mean(dd) = gdap_SO.(depth_names{dd}).G2tco2_mean;
%         gdap_SO.talk_yr_mean(dd) = gdap_SO.(depth_names{dd}).G2talk_mean;
% 
%         argo_SO.dissic_yr_mean(dd) = argo_SO.(depth_names{dd}).DIC_LIAR_mean;
%         argo_SO.talk_yr_mean(dd) = argo_SO.(depth_names{dd}).TALK_LIAR_mean;
% 
% end
% 
% clear dd g
% 
% % %% plotting seasonal observations TALK cycle
% % 
% % plot_filename = 'Data_TALK_surface_cycle_v2';
% % clf
% % set(gcf, 'units', 'inches')
% % paper_w = 10; paper_h =8;
% % set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
% % 
% % argo_vec = datevec(argo_SO.d10.GMT_Matlab);
% % argo_vec(:,1) = 2016;
% % argo_date_single_year = datenum(argo_vec);
% % p1 = plot(argo_date_single_year, argo_SO.d10.TALK_LIAR, 'xb');
% % %%
% % hold on
% % 
% % gdap_vec = datevec(gdap_SO.surf.GMT_Matlab);
% % gdap_vec(:,1) = 2016;
% % gdap_date_single_year = datenum(gdap_vec);
% % p2 = plot(gdap_date_single_year, gdap_SO.surf.G2talk, 'or');
% % 
% % ylabel('[TALK]')
% % datetick('x', 'mmm')
% % title(['Surface Data, lat. limits: ' num2str(lat_lims)])
% % 
% % % Mean observational seasonal cycle
% % 
% % obs_talk_monthly = NaN(12,2);
% % 
% % for m=1:12
% %     
% %     argo_index = argo_vec(:,2)==m;
% %     gdap_index = gdap_vec(:,2)==m;
% %     
% %     obs_talk_monthly(m,1) = nanmean([argo_SO.surf.TALK_LIAR(argo_index) ; gdap_SO.surf.G2talk(gdap_index)]);
% %     obs_talk_monthly(m,2) = nanstd([argo_SO.surf.TALK_LIAR(argo_index) ; gdap_SO.surf.G2talk(gdap_index)]);
% % end
% % 
% % e1 = errorbar(datenum(2016,1:12,15), obs_talk_monthly(:,1), obs_talk_monthly(:,2), 'linewidth', 2, 'color', 'k');
% % 
% % legend([p1 p2 e1], 'SOCCOM', 'GLODAP', 'Combined mean +/- 1 sd', 'location', 'southeast')
% % print(gcf, '-dpng', [Plot_out_dir 'talk/' plot_filename '.png'])
% % 
% % clear m e1 p2 p1 argo_vec argo_date_single_year gdap_vec gdap_date_single_year
% % SOCCOM/GLODAP observational seasonal cycles:
% 
% obs.dissic.out_seasonal = NaN(12,2);
% obs.talk.out_seasonal = NaN(12,2);
% 
% argo_vec = datevec(argo_SO.(depth_names{1}).GMT_Matlab);
% gdap_vec = datevec(gdap_SO.(depth_names{1}).GMT_Matlab);
% 
% for m=1:12
%     
%     argo_index = argo_vec(:,2)==m;
%     gdap_index = gdap_vec(:,2)==m;
%     
%     obs.dissic.out_seasonal(m,1) = nanmean([ (argo_SO.(depth_names{1}).DIC_LIAR(argo_index)) ; (gdap_SO.(depth_names{1}).G2tco2(gdap_index))]);
%     obs.dissic.out_seasonal(m,2) = nanstd([argo_SO.(depth_names{1}).DIC_LIAR(argo_index) ; gdap_SO.(depth_names{1}).G2tco2(gdap_index)]);
%     
%     obs.talk.out_seasonal(m,1) = nanmean([ (argo_SO.(depth_names{1}).TALK_LIAR(argo_index)) ; (gdap_SO.(depth_names{1}).G2talk(gdap_index))]);
%     obs.talk.out_seasonal(m,2) = nanstd([argo_SO.(depth_names{1}).TALK_LIAR(argo_index) ; gdap_SO.(depth_names{1}).G2talk(gdap_index)]);
% end
% clear argo_vec gdap_vec m
% 
% % switching to gridded Argo product for MLD
% % obs.mlotst.out_seasonal = NaN(12,2);
% % argo_vec = datevec(argo_SO.ml.GMT_Matlab);
% % 
% % for m=1:12
% %     
% %     argo_index = argo_vec(:,2)==m;
% %     
% %     obs.mlotst.out_seasonal(m,1) = nanmean(argo_SO.ml.MLD(argo_index));
% %     obs.mlotst.out_seasonal(m,2) = nanstd(argo_SO.ml.MLD(argo_index));
% %     
% % end
% clear argo_vec m argo_index gdap_index


%% for annual only variables, plot all mean values
v=11;
max_depth = 10;

plot_filename = ['Mean_annual_' variables{v} '_by_depth'];
clf
set(gcf, 'units', 'inches')
paper_w = 16; paper_h =9;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

subplot(1,1,1)
hold on

depth_colors = distinguishable_colors(length(CMIP.(variables{v}).(cmip_names.(variables{v}){1}).depth));

% arrange models by surface concentration
temp_out_annual = CMIP.(variables{v}).out_annual(:,:,1);
sorted_array = NaN(size(CMIP.(variables{v}).out_annual,1), size(CMIP.(variables{v}).out_annual,2));
temp_names = cmip_names.(variables{v});
sorted_names = {};
sort_index = 0;

while ~isempty(temp_out_annual) && sum(reshape(isnan(temp_out_annual),[],1))~=numel(temp_out_annual)
    sort_index = sort_index+1;
    min_val = min(temp_out_annual(:,1))==temp_out_annual(:,1);
    mod_name = temp_names{min_val};
    mod_name(strfind(mod_name, '_')) = ' ';
    sorted_names{sort_index} = mod_name;
    sorted_array(sort_index,:) = temp_out_annual(min_val,:);
    
    temp_out_annual = temp_out_annual(~min_val,:);
    temp_names = temp_names(~min_val);

    clear mod_name min_val
end
if size(sorted_array,1)~=length(sorted_names)
    sorted_array = sorted_array(~isnan(sorted_array(:,1)),:);
end


for m = 1:length(sorted_names)

    for dd = 1:max_depth %length(CMIP.(variables{v}).(cmip_names.(variables{v}){1}).depth)
        plot(m, sorted_array(m,dd,1), 'x', 'linewidth', 2, 'color', depth_colors(dd,:))
    end
end

for  dd = 1:max_depth %length(CMIP.(variables{v}).(cmip_names.(variables{v}){1}).depth)
    plot(m+1, argo_SO.([variables{v} '_mean'])(dd), 'o', 'linewidth', 2, 'color', depth_colors(dd,:))
    plot(m+2, gdap_SO.([variables{v} '_mean'])(dd), 'o', 'linewidth', 2, 'color', depth_colors(dd,:))

end


set(gca, 'xtick', 1:length(sorted_names)+2)
set(gca, 'xticklabels', [sorted_names 'Argo' 'GDAP'],'XTickLabelRotation', 45)

set(gca, 'xlim', [0 length(sorted_names)+6])
grid on
legend(num2str(CMIP.(variables{v}).(cmip_names.(variables{v}){1}).depth(1:max_depth)))

saveas(gcf, [Plot_out_dir variables{v} '/' plot_filename '_GDAP_2010_max_depth ' num2str(depth_levs(max_depth)) '_v1'], 'png')
%% for annual only variables, plot all differences from surface values
v=11;

plot_filename = ['Mean_annual_' variables{v} '_by_depth_diff_surf'];
clf
set(gcf, 'units', 'inches')
paper_w = 16; paper_h =9;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

subplot(1,1,1)
hold on

depth_colors = distinguishable_colors(length(CMIP.(variables{v}).(cmip_names.(variables{v}){1}).depth));

% arrange models by surface concentration
temp_out_annual = CMIP.(variables{v}).out_annual(:,:,1);
sorted_array = NaN(size(CMIP.(variables{v}).out_annual,1), size(CMIP.(variables{v}).out_annual,2));
temp_names = cmip_names.(variables{v});
sorted_names = {};
sort_index = 0;

while ~isempty(temp_out_annual) && sum(reshape(isnan(temp_out_annual),[],1))~=numel(temp_out_annual)
    sort_index = sort_index+1;
    min_val = min(temp_out_annual(:,1))==temp_out_annual(:,1);
    mod_name = temp_names{min_val};
    mod_name(strfind(mod_name, '_')) = ' ';
    sorted_names{sort_index} = mod_name;
    sorted_array(sort_index,:) = temp_out_annual(min_val,:);
    
    temp_out_annual = temp_out_annual(~min_val,:);
    temp_names = temp_names(~min_val);

    clear mod_name min_val
end
if size(sorted_array,1)~=length(sorted_names)
    sorted_array = sorted_array(~isnan(sorted_array(:,1)),:);
end

for m = 1:length(sorted_names)

    for dd = 1:max_depth %length(CMIP.(variables{v}).(cmip_names.(variables{v}){1}).depth)
        plot(m, sorted_array(m,dd,1) - sorted_array(m,1,1), 'x', 'linewidth', 2, 'color', depth_colors(dd,:))
    end
end

for  dd = 1:max_depth %length(CMIP.(variables{v}).(cmip_names.(variables{v}){1}).depth)
    plot(m+1, argo_SO.([variables{v} '_mean'])(dd) - argo_SO.([variables{v} '_mean'])(1), 'o', 'linewidth', 2, 'color', depth_colors(dd,:))
    plot(m+2, gdap_SO.([variables{v} '_mean'])(dd) - gdap_SO.([variables{v} '_mean'])(1), 'o', 'linewidth', 2, 'color', depth_colors(dd,:))

end


set(gca, 'xtick', 1:length(sorted_names)+2)
set(gca, 'xticklabels', [sorted_names 'Argo' 'GDAP'],'XTickLabelRotation', 45)

set(gca, 'xlim', [0 length(sorted_names)+6])
grid on
legend(num2str(CMIP.(variables{v}).(cmip_names.(variables{v}){1}).depth(1:max_depth)))

saveas(gcf, [Plot_out_dir variables{v} '/' plot_filename '_GDAP_2010 ' num2str(depth_levs(max_depth)) '_v1'], 'png')

%% Neural network pco2 load

neural_dir = [home_dir 'Data/Data_Products/CO2_fluxes/Landshuster_Neural/2018_08_30/'];

runs = {'SOCAT_only'; 'SOCCOM_SOCAT'};
% runs = {'SOCCOM_SOCAT'};

run_filenames = {'MPI-SOM_FFN_GCB2018.nc'; 'MPI-SOM_FFN_SOCCOMv2018.nc'};


for q = 1:length(runs)
    Mapped_pCO2.Neur.(runs{q}) = double(ncread([neural_dir run_filenames{q}], 'spco2'));
    Mapped_pCO2.Neur.(runs{q})(abs(Mapped_pCO2.Neur.(runs{q}))>1e5) = nan;
    if q==1
        lat_neur = ncread([neural_dir run_filenames{q}], 'lat');
        lon_neur = ncread([neural_dir run_filenames{q}], 'lon');
    end
end
Mapped_pCO2.Neur.units = 'muatm';
time_neural =  ncread([neural_dir run_filenames{1}], 'time'); % 'seconds since 2000-01-01'

Mapped_pCO2.Neur.time_Matlab = double(time_neural)/60/60/24 + datenum('jan-01-2000');  % days since 2000-01-01
lat_neur = double(lat_neur);
lon_neur = double(lon_neur);

[X_lon_neur, Y_lat_neur] = meshgrid(lon_neur, lat_neur);

temp_lon_neur = X_lon_neur;
temp_lon_neur(temp_lon_neur>180) = temp_lon_neur(temp_lon_neur>180)-360;

Mapped_pCO2.Neur.lon = lon_neur;
Mapped_pCO2.Neur.lat = lat_neur;

Mapped_pCO2.Neur.lon_grid = temp_lon_neur';
Mapped_pCO2.Neur.lat_grid = Y_lat_neur';

clear time_neural temp_lon_neur X_lon_neur Y_lat_neur lat_neur lon_neur q neural_dir

%  Neural network pCO2 seasonal cycle

% create a neural network -180 - 180 S of SAF mask

C_input.Neur.y2021.index.SAF_S_mask = C_input.Neur.y2021.index.pfz | C_input.Neur.y2021.index.asz | C_input.Neur.y2021.index.siz ;
C_input.Neur.y2021.index.SAF_S_mask = C_input.Neur.y2021.index.SAF_S_mask';
C_input.Neur.y2021.index.SAF_S_mask = C_input.Neur.y2021.index.SAF_S_mask & C_input.Neur.y2021.lat_grid>poleward_lat_lim;
% lat_index = Mapped_pCO2.Neur.lat<=lat_lims(2) & Mapped_pCO2.Neur.lat>=lat_lims(1);
obs.spco2.out_seasonal = NaN(12,2);
mod_vec = datevec(Mapped_pCO2.Neur.time_Matlab);

for mon=1:12
    time_index = mod_vec(:,2)==mon & mod_vec(:,1)>=2015;
    
    SO_spco2 = Mapped_pCO2.Neur.SOCCOM_SOCAT(:, :, time_index);
    % for each year, mask out the non SAF_S region:
    for zz = 1:size(SO_spco2,3)
        TT = SO_spco2(:,:,zz);
        TT(~C_input.Neur.y2021.index.SAF_S_mask) = nan;
        
        temp_area = C_input.Neur.y2021.area';
        temp_area(isnan(TT)) = nan;
        % creating an area weighting:
        grid_weights = temp_area./nansum(reshape(temp_area,[],1));
        
        SO_spco2(:,:,zz) = TT.*grid_weights; % weight each value - now to get the annual mean you will sum these together
        clear TT
    end
    clear zz
    
    
    % sum each year into a single month, then take the mean and std:
    zonal_sum = nansum(SO_spco2,1);
    box_sum = squeeze(nansum(zonal_sum,2));
    
    obs.spco2.out_seasonal (mon,1) = nanmean(box_sum);
    obs.spco2.out_seasonal (mon,2) = nanstd(box_sum);
    
    clear SO_spco2 zonal_sum box_sum
end

clear lat_index mod_vec time_index mon

% Neural Network seasonal fgCO2 - 2021_02_08 updated to use the "C_input
% from "Carbon_mapped_product_analysis"

p=1;
% y=1;
% q = 1;

% mod_vec = datevec(Neur_input.time_Matlab);
product_names = C_input.product_names;
years = C_input.years;
for y = 1:length(years)
    % for p = 1:2
    for q = 1:2
%         lat_index = C_input.(product_names{p}).(years{y}).lat<=lat_lims(2) & C_input.(product_names{p}).(years{y}).lat>=lat_lims(1);
        obs.fgco2.(product_names{p}).(years{y}).(runs{q}).out_seasonal = NaN(12,2);

        for mon=1:12
            time_index = C_input.(product_names{p}).(years{y}).date_vec(:,2)==mon & C_input.(product_names{p}).(years{y}).date_vec(:,1)>=2015;
            
            SO_fgco2 = C_input.(product_names{p}).(years{y}).Pg_mon.(runs{q})(:, :, time_index);
            
            % for each year, mask out the non SAF_S region:
            for zz = 1:size(SO_fgco2,3)
                TT = SO_fgco2(:,:,zz);
                TT(~C_input.Neur.y2021.index.SAF_S_mask) = nan;
                SO_fgco2(:,:,zz) = TT;
                clear tt
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
        end
        
        clear lat_index mod_vec time_index mon
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
clear y q
%% Holte and talley climatology for MLD - Load and grid
disp('Starting H & T MLD Climatology load')
h_t = load([home_dir 'Data/Data_Products/Holte_and_Talley/' 'Argo_mixedlayers_monthlyclim_03172021.mat']);

load([home_dir 'Data/ARGO_O2_Floats/Front_definitions/Gray_5_regions/regional_boundaries_5zone_SMB.mat']);

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

end
% %% load Ivana's gridded Argo ML product and compare to the MLD you get from floats
% % load gridded Argo-derived MLDs
% 
% argo_MLD = load([home_dir 'Work/Projects/2020_02 SO SAMW Variability_Cerovecki/Data_from_Ivana/MLD_monthly_2005_jan_2020.mat']);
% 
% argo_MLD.GMT_Matlab = datenum(2005,1:12*(2020-2005)+1,15);
% argo_MLD.datevec = datevec(argo_MLD.GMT_Matlab);
% %
% % MLD_index = argo_MLD.LAT>= lat_lims(1) & argo_MLD.LAT<=lat_lims(2);
% % starting ARGO MLD is from -64.5 to -30.5;
% 
% obs.mlotst.out_seasonal = NaN(12,2);
% for mon=1:12
%    month_index = argo_MLD.datevec(:,2)==mon & argo_MLD.datevec(:,1)>=2010 & argo_MLD.datevec(:,1)<=2019;
%     
%    TTT = nanmean(argo_MLD.MLDepth(:,:,month_index),3);
%    
%    obs.mlotst.out_seasonal(mon,1) = nanmean(TTT(MLD_index));
%    obs.mlotst.out_seasonal(mon,2) = nanstd(TTT(MLD_index));
% 
% end
% 
% clear MLD_index TTT month_index
% Loading CBPM NPP
disp('Startign CBPM NPP load')
NPP_dir = [home_dir 'Data/Data_Products/NPP/CbPM/'];
npp_files = dir([NPP_dir '*.hdf']);

clear NPP_obs

m = 1080;
n = 2160;

lat_step = (90--90)/(m-1);
lon_step = (180--180)/(n-1);

npp_lat = 90:-lat_step:-90;
npp_lon = -180:lon_step:180;

[X, Y] = meshgrid(npp_lon, npp_lat);

NPP_obs.Matlab_date = NaN(length(npp_files),1);
NPP_obs.lat = npp_lat;
NPP_obs.lon = npp_lon;
NPP_obs.lat_grid = Y;
NPP_obs.lon_grid = X;

NPP_obs.cbpm = NaN(m,n,length(npp_files));


% read in individual npp files (currently 2008-2016)
for q = 1:length(npp_files)
    
    BB = npp_files(q).name(6:12);
    NPP_obs.Matlab_date(q) = datenum(BB(1:4), 'YYYY')-1 + str2double(BB(5:7)) + 15;
    
    month_npp = hdfread([NPP_dir npp_files(q).name], '/npp', 'Index', {[1  1],[1  1],[m  n]}); % mgC m-2 d-1
    month_npp = double(month_npp);
    month_npp(month_npp<-50)=nan;
    
    NPP_obs.cbpm(:,:,q) = month_npp;
    clear month_npp BB
end

clear X Y npp_lat npp_lon lon_step lat_step m n NPP_dir npp_files q
% saving observation monthly means and std


% create an NPP mask for south of the SAF

NPP_obs.SAF_S_mask = inpolygon(NPP_obs.lat_grid, NPP_obs.lon_grid, five_region_bounds.lat_saf, five_region_bounds.lon_saf) & NPP_obs.lat_grid>poleward_lat_lim;


obs.intpp.out_seasonal = NaN(12,2);

% for m = 1:size(NPP_obs_out_seasonal,1)
mod_vec = datevec(NPP_obs.Matlab_date);
% lat_index = NPP_obs.lat<=lat_lims(2) & NPP_obs.lat>=lat_lims(1);
m_per_deg = 110.567.*10.^3;

lat_deg_step = NPP_obs.lat(1)-NPP_obs.lat(2);
lon_deg_step = NPP_obs.lon(2)-NPP_obs.lon(1);

% NPP_obs.area = (lon_deg_step.*ones(length(NPP_obs.lon),1).*m_per_deg)'*(lat_deg_step.*ones(length(NPP_obs.lat),1).*m_per_deg.*cosd(NPP_obs.lat'))';
NPP_obs.area = (lat_deg_step.*ones(length(NPP_obs.lat),1).*m_per_deg.*cosd(NPP_obs.lat'))*(lon_deg_step.*ones(length(NPP_obs.lon),1).*m_per_deg)';
for mon = 1:12
    time_index = mod_vec(:,2)==mon & mod_vec(:,1)>=2010;
    
    SO_pp = NPP_obs.cbpm(:, :, time_index); 
    
     % for each year, mask out the non SAF_S region:
    for zz = 1:size(SO_pp,3)
        TT = SO_pp(:,:,zz);
        TT(~NPP_obs.SAF_S_mask) = nan;
        temp_area = NPP_obs.area;
        
        temp_area(isnan(TT)) = nan;
        % creating an area weighting:
        grid_weights = temp_area./nansum(reshape(temp_area,[],1));
        
        SO_pp(:,:,zz) = TT.*grid_weights; % weight each value - now to get the annual mean you will sum these together
        clear TT
    end
    clear zz
   
    % sum each year into a single month, then take the mean and std:
    zonal_sum = nansum(SO_pp,1);
    box_sum = squeeze(nansum(zonal_sum,2));
    
    % area weighted mean and std deviation (representing the time variance)
    obs.intpp.out_seasonal(mon,1) = nanmean(box_sum);
    obs.intpp.out_seasonal(mon,2) = nanstd(box_sum);
    
    clear  time_index  SO_pp zonal_sum box_sum
end

clear mod_vec lat_index mon lat_deg_step lon_deg_step

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
obs.DIC_Alk.out_seasonal = obs.dissic.out_seasonal(:,1) - obs.talk.out_seasonal(:,1);
CMIP.(variables{v}).(cmip_names.(variables{v}){1}).units = CMIP.dissic.(cmip_names.(variables{v}){1}).units;
clear m mod_match model_index v 

%% Taylor diagrams:

%% Taylor calculations and diagram using Kathy Kelly's tools

for v = 1:length(variables)
    
    % currently skipping psl and wmo
    if sum(strcmp(variables{v}, {'psl'; 'wmo';'dissic_yr';'talk_yr';'thetao'}))>0
        continue
    end
    % I believe this removes mean, but I can test that:
    obs.(variables{v}).correlation = NaN(size(CMIP.(variables{v}).out_seasonal,1),1);
    obs.(variables{v}).ratio = NaN(size(CMIP.(variables{v}).out_seasonal,1),1);
    obs.(variables{v}).norm_error = NaN(size(CMIP.(variables{v}).out_seasonal,1),1);
    
    for m = 1:length(cmip_names.(variables{v}))
        if v==9
            [obs.(variables{v}).correlation(m),obs.(variables{v}).ratio(m),obs.(variables{v}).norm_error(m)]=taylor_eval(obs.(variables{v}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,1),CMIP.(variables{v}).out_seasonal(m,:,1));
        else
            [obs.(variables{v}).correlation(m),obs.(variables{v}).ratio(m),obs.(variables{v}).norm_error(m)]=taylor_eval(obs.(variables{v}).out_seasonal(:,1),CMIP.(variables{v}).out_seasonal(m,:,1));

        end
    end
end
clear v m
%% Plotting taylor diagrams
rms_cutoff_for_good = .75;
out_of_phase_corr_cutoff = 0;

legend_on = 0;
for v =  9%[1 2 4 5 6 7 8 9 14 15]
    plot_filename = ['Taylor ' variables{v}];
    
    clf
    set(gcf, 'units', 'inches')
    paper_w = 14; paper_h =8;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    
    if v==9
        DDD = taylor_dist_smb(obs.(variables{v}).correlation, obs.(variables{v}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, rms_cutoff_for_good, out_of_phase_corr_cutoff);
    else
        DDD = taylor_dist_smb(obs.(variables{v}).correlation, obs.(variables{v}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, [], []);
    end
    title(variables{v})
    
    set(gca, 'fontsize', 12)
    %
    print(gcf, '-dpng', [Plot_out_dir variables{v} '/' plot_filename 'leg ' num2str(legend_on) '_v6_theta.png'])
end

clear paper_w paper_h legend_on
%% choosing model groups based on taylor diagram
clear model_group_names

model_group_names.good_mag_good_phase = {};
model_group_names.bad_phase = {};
% model_group_names.large_mag_good_phase = {};
model_group_names.other = {};
for m = 1:length(cmip_names.fgco2)
    if isfield(CMIP.thetao, cmip_names.fgco2{m}) % only assigns a model if it has thetao, which is needed for the SAF mask
        if obs.fgco2.norm_error(m)<rms_cutoff_for_good
            model_group_names.good_mag_good_phase{end+1} = cmip_names.fgco2{m};
        elseif obs.fgco2.correlation(m)<out_of_phase_corr_cutoff
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

for v = [1 2 4 5 6 7 8 9 14 15]
    plot_filename = ['Taylor ' variables{v} ' by model group'];
    
    clf
    set(gcf, 'units', 'inches')
    paper_w = 14; paper_h =8;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h
    
    
    for q = length(model_types):-1:1
        model_list = CMIP.(variables{v}).model_groups.(model_types{q});
        
        % make a temp colormap that is all one model type's color
        temp_color_model = model_group_colors(q,:);
        temp_cmap = repmat(temp_color_model, length(cmap),1);
        
        taylor_dist_smb(obs.(variables{v}).correlation(model_list), obs.(variables{v}).ratio(model_list), [], cmip_names.(variables{v})(model_list), color_model, temp_cmap, 0, [], []);
        
    end
    title(variables{v})
    set(gca, 'fontsize', 16)
    
    print(gcf, '-dpng', [Plot_out_dir variables{v} '/' plot_filename '_v6_theta.png'])
end
%% plotting Taylor RMS vs each other.

% example spco2 match vs. intpp

for v = 7%:length(variables)
    if strcmp(variables{v}, 'wmo') || strcmp(variables{v}, 'psl') || strcmp(variables{v}, 'dissic_yr') || strcmp(variables{v}, 'talk_yr') || strcmp(variables{v}, 'thetao')
        continue
    end
    
    clf
    set(gcf, 'units', 'inches')
    paper_w = 15; paper_h =8;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h
    
    plot_index = 0;
    
    plot_filename = ['Taylor ' variables{v} ' Norm Error vs. other vars_v2'];
    
    
    for v2 = 1:length(variables)

        if v2==v
            continue
        elseif strcmp(variables{v2}, 'wmo') || strcmp(variables{v2}, 'psl') || strcmp(variables{v2}, 'dissic_yr') || strcmp(variables{v2}, 'talk_yr') || strcmp(variables{v2}, 'thetao')
            continue
        end
        
        plot_index = plot_index+1;
        
        subplot(3,3,plot_index)
        
        hold on
        grid on
        
        %         legend_list = [];
        for m = 1:length(cmip_names.(variables{v}))
            
            
            %             if isnan(obs.(variables{v}).norm_error(m))
            %                 continue
            %             end
            % find the matching model
            mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
            
            if sum(mod_match)>0
                if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
                    
                    plot(obs.(variables{v}).norm_error(m), obs.(variables{v2}).norm_error(mod_match), '.', 'color', cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:), 'markersize', 20)
                    %         legend_list = [legend_list ; {cmip_names.(variables{v}){m}}];
                    
                    
                end
            end
            
            
            
        end
        xlabel( [variables{v} ' norm_error'])
        ylabel([variables{v2} ' norm error'])
        
    end
    % use the final subplot to plot a single dot for each model and create
    % a legend that has all of the fgco2 models to use for the plot
    subplot(3,3,9)
    hold on
    legend_names = {};
    
    for m = 1:length(cmip_names.fgco2)
        if ~isempty(color_model{strcmp(cmip_names.fgco2{m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
            
            plot(0,0, '.', 'color', cmap(strcmp(cmip_names.fgco2{m}, color_model(:,1)),:), 'markersize', 25)
            
            legend_names{end+1,1} = cmip_names.fgco2{m};
        end
    end
%     l1 = legend(cmip_names.(variables{v}));
    l1 = legend(legend_names);

    oldpos = l1.Position;
set(l1, 'interpreter', 'none', 'position', oldpos+[0.07 0.5 0 0], 'fontsize', 8, 'edgecolor', [1 1 1]);
print(gcf, '-dpng', [Plot_out_dir variables{v} '/' plot_filename '.png'])
end

%% plotting Taylor RMS vs each other by model group
% now also do the other comparisons (i.e. correlation vs. correlation)
filter_on=0;
if filter_on==1
    disp('Warning, some results filtered from regression analysis')
end
% example spco2 match vs. intpp
tests = {'norm_error';'correlation' ; 'ratio'};
legend_on=0;
for tt = 1:length(tests)
    for qq = 1:length(tests)
        for v = 1:length(variables)
            if strcmp(variables{v}, 'wmo') || strcmp(variables{v}, 'psl') || strcmp(variables{v}, 'dissic_yr') || strcmp(variables{v}, 'talk_yr') || strcmp(variables{v}, 'thetao')
                continue
            end
            
            clf
            set(gcf, 'units', 'inches')
            paper_w = 15; paper_h =8;
            set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h
            
            plot_index = 0;
            
            plot_filename = ['Taylor ' variables{v} ' ' tests{qq} ' vs. ' tests{tt} ' other vars_model_groups_leg ' num2str(legend_on) ' filter ' num2str(filter_on)];
            
            for v2 = 1:length(variables)
                if v2==v
                    continue
                elseif strcmp(variables{v2}, 'wmo') || strcmp(variables{v2}, 'psl') || strcmp(variables{v2}, 'dissic_yr') || strcmp(variables{v2}, 'talk_yr') || strcmp(variables{v2}, 'thetao')
                    continue
                end
                
                plot_index = plot_index+1;
                
                subplot(3,3,plot_index)
                
                hold on
                grid on
                
                %         legend_list = [];
                temp_array = [];
                for m = 1:length(cmip_names.(variables{v}))
                    
                    
                    % find the matching model
                    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
                    
                    if sum(mod_match)>0
                        if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
                            plot(obs.(variables{v}).(tests{qq})(m), obs.(variables{v2}).(tests{tt})(mod_match), '.', 'color', ...
                                model_group_colors(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3},:), 'markersize', 20)
                            %         legend_list = [legend_list ; {cmip_names.(variables{v}){m}}];
                            temp_array(end+1,1) = obs.(variables{v}).(tests{qq})(m);
                            temp_array(end,2) = obs.(variables{v2}).(tests{tt})(mod_match);
                            
                        end
                    end
                    
                    xlabel( [variables{v} ' ' tests{qq}])
                    ylabel([variables{v2} ' ' tests{tt}])
                end

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
%             subplot(3,3,9)
%             hold on
%             for m = 1:length(model_types)
%                 plot(0,0, '.', 'color', model_group_colors(m,:), 'markersize', 25)
%                 
%             end
%             if legend_on ==1
%                 l1 = legend(model_types);
%                 
%                 set(l1, 'interpreter', 'none', 'position', [0.8973    0.0801    0.1005    0.5704]);
%             end
            print(gcf, '-dpng', [Plot_out_dir variables{v} '/' plot_filename '_v5_test.png'])
        end
    end
end

%% make a table with "important" numbers:
clear out_table
% base the table on fgCO2 list:
out_table{1,1} = 'Model Name';
out_table{1,2} = 'fgCO2 Norm. Error';
out_table{1,3} = 'fgCO2 Corr.';
out_table{1,4} = 'fgCO2 Ratio';
out_table{1,5} = 'Categorization';
out_table{1,6} = 'spCO2 Norm. Error';
out_table{1,7} = 'spCO2 Corr.';
out_table{1,8} = 'spCO2 Ratio';
out_table{1,9} = 'DIC Corr.';
out_table{1,10} = 'MLD Corr.';
out_table{1,11} = 'Intpp Ratio.';
out_table{1,12} = 'TOS Norm. Error';
out_table{1,13} = 'DIC minus Alk Ratio';
out_table{1,14} = 'DIC minus Alk Corr.';
out_table{1,15} = 'DIC minus Alk Norm. Error';

for m=1:length(cmip_names.fgco2)
   if isnan(CMIP.fgco2.out_seasonal(m,1,1))
       continue
   end
   out_table{m+1,1} = cmip_names.fgco2{m};
   
   out_table{m+1,2} = obs.fgco2.norm_error(m);
   out_table{m+1,3} = obs.fgco2.correlation(m);
   out_table{m+1,4} = obs.fgco2.ratio(m);

   out_table{m+1,5} = model_types{color_model{strcmp(cmip_names.fgco2{m}, color_model(:,1)),3}};
   
   % spco2
   v2 = 1;
   mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.fgco2{m});
   out_table{m+1,6} = obs.(variables{v2}).norm_error(mod_match);
   out_table{m+1,7} = obs.(variables{v2}).correlation(mod_match);
   out_table{m+1,8} = obs.(variables{v2}).ratio(mod_match);

    % DIC Correlation
    v2 = 7;
    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.fgco2{m});
    out_table{m+1,9} = obs.(variables{v2}).correlation(mod_match);
    
    % MLD Correlation
    v2 = 4;
    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.fgco2{m});
    out_table{m+1,10} = obs.(variables{v2}).correlation(mod_match);
    
      % IntPP Ratio
    v2 = 2;
    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.fgco2{m});
    out_table{m+1,11} = obs.(variables{v2}).ratio(mod_match);
    
      % TOS Norm Error
    v2 = 5;
    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.fgco2{m});
    out_table{m+1,12} = obs.(variables{v2}).norm_error(mod_match);
    
       % DIC-ALK 
    v2 = 15;
    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.fgco2{m});
    out_table{m+1,13} = obs.(variables{v2}).ratio(mod_match);
    out_table{m+1,14} = obs.(variables{v2}).correlation(mod_match);
    out_table{m+1,15} = obs.(variables{v2}).norm_error(mod_match);

end

%% report out specific model fit parameters:

test = 'CESM2_6';

reference = 'CESM1_BGC';

for v = [1 2 4 5 6 7 8 9 14]
disp(variables{v})
model_index = strcmp(cmip_names.(variables{v}), test);
test_error = obs.(variables{v}).norm_error(model_index);

disp([test ' ' num2str(test_error)])
clear model_index
model_index = strcmp(cmip_names.(variables{v}), reference);
test_error = obs.(variables{v}).norm_error(model_index);

clear model_index

disp([reference ' ' num2str(test_error)])
disp(' ')


end

%% plot all model RMSEs for specific models of interest
test = {'CESM2_6'; 'CESM2_WACCM_6';'UKESM1_0_LL_6'; 'CESM1_BGC'; 'GFDL_ESM4_6'; 'MIROC_ESM_CHEM';'MIROC_ESM';'SOSE_i133'};

reference = 'CESM1_BGC';
clf
subplot(1,1,1)
hold on
for tt = 1:length(test)
    for v = [1 2 4 5 6 7 8 9 14]
        % disp(variables{v})
        model_index = strcmp(cmip_names.(variables{v}), test{tt});
        test_error = obs.(variables{v}).norm_error(model_index);
        
        % disp([test ' ' num2str(test_error)])
        if isempty(test_error)
            continue
        end
        plot(v, test_error, '.', 'markersize', 100, 'color', cmap(strcmp(cmip_names.(variables{v}){model_index}, color_model(:,1)),:))
        
        clear model_index
        
        % model_index = strcmp(cmip_names.(variables{v}), reference);
        % test_error = obs.(variables{v}).norm_error(model_index);
        %
        % clear model_index
        %
        % disp([reference ' ' num2str(test_error)])
        % disp(' ')
        
        
    end
end
set(gca, 'xtick', [1:14], 'xticklabel', variables)



%% investigating dT/dDIC

clf
d1 = subplot(2,1,1);
hold on
d2 = subplot(2,1,2); hold on

plot(d1, 1:11, diff(obs.tos.out_seasonal(:,1))./diff( obs.dissic.out_seasonal(:,1)),'x--k', 'linewidth', 3)
for m = 1:length(cmip_names.tos)
    mod_match = strcmp(cmip_names.dissic, cmip_names.tos{m});
    if sum(mod_match)>0
        if ~isempty(color_model{strcmp(cmip_names.tos{m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
            
            plot(d1, 1:11, diff(CMIP.tos.out_seasonal(m,:,1))./ diff(CMIP.dissic.out_seasonal(mod_match,:,1)), 'o-', 'color', ...
                model_group_colors(color_model{strcmp(cmip_names.tos{m}, color_model(:,1)),3},:), 'linewidth', 2)
            
            mean_ratio = nanmean(diff(CMIP.tos.out_seasonal(m,:,1))./ diff(CMIP.dissic.out_seasonal(mod_match,:,1)));
            
            
            mod_match = strcmp(cmip_names.spco2, cmip_names.tos{m});
            if sum(mod_match)>0
                
                plot(d2, obs.spco2.norm_error(mod_match), mean_ratio, 'color', 'r', 'marker', 'o')% ...
%                     model_group_colors(color_model{strcmp(cmip_names.tos{m}, color_model(:,1)),3},:));
            end
        end
    end
    
end

%% plot the differences for tos / dic for each model and obs
clf
d1 = subplot(1,1,1);
plot(diff(obs.tos.out_seasonal(:,1)), 'linestyle', '--', 'color', 'k', 'linewidth', 3)
hold on
set(gca, 'ylim', [-2 2])
yyaxis right
plot(diff(obs.dissic.out_seasonal(:,1)), 'linestyle', '--', 'color', 'k', 'linewidth', 3)
grid on
set(gca, 'ylim', [-30 30])

%%
for m = 1:length(cmip_names.tos)
    mod_match = strcmp(cmip_names.dissic, cmip_names.tos{m});
    if sum(mod_match)>0
        if ~isempty(color_model{strcmp(cmip_names.tos{m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
            
            yyaxis left
            plot(d1,diff(CMIP.tos.out_seasonal(m,:,1)), 'color', ...
                model_group_colors(color_model{strcmp(cmip_names.tos{m}, color_model(:,1)),3},:), 'linewidth', 2, 'linestyle', '-')
            
            
            %             mod_match = strcmp(cmip_names.spco2, cmip_names.tos{m});
            %             if sum(mod_match)>0
            %
            %                 plot(d2, obs.spco2.norm_error(mod_match), mean_ratio, 'color', 'r', 'marker', 'o')% ...
            % %                     model_group_colors(color_model{strcmp(cmip_names.tos{m}, color_model(:,1)),3},:));
            %             end
            
            yyaxis right
            plot(d1,diff(CMIP.dissic.out_seasonal(mod_match,:,1)), 'color', ...
                model_group_colors(color_model{strcmp(cmip_names.tos{m}, color_model(:,1)),3},:), 'linewidth', 2, 'linestyle', '-')
            
        end
    end
%     pause
end

%%
DIC_summer_index = find((diff(obs.dissic.out_seasonal(1:6,1))>0));
DIC_summer_transition = DIC_summer_index(1)+1;

T_summer_index = find((diff(obs.tos.out_seasonal(1:6,1))<0));
T_summer_transition = T_summer_index(1)+1;

DIC_winter_index = find((diff(obs.dissic.out_seasonal(7:12,1))<0));
DIC_winter_transition = DIC_winter_index(1)+1+6;

T_winter_index = find((diff(obs.tos.out_seasonal(7:12,1))>0));
T_winter_transition = T_winter_index(1)+1+6;


DIC_summer_transition_models = NaN(length(cmip_names.tos),1);
DIC_winter_transition_models = NaN(length(cmip_names.tos),1);


T_summer_transition_models = NaN(length(cmip_names.tos),1);
T_winter_transition_models = NaN(length(cmip_names.tos),1);


for m = 1:length(cmip_names.tos)
    mod_match = strcmp(cmip_names.dissic, cmip_names.tos{m});
    if sum(mod_match)>0
        if ~isempty(color_model{strcmp(cmip_names.tos{m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
            
            
            DIC_summer_index = find((diff(CMIP.dissic.out_seasonal(mod_match,1:6,1))>0));
            DIC_summer_transition_models(m) = DIC_summer_index(1)+1;
            
            DIC_winter_index = find((diff(CMIP.dissic.out_seasonal(mod_match,7:12,1))<0));
            DIC_winter_transition_models(m) = DIC_winter_index(1)+1+6;
            
            T_summer_index = find((diff(CMIP.tos.out_seasonal(m,1:6,1))<0));
            T_summer_transition_models(m) = T_summer_index(1)+1;
            
            T_winter_index = find((diff(CMIP.tos.out_seasonal(m,7:12,1))>0));
            T_winter_transition_models(m) = T_winter_index(1)+1+6;
            
        end
    end
    %     pause
end
%%
SI= 5;
PO4=1.8;
tic

t_in = (obs.tos.out_seasonal(:,1));
t_alk = mean(obs.talk.out_seasonal(:,1));
dic = mean(obs.dissic.out_seasonal(:,1));

[DATA,~,~]=CO2SYSSOCCOM_smb(t_alk, ...
    dic, ...
    1,2, 34, t_in, t_in ,...
    1,1,SI,PO4,1,10,3);


tos_pCO2 = DATA(:,19);

t_in = mean(obs.tos.out_seasonal(:,1));
t_alk = mean(obs.talk.out_seasonal(:,1));
dic = (obs.dissic.out_seasonal(:,1));

[DATA,~,~]=CO2SYSSOCCOM_smb(t_alk, ...
    dic, ...
    1,2, 34, t_in, t_in ,...
    1,1,SI,PO4,1,10,3);

dic_pCO2 = DATA(:,19);


t_in = mean(obs.tos.out_seasonal(:,1));
t_alk = (obs.talk.out_seasonal(:,1));
dic = mean(obs.dissic.out_seasonal(:,1));

[DATA,~,~]=CO2SYSSOCCOM_smb(t_alk, ...
    dic, ...
    1,2, 34, t_in, t_in ,...
    1,1,SI,PO4,1,10,3);

talk_pCO2 = DATA(:,19);

%% calculate wintertime wmo values and save out
depth_test = 800;

CMIP.wmo.out_winter_depth = NaN(length(cmip_names.wmo),1);

for m = 1:length(cmip_names.wmo)
    
    dd_index = CMIP.wmo.(cmip_names.wmo{m}).depth==depth_test;
    
    
    CMIP.wmo.out_winter_depth(m) = mean(squeeze(CMIP.wmo.out_seasonal(m,dd_index,7:9,1)));
    
end
clear m dd_index
%% plot Taylor values for variables against annual values

model_grp = 1;

annual_vars = {'wmo'; 'dissic_yr' ; 'talk_yr'};

tests = {'norm_error';'correlation' ; 'ratio'};
dd = find(depth_levs==depth_test);

for aa = 1:length(annual_vars)
    for tt = 1:length(tests)
        
        clf
        set(gcf, 'units', 'inches')
        paper_w = 15; paper_h =8;
        set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h
        
        plot_index = 0;
        
        if model_grp==0
            plot_filename = ['Taylor ' tests{tt} ' vs. ' annual_vars{aa} ' at ' num2str(depth_test)];
        else
                    plot_filename = ['Taylor ' tests{tt} ' vs. ' annual_vars{aa} ' at ' num2str(depth_test), 'by model group'];

        end
        
        for v2 = 1:length(variables)
            
            if sum(strcmp(variables{v2}, {'psl'; 'wmo'; 'dissic_yr'; 'talk_yr'}))>0
                continue
            end
            
            plot_index = plot_index+1;
            
            subplot(3,3,plot_index)
            
            hold on
            grid on
            
            for m = 1:length(cmip_names.(annual_vars{aa}))
                
                
                % find the matching model
                mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(annual_vars{aa}){m});
                
                if sum(mod_match)>0
                    if strcmp(annual_vars{aa}, 'wmo')
                        if model_grp==0
                            plot(CMIP.wmo.out_winter_depth(m), obs.(variables{v2}).(tests{tt})(mod_match), '.', 'color', cmap(strcmp(cmip_names.(annual_vars{aa}){m}, color_model(:,1)),:), 'markersize', 20)
                        elseif model_grp==1
                            plot(CMIP.wmo.out_winter_depth(m), obs.(variables{v2}).(tests{tt})(mod_match), '.', 'color', model_group_colors(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3},:), 'markersize', 20)
                        end
                    else
                        if model_grp==0
                            plot(CMIP.(annual_vars{aa}).out_annual(m, dd, 1) - CMIP.(annual_vars{aa}).out_annual(m, 1, 1), ...
                                obs.(variables{v2}).(tests{tt})(mod_match), '.', 'color', cmap(strcmp(cmip_names.(annual_vars{aa}){m}, color_model(:,1)),:), 'markersize', 20)
                        elseif model_grp==1
                            plot(CMIP.(annual_vars{aa}).out_annual(m, dd, 1) - CMIP.(annual_vars{aa}).out_annual(m, 1, 1), ...
                                obs.(variables{v2}).(tests{tt})(mod_match), '.', 'color', model_group_colors(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3},:), 'markersize', 20)
                        end
                    end
                    %         legend_list = [legend_list ; {cmip_names.(variables{v}){m}}];
                end
                
                xlabel(annual_vars{aa})
                ylabel(variables{v2})
            end
            
            title(tests{tt}, 'interpreter', 'none')
            if tt>1
                plot([get(gca, 'xlim')], [1 1], 'k')
            end
        end
        print(gcf, '-dpng', [Plot_out_dir  annual_vars{aa} '/' plot_filename '_v2.png'])
        
    end
    clear tt mod_match plot_index v2 m
end
clear aa


%% Calculate mean surface DIC differences:
CMIP.dissic.out_mean_diff = NaN(length(cmip_names.dissic),1);
for m = 1:length(cmip_names.dissic)
    
    CMIP.dissic.out_mean_diff(m) = nanmean(obs.dissic.out_seasonal(:,1)) - nanmean(CMIP.dissic.out_seasonal(m,:,1));
    
end

CMIP.talk.out_mean_diff = NaN(length(cmip_names.talk),1);
for m = 1:length(cmip_names.talk)
    
    CMIP.talk.out_mean_diff(m) = nanmean(obs.talk.out_seasonal(:,1)) - nanmean(CMIP.talk.out_seasonal(m,:,1));
    
end

%% calculate minimum and maximum months for variables...

% just dic and alk for now
CMIP.dissic.max_min_month = NaN(length(cmip_names.dissic),2);

for m = 1:length(cmip_names.dissic)

CMIP.dissic.max_min_month(m,1) = find(max(CMIP.dissic.out_seasonal(m,:,1))==CMIP.dissic.out_seasonal(m,:,1));
CMIP.dissic.max_min_month(m,2) = find(min(CMIP.dissic.out_seasonal(m,:,1))==CMIP.dissic.out_seasonal(m,:,1));

end

obs.dissic.max_min_month(1,1) = find(max(obs.dissic.out_seasonal(:,1))==obs.dissic.out_seasonal(:,1));

obs.dissic.max_min_month(1,2) = find(min(obs.dissic.out_seasonal(:,1))==obs.dissic.out_seasonal(:,1));
%% Zonal integral flux diagrams
v = 9;
   color_map = brewermap(30, 'RdYlBu');
    color_map = flipud(color_map);
    
for m = 26%1:length(cmip_names.(variables{v}))
    
    
    plot_filename = ['Zonally_integrated_flux_' cmip_names.(variables{v}){m} '_v2'];
    clf
    set(gcf, 'units', 'inches')
    paper_w = 10; paper_h =8;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    
    
    mod_vec = datevec(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).GMT_Matlab);
    
    lat_index = CMIP.(variables{v}).lat>=-80 & CMIP.(variables{v}).lat<=-35;
    
    temp_array = NaN(sum(lat_index), 12);
    for mon = 1:12
        date_index = mod_vec(:,2)==mon;
        CC = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, lat_index, date_index);
        DD = nanmean(CC,3);
        EE = nansum(DD,1);
        
        temp_array(:, mon) = EE'; % Tg Mon-1
    end
    
 
    set(gcf, 'colormap', color_map)
    clf
    lat_x = CMIP.(variables{v}).lat(lat_index);
    lat_lab = repmat(lat_x, 1, 12);
    
    mon_lab = repmat(1:12, length(lat_lab),1);
    
    pcolor(mon_lab, lat_lab, temp_array); shading flat
    caxis([-10 10])
    c1 = colorbar;
    xlabel('Months')
    ylabel('Latitude')
    ylabel(c1, 'Tg C mon^-^1 \circLat^-^1')
    title(cmip_names.(variables{v}){m}, 'interpreter', 'none')
    set(gca, 'fontsize', 18)
    
    print(gcf, '-dpng', [Plot_out_dir 'fgco2/' plot_filename '.png'])
end
%% Plotting annual mean [DIC] and surface/deep gradient
plot_filename = ['DIC_model_comparison_v6 Lat ' num2str(lat_lims)];
clf
plot_text=0;
set(gcf, 'units', 'inches')
paper_w = 10; paper_h =8;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

deep_color = 'r';
surf_color = 'b';

d1 = subplot(2,1,1); hold on
% set(d1, 'xlim', [0 20])
title(['Lat. limits: ' num2str(lat_lims)])
d2 = subplot(2,1,2); hold on

errorbar(d1, 1, nanmean(gdap_SO.surf.G2tco2), nanstd(gdap_SO.surf.G2tco2), 'color', surf_color, 'marker', 'x', 'linewidth', 2);
errorbar(d1, 1, nanmean(gdap_SO.deep.G2tco2), nanstd(gdap_SO.deep.G2tco2), 'color', deep_color, 'marker', 'x', 'linewidth', 2);

errorbar(d1, 2, nanmean(argo_SO.surf.DIC_LIAR), nanstd(argo_SO.surf.DIC_LIAR), surf_color, 'marker', 'x', 'linewidth', 2);
errorbar(d1, 2, nanmean(argo_SO.deep.DIC_LIAR), nanstd(argo_SO.deep.DIC_LIAR), deep_color, 'marker', 'x', 'linewidth', 2);

plot(d2, 1, nanmean(gdap_SO.surf.G2tco2) - nanmean(gdap_SO.deep.G2tco2), 'kx', 'linewidth', 2)
plot(d2, 2, nanmean(argo_SO.surf.DIC_LIAR) - nanmean(argo_SO.deep.DIC_LIAR), 'kx', 'linewidth', 2)
plot_index = 2;
plot(d1, [plot_index plot_index]+0.5, [2100 2400], '--k')
plot(d2, [plot_index plot_index]+0.5, [-160 -20], '--k')

good_mag_good_phase = find(contains(DIC_out_array_names, {'MIROC_ESM', 'MIROC_ESM_CHEM', ...
    'HadGEM', 'CESM1_BGC', 'GFDL_ESM4_6'}));
plot_range = plot_index+1:plot_index+length(good_mag_good_phase);

plot(d1, plot_range, DIC_out_array(good_mag_good_phase,2), 'color', surf_color, 'marker', 'x', 'linestyle', 'none', 'linewidth', 2)
plot(d1, plot_range, DIC_out_array(good_mag_good_phase,3), 'color', deep_color, 'marker', 'x', 'linestyle', 'none', 'linewidth', 2)
plot(d2, plot_range, DIC_out_array(good_mag_good_phase,4), 'color', 'k', 'marker', 'x', 'linestyle', 'none', 'linewidth', 2)

% plot(d3, plot_range, annual(good_mag_good_phase,4), 'color', 'k', 'marker', 'x', 'linestyle', 'none', 'linewidth', 2)

plot_index = max(plot_range);
plot(d1, [plot_index plot_index]+0.5, [2100 2400], '--k')
plot(d2, [plot_index plot_index]+0.5, [-160 -20], '--k')
if plot_text==1
    
    text(d1, (plot_range(end)-plot_range(1))/2 + plot_range(1)-2, 2375, 'Good mag. good phase')
end
large_mag_good_phase = find(contains(DIC_out_array_names, {'MPI', 'NorESM1', 'MPI_ESM1_2_HR_6', 'MPI_ESM1_2_LR_6'}));
plot_range = plot_index+1:plot_index+length(large_mag_good_phase);

plot(d1, plot_range, DIC_out_array(large_mag_good_phase,2), 'color', surf_color, 'marker', 'x', 'linestyle', 'none', 'linewidth', 2)
plot(d1, plot_range, DIC_out_array(large_mag_good_phase,3), 'color', deep_color, 'marker', 'x', 'linestyle', 'none', 'linewidth', 2)
plot(d2, plot_range, DIC_out_array(large_mag_good_phase,4), 'color', 'k', 'marker', 'x', 'linestyle', 'none', 'linewidth', 2)
plot_index = max(plot_range);
plot(d1, [plot_index plot_index]+0.5, [2100 2400], '--k')
plot(d2, [plot_index plot_index]+0.5, [-160 -20], '--k')
if plot_text==1
    
    text(d1, (plot_range(end)-plot_range(1))/2 + plot_range(1) - 1.8, 2375, 'Large mag. good phase')
end
bad_phase = find(contains(DIC_out_array_names, {'IPSL', 'MRI', 'CNRM_CM5','ESM2G', ...
    'CESM2_WACCM_6', 'CESM2_6', 'CNRM_ESM2_1_6', 'UKESM1_0_LL_6', 'CanESM5_6', 'MIROC_ES2L_6', ...
    'INM_CM5_0_6','INM_CM4_8_6', 'ACCESS_ESM1_5_6', 'GFDL_CM4_6', 'NorESM2_LM_6', 'NorESM2_MM_6'}));
plot_range = plot_index+1:plot_index+length(bad_phase);

plot(d1, plot_range, DIC_out_array(bad_phase,2), 'color', surf_color, 'marker', 'x', 'linestyle', 'none', 'linewidth', 2)
plot(d1, plot_range, DIC_out_array(bad_phase,3), 'color', deep_color, 'marker', 'x', 'linestyle', 'none', 'linewidth', 2)
plot(d2, plot_range, DIC_out_array(bad_phase,4), 'color', 'k', 'marker', 'x', 'linestyle', 'none', 'linewidth', 2)
plot_index = max(plot_range);
plot(d1, [plot_index plot_index]+0.5, [2100 2400], '--k')
plot(d2, [plot_index plot_index]+0.5, [-160 -20], '--k')
if plot_text==1
    text(d1, (plot_range(end)-plot_range(1))/2 + plot_range(1)-1, 2375, 'Bad phase')
end
double_peak = find(contains(DIC_out_array_names, {'CanESM2', 'CMCC_CESM', 'ESM2M'}));
plot_range = plot_index+1:plot_index+length(double_peak);

plot(d1, plot_range, DIC_out_array(double_peak,2), 'color', surf_color, 'marker', 'x', 'linestyle', 'none', 'linewidth', 2)
plot(d1, plot_range, DIC_out_array(double_peak,3), 'color', deep_color, 'marker', 'x', 'linestyle', 'none', 'linewidth', 2)
plot(d2, plot_range, DIC_out_array(double_peak,4), 'color', 'k', 'marker', 'x', 'linestyle', 'none', 'linewidth', 2)
plot_index = max(plot_range);
plot(d1, [plot_index plot_index]+0.5, [2100 2400], '--k')
plot(d2, [plot_index plot_index]+0.5, [-160 -20], '--k')
if plot_text==1
    text(d1, (plot_range(end)-plot_range(1))/2 + plot_range(1)-1, 2375, 'Double Peak')
end
other = find(contains(DIC_out_array_names, {  'GISS_E2_H_CC', 'GISS_E2_R_CC', ...
    'GISS_E2_R',  'BCC_CSM2_MR_6'   ...
    }));
plot_range = plot_index+1:plot_index+length(other);

p1 = plot(d1, plot_range, DIC_out_array(other,2), 'color', surf_color, 'marker', 'x', 'linestyle', 'none', 'linewidth', 2);
p2 = plot(d1, plot_range, DIC_out_array(other,3), 'color', deep_color, 'marker', 'x', 'linestyle', 'none', 'linewidth', 2);
plot(d2, plot_range, DIC_out_array(other,4), 'color', 'k', 'marker', 'x', 'linestyle', 'none', 'linewidth', 2)
if plot_text==1
    
    text(d1, (plot_range(end)-plot_range(1))/2 + plot_range(1), 2375, 'Other')
end
legend(d1, [p1 p2], 'Surface', [num2str(deep_depth) ' m'], 'location', 'northeast')

plot_index = max(plot_range);

label_names = DIC_out_array_names;

for l = 1:length(label_names)
    label_names{l}(strfind(label_names{l}, '_')) = ' ';
end
set([d1 d2], 'xtick', 1:plot_index)
set([d1 d2], 'xlim', [0 plot_index+1])

set(d2, 'xticklabel',  {'GLODAP' 'SOCCOM' label_names{good_mag_good_phase} label_names{large_mag_good_phase} label_names{bad_phase} label_names{double_peak} label_names{other}})
xtickangle(d2, 45)
set(d1, 'xticklabel', [])
set([d1 d2], 'ygrid', 'on', 'fontsize', 16)

ylabel(d1, '[DIC]')
ylabel(d2, 'Surface DIC - Deep DIC')
set(d2, 'ylim', [-140 -30])
tab_pos = get(d2, 'position');

set(d2, 'position', tab_pos+[0 .1 0 0])
print(gcf, '-dpdf', [Plot_out_dir 'DIC/' plot_filename '_v4.pdf'])

clear l d1 d2

%% plotting difference between seasonal DIC and TALK
plot_filename = 'Obs model Seasonal DIC minus TALK_v2';
clf
set(gcf, 'units', 'inches')
paper_w = 15; paper_h =8;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

subplot(1,1,1)
hold on
legend_names = {};
for m = 1:length(cmip_dic_talk_mon_names)
    
    plot(1:12, DIC_TALK_out_seasonal(m,:,1), 'color', cmap(find(contains(color_model(:,1), cmip_dic_talk_mon_names{m})),:), 'linewidth', 2);
    
    legend_names = [legend_names ; cmip_dic_talk_mon_names{m}];
    
end

% e1 = errorbar(1:12, obs_dic_monthly(:,1)-obs_talk_monthly(:,1), obs_dic_monthly(:,2)+obs_talk_monthly(:,2), 'linewidth', 3, 'color', 'k');
e1 = plot(1:12, obs_dic_monthly(:,1)-obs_talk_monthly(:,1), 'linewidth', 3, 'color', 'k', 'linestyle', '--');

ylabel('[TALK] (umol / l)')
xlabel('Month')
set(gca, 'fontsize', 15, 'xlim', [.5 12.5])

legend([legend_names ; 'Obs'], 'interpreter', 'none', 'location', 'eastoutside', 'box', 'off', 'fontsize', 10)
title('Seasonal DIC - TALK')
print(gcf, '-dpng', [Plot_out_dir 'DIC_TALK_Diff/' plot_filename '.png'])

%% plotting difference between seasonal DIC and TALK by model group

for q = 1:length(model_types)
    
    plot_filename = ['Obs model Seasonal DIC - Talk by model_groups ' model_types{q}];
    clf
    set(gcf, 'units', 'inches')
    paper_w = 15; paper_h =8;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    
    subplot(1,1,1)
    hold on
    
    p = [];
    legend_list = [];
    model_list = CMIP5_mon_talk.model_groups.(model_types{q});
    if ~isempty(model_list)
        for m = 1:length(model_list)
            
            p1 = plot(1:12, DIC_out_seasonal(dic_index,:,1)-TALK_out_seasonal(model_list(m),:,1), 'color', cmap(find(contains(color_model(:,1), cmip_talk_mon_names{model_list(m)})),:), 'linewidth', 2);
            p(m) = p1(1);
            legend_list = [legend_list ; {cmip_talk_mon_names{model_list(m)}}];
        end
    else
        p = plot([-1 -1], [0 0], 'color', model_group_colors(q,:), 'linewidth', 2);
    end
    
    % e1 = errorbar(1:12, obs_dic_monthly(:,1), obs_dic_monthly(:,2), 'linewidth', 3, 'color', 'k');
    e1 = plot(1:12, obs_dic_monthly(:,1)-obs_talk_monthly(:,1), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
    
    ylabel('DIC-TALK')
    xlabel('Month')
    set(gca, 'fontsize', 15, 'xlim', [.5 12.5])
    set(gca, 'xtick', [1 3 5 7 9 11], 'xticklabel',{'Jan.', 'Mar.', 'May', 'July', 'Sept.', 'Nov.'} )
    
    legend([p e1], [legend_list ; {'Obs'}], 'interpreter', 'none', 'location', 'eastoutside', 'box', 'off', 'fontsize', 10)
    title('Seasonal DIC-TALK')
    print(gcf, '-dpng', [Plot_out_dir  'DIC_TALK_Diff/' plot_filename '.png'])
    
    clear p e1 q m paper_w paper_h
    
end



%% plotting more complex difference between seasonal DIC and TALK by model group

for q = 1:length(model_types)
    
    plot_filename = ['Obs model Seasonal (2DIC - Talk)2_(Alk-DIC) by model_groups ' model_types{q}];
    clf
    set(gcf, 'units', 'inches')
    paper_w = 15; paper_h =8;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    
    subplot(1,1,1)
    hold on
    
    p = [];
    legend_list = [];
    model_list = CMIP5_mon_talk.model_groups.(model_types{q});
    if ~isempty(model_list)
        for m = 1:length(model_list)
            
            dic_index = find(contains(cmip_monthly_names,  cmip_talk_mon_names{model_list(m)}));
            if isempty(dic_index)
                continue
            end
            p1 = plot(1:12, ((2.*DIC_out_seasonal(dic_index,:,1)-TALK_out_seasonal(model_list(m),:,1)).^2)./(TALK_out_seasonal(model_list(m),:,1) - DIC_out_seasonal(dic_index,:,1)),...
                'color', cmap(find(contains(color_model(:,1), cmip_talk_mon_names{model_list(m)})),:), 'linewidth', 2);
            p(m) = p1(1);
            legend_list = [legend_list ; {cmip_talk_mon_names{model_list(m)}}];
            clear dic_index p1
        end
    else
        p = plot([-1 -1], [0 0], 'color', model_group_colors(q,:), 'linewidth', 2);
    end
    
    % e1 = errorbar(1:12, obs_dic_monthly(:,1), obs_dic_monthly(:,2), 'linewidth', 3, 'color', 'k');
    e1 = plot(1:12, ((2.*obs_dic_monthly(:,1)-obs_talk_monthly(:,1)).^2)./(obs_talk_monthly(:,1)-obs_dic_monthly(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
    
    ylabel('DIC-TALK')
    xlabel('Month')
    set(gca, 'fontsize', 15, 'xlim', [.5 12.5])
    set(gca, 'xtick', [1 3 5 7 9 11], 'xticklabel',{'Jan.', 'Mar.', 'May', 'July', 'Sept.', 'Nov.'} )
    
    legend([p e1], [legend_list ; {'Obs'}], 'interpreter', 'none', 'location', 'eastoutside', 'box', 'off', 'fontsize', 10)
    title('Seasonal DIC-TALK')
    print(gcf, '-dpng', [Plot_out_dir  'DIC_TALK_Diff/' plot_filename '.png'])
    
    clear legend_list
end

clear p e1 q m paper_w paper_h

%% plotting Anomaly difference between seasonal DIC and TALK by model group

replace_model_ALK_w_obs =0;
replace_model_DIC_w_obs =1;

if replace_model_ALK_w_obs==1
    alk_name = 'alk_replaced_';
else
    alk_name = '';
end

if replace_model_DIC_w_obs==1
    dic_name = 'DIC_replaced_';
else
    dic_name = '';
end
for q = 1:length(model_types)
    
    plot_filename = ['Obs model Seasonal DIC - Talk Anomaly by model_groups ' alk_name dic_name model_types{q}];
    clf
    set(gcf, 'units', 'inches')
    paper_w = 8; paper_h =4;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    
    subplot(1,1,1)
    hold on
    
    p = [];
    legend_list = [];
    model_list = CMIP5_mon_talk.model_groups.(model_types{q});
    if ~isempty(model_list)
        for m = 1:length(model_list)
            
            dic_index = find(contains(cmip_monthly_names,  cmip_talk_mon_names{model_list(m)}));
            if isempty(dic_index)
                continue
            end
            if replace_model_ALK_w_obs==0
                alk_for_plot = TALK_out_seasonal(model_list(m),:,1);
            else
                alk_for_plot = obs_talk_monthly(:,1)';
            end
            
            if replace_model_DIC_w_obs==0
                dic_for_plot = DIC_out_seasonal(dic_index,:,1);
            else
                dic_for_plot = obs_dic_monthly(:,1)';
            end
            
            p1 = plot(1:12, dic_for_plot-alk_for_plot - nanmean(dic_for_plot-alk_for_plot),...
                'color', cmap(find(contains(color_model(:,1), cmip_talk_mon_names{model_list(m)})),:), 'linewidth', 2);
            p(m) = p1(1);
            legend_list = [legend_list ; {cmip_talk_mon_names{model_list(m)}}];
            clear dic_index p1
        end
    else
        p = plot([-1 -1], [0 0], 'color', model_group_colors(q,:), 'linewidth', 2);
    end
    
    % e1 = errorbar(1:12, obs_dic_monthly(:,1), obs_dic_monthly(:,2), 'linewidth', 3, 'color', 'k');
    e1 = plot(1:12, obs_dic_monthly(:,1)-obs_talk_monthly(:,1) - nanmean(obs_dic_monthly(:,1)-obs_talk_monthly(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
    
    ylabel('DIC-TALK')
    %     xlabel('Month')
    set(gca, 'fontsize', 20, 'xlim', [.5 12.5], 'ylim', [-30 30])
    set(gca, 'xtick', [1 3 5 7 9 11], 'xticklabel',{'Jan.', 'Mar.', 'May', 'July', 'Sept.', 'Nov.'} )
    
    legend([p e1], [legend_list ; {'Obs'}], 'interpreter', 'none', 'location', 'eastoutside', 'box', 'off', 'fontsize', 10)
    title(model_types{q}, 'interpreter', 'none')
    print(gcf, '-dpng', [Plot_out_dir  'DIC_TALK_Diff/' plot_filename '_v2.png'])
    
    clear p e1 q m paper_w paper_h
    
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

v =9;

plot_filename = ['Obs model Seasonal ' anomaly_text variables{v} '_v8'];
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
        plot(1:12, CMIP.(variables{v}).out_seasonal(m,:,1)-nanmean(CMIP.(variables{v}).out_seasonal(m,:,1)), 'color', cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:), 'linewidth', 3);
    else
        plot(1:12, CMIP.(variables{v}).out_seasonal(m,:,1), 'color', cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:), 'linewidth', 3);
    end
    
    legend_names{end+1,1} = cmip_names.(variables{v}){m};
end

if v==9
    if anomaly==1
        e1 = errorbar(1:12, obs.(variables{v}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,1)-nanmean( obs.(variables{v}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,1)), ...
            obs.(variables{v}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 4, 'color', 'k', 'linestyle', '--');
    else
        e1 = errorbar(1:12, obs.(variables{v}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,1), obs.(variables{v}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 4, 'color', 'k', 'linestyle', '--');
    end
else
    if anomaly==1
        e1 = plot(1:12, obs.(variables{v}).out_seasonal(:,1)-nanmean( obs.(variables{v}).out_seasonal(:,1)), 'linewidth', 4, 'color', 'k', 'linestyle', '--');
    else
        e1 = plot(1:12, obs.(variables{v}).out_seasonal(:,1), 'linewidth', 4, 'color', 'k', 'linestyle', '--');
    end
end
ylabel([variables{v} ' ' anomaly_text ' (' (CMIP.(variables{v}).(cmip_names.(variables{v}){1}).units) ')'], 'interpreter', 'none')

xlabel('Month')
l1 = legend([legend_names ; 'Obs'], 'interpreter', 'none', 'location', 'eastoutside');
set(gca, 'fontsize', 18)
set(l1, 'fontsize', 10)
title(['Seasonal ' variables{v}])
% print(gcf, '-dtiff', [Plot_out_dir variables{v} '/' plot_filename '.tif'])
print(gcf, '-dpng', [Plot_out_dir variables{v} '/' plot_filename '.png'])

% Separate seasonal plots by model group
% v=4;
clear m plot_filename
% 
% for q = 1:length(model_types)
%     CMIP5_mon_fgco2.model_groups.(model_types{q}) = find(contains(cmip_fgco2_names, model_group_names.(model_types{q})));
% end

% CMIP5_mon_fgco2.model_groups.good_mag_good_phase = find(contains(cmip_fgco2_names, {'MIROC_ESM', 'MIROC_ESM_CHEM', ...
%     'HadGEM', 'CESM1_BGC', 'GFDL_ESM4_6'}));
% CMIP5_mon_fgco2.model_groups.large_mag_good_phase = find(contains(cmip_fgco2_names, {'MPI', 'NorESM1', 'MPI_ESM1_2_HR_6', 'MPI_ESM1_2_LR_6'}));
% CMIP5_mon_fgco2.model_groups.bad_phase = find(contains(cmip_fgco2_names, {'IPSL', 'MRI', 'CNRM_CM5','ESM2G', ...
%     'CESM2_WACCM_6', 'CESM2_6', 'CNRM_ESM2_1_6', 'UKESM1_0_LL_6', 'CanESM5_6', 'MIROC_ES2L_6', ...
%     'INM_CM5_0_6','INM_CM4_8_6', 'ACCESS_ESM1_5_6', 'GFDL_CM4_6', 'NorESM2_LM_6', 'NorESM2_MM_6'}));
% CMIP5_mon_fgco2.model_groups.double_peak = find(contains(cmip_fgco2_names, {'CanESM2', 'CMCC_CESM', 'ESM2M'}));
% CMIP5_mon_fgco2.model_groups.other = find(contains(cmip_fgco2_names, {  'GISS_E2_H_CC', 'GISS_E2_R_CC', ...
%     'GISS_E2_R',  'BCC_CSM2_MR_6'   ...
%      }));

% model_types = fieldnames(CMIP5_mon_fgco2.model_groups);

clf
set(gcf, 'units', 'inches')
paper_w = 14; paper_h =8;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

plot_filename = ['Obs model Seasonal ' anomaly_text '_' variables{v} 'split_by_model_types_v7'];

for q = 1:length(model_types)
    
    
    subplot(2,2,q)
    hold on
    
    grid on; set(gca, 'gridalpha', .4)
    
    model_list = CMIP.(variables{v}).model_groups.(model_types{q});
    for m = 1: length(model_list)
        % [l, a] = boundedline(1:12, DIC_out_seasonal(m,:,1), DIC_out_seasonal(m,:,2));
        % a.FaceAlpha = 0.3;
        if anomaly==1
            plot(1:12, CMIP.(variables{v}).out_seasonal(model_list(m),:,1) - nanmean(CMIP.(variables{v}).out_seasonal(model_list(m),:,1)), ...
                'color', cmap(strcmp(cmip_names.(variables{v}){model_list(m)}, color_model(:,1)),:), 'linewidth', 2);
        else
            plot(1:12, CMIP.(variables{v}).out_seasonal(model_list(m),:,1), 'color', cmap(strcmp(cmip_names.(variables{v}){model_list(m)}, color_model(:,1)),:), 'linewidth', 2);
        end
    end
    
    if v==9
        if anomaly==1
            e1 = errorbar(1:12, obs.(variables{v}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,1)-nanmean(obs.(variables{v}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,1)), obs.(variables{v}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
        else
            e1 = errorbar(1:12, obs.(variables{v}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,1), obs.(variables{v}).Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
        end
    else
        if anomaly==1
            e1 = plot(1:12, obs.(variables{v}).out_seasonal(:,1)-nanmean(obs.(variables{v}).out_seasonal(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
        else
            e1 = plot(1:12, obs.(variables{v}).out_seasonal(:,1), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
        end
        
    end
    ylabel([variables{v} ' ' anomaly_text ' (' (CMIP.(variables{v}).(cmip_names.(variables{v}){1}).units) ')'])
    %     xlabel('Month')
    set(gca, 'fontsize', 16)
    if anomaly==1
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
    print(gcf, '-dpng', '-r300', [Plot_out_dir variables{v} '/' plot_filename '.png'])
    clear  plot_filename

%% obs on their own
plot_filename = ['Obs Seasonal fgco2_Pg_mon_v2'];

clf
set(gcf, 'units', 'inches')
paper_w = 10; paper_h =6;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

subplot(1,1,1)
hold on

grid on; set(gca, 'gridalpha', .4)

%     model_list = CMIP5_mon_fgco2.model_groups.(model_types{q});
%     for m = 1: length(model_list)
%         % [l, a] = boundedline(1:12, DIC_out_seasonal(m,:,1), DIC_out_seasonal(m,:,2));
%         % a.FaceAlpha = 0.3;
%         plot(1:12, fgco2_out_seasonal(model_list(m),:,1), 'color', cmap(strmatch(cmip_fgco2_names{model_list(m)}, color_model(:,1), 'exact'),:), 'linewidth', 2);
%
%     end

e1 = errorbar(1:12, neur_out_seasonal(1,:,1), neur_out_seasonal(1,:,2), 'linewidth', 3, 'color', 'k', 'linestyle', '--');

ylabel('Integrated Flux (Tg C mon^-^1)')
%     xlabel('Month')
set(gca, 'fontsize', 18)
set(gca, 'ylim', [-200 200])
set(gca , 'xtick', [1 3 5 7 9 11])
set(gca, 'xticklabel',{'Jan.', 'Mar.', 'May', 'July', 'Sept.', 'Nov.'} )

l1 = legend([ 'Obs'], 'interpreter', 'none', 'location', 'eastoutside');
set(l1, 'fontsize', 14)
%     title(['Seasonal fgco2 model subset: ' model_types{q}], 'interpreter', 'none')
print(gcf, '-dtiff', [Plot_out_dir 'fgco2/' plot_filename '.tif'])

clear m plot_filename
% pause

%% fgco2 annual mean

plot_filename = 'annual flux';

clf
set(gcf, 'units', 'inches')
paper_w = 8; paper_h =8;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

d1 = subplot(1,1,1);
model_types = fieldnames(CMIP5_mon_fgco2.model_groups);
hold on
e1 = errorbar(d1, 1, -.75, .22);
set(e1, 'color', 'k', 'marker', 'x', 'linewidth', 2)

plot_index = 2;
for q = 1:length(model_types)-1
    
    model_list = CMIP5_mon_fgco2.model_groups.(model_types{q});
    
    ppp = NaN(length(model_list),1);
    ppp(:) = plot_index;
    e2= errorbar(d1, ppp, fgco2_out_annual(model_list,1), fgco2_out_annual(model_list,2));
    set(e2, 'marker', 'x','color', model_group_colors(q,:), 'linewidth', 2)
    plot_index = plot_index+1;
    
end
set(d1, 'xlim', [.5 6.5])

set(d1, 'xtick', [1:6], 'xticklabels', {'Obs.', 'Good phase, mag', 'Good phase, large mag', 'Out of phase', 'Double peak', 'Other'})
xtickangle(d1, 45)
set(d1, 'fontsize', 18)
ylabel(d1, 'Annual Flux, <35\circS (Pg C yr^-^1)')

print(gcf, '-dpdf', [Plot_out_dir plot_filename '.pdf'])


%% Calculating pCO2 from model output

%  [Result,Headers]             = CO2SYS(2400,   8,1,3,35,0,25,4200,0,15,1,1,10,3)
% INPUT:
%   PAR1  (some unit) : scalar or vector of size n
%   PAR2  (some unit) : scalar or vector of size n
%   PAR1TYPE       () : scalar or vector of size n (*)
%   PAR2TYPE       () : scalar or vector of size n (*)
%   SAL            () : scalar or vector of size n
%   TEMPIN  (degr. C) : scalar or vector of size n
%   TEMPOUT (degr. C) : scalar or vector of size n
%   PRESIN     (dbar) : scalar or vector of size n
%   PRESOUT    (dbar) : scalar or vector of size n
%   SI    (umol/kgSW) : scalar or vector of size n
%   PO4   (umol/kgSW) : scalar or vector of size n
%   pHSCALEIN         : scalar or vector of size n (**)
%   K1K2CONSTANTS     : scalar or vector of size n (***)
%   KSO4CONSTANTS     : scalar or vector of size n (****)
%
% example from SO_air_flux

%  [DATA,HEADERS,NICEHEADERS]=CO2SYSSOCCOM(Argo.(SO_SNs{f}).TALK_LIAR(p,:), Argo.(SO_SNs{f}).pH_insitu_corr(p,:) , ...
%                     1,3,Argo.(SO_SNs{f}).Sal(p,:),Argo.(SO_SNs{f}).Temp_C(p,:),Argo.(SO_SNs{f}).Temp_C(p,:),...
%                     Argo.(SO_SNs{f}).Press_db(p,:),Argo.(SO_SNs{f}).Press_db(p,:),SI,PO4,1,10,3);
% [Result]                     = CO2SYS(CMIP5_mon_talk.CESM1_BGC.talk(:,1,end),CMIP5_monthly.CESM1_BGC.DIC(:,1,end),1,2,CMIP5_ts.CESM1_BGC.sos(:,1,end),CMIP5_ts.CESM1_BGC.tos(:,1,end),CMIP5_ts.CESM1_BGC.tos(:,1,end),0,0,15,1,1,4,1);
% SI= 5;
% PO4=1.8;
clear CMIP5_test
test_names = cell(length(cmip_names.dissic),1);

%% Recalculating pCO2 for different tests
lat_index = find(CMIP.talk.lat>= lat_lims(1) & CMIP.talk.lat<= lat_lims(2));

SI= 5;
PO4=1.8;
tic

% loop through DIC names
for m = 2:length(cmip_names.dissic)
    
    talk_index = find(contains(cmip_names.talk, cmip_names.dissic{m}));
    tos_index = find(contains(cmip_names.tos, cmip_names.dissic{m}));
    sos_index = find(contains(cmip_names.sos, cmip_names.dissic{m}));
    %     spco2_index = find(contains(cmip_names.spco2, cmip_names.dissic{m})); % don't need spco2 for this calculation, but you do need it to show an "improvement"
    
    if isempty(talk_index) || isempty(tos_index) || isempty(sos_index) % isempty(spco2_index) ||
        continue
    end
    disp([cmip_names.dissic{m} ' started'])
    
    test_names = { 'pCO2_recalc' 'pCO2_recalc_real_SST' 'pCO2_mean_DIC_shift_real_SST' 'pCO2_mean_DIC_shift' 'pCO2_mean_TALK_shift' 'pCO2_mean_DIC_TALK_shift'};
    
    for tn = 1:length(test_names)
        if ~isfield(CMIP5_test.(cmip_names.dissic{m}), test_names{tn})
            CMIP5_test.(cmip_names.dissic{m}).(test_names{tn}) = NaN(360,length(lat_index), length(CMIP.dissic.(cmip_names.dissic{m}).GMT_Matlab));
        end
    end
    %     CMIP5_test.(cmip_names.dissic{m}).pCO2_recalc_real_SST = NaN(360,length(lat_index), length(CMIP.dissic.(cmip_names.dissic{m}).GMT_Matlab));
    %     % %     CMIP5_test.(cmip_names.dissic{m}).pCO2_recalc_real_SST_SSS = NaN(360,length(lat_index), length(CMIP5_monthly.(cmip_names.dissic{m}).GMT_Matlab));
    %     CMIP5_test.(cmip_names.dissic{m}).pCO2_mean_DIC_shift_real_SST = NaN(360,length(lat_index), length(CMIP.dissic.(cmip_names.dissic{m}).GMT_Matlab));
    %     CMIP5_test.(cmip_names.dissic{m}).pCO2_mean_DIC_shift = NaN(360,length(lat_index), length(CMIP.dissic.(cmip_names.dissic{m}).GMT_Matlab));
    %     CMIP5_test.(cmip_names.dissic{m}).pCO2_mean_TALK_shift = NaN(360,length(lat_index), length(CMIP.dissic.(cmip_names.dissic{m}).GMT_Matlab));
    
    
    %loop through each time step
    for tt = 1:length(CMIP.dissic.(cmip_names.dissic{m}).GMT_Matlab)
        disp(tt)
        [~, mon, ~, ~, ~, ~] = datevec(CMIP.dissic.(cmip_names.dissic{m}).GMT_Matlab(tt));
        
        temp_dens = sw_dens(CMIP.sos.(cmip_names.dissic{m}).sos(:,:,tt), CMIP.tos.(cmip_names.dissic{m}).tos(:,:,tt), 1)./1000;  % first in kg / m3 then kg /l
        
        
        if sum(~isnan(reshape(CMIP5_test.(cmip_names.dissic{m}).pCO2_recalc(:,:,tt), [],1)))==0
            if tt==1; disp([cmip_names.dissic{m} ' pCO2 recalculation, no vars changed']); end
            for la = 1:length(lat_index)
                for ll = 1:360
                    
                    [DATA,~,~]=CO2SYSSOCCOM_smb(CMIP.talk.(cmip_names.dissic{m}).talk(ll,lat_index(la),tt)./temp_dens(ll,lat_index(la)), ...
                        CMIP.dissic.(cmip_names.dissic{m}).dissic(ll,lat_index(la),tt)./temp_dens(ll,lat_index(la)), ...
                        1,2, CMIP.sos.(cmip_names.dissic{m}).sos(ll,lat_index(la),tt), CMIP.tos.(cmip_names.dissic{m}).tos(ll,lat_index(la),tt), CMIP.tos.(cmip_names.dissic{m}).tos(ll,lat_index(la),tt),...
                        1,1,SI,PO4,1,10,3);
                    CMIP5_test.(cmip_names.dissic{m}).pCO2_recalc(ll,la,tt) = DATA(4);
                end
            end
        end
        
        if sum(~isnan(reshape(CMIP5_test.(cmip_names.dissic{m}).pCO2_recalc_real_SST(:,:,tt), [],1)))==0
            if tt==1; disp([cmip_names.dissic{m} ' pCO2 recalculation, real SST']); end
            
            for la = 1:length(lat_index)
                for ll = 1:360
                    
                    [DATA,~,~]=CO2SYSSOCCOM_smb(CMIP.talk.(cmip_names.dissic{m}).talk(ll,lat_index(la),tt)./temp_dens(ll,lat_index(la)), ...
                        CMIP.dissic.(cmip_names.dissic{m}).dissic(ll,lat_index(la),tt)./temp_dens(ll,lat_index(la)), ...
                        1,2, CMIP.sos.(cmip_names.dissic{m}).sos(ll,lat_index(la),tt), NOAA_SST.SST_mean_flipped(ll,lat_index(la),mon), NOAA_SST.SST_mean_flipped(ll,lat_index(la),mon),...
                        1,1,SI,PO4,1,10,3);
                    CMIP5_test.(cmip_names.dissic{m}).pCO2_recalc_real_SST(ll,la,tt) = DATA(4);
                end
            end
        end
        %
        %                                 [DATA,~,~]=CO2SYSSOCCOM_smb(CMIP5_mon_talk.(cmip_names.dissic{m}).talk(ll,lat_index(la),tt).*temp_dens(ll,lat_index(la)), CMIP.dissic.(cmip_names.dissic{m}).DIC(ll,lat_index(la),tt).*temp_dens(ll,lat_index(la)), ...
        %                                     1,2, WOA_SSS.SSS(ll,lat_index(la),mon), NOAA_SST.SST_mean_flipped(ll,lat_index(la),mon), NOAA_SST.SST_mean_flipped(ll,lat_index(la),mon),...
        %                                     1,1,SI,PO4,1,10,3);
        %                                 CMIP5_test.(cmip_names.dissic{m}).pCO2_recalc_real_SST_SSS(ll,la,tt) = DATA(4);
        %
        if sum(~isnan(reshape(CMIP5_test.(cmip_names.dissic{m}).pCO2_mean_DIC_shift_real_SST(:,:,tt), [],1)))==0
            if tt==1; disp([cmip_names.dissic{m} ' pCO2 recalculation, real SST, mean DIC shifted']); end
            
            for la = 1:length(lat_index)
                for ll = 1:360
                    
                    [DATA,~,~]=CO2SYSSOCCOM_smb(CMIP.talk.(cmip_names.dissic{m}).talk(ll,lat_index(la),tt)./temp_dens(ll,lat_index(la)), ...
                        CMIP.dissic.(cmip_names.dissic{m}).dissic(ll,lat_index(la),tt)./temp_dens(ll,lat_index(la))+CMIP.dissic.out_mean_diff(m), ...
                        1,2, CMIP.sos.(cmip_names.dissic{m}).sos(ll,lat_index(la),tt), NOAA_SST.SST_mean_flipped(ll,lat_index(la),mon), NOAA_SST.SST_mean_flipped(ll,lat_index(la),mon),...
                        1,1,SI,PO4,1,10,3);
                    CMIP5_test.(cmip_names.dissic{m}).pCO2_mean_DIC_shift_real_SST(ll,la,tt) = DATA(4);
                end
            end
        end
        
        if sum(~isnan(reshape(CMIP5_test.(cmip_names.dissic{m}).pCO2_mean_DIC_shift(:,:,tt), [],1)))==0
            
            if tt==1; disp([cmip_names.dissic{m} ' pCO2 recalculation, mean DIC shifted']); end
            for la = 1:length(lat_index)
                for ll = 1:360
                    
                    [DATA,~,~]=CO2SYSSOCCOM_smb(CMIP.talk.(cmip_names.dissic{m}).talk(ll,lat_index(la),tt)./temp_dens(ll,lat_index(la)), ...
                        CMIP.dissic.(cmip_names.dissic{m}).dissic(ll,lat_index(la),tt)./temp_dens(ll,lat_index(la))+CMIP.dissic.out_mean_diff(m), ...
                        1,2, CMIP.sos.(cmip_names.dissic{m}).sos(ll,lat_index(la),tt), CMIP.tos.(cmip_names.dissic{m}).tos(ll,lat_index(la),tt), CMIP.tos.(cmip_names.dissic{m}).tos(ll,lat_index(la),tt),...
                        1,1,SI,PO4,1,10,3);
                    CMIP5_test.(cmip_names.dissic{m}).pCO2_mean_DIC_shift(ll,la,tt) = DATA(4);
                end
            end
        end
        
        if sum(~isnan(reshape(CMIP5_test.(cmip_names.dissic{m}).pCO2_mean_TALK_shift(:,:,tt), [],1)))==0
            if tt==1; disp([cmip_names.dissic{m} ' pCO2 recalculation, mean TALK shifted']); end
            for la = 1:length(lat_index)
                for ll = 1:360
                    [DATA,~,~]=CO2SYSSOCCOM_smb(CMIP.talk.(cmip_names.dissic{m}).talk(ll,lat_index(la),tt)./temp_dens(ll,lat_index(la))+CMIP.talk.out_mean_diff(talk_index), ... % TALK
                        CMIP.dissic.(cmip_names.dissic{m}).dissic(ll,lat_index(la),tt)./temp_dens(ll,lat_index(la)), ... % DIC
                        1,2, CMIP.sos.(cmip_names.dissic{m}).sos(ll,lat_index(la),tt), CMIP.tos.(cmip_names.dissic{m}).tos(ll,lat_index(la),tt), CMIP.tos.(cmip_names.dissic{m}).tos(ll,lat_index(la),tt),...
                        1,1,SI,PO4,1,10,3);
                    CMIP5_test.(cmip_names.dissic{m}).pCO2_mean_TALK_shift(ll,la,tt) = DATA(4);
                end
            end
        end
        
        if sum(~isnan(reshape(CMIP5_test.(cmip_names.dissic{m}).pCO2_mean_DIC_TALK_shift(:,:,tt), [],1)))==0
            if tt==1; disp([cmip_names.dissic{m} ' pCO2 recalculation, mean DIC, mean TALK shifted']); end
            for la = 1:length(lat_index)
                for ll = 1:360
                    [DATA,~,~]=CO2SYSSOCCOM_smb(CMIP.talk.(cmip_names.dissic{m}).talk(ll,lat_index(la),tt)./temp_dens(ll,lat_index(la))+CMIP.talk.out_mean_diff(talk_index), ... % TALK
                        CMIP.dissic.(cmip_names.dissic{m}).dissic(ll,lat_index(la),tt)./temp_dens(ll,lat_index(la))+CMIP.dissic.out_mean_diff(m), ... % DIC
                        1,2, CMIP.sos.(cmip_names.dissic{m}).sos(ll,lat_index(la),tt), CMIP.tos.(cmip_names.dissic{m}).tos(ll,lat_index(la),tt), CMIP.tos.(cmip_names.dissic{m}).tos(ll,lat_index(la),tt),...
                        1,1,SI,PO4,1,10,3);
                    CMIP5_test.(cmip_names.dissic{m}).pCO2_mean_DIC_TALK_shift(ll,la,tt) = DATA(4);
                end
            end
        end
        
        clear temp_dens mon
    end
    test_names{m} = cmip_names.dissic{m};
    disp([cmip_names.dissic{m} ' finished'])
    clear talk_index tos_index
    
end
toc

%% test plot looking at differences
m=2;
mon = 60;
clf

recalc_pCO2 = CMIP5_test.(cmip_names.dissic{m}).pCO2_mean_DIC_shift(:,:,mon);
temp_slp = CMIP.psl.(cmip_names.dissic{m}).psl(:,lat_index,mon);
adjust_recalc_pCO2 = recalc_pCO2.*temp_slp./1013.25;
subplot(4,1,1)
pcolor(CMIP.spco2.(cmip_names.dissic{m}).spco2(:,lat_index, mon)'); shading flat; colorbar
title(cmip_names.dissic{m})
subplot(4,1,2)
pcolor(adjust_recalc_pCO2'); shading flat; colorbar

subplot(4,1,3)
pcolor(CMIP.spco2.(cmip_names.dissic{m}).spco2(:,lat_index, mon)' - adjust_recalc_pCO2'); shading flat; colorbar
title('Difference')

subplot(4,1,4)
pcolor(CMIP.psl.(cmip_names.dissic{m}).psl(:,lat_index,mon)'); shading flat; colorbar

%% saving recalc spco2 monthly means and std
lat_index = CMIP.talk.lat>= lat_lims(1) & CMIP.talk.lat<= lat_lims(2);


CMIP5_test.pco2_out_seasonal_orig = NaN(length(cmip_names.dissic),12,2);
CMIP5_test.pco2_out_seasonal_no_change = NaN(length(cmip_names.dissic),12,2);
CMIP5_test.pco2_out_seasonal_real_SST = NaN(length(cmip_names.dissic),12,2);
CMIP5_test.pco2_out_seasonal_real_SST_SSS = NaN(length(cmip_names.dissic),12,2);
CMIP5_test.pco2_out_seasonal_no_change_press_adjust = NaN(length(cmip_names.dissic),12,2);
CMIP5_test.pco2_out_seasonal_mean_DIC_shift_real_SST = NaN(length(cmip_names.dissic),12,2);
CMIP5_test.pco2_out_seasonal_mean_DIC_shift = NaN(length(cmip_names.dissic),12,2);
CMIP5_test.pco2_out_seasonal_mean_TALK_shift = NaN(length(cmip_names.dissic),12,2);
CMIP5_test.pco2_out_seasonal_mean_DIC_TALK_shift = NaN(length(cmip_names.dissic),12,2);

lat_index_spco2 = CMIP.spco2.lat<=lat_lims(2) & CMIP.spco2.lat>=lat_lims(1);

for m = 2:length(cmip_names.dissic)
    
    for mon = 1:12
        if ~isfield(CMIP.spco2, (cmip_names.dissic{m})) || ~isfield(CMIP5_test, (cmip_names.dissic{m}))
            continue
        end
        mod_vec = datevec(CMIP.spco2.(cmip_names.dissic{m}).GMT_Matlab);
        time_index = mod_vec(:,2)==mon;
        
        % don't need a lat index bc I only did this calculation for the
        % latitudes w/in the lat_lim
        
        if isfield (CMIP5_test.(cmip_names.dissic{m}), 'pCO2_recalc')
            SO_pco2 = CMIP5_test.(cmip_names.dissic{m}).pCO2_recalc(:, :, time_index);
            
            CMIP5_test.pco2_out_seasonal_no_change(m,mon,1) = nanmean(reshape(SO_pco2,[],1));
            CMIP5_test.pco2_out_seasonal_no_change(m,mon,2) = nanstd(reshape(SO_pco2,[],1));
            
            clear SO_pco2
            
        end
        
        if isfield (CMIP.psl, (cmip_names.dissic{m})) && isfield (CMIP5_test.(cmip_names.dissic{m}), 'pCO2_recalc')
            
            SO_pco2 = CMIP5_test.(cmip_names.dissic{m}).pCO2_recalc(:, :, time_index).*CMIP.psl.(cmip_names.dissic{m}).psl(:,lat_index,time_index)./1013.25;
            
            CMIP5_test.pco2_out_seasonal_no_change_press_adjust(m,mon,1) = nanmean(reshape(SO_pco2,[],1));
            CMIP5_test.pco2_out_seasonal_no_change_press_adjust(m,mon,2) = nanstd(reshape(SO_pco2,[],1));
            
            clear SO_pco2
        end
        
        if isfield (CMIP5_test.(cmip_names.dissic{m}), 'pCO2_recalc_real_SST')
            
            SO_pco2 = CMIP5_test.(cmip_names.dissic{m}).pCO2_recalc_real_SST(:, :, time_index);
            
            CMIP5_test.pco2_out_seasonal_real_SST(m,mon,1) = nanmean(reshape(SO_pco2,[],1));
            CMIP5_test.pco2_out_seasonal_real_SST(m,mon,2) = nanstd(reshape(SO_pco2,[],1));
            
            clear SO_pco2
        end
        
        if isfield (CMIP5_test.(cmip_names.dissic{m}), 'pCO2_recalc_real_SST_SSS')
            
            SO_pco2 = CMIP5_test.(cmip_names.dissic{m}).pCO2_recalc_real_SST_SSS(:, :, time_index);
            
            CMIP5_test.pco2_out_seasonal_real_SST_SSS(m,mon,1) = nanmean(reshape(SO_pco2,[],1));
            CMIP5_test.pco2_out_seasonal_real_SST_SSS(m,mon,2) = nanstd(reshape(SO_pco2,[],1));
            
            clear SO_pco2
        end
        
        if isfield (CMIP5_test.(cmip_names.dissic{m}), 'pCO2_mean_DIC_shift_real_SST')
            
            SO_pco2 = CMIP5_test.(cmip_names.dissic{m}).pCO2_mean_DIC_shift_real_SST(:, :, time_index);
            
            CMIP5_test.pco2_out_seasonal_mean_DIC_shift_real_SST(m,mon,1) = nanmean(reshape(SO_pco2,[],1));
            CMIP5_test.pco2_out_seasonal_mean_DIC_shift_real_SST(m,mon,2) = nanstd(reshape(SO_pco2,[],1));
            
            clear SO_pco2
        end
        
        if isfield (CMIP5_test.(cmip_names.dissic{m}), 'pCO2_mean_DIC_shift')
            
            SO_pco2 = CMIP5_test.(cmip_names.dissic{m}).pCO2_mean_DIC_shift(:, :, time_index);
            
            CMIP5_test.pco2_out_seasonal_mean_DIC_shift(m,mon,1) = nanmean(reshape(SO_pco2,[],1));
            CMIP5_test.pco2_out_seasonal_mean_DIC_shift(m,mon,2) = nanstd(reshape(SO_pco2,[],1));
            
            clear SO_pco2
        end
        
              
        if isfield (CMIP5_test.(cmip_names.dissic{m}), 'pCO2_mean_TALK_shift')
            
            SO_pco2 = CMIP5_test.(cmip_names.dissic{m}).pCO2_mean_TALK_shift(:, :, time_index);
            
            CMIP5_test.pco2_out_seasonal_mean_TALK_shift(m,mon,1) = nanmean(reshape(SO_pco2,[],1));
            CMIP5_test.pco2_out_seasonal_mean_TALK_shift(m,mon,2) = nanstd(reshape(SO_pco2,[],1));
            
            clear SO_pco2
        end
        
        if isfield (CMIP5_test.(cmip_names.dissic{m}), 'pCO2_mean_DIC_TALK_shift')
            
            SO_pco2 = CMIP5_test.(cmip_names.dissic{m}).pCO2_mean_DIC_TALK_shift(:, :, time_index);
            
            CMIP5_test.pco2_out_seasonal_mean_DIC_TALK_shift(m,mon,1) = nanmean(reshape(SO_pco2,[],1));
            CMIP5_test.pco2_out_seasonal_mean_DIC_TALK_shift(m,mon,2) = nanstd(reshape(SO_pco2,[],1));
            
            clear SO_pco2
        end
        
        SO_pco2 = CMIP.spco2.(cmip_names.dissic{m}).spco2(:, lat_index_spco2, time_index);
        
        CMIP5_test.pco2_out_seasonal_orig(m,mon,1) = nanmean(reshape(SO_pco2,[],1));
        CMIP5_test.pco2_out_seasonal_orig(m,mon,2) = nanstd(reshape(SO_pco2,[],1));
        
        clear time_index SO_spco2 mod_vec
    end
end
clear m mon


%% Taylor distance calculations for recalculated pCO2
clear taylor
% I believe this removes mean, but I can test that:
taylor.orig.correlation = NaN(size(CMIP5_test.pco2_out_seasonal_orig,1),1);
taylor.orig.ratio = NaN(size(CMIP5_test.pco2_out_seasonal_orig,1),1);
taylor.orig.norm_error = NaN(size(CMIP5_test.pco2_out_seasonal_orig,1),1);

taylor.new.correlation = NaN(size(CMIP5_test.pco2_out_seasonal_orig,1),1);
taylor.new.ratio = NaN(size(CMIP5_test.pco2_out_seasonal_orig,1),1);
taylor.new.norm_error = NaN(size(CMIP5_test.pco2_out_seasonal_orig,1),1);

for m = 1:size(CMIP5_test.pco2_out_seasonal_orig,1)
    [taylor.orig.correlation(m),taylor.orig.ratio(m),taylor.orig.norm_error(m)] = taylor_eval(obs.spco2.out_seasonal(:,1),CMIP5_test.pco2_out_seasonal_orig(m,:,1));
end

for m = 1:size(CMIP5_test.pco2_out_seasonal_orig,1)
    [taylor.new.correlation(m),taylor.new.ratio(m),taylor.new.norm_error(m)] = taylor_eval(obs.spco2.out_seasonal(:,1),CMIP5_test.pco2_out_seasonal_real_SST(m,:,1));
end

%%
obs.pco2_out_seasonal_real_SST.correlation = NaN(size(CMIP.dissic.out_seasonal,1),1);
obs.pco2_out_seasonal_real_SST.ratio = NaN(size(CMIP.dissic.out_seasonal,1),1);
obs.pco2_out_seasonal_real_SST.norm_error = NaN(size(CMIP.dissic.out_seasonal,1),1);


for m = 1:length(cmip_names.dissic)
    [obs.pco2_out_seasonal_real_SST.correlation(m),obs.pco2_out_seasonal_real_SST.ratio(m),obs.pco2_out_seasonal_real_SST.norm_error(m)]=taylor_eval(obs.spco2.out_seasonal(:,1), CMIP5_test.pco2_out_seasonal_real_SST(m,:,1));
end

%%
taylor_index = ~isnan(CMIP5_test.pco2_out_seasonal_orig(:,1));
taylor.orig.filt.correlation = taylor.orig.correlation(taylor_index);
taylor.orig.filt.ratio = taylor.orig.ratio(taylor_index);
taylor.orig.filt.norm_error = taylor.orig.norm_error(taylor_index);

taylor.new.filt.correlation = taylor.new.correlation(taylor_index);
taylor.new.filt.ratio = taylor.new.ratio(taylor_index);
taylor.new.filt.norm_error = taylor.new.norm_error(taylor_index);

taylor_names = cmip_names.dissic(taylor_index);
%% plotting taylor diagram for recalculated and old pCO2
plot_filename = 'Taylor spCO2 recalculated_v3_leg';

clf
subplot(4,1,1:3)
% taylor_dist_smb(taylor.orig.correlation, taylor.orig.ratio, [], cmip_monthly_names, color_model, cmap, 1);
%
% taylor_dist_smb(taylor.new.correlation, taylor.new.ratio, [], cmip_monthly_names, color_model, cmap, 0);
out_taylor = taylor_dist_smb([taylor.orig.filt.correlation taylor.new.filt.correlation], [taylor.orig.filt.ratio taylor.new.filt.ratio], [], taylor_names, color_model, cmap, 1);

d2 = subplot(4,1,4);

hold on
b1 = bar(out_taylor);
set(d2, 'xtick', [1:length(out_taylor)])
set(d2, 'xticklabel', taylor_names, 'XTickLabelRotation', 45)
legend(d2, b1, 'Original', 'Recalc SST')
ylabel('RMS Error')

print(gcf, '-dpng', [Plot_out_dir 'pCO2_recalc/' plot_filename '.png'])

%%
cmap = brewermap(10, 'Dark2');

for m =29
    if sum(~isnan(CMIP5_test.pco2_out_seasonal_orig(m,:,1)))==0
        continue
    end
    clf
    
    subplot(2,1,1)
    p1 = plot(CMIP5_test.pco2_out_seasonal_orig(m, :, 1), 'g-');
    hold on
    p2 = plot(CMIP5_test.pco2_out_seasonal_no_change(m, :, 1), 'r');
    p3 = plot(CMIP5_test.pco2_out_seasonal_real_SST(m, :, 1), 'b');
    p4 = plot(CMIP5_test.pco2_out_seasonal_real_SST_SSS(m, :, 1), 'b--');
    p5 = plot(CMIP5_test.pco2_out_seasonal_no_change_press_adjust(m, :, 1), 'r--');
    p6 = plot(CMIP5_test.pco2_out_seasonal_mean_DIC_shift_real_SST(m, :, 1), 'color', [.6 .6 .6], 'linewidth', 2, 'linestyle', '--');
    p7 = plot(CMIP5_test.pco2_out_seasonal_mean_DIC_shift(m, :, 1), 'color', 'm', 'linewidth', 2, 'linestyle', '-.');
    p8 = plot(CMIP5_test.pco2_out_seasonal_mean_TALK_shift(m, :, 1), 'color', 'k', 'linewidth', 2, 'linestyle', '-');
    p9 = plot(CMIP5_test.pco2_out_seasonal_mean_DIC_TALK_shift(m, :, 1), 'color', cmap(10,:), 'linewidth', 2, 'linestyle', '--');

    plot(1:12, obs.spco2.out_seasonal(:,1), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
    
    title(cmip_names.dissic{m}, 'interpreter', 'none')
    subplot(2,1,2)
    plot(CMIP5_test.pco2_out_seasonal_orig(m, :, 1) - nanmean(CMIP5_test.pco2_out_seasonal_orig(m, :, 1)), 'g-')
    hold on
    plot(CMIP5_test.pco2_out_seasonal_no_change(m, :, 1) - nanmean(CMIP5_test.pco2_out_seasonal_no_change(m, :, 1)), 'r')
    plot(CMIP5_test.pco2_out_seasonal_real_SST(m, :, 1) - nanmean(CMIP5_test.pco2_out_seasonal_real_SST(m, :, 1)), 'b')
    plot(CMIP5_test.pco2_out_seasonal_real_SST_SSS(m, :, 1) - nanmean(CMIP5_test.pco2_out_seasonal_real_SST_SSS(m, :, 1)), 'b--')
    plot(CMIP5_test.pco2_out_seasonal_no_change_press_adjust(m, :, 1) - nanmean(CMIP5_test.pco2_out_seasonal_no_change_press_adjust(m, :, 1)), 'r--')
    plot(CMIP5_test.pco2_out_seasonal_mean_DIC_shift_real_SST(m, :, 1) - nanmean(CMIP5_test.pco2_out_seasonal_mean_DIC_shift_real_SST(m, :, 1)), 'color', [.6 .6 .6], 'linewidth', 2, 'linestyle', '--');
    plot(CMIP5_test.pco2_out_seasonal_mean_DIC_shift(m, :, 1) - nanmean(CMIP5_test.pco2_out_seasonal_mean_DIC_shift(m, :, 1)), 'color', 'm', 'linewidth', 2, 'linestyle', '-.');
    plot(CMIP5_test.pco2_out_seasonal_mean_TALK_shift(m, :, 1) - nanmean(CMIP5_test.pco2_out_seasonal_mean_TALK_shift(m, :, 1)), 'color', 'k', 'linewidth', 2, 'linestyle', '-');
    plot(CMIP5_test.pco2_out_seasonal_mean_DIC_TALK_shift(m, :, 1) - nanmean(CMIP5_test.pco2_out_seasonal_mean_DIC_TALK_shift(m, :, 1)), 'color', cmap(10,:), 'linewidth', 2, 'linestyle', '--');

    e1 = plot(1:12, obs.spco2.out_seasonal(:,1) - nanmean(obs.spco2.out_seasonal(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
    
    legend([p1 p2 p5 p3 p4 p7 p6 p8 p9 e1], 'Model', 'Recalc no change', 'Asjusted for SLP', 'Replaced SST', 'Replaced SSS', 'Mean DIC offset', 'Real SST Mean DIC offset', 'Mean TALK Shift', 'Mean DIC & TALK Shift', 'Obs')
    
    pause
end
%% plot for presentation



for m =2
    if sum(~isnan(CMIP5_test.pco2_out_seasonal_orig(m,:,1)))==0
        continue
    end
    clf
    set(gcf, 'units', 'inches')
    paper_w = 6; paper_h =4;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    
    plot_filename = ['Model pCO2 and obs ' cmip_monthly_names{m}];
    
    %     subplot(2,1,1)
    %     p1 = plot(CMIP5_test.pco2_out_seasonal_orig(m, :, 1), 'g-');
    %     hold on
    %     p2 = plot(CMIP5_test.pco2_out_seasonal_no_change(m, :, 1), 'r');
    %     p3 = plot(CMIP5_test.pco2_out_seasonal_real_SST(m, :, 1), 'b');
    %     p4 = plot(CMIP5_test.pco2_out_seasonal_real_SST_SSS(m, :, 1), 'm');
    %
    subplot(1,1,1)
    hold on
    title(cmip_monthly_names{m}, 'interpreter', 'none')
    
    p1 = plot(CMIP5_test.pco2_out_seasonal_orig(m, :, 1) - nanmean(CMIP5_test.pco2_out_seasonal_orig(m, :, 1)), 'g-', 'linewidth', 2);
    hold on
    %     plot(CMIP5_test.pco2_out_seasonal_no_change(m, :, 1) - nanmean(CMIP5_test.pco2_out_seasonal_no_change(m, :, 1)), 'r')
    
    e1 = plot(1:12, obs_pco2_monthly(:,1) - nanmean(obs_pco2_monthly(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
    legend([p1 e1], 'Model', 'Obs')
    
    set(gca, 'fontsize', 15)
    print(gcf, '-dpng', [Plot_out_dir  'pCO2_recalc/' plot_filename '.png'])
    
    p2 = plot(CMIP5_test.pco2_out_seasonal_real_SST(m, :, 1) - nanmean(CMIP5_test.pco2_out_seasonal_real_SST(m, :, 1)), 'b', 'linewidth', 2);
    %     plot(CMIP5_test.pco2_out_seasonal_real_SST_SSS(m, :, 1) - nanmean(CMIP5_test.pco2_out_seasonal_real_SST_SSS(m, :, 1)), 'm')
    
    legend([p1 e1 p2], 'Model', 'Obs', 'Model recalc with real SST')
    
    print(gcf, '-dpng', [Plot_out_dir  'pCO2_recalc/' plot_filename 'with real SST.png'])
    
end

%% plots looking at the impact of changing T

% cmap = distinguishable_colors(20);

plot_filename = 'Model pCO2 and obs all no correction_CMIP6';
clf
set(gcf, 'units', 'inches')
paper_w = 10; paper_h =6;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

subplot(1,1,1)
hold on
legend_list = [];
p = [];
p_index = 0;
for m = 18:28%length(cmip_monthly_names)
    if sum(~isnan(CMIP5_test.pco2_out_seasonal_orig(m,:,1)))==0
        continue
    end
    p_index = p_index+1;
    
    %         plot(1:12, fgco2_out_seasonal(m,:,1)-nanmean(fgco2_out_seasonal(m,:,1)), 'color', cmap(strmatch(cmip_fgco2_names{m}, color_model(:,1), 'exact'),:), 'linewidth', 2);
    p1 = plot(1:12, CMIP5_test.pco2_out_seasonal_orig(m, :, 1) - nanmean(CMIP5_test.pco2_out_seasonal_orig(m, :, 1)), 'color', cmap(strmatch(cmip_fgco2_names{m}, color_model(:,1), 'exact'),:), 'linewidth', 2);
    %         p2 = plot(CMIP5_test.pco2_out_seasonal_real_SST(m, :, 1) - nanmean(CMIP5_test.pco2_out_seasonal_real_SST(m, :, 1)), 'b', 'linewidth', 2);
    
    p(p_index) = p1(1);
    
    legend_list = [legend_list ; {cmip_monthly_names{m}}];
    
end

e1 = plot(1:12, obs_pco2_monthly(:,1) - nanmean(obs_pco2_monthly(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '--');

ylabel('pCO_2 anomaly (\muatm)')

xlabel('Month')
legend([p' ; e1], [legend_list ; {'Obs'}], 'interpreter', 'none', 'location', 'eastoutside', 'box', 'off', 'fontsize', 10)
set(gca, 'fontsize', 18, 'ylim', [-70 45])
% title('Seasonal fgco2')

print(gcf, '-dtiff', [Plot_out_dir 'pCO2_recalc/' plot_filename '.tif'])

%% now with replaced SST

% cmap = distinguishable_colors(20);

plot_filename = 'Model pCO2 and obs all replaced SST_CMIP5';
clf
set(gcf, 'units', 'inches')
paper_w = 10; paper_h =6;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

subplot(1,1,1)
hold on
legend_list = [];
p = [];
p_index = 0;
for m = 1:17%length(cmip_monthly_names)
    if sum(~isnan(CMIP5_test.pco2_out_seasonal_orig(m,:,1)))==0
        continue
    end
    p_index = p_index+1;
    
    %         plot(1:12, fgco2_out_seasonal(m,:,1)-nanmean(fgco2_out_seasonal(m,:,1)), 'color', cmap(strmatch(cmip_fgco2_names{m}, color_model(:,1), 'exact'),:), 'linewidth', 2);
    p1 = plot(1:12, CMIP5_test.pco2_out_seasonal_real_SST(m, :, 1) - nanmean(CMIP5_test.pco2_out_seasonal_real_SST(m, :, 1)), 'color', cmap(strmatch(cmip_fgco2_names{m}, color_model(:,1), 'exact'),:), 'linewidth', 2);
    p(p_index) = p1(1);
    
    legend_list = [legend_list ; {cmip_monthly_names{m}}];
    
end

e1 = plot(1:12, obs_pco2_monthly(:,1) - nanmean(obs_pco2_monthly(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '--');

ylabel('pCO_2 anomaly (\muatm)')

xlabel('Month')
legend([p' ; e1], [legend_list ; {'Obs'}], 'interpreter', 'none', 'location', 'eastoutside', 'box', 'off', 'fontsize', 10)
set(gca, 'fontsize', 18, 'ylim', [-70 45])
% title('Seasonal fgco2')

print(gcf, '-dtiff', [Plot_out_dir 'pCO2_recalc/' plot_filename '.tif'])
%% CO2 Approximation using K0 K1 K2 -
% doesn't really give satisfactory numbers.. very large differences in pCO2
lat_index = find(CMIP5_mon_talk.lat>= lat_lims(1) & CMIP5_mon_talk.lat<= lat_lims(2));

tic
pCO2_temp = NaN(360, length(lat_index), length(CMIP5_ts.CanESM2.GMT_Matlab));

for tt = 1:length(CMIP5_ts.CanESM2.GMT_Matlab)
    
    temp_dens = sw_dens(CMIP5_ts.CanESM2.sos(:,lat_index,tt), CMIP5_ts.CanESM2.tos(:,lat_index,tt), 1);
    
    [K0, K1, K2] = CO2_K0_K1_K2(5, CMIP5_ts.CanESM2.sos(:,lat_index,tt));
    
    DIC_in = CMIP5_monthly.CanESM2.DIC(:,lat_index,tt).*temp_dens;
    ALK_in = CMIP5_mon_talk.CanESM2.talk(:,lat_index,tt).*temp_dens;
    pCO2_temp(:,:,tt) = K2./(K0.*K1).*((2*DIC_in - ALK_in).^2)./(ALK_in - DIC_in);
    
end

toc

%% Exploring Relationship

m = 4;

talk_index = find(contains(cmip_names.talk, cmip_names.dissic{m}));
tos_index = find(contains(cmip_names.tos, cmip_names.dissic{m}));
sos_index = find(contains(cmip_names.sos, cmip_names.dissic{m}));
psl_index = find(contains(cmip_names.psl, cmip_names.dissic{m}));
spco2_index = find(contains(cmip_names.spco2, cmip_names.dissic{m}));


clf
d1 = subplot(3,2,1);
plot(obs.spco2.out_seasonal(:,1), 'k')
hold on
plot(CMIP.spco2.out_seasonal(spco2_index,:,1), 'r')
title('spCO2')

subplot(3,2,2)
plot(obs.dissic.out_seasonal(:,1), 'k')
hold on
plot(CMIP.dissic.out_seasonal(m,:,1), 'r')
title('dissic')

subplot(3,2,3)
plot(obs.tos.out_seasonal(:,1), 'k')
hold on
plot(CMIP.tos.out_seasonal(tos_index,:,1), 'r')
title('tos')

subplot(3,2,4)
plot(obs.sos.out_seasonal(:,1), 'k')
hold on
plot(CMIP.sos.out_seasonal(sos_index,:,1), 'r')
title('sos')

subplot(3,2,5)
plot(obs.talk.out_seasonal(:,1), 'k')
hold on
plot(CMIP.talk.out_seasonal(talk_index,:,1), 'r')
title('talk')

subplot(3,2,6)
% plot(obs..out_seasonal(:,1), 'k')
hold on
plot(CMIP.psl.out_seasonal(psl_index,:,1), 'r')
title('psl')

[DATA,~,~]=CO2SYSSOCCOM_smb((CMIP.talk.out_seasonal(talk_index,:,1)+CMIP.talk.out_mean_diff(m))./1.025, (CMIP.dissic.out_seasonal(m,:,1)+CMIP.dissic.out_mean_diff(m))./1.025, ...
    1,2, obs.sos.out_seasonal(:,1), obs.tos.out_seasonal(:,1), CMIP.tos.out_seasonal(tos_index,:,1),...
    1,1,SI,PO4,1,10,3);

plot(d1, DATA(:,4)'.*CMIP.psl.out_seasonal(psl_index,:,1)./1013.25, 'm--')


%% Testing simple curve changes and pCO2 relationships

% dic_new = [obs.dissic.out_seasonal(12,1); obs.dissic.out_seasonal(1:11,1)];
% talk_new = [obs.talk.out_seasonal(12,1); obs.talk.out_seasonal(1:11,1)];

dic_new = obs.dissic.out_seasonal(:,1);

date_radians = [63:31:425]./365.*2.*pi();
           
test_sin = -sin(date_radians);

% dic_new = (2200-20.*sin(date_radians)-10);
% dic_new = obs.dissic.out_seasonal(:,1)-10.*test_sin';
talk_new = obs.talk.out_seasonal(:,1);

% t_new = obs.tos.out_seasonal(:,1);
t_new = obs.tos.out_seasonal(:,1)-1.*test_sin';

%%
SI= 5;
PO4=1.8;
[DATA,~,~]=CO2SYSSOCCOM_smb(talk_new, ...
    dic_new, ...
    1,2, obs.sos.out_seasonal(:,1), t_new, obs.tos.out_seasonal(:,1),...
    1,1,SI,PO4,1,10,3);
pco2_test = DATA(:,4);

[DATA,~,~]=CO2SYSSOCCOM_smb(obs.talk.out_seasonal(:,1), ...
    obs.dissic.out_seasonal(:,1), ...
    1,2, obs.sos.out_seasonal(:,1), obs.tos.out_seasonal(:,1), obs.tos.out_seasonal(:,1),...
    1,1,SI,PO4,1,10,3);
pco2_orig = DATA(:,4);

% [DATA,~,~]=CO2SYSSOCCOM_smb(obs.talk.out_seasonal(:,1), ...
%     obs.spco2.out_seasonal(:,1), ...
%     1,4, obs.sos.out_seasonal(:,1), obs.tos.out_seasonal(:,1), obs.tos.out_seasonal(:,1),...
%     1,1,SI,PO4,1,10,3);
% dic_from_pco2 = DATA(:,2);

% %% temperature shifts
% 
% t_new = CMIP.tos.out_seasonal(4,:,1)';
% %%
% 
% t_new = [obs.tos.out_seasonal(2:12,1) ;obs.tos.out_seasonal(1,1)];
% %%
% [DATA,~,~]=CO2SYSSOCCOM_smb(obs.talk.out_seasonal(:,1), ...
%     obs.dissic.out_seasonal(:,1), ...
%     1,2, obs.sos.out_seasonal(:,1), t_new, obs.tos.out_seasonal(:,1),...
%     1,1,SI,PO4,1,10,3);
% pco2_test = DATA(:,4);
%%
clf
subplot(3,2,1)
plot(obs.spco2.out_seasonal(:,1), 'k--')
hold on
plot(pco2_orig, 'color', [.5 .5 .5], 'linestyle', '--')

plot(pco2_test, 'r-')

subplot(3,2,2)
plot(obs.dissic.out_seasonal(:,1), 'k--')
hold on
plot(dic_new)
% plot(dic_from_pco2, 'b')

subplot(3,2,3)
plot(obs.spco2.out_seasonal(:,1)-nanmean(obs.spco2.out_seasonal(:,1)), 'k--')
hold on
plot(pco2_test-nanmean(pco2_test), 'color', [.5 .5 .5], 'linestyle', '--')


subplot(3,2,4)
plot(obs.dissic.out_seasonal(:,1)-nanmean(obs.dissic.out_seasonal(:,1)), 'k--')
hold on
plot(dic_new - nanmean(dic_new))

subplot(3,2,5)
plot(obs.tos.out_seasonal(:,1), 'k--')
hold on
plot(t_new, 'r-.')

subplot(3,2,6)
plot(obs.tos.out_seasonal(:,1) - nanmean(obs.tos.out_seasonal(:,1)), 'k--')
hold on
plot(t_new-nanmean(t_new), 'r-.')
%% fit a harmonic to data
clear harm
year_days = datenum(2012,1:12,15)-datenum(2012,1,0);

nharm=1;cutoff=10;L=365.25;

[harm.spco2.amp,harm.spco2.phase,harm.spco2.frac,harm.spco2.offset,harm.spco2.residual]= ...
    fit_harmonics(obs.spco2.out_seasonal(:,1), year_days, nharm, L, cutoff);

yt = harm.spco2.offset.*ones(12,1);
for j=1:nharm
    yt=yt+(harm.spco2.amp(j).*cos(2.*pi.*j.*[year_days]./L + harm.spco2.phase(j)))';
end
seasonal_pco2 = yt;


[harm.talk.amp,harm.talk.phase,harm.talk.frac,harm.talk.offset,harm.talk.residual]= ...
    fit_harmonics(obs.talk.out_seasonal(:,1), year_days, nharm, L, cutoff);

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

[harm.DIC_Alk.amp,harm.DIC_Alk.phase,harm.DIC_Alk.frac,harm.DIC_Alk.offset,harm.DIC_Alk.residual]= ...
    fit_harmonics(obs.DIC_Alk.out_seasonal(:,1), year_days, nharm, L, cutoff);




% using actual dic amplitude gives me a pCO2 that doesn't match obs.  
% [harm.dic.amp,harm.dic.phase,harm.dic.frac,harm.dic.offset,harm.dic.residual]= ...
%     fit_harmonics(obs.dissic.out_seasonal(:,1), year_days, nharm, L, cutoff);
% 
% yt = harm.dic.offset.*ones(12,1);
% for j=1:nharm
%     yt=yt+(harm.dic.amp(j).*cos(2.*pi.*j.*[year_days]./L + harm.dic.phase(j)))';
% end
% 
% seasonal_dic = yt;



%% creating a seasonal dic that is internally consistent with pCO2 and TALK
% Maybe undo this b/c of new way of doing things... to be seen

% because pCO2 is from mapping method and DIC/Talk are from obs, if we just
% used the harmonic fits as is then they would not be internally
% consistent.  This approach creates a seasonal dic that is consistent with
% pCO2 and Talk and has a correlation of 0.96, and amplitude ratio of 1.09
% and a normalized error of 0.29 to the original obs.dissic.out_seasonal
% record.  Seems like the best compromise.  

[DATA,~,~]=CO2SYSSOCCOM_smb(seasonal_talk, ...
    seasonal_pco2, ...
    1,4, obs.sos.out_seasonal(:,1), seasonal_tos, seasonal_tos,...
    1,1,SI,PO4,1,10,3);
dic_from_pco2_alk = DATA(:,2);

[harm.dissic.amp,harm.dissic.phase,harm.dissic.frac,harm.dissic.offset,harm.dissic.residual]= ...
    fit_harmonics(dic_from_pco2_alk, year_days, nharm, L, cutoff);

yt = harm.dissic.offset.*ones(12,1);
for j=1:nharm
    yt=yt+(harm.dissic.amp(j).*cos(2.*pi.*j.*[year_days]./L + harm.dissic.phase(j)))';
end

seasonal_dic = yt;

%% test for checking the above process
% recreating seasonal pco2 from dic and talk
[DATA,~,~]=CO2SYSSOCCOM_smb(seasonal_talk, ...
    seasonal_dic, ...
    1,2, obs.sos.out_seasonal(:,1), seasonal_tos, seasonal_tos,...
    1,1,SI,PO4,1,10,3);
pco2_test = DATA(:,4);

%%
m = 26; % spco2 model number


mod_match_dic = strcmp(cmip_names.dissic, cmip_names.spco2{m});
mod_match_tos = strcmp(cmip_names.tos, cmip_names.spco2{m});
mod_match_talk = strcmp(cmip_names.talk, cmip_names.spco2{m});

dic_amp_change = 1;
dic_phase_change = 1;
tos_amp_change = 0;
tos_phase_change = 0;

talk_amp_change= 0;
talk_phase_change =0;
% mod_dic_index = 8; % GISS e2 r cc


% seasonal_tos_ajust = seasonal_tos;
if dic_amp_change==1
    target_dic_amplitude = harm_mod.dissic.amp(mod_match_dic);
    dic_amp_adjust = target_dic_amplitude./harm.dissic.amp;
else
    dic_amp_adjust = 1;
end

dic_offset_adjust = 0;

if dic_phase_change==1
    target_dic_phase = harm_mod.dissic.phase(mod_match_dic);
    dic_phase_adjust = target_dic_phase./harm.dissic.phase;
else
    dic_phase_adjust = 1;
end

if tos_amp_change ==1
    target_tos_amplitude = harm_mod.tos.amp(mod_match_tos);
    tos_amp_adjust = target_tos_amplitude./harm.tos.amp;
else
    tos_amp_adjust = 1;
end

tos_offset_adjust = 0;

if tos_phase_change ==1
    target_tos_phase = harm_mod.tos.phase(mod_match_tos);
    tos_phase_adjust = target_tos_phase./harm.tos.phase;
else
tos_phase_adjust = 1;
end

if talk_amp_change==1
    target_talk_amplitude = harm_mod.talk.amp(mod_match_talk);
    talk_amp_adjust = target_talk_amplitude./harm.talk.amp;
    
else
    talk_amp_adjust = 1;
end

talk_offset_adjust = 0;

if talk_phase_change==1
    target_talk_phase = harm_mod.talk.phase(mod_match_talk);
    talk_phase_adjust = target_talk_phase./harm.talk.phase;
    
else
talk_phase_adjust = 1;
end

yt = harm.dissic.offset.*ones(12,1)+dic_offset_adjust;
for j=1:nharm
    yt=yt+(harm.dissic.amp(j).*dic_amp_adjust.*cos(2.*pi.*j.*[year_days]./L + harm.dissic.phase(j).*dic_phase_adjust))';
end
seasonal_dic_adjust = yt;


yt = harm.tos.offset.*ones(12,1)+tos_offset_adjust;
for j=1:nharm
    yt=yt+(harm.tos.amp(j).*tos_amp_adjust.*cos(2.*pi.*j.*[year_days]./L + harm.tos.phase(j).*tos_phase_adjust))';
end

seasonal_tos_adjust = yt;


yt = harm.talk.offset.*ones(12,1)+talk_offset_adjust;
for j=1:nharm
    yt=yt+(harm.talk.amp(j).*talk_amp_adjust.*cos(2.*pi.*j.*[year_days]./L + harm.talk.phase(j).*talk_phase_adjust))';
end
seasonal_talk_adjust = yt;


[DATA,~,~]=CO2SYSSOCCOM_smb(seasonal_talk_adjust, ...
    seasonal_dic_adjust, ...
    1,2, obs.sos.out_seasonal(:,1), seasonal_tos_adjust, seasonal_tos_adjust,...
    1,1,SI,PO4,1,10,3);
pco2_test = DATA(:,4);

% pCO2 anomaly only
dic_ampl_out = harm.dissic.amp(j).*dic_amp_adjust;
dic_phase_out = harm.dissic.phase(j).*dic_phase_adjust;
dic_offset_out = harm.dissic.offset+dic_offset_adjust;

tos_amp_out = harm.tos.amp(j).*tos_amp_adjust;

% 
% plot_filename = ['pCO2 test DIC amp ' num2str(dic_ampl_out,3) ' DIC Phase ' num2str(dic_phase_out,2) ' TOS Amp ' num2str(tos_amp_out,2)];
% clf
% set(gcf, 'units', 'inches')
% paper_w = 5; paper_h =5;
% set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h
% 
% 
% subplot(1,1,1)
% % plot(obs.spco2.out_seasonal(:,1)-nanmean(obs.spco2.out_seasonal(:,1)), 'k--')
% hold on
% plot(seasonal_pco2-nanmean(seasonal_pco2), 'color', 'k', 'linestyle', '--', 'linewidth', 2)
% plot(pco2_test-nanmean(pco2_test), 'r', 'linewidth', 2)
% title('pCO2 anomaly'); ylabel('pCO_2 anomaly (uatm)');
% legend('Harm. to obs.', 'Test case', 'location', 'southeast')
% title(['DIC Amp: ' num2str(dic_ampl_out,3) ' DIC Ph: ' num2str(dic_phase_out,2) ' TOS Amp: ' num2str(tos_amp_out,2)])
% %     print(gcf, '-dpng', [Plot_out_dir '/' plot_filename '.png'])

% all properties
clf
subplot(4,2,1)
plot(obs.spco2.out_seasonal(:,1), 'k--')
hold on
plot(seasonal_pco2, 'color', [.5 .5 .5], 'linestyle', '--')
plot(pco2_test, 'r')
plot(CMIP.spco2.out_seasonal(m,:,1), 'b')
title(['pCO2, obs amp: ' num2str(harm.spco2.amp,3) ' ph: ' num2str(harm.spco2.phase,3) ' offset: ' num2str(harm.spco2.offset,4)])

subplot(4,2,2)
plot(obs.spco2.out_seasonal(:,1)-nanmean(obs.spco2.out_seasonal(:,1)), 'k--')
hold on
plot(seasonal_pco2-nanmean(seasonal_pco2), 'color', [.5 .5 .5], 'linestyle', '--')
plot(pco2_test-nanmean(pco2_test), 'r')
plot(CMIP.spco2.out_seasonal(m,:,1) - nanmean(CMIP.spco2.out_seasonal(m,:,1)), 'b')

title([cmip_names.spco2{m} ' Model amp: ' num2str(harm_mod.spco2.amp(m),3) ' ph: ' num2str(harm_mod.spco2.phase(m),3) ' offset: ' num2str(harm_mod.spco2.offset(m),4)])
ylabel('pCO2 (uatm)');
legend('obs.', 'Harm. to obs.', 'Test case', 'Model', 'location', 'south')

subplot(4,2,3)
plot(obs.dissic.out_seasonal(:,1), 'k--')
hold on
% plot(dic_from_pco2_alk, 'color', [.5 .5 .5], 'linestyle', '--')
plot(seasonal_dic, 'color', [.5 .5 .5], 'linestyle', '--')
plot(seasonal_dic_adjust, 'r')
plot(CMIP.dissic.out_seasonal(mod_match_dic,:,1), 'b')

title(['DIC, obs amp: ' num2str(harm.dissic.amp,3) ' ph: ' num2str(harm.dissic.phase,3) ' offset: ' num2str(harm.dissic.offset,4)])

subplot(4,2,4)
plot(obs.dissic.out_seasonal(:,1)-nanmean(obs.dissic.out_seasonal(:,1)), 'k--')
hold on
plot(seasonal_dic-nanmean(seasonal_dic), 'color', [.5 .5 .5], 'linestyle', '--')
plot(seasonal_dic_adjust-nanmean(seasonal_dic_adjust), 'r')
plot(CMIP.dissic.out_seasonal(mod_match_dic,:,1) - nanmean(CMIP.dissic.out_seasonal(mod_match_dic,:,1)), 'b')
title(['Test case amp: ' num2str(dic_ampl_out,3) ' ph: ' num2str(dic_phase_out,3) ' offset: ' num2str(dic_offset_out,4) ' ----- '...
    'Model amp: ' num2str(harm_mod.dissic.amp(mod_match_dic),3) ' ph: ' num2str(harm_mod.dissic.phase(mod_match_dic),3) ' offset: ' num2str(harm_mod.dissic.offset(mod_match_dic),4)])


subplot(4,2,5)
plot(obs.tos.out_seasonal(:,1), 'k--')
hold on
plot(seasonal_tos, 'color', [.5 .5 .5], 'linestyle', '--')
plot(seasonal_tos_adjust, 'r');
plot(CMIP.tos.out_seasonal(mod_match_tos,:,1), 'b')

title('SST')
title(['SST, obs amp: ' num2str(harm.tos.amp,3) ' ph: ' num2str(harm.tos.phase,3) ' offset: ' num2str(harm.tos.offset,2)])

subplot(4,2,6)
plot(obs.tos.out_seasonal(:,1) - nanmean(obs.tos.out_seasonal(:,1)), 'k--')
hold on
plot(seasonal_tos-nanmean(seasonal_tos), 'color', [.5 .5 .5], 'linestyle', '--')
plot(seasonal_tos_adjust - nanmean(seasonal_tos_adjust), 'r');
plot(CMIP.tos.out_seasonal(mod_match_tos,:,1)-nanmean(CMIP.tos.out_seasonal(mod_match_tos,:,1)), 'b')

title(['Test case amp: ' num2str(tos_amp_out,3) ' ----- '...
' Model amp: ' num2str(harm_mod.tos.amp(mod_match_tos),3) ' ph: ' num2str(harm_mod.tos.phase(mod_match_tos),3) ' offset: ' num2str(harm_mod.tos.offset(mod_match_tos),2)])

subplot(4,2,7)
plot(obs.talk.out_seasonal(:,1), 'k--')
hold on
plot(seasonal_talk, 'color', [.5 .5 .5], 'linestyle', '--')
plot(seasonal_talk_adjust, 'r')
plot(CMIP.talk.out_seasonal(mod_match_talk,:,1), 'b')

title('Talk')
title(['TALK, obs amp: ' num2str(harm.talk.amp,3) ' ph: ' num2str(harm.talk.phase,3) ' offset: ' num2str(harm.talk.offset,4)])

subplot(4,2,8)
plot(obs.talk.out_seasonal(:,1)-nanmean(obs.talk.out_seasonal(:,1)), 'k--')
hold on
plot(seasonal_talk-nanmean(seasonal_talk), 'color', [.5 .5 .5], 'linestyle', '--')
plot(seasonal_talk_adjust-nanmean(seasonal_talk_adjust), 'r')
plot(CMIP.talk.out_seasonal(mod_match_talk,:,1)-nanmean(CMIP.talk.out_seasonal(mod_match_talk,:,1)), 'b')

title(['Model amp: ' num2str(harm_mod.talk.amp(mod_match_talk),3) ' ph: ' num2str(harm_mod.talk.phase(mod_match_talk),3) ' offset: ' num2str(harm_mod.talk.offset(mod_match_talk),4)])

%% plot for ODU presentation - example from one model
plot_filename = 'Model Example - ODU-adjusted';
clf
    set(gcf, 'units', 'inches')
    paper_w = 5; paper_h =8;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    
subplot(2,1,1)
plot(obs.spco2.out_seasonal(:,1)-nanmean(obs.spco2.out_seasonal(:,1)), 'k--', 'linewidth', 2)
hold on
% plot(seasonal_pco2-nanmean(seasonal_pco2), 'color', [.5 .5 .5], 'linestyle', '--')
plot(pco2_test-nanmean(pco2_test), 'r', 'linewidth', 2)
plot(CMIP.spco2.out_seasonal(m,:,1) - nanmean(CMIP.spco2.out_seasonal(m,:,1)), 'b', 'linewidth', 2)

title([cmip_names.spco2{m} ' Model amp: ' num2str(harm_mod.spco2.amp(m),3) ' ph: ' num2str(harm_mod.spco2.phase(m),3) ' offset: ' num2str(harm_mod.spco2.offset(m),4)])
ylabel('pCO_2 anomaly (\muatm)');

subplot(2,1,2)
plot(obs.dissic.out_seasonal(:,1)-nanmean(obs.dissic.out_seasonal(:,1)), 'k--', 'linewidth', 2)
hold on
ylabel('DIC atnomaly (\mumol kg^-^1)');
set(gca, 'ylim', [-20 20])
% plot(seasonal_dic-nanmean(seasonal_dic), 'color', [.5 .5 .5], 'linestyle', '--')
plot(seasonal_dic_adjust-nanmean(seasonal_dic_adjust), 'r', 'linewidth', 2)
plot(CMIP.dissic.out_seasonal(mod_match_dic,:,1) - nanmean(CMIP.dissic.out_seasonal(mod_match_dic,:,1)), 'b', 'linewidth', 2)
% title(['Test case amp: ' num2str(dic_ampl_out,3) ' ph: ' num2str(dic_phase_out,3) ' offset: ' num2str(dic_offset_out,4) ' ----- '...
%     'Model amp: ' num2str(harm_mod.dissic.amp(mod_match_dic),3) ' ph: ' num2str(harm_mod.dissic.phase(mod_match_dic),3) ' offset: ' num2str(harm_mod.dissic.offset(mod_match_dic),4)])

print(gcf, '-dpdf', [Plot_out_dir  plot_filename])

%% Fit Harmonics to DIC and T for all models
% year_days = datenum(2012,1:12,15)-datenum(2012,1,0);

for v = [7 5 1 8 15 6]
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

%% 2022_03_14 test plots for pCO2 tests

% recreate harmonic of obs DIC and T:
for v = [7 5 1 8 15 6]
    yt = harm.(variables{v}).offset.*ones(12,1);
    for j=1:nharm
        yt=yt+(harm.(variables{v}).amp(j).*cos(2.*pi.*j.*[year_days]./L + harm.(variables{v}).phase(j)))';
    end
    harm.(variables{v}).seasonal_fit = yt;
    clear yt
end
%% Sensitivity tests - can we fix models by adjusting certain parameters

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
            
            plot(obs.(variables{v}).out_seasonal(:,1)-nanmean(obs.(variables{v}).out_seasonal(:,1)), 'k-', 'linewidth', 2)
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
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.out_seasonal(:,1),pco2_test);
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
            
            plot(obs.(variables{v}).out_seasonal(:,1)-nanmean(obs.(variables{v}).out_seasonal(:,1)), 'k-', 'linewidth', 2)
            
            
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
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.out_seasonal(:,1),pco2_test);
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
            
            plot(obs.(variables{v}).out_seasonal(:,1)-nanmean(obs.(variables{v}).out_seasonal(:,1)), 'k-', 'linewidth', 2)
            
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
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.out_seasonal(:,1),pco2_test);
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
            
            plot(obs.(variables{v}).out_seasonal(:,1)-nanmean(obs.(variables{v}).out_seasonal(:,1)), 'k-', 'linewidth', 2)
            
            
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
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.out_seasonal(:,1),pco2_test);
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
            
            plot(obs.(variables{v}).out_seasonal(:,1)-nanmean(obs.(variables{v}).out_seasonal(:,1)), 'k-', 'linewidth', 2)
            
            
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
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.out_seasonal(:,1),pco2_test);
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
            
            plot(obs.(variables{v}).out_seasonal(:,1)-nanmean(obs.(variables{v}).out_seasonal(:,1)), 'k-', 'linewidth', 2)
            
            
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
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.out_seasonal(:,1),pco2_test);
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
            
            
            plot(obs.(variables{v}).out_seasonal(:,1)-nanmean(obs.(variables{v}).out_seasonal(:,1)), 'k-', 'linewidth', 2)
            
            
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
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.out_seasonal(:,1),pco2_test);
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
            
            plot(obs.(variables{v}).out_seasonal(:,1)-nanmean(obs.(variables{v}).out_seasonal(:,1)), 'k-', 'linewidth', 2)
            
            
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
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.out_seasonal(:,1),pco2_test);
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
            
            plot(obs.(variables{v}).out_seasonal(:,1)-nanmean(obs.(variables{v}).out_seasonal(:,1)), 'k-', 'linewidth', 2)
            
            
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
    [test_out.correlation, test_out.ratio, test_out.norm_error]=taylor_eval(obs.spco2.out_seasonal(:,1),pco2_test);
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

%% Starting from correct model, recalculating pCO2 for different test cases
% clf
idealized_test_out = table;

clear test_data adjust
for v = [5 6 7 8]
    test_data_start.(variables{v}) = harm.(variables{v}).seasonal_fit;
    
%     adjust.(variables{v}).offset = 0;
%     adjust.(variables{v}).phase_shift_days = 0;
%     adjust.(variables{v}).amp_percent      = 0;
%     
end

adjust.dissic.phase_shift_days =-50:10:50;
adjust.dissic.amp_percent =-100:10:100;
% adjust.dissic.amp_percent = 0;
% adjust.dissic.phase_shift_days = 0 ;
% 
% adjust.talk.phase_shift_days   = -75:25:75;
adjust.talk.amp_percent   =[-30 0]; %-80:20:80;

adjust.talk.phase_shift_days   = 0;
% adjust.talk.amp_percent   =0;

% adjust.tos.phase_shift_days    = -10:5:10;
adjust.tos.amp_percent    =-100:50:100;

adjust.tos.phase_shift_days    = 0;
% adjust.tos.amp_percent    = 0;

% adjust.sos.phase_shift_days    =-40:20:40;
% adjust.sos.amp_percent    =-250:50:250;
% 
adjust.sos.phase_shift_days    =0;
adjust.sos.amp_percent    =0;





offset_adjust = 0; % not varying this for now

table_index = 0;
v=7;
test_data = test_data_start;

for dd = 1:length(adjust.(variables{v}).phase_shift_days)
    clear phase_shift phase_shift_days amp_adjust_percent amp_adjust

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

% %% plotting results from idealized_test_out:
% c_map = turbo;
% plot_filename = 'dissic ampl and phase attempt v1';
% % make a plot showing the various combinations of amplitude percentages and
% % phase shift days for dissic alone
% 
% % DISSIC plot
% clf
% subplot_index = 0;
% 
% for tt = 1:length(adjust.tos.amp_percent)
%     tos_amp_percent=adjust.tos.amp_percent(tt);
%     tos_shift_days = 0;
%     
%     subplot_index = subplot_index+1;
%     subplot(3,2,subplot_index)
%     hold on; grid on
%     
%     pl = NaN(length(adjust.dissic.amp_percent),1);
%     leg_names = cell(length(adjust.dissic.amp_percent),1);
%     for dd =1: length(adjust.dissic.amp_percent)
%         
%         dic_amp_index = idealized_test_out.dissic_amp_adjust_percent==adjust.dissic.amp_percent(dd) & ...
%             idealized_test_out.tos_amp_adjust_percent==tos_amp_percent & ...
%             idealized_test_out.tos_phase_shift_days==tos_shift_days;
%         
%         xy = [idealized_test_out.dissic_phase_shift_days(dic_amp_index) idealized_test_out.pco2_corr(dic_amp_index)];
%         xy = sortrows(xy);
%         
%         % scale color according to the range of the plotted variable:
%         line_color_index = round((adjust.dissic.amp_percent(dd) - min(adjust.dissic.amp_percent))./diff(range(adjust.dissic.amp_percent))*length(c_map));
%         if line_color_index==0
%             line_color_index=1;
%         end
%         pl(dd) = plot(xy(:,1), xy(:,2), 'color', c_map(line_color_index,:), 'linewidth', 3);
%         
%         leg_names{dd} = num2str(adjust.dissic.amp_percent(dd));
%     end
%     title(['TOS amplitude percent ' num2str(tos_amp_percent)]);
%     set(gca, 'ylim', [-1 1]);
%     
%     % overlay scatter plots with models that fit into different TOS
%     % amplitude bins
%     % will need to adjust bin ranges if you modify the number of bins here:
%     tos_amp_bin = 25;
%     
%     for m = 1:length(cmip_names.spco2)
%         mod_talk_index = strcmp(cmip_names.talk, cmip_names.spco2{m});
%         
%         if sum(mod_talk_index)==0 % if there is no talk, then it is hard to know if talk is at all reasonable and not causing issues
%             continue
%         end
%         
%         mod_tos_index = strcmp(cmip_names.tos, cmip_names.spco2{m});
%         tos_amp_per_diff = (harm_mod.tos.amp(mod_tos_index) - harm.tos.amp)./harm.tos.amp*100;
%         
%         if isempty(tos_amp_per_diff)
%             continue
%         end
%         % only plot models that fall in each TOS amplitude range
%         if tos_amp_per_diff>=tos_amp_percent - tos_amp_bin && tos_amp_per_diff<tos_amp_percent + tos_amp_bin
%             
%             mod_dissic_index = strcmp(cmip_names.dissic, cmip_names.spco2{m});
%             
%            
%        
%             dissic_phase_shift_days = (harm_mod.dissic.phase(mod_dissic_index) - harm.dissic.phase )*365.25./(2*pi);
%             dissic_amp_per_diff = (harm_mod.dissic.amp(mod_dissic_index) - harm.dissic.amp)./harm.dissic.amp*100;
%                
%             if isempty(dissic_phase_shift_days)
%                 continue
%             end
%             mod_pco2_corr = obs.spco2.correlation(m);
%             
%             if dissic_amp_per_diff>max(adjust.dissic.amp_percent)
%                 point_color_index = length(c_map);
%             elseif dissic_amp_per_diff<=min(adjust.dissic.amp_percent)
%                 point_color_index = 1;
%             else
%             point_color_index = round((dissic_amp_per_diff - min(adjust.dissic.amp_percent))./diff(range(adjust.dissic.amp_percent))*length(c_map));
%             end
%             
%         
%          
%             plot(dissic_phase_shift_days, mod_pco2_corr, 'color', c_map(point_color_index,:), 'markerfacecolor', c_map(point_color_index,:),'marker', 'o', 'markersize', 20)
%             disp(m)
%             disp(mod_pco2_corr)
%             disp(dissic_amp_per_diff)
% %             pause
%         end
%     end
%     
%     legend(pl, leg_names)
% end
% 
% print(gcf, '-dpdf', [Plot_out_dir 'Sensitivity_tests/' plot_filename])

%% Similar to above, but contour plots of pCO2 correlation against DISSIC amplitude and phase shifts
set(gcf, 'colormap', brewermap(30, 'Spectral'))
clf
subplot_index = 0;

v = 7;

sub_v = 5;
% first, find all points with the correct sub_v amplitude and shift, then put
% into a matric of ampl rows and phase columns

plot_filename = ['Contour_correlation ' variables{v} ' subplots by ' variables{sub_v} ];
for tt = 1:length(adjust.(variables{sub_v}).amp_percent)
    
    sub_v_amp_percent=adjust.(variables{sub_v}).amp_percent(tt);
    sub_v_shift_days = 0;
    
    subplot_index = subplot_index+1;
    if tt==2
        subplot_index = subplot_index+1;
    end
    subplot(3,2,subplot_index)
    
    pCO2_grid = NaN(length(adjust.(variables{v}).amp_percent), length(adjust.(variables{v}).phase_shift_days));
    
    for dd =1: length(adjust.(variables{v}).amp_percent)
        var_amp_index = idealized_test_out.([variables{v} '_amp_adjust_percent'])==adjust.(variables{v}).amp_percent(dd) & ...
            idealized_test_out.([variables{sub_v} '_amp_adjust_percent'])==sub_v_amp_percent & ...
            idealized_test_out.([variables{sub_v} '_phase_shift_days'])==sub_v_shift_days & idealized_test_out.talk_amp_adjust_percent==-30;
        
        pCO2_grid(dd,:) = idealized_test_out.pco2_corr(var_amp_index);
    end
    
    [C, h] = contourf( adjust.(variables{v}).phase_shift_days, adjust.(variables{v}).amp_percent,pCO2_grid, 'levellist', -1:0.05:1, 'linestyle', 'none'); colorbar; caxis([-1 1])
    hold on
    [C1, h1] = contour( adjust.(variables{v}).phase_shift_days, adjust.(variables{v}).amp_percent, pCO2_grid, 'levellist', [-0.5:0.5:0.5], 'linestyle', '-', 'linewidth', 2, 'color', 'k');
    clabel(C1, h1)
    xlabel([variables{v} ' Shift (days)'])
    ylabel([variables{v} ' Amplitude (% diff)'])
    title([(variables{sub_v}) ' amplitude percent ' num2str(sub_v_amp_percent)]);
    
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

print(gcf, '-dpdf', [Plot_out_dir 'Sensitivity_tests/' plot_filename])

%% TOS plot
clf
subplot(1,1,1)
hold on; grid on

pl = NaN(length(adjust.tos.amp_percent),1);
leg_names = cell(length(adjust.tos.amp_percent),1);
for dd =1: length(adjust.tos.amp_percent)
    
    dissic_amp_percent=0;
    dissic_shift_days = 0;
    
    tos_amp_index = idealized_test_out.tos_amp_adjust_percent==adjust.tos.amp_percent(dd) & ...
        idealized_test_out.dissic_amp_adjust_percent==dissic_amp_percent & ...
        idealized_test_out.dissic_phase_shift_days==dissic_shift_days;
    
    xy = [idealized_test_out.tos_phase_shift_days(tos_amp_index) idealized_test_out.pco2_corr(tos_amp_index)];
    xy = sortrows(xy);
    
    % scale color according to the range of the plotted variable:
    line_color_index = round((adjust.tos.amp_percent(dd) - min(adjust.tos.amp_percent))./diff(range(adjust.tos.amp_percent))*length(c_map));
    if line_color_index==0
        line_color_index=1;
    end
    pl(dd) = plot(xy(:,1), xy(:,2), 'color', c_map(line_color_index,:), 'linewidth', 2);
    
    leg_names{dd} = num2str(adjust.tos.amp_percent(dd));
end

legend(pl, leg_names)

%%
clf
plot(harm.spco2.seasonal_fit, 'k-', 'linewidth', 2)
hold on
plot(pco2_test, 'r-', 'linewidth', 2)
    
y_lim = get(gca, 'ylim');
text(2, y_lim(1)+4, ['E: ' num2str(test_out.norm_error, 2) '; C: ' num2str(test_out.correlation, 2) '; R: ' num2str(test_out.ratio, 2)], 'fontsize', 12, 'fontweight', 'bold')
clear pco2_test
%% plotting results from harmonic fits to each other:
plot_group = 1;

plot_filename = ['Harmonic fits TOS DISSIC group =' num2str(plot_group)];
clf


v = 5; % tos
v2 = 7; % dissic


% DIC amplitude on y axis, SST amplitude on x axis:
d1 = subplot(2,2,1);
hold on
grid on
xlabel(d1, [variables{v} ' Amplitude'])
ylabel(d1, [variables{v2} ' Amplitude'])

% DIC phase and DIC amplitude
d2 = subplot(2,2,2);
grid on; hold on
xlabel(d2, [variables{v2} ' Amplitude'])
ylabel(d2, [variables{v2} ' Phase'])

% DIC phase and TOS amplitude
d3 = subplot(2,2,3);
grid on; hold on;
xlabel(d3, [variables{v} ' Amplitude'])
ylabel(d3, [variables{v2} ' Phase'])

d4 = subplot(2,2,4);
grid on; hold on;
xlabel(d4, [variables{v} ' Amplitude'])
ylabel(d4, [variables{v2} ' Phase'])
for m = 1:length(cmip_names.(variables{v}))
    
    
    % find the matching model
    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
    
    
    if sum(mod_match)>0
        if plot_group==1
            plot_color = model_group_colors(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3},:);
        else
            plot_color  = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);
        end
        
        plot(d1, harm_mod.(variables{v}).amp(m), harm_mod.(variables{v2}).amp(mod_match), '.', 'color', ...
            plot_color, 'markersize', 20)
        
        plot(d3, harm_mod.(variables{v}).amp(m), harm_mod.(variables{v2}).phase(mod_match), '.', 'color', ...
            plot_color, 'markersize', 20)
        
        plot3(d4, harm_mod.(variables{v}).amp(m), harm_mod.(variables{v2}).phase(mod_match), harm_mod.(variables{v2}).amp(mod_match), '.', 'color', ...
            plot_color, 'markersize', 20)
        %         obs.(variables{v}).norm_error(m), obs.(variables{v2}).(tests{tt})(mod_match), '.', 'color', ...
        %             model_group_colors(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3},:), 'markersize', 20)
        %         legend_list = [legend_list ; {cmip_names.(variables{v}){m}}];
        clear plot_color
    end
    
end

% second loop to plot just DIC amplitude and phase
for m = 1:length(cmip_names.(variables{v2}))
    if plot_group==1
        plot_color = model_group_colors(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3},:);
    else
        plot_color  = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);
    end
    
    plot(d2, harm_mod.(variables{v2}).amp(m), harm_mod.(variables{v2}).phase(m), '.', 'color', ...
            plot_color, 'markersize', 20)
        clear plot_color
    
end
    
x_lims_d1 = get(d1, 'xlim');
y_lims_d1 = get(d1, 'ylim');

plot(d1, [harm.tos.amp harm.tos.amp], y_lims_d1, '--k', 'linewidth', 2)
plot(d1,  x_lims_d1, [harm.dissic.amp harm.dissic.amp],'--k', 'linewidth', 2)

x_lims_d2 = get(d2, 'xlim');
y_lims_d2 = get(d2, 'ylim');

plot(d2, [harm.dissic.amp harm.dissic.amp], y_lims_d2, '--k', 'linewidth', 2)
plot(d2,  x_lims_d2, [harm.dissic.phase harm.dissic.phase],'--k', 'linewidth', 2)


x_lims_d3 = get(d3, 'xlim');
y_lims_d3 = get(d3, 'ylim');

plot(d3, [harm.tos.amp harm.tos.amp], y_lims_d3, '--k', 'linewidth', 2)
plot(d3,  x_lims_d3, [harm.dissic.phase harm.dissic.phase],'--k', 'linewidth', 2)

%     print(gcf, '-dpng', [Plot_out_dir '/' plot_filename '.png'])

%%  2021_04
%%
% plot(pco2_test, 'r-')

subplot(3,2,2)
plot(obs.dissic.out_seasonal(:,1), 'k--')
hold on
plot(dic_new)
% plot(dic_from_pco2, 'b')

subplot(3,2,3)
plot(obs.spco2.out_seasonal(:,1)-nanmean(obs.spco2.out_seasonal(:,1)), 'k--')
hold on
plot(pco2_test-nanmean(pco2_test), 'color', [.5 .5 .5], 'linestyle', '--')


subplot(3,2,4)
plot(obs.dissic.out_seasonal(:,1)-nanmean(obs.dissic.out_seasonal(:,1)), 'k--')
hold on
plot(dic_new - nanmean(dic_new))

subplot(3,2,5)
plot(obs.tos.out_seasonal(:,1), 'k--')
hold on
plot(t_new, 'r-.')

subplot(3,2,6)
plot(obs.tos.out_seasonal(:,1) - nanmean(obs.tos.out_seasonal(:,1)), 'k--')
hold on
plot(t_new-nanmean(t_new), 'r-.')

%% Looking at timing between fgco2 and pCO2 (i.e. why are they weird for bsose and ipsl CM6A LR?

for m = 1:length(cmip_names.fgco2)

    
    mod_match = strcmp(cmip_names.spco2, cmip_names.fgco2{m});
    if sum(mod_match)==0
        continue
    end
    

    clf

subplot(1,2,1)
hold on
title('obs')

plot(obs.fgco2.Neur.y2021.SOCCOM_SOCAT.out_seasonal(:,1), 'b')
yyaxis right

plot(obs.spco2.out_seasonal(:,1), 'r')



subplot(1,2,2)
hold on
title(cmip_names.fgco2{m})
plot(CMIP.fgco2.out_seasonal(m,:,1), 'b');

yyaxis right

plot(CMIP.spco2.out_seasonal(mod_match,:,1), 'r');


pause



end
%% Old code %%%%%%%%%%%%%%%%%%%%%


 %% plotting seasonal anomaly
% v = 9;
% 
% plot_filename = ['Obs model Seasonal ' variables{v} ' anomaly_v2'];
% clf
% set(gcf, 'units', 'inches')
% paper_w = 12; paper_h =8;
% set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
% 
% 
% subplot(1,1,1)
% hold on
% legend_names = {};
% for m = 37:38%length(cmip_names.(variables{v}))
%     
%     seasonal_anomaly = CMIP.(variables{v}).out_seasonal(m,:,1) - nanmean(CMIP.(variables{v}).out_seasonal(m,:,1));
%     
%     plot(1:12, seasonal_anomaly, 'color', cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:), 'linewidth', 2);
%     clear seasonal_anomaly
%     legend_names{end+1,1} = cmip_names.(variables{v}){m};
% 
% end
% 
% seasonal_anomaly = obs.(variables{v}).out_seasonal(:,1) - nanmean(obs.(variables{v}).out_seasonal(:,1));
% plot(1:12, seasonal_anomaly, 'linewidth', 3, 'color' , 'k', 'linestyle', '--')    
% % e1 = errorbar(1:12, seasonal_anomaly, obs_dic_monthly(:,2), 'linewidth', 3, 'color', 'k');
% 
% ylabel(variables{v})
% xlabel('Month')
% legend([legend_names ; 'Obs'], 'interpreter', 'none', 'location', 'eastoutside')
% 
% title([variables{v} ' Anomaly'])
% 
% print(gcf, '-dpng', [Plot_out_dir  variables{v} '/' plot_filename '.png'])


%% SPCO2 Monthly CMIP5 LOAD
% load monthly output:
% CMIP5_spco2_dir = [home_dir 'Data/Model_Output/CMIP5/spco2/regrid/'];
% 
% cmip_spco2_files = dir([CMIP5_spco2_dir '*.nc']);
% 
% clear CMIP5_mon_spco2
% time_offset = 0;
% 
% cmip_spco2_names = cell(length(cmip_spco2_files),1);
% 
% for f=1:length(cmip_spco2_files)
%     first_index = strfind(cmip_spco2_files(f).name, 'Omon');
%     second_index = strfind(cmip_spco2_files(f).name, 'rcp85');
%     mod_name = cmip_spco2_files(f).name(first_index+5:second_index-2);
%     disp([mod_name ' started'])
%     
%     mod_name = strrep(mod_name, '-', '_');
%     
%     time_temp = ncread([CMIP5_spco2_dir cmip_spco2_files(f).name], 'time');
%     
%     temp_Matlab_time = time_temp + time_offset;
%     %     mod_vec = datevec(temp_Matlab_time);
%     %     disp(mod_vec(1:12,:))
%     
%     
%     if f==1
%         CMIP5_mon_spco2.lon = ncread([CMIP5_spco2_dir cmip_spco2_files(f).name], 'lon');
%         CMIP5_mon_spco2.lat = ncread([CMIP5_spco2_dir cmip_spco2_files(f).name], 'lat');
%     end
%     
%     CMIP5_mon_spco2.(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time
%     CMIP5_mon_spco2.(mod_name).spco2 = ncread([CMIP5_spco2_dir cmip_spco2_files(f).name], 'spco2');
%     CMIP5_mon_spco2.(mod_name).units = ncreadatt([CMIP5_spco2_dir cmip_spco2_files(f).name], 'spco2', 'units');
%     CMIP5_mon_spco2.(mod_name).long_name = ncreadatt([CMIP5_spco2_dir cmip_spco2_files(f).name], 'spco2', 'long_name');
%     
%     cmip_spco2_names{f} = mod_name;
%     
%     if contains(mod_name, 'MRI_ESM1')
%         CMIP5_mon_spco2.(mod_name).spco2(CMIP5_mon_spco2.(mod_name).spco2==0)=nan;
%     end
%     
%     clear mod_name time_temp first_index second_index temp_Matlab_time
% end
% 
% clear f cmip_spco2_files time_offset
% 
% %% SPCO2 Monthly CMIP6 LOAD
% CMIP6_spco2_dir = [home_dir 'Data/Model_Output/CMIP6/spco2/regrid/'];
% 
% cmip_spco2_files = dir([CMIP6_spco2_dir '*.nc']);
% 
% cmip6_spco2_names = cell(length(cmip_spco2_files),1);
% time_offset = 0; % time and calendar has been set in CDO
% 
% 
% for f=1:length(cmip_spco2_files)
%     
%     first_index = strfind(cmip_spco2_files(f).name, 'Omon');
%     second_index = strfind(cmip_spco2_files(f).name, 'ssp585');
%     mod_name = cmip_spco2_files(f).name(first_index+5:second_index-2);
%     
%     disp([mod_name ' started'])
%     
%     mod_name = strrep(mod_name, '-', '_');
%     mod_name = [mod_name '_6'];
%     
%     time_temp = ncread([CMIP6_spco2_dir cmip_spco2_files(f).name], 'time');
%     
%     temp_Matlab_time = time_temp + time_offset;
%     
%     CMIP5_mon_spco2.(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time
%     CMIP5_mon_spco2.(mod_name).spco2 = ncread([CMIP6_spco2_dir cmip_spco2_files(f).name], 'spco2');
%     CMIP5_mon_spco2.(mod_name).units = ncreadatt([CMIP6_spco2_dir cmip_spco2_files(f).name], 'spco2', 'units');
%     CMIP5_mon_spco2.(mod_name).long_name = ncreadatt([CMIP6_spco2_dir cmip_spco2_files(f).name], 'spco2', 'long_name');
%     
%     cmip6_spco2_names{f} = mod_name;
%     
%     clear mod_name time_temp first_index second_index temp_Matlab_time
% end
% 
% clear f cmip_spco2_files
% 
% cmip_spco2_names = [cmip_spco2_names ; cmip6_spco2_names];
% 
% for q = 1:length(model_types)
%     CMIP5_mon_spco2.model_groups.(model_types{q}) = find(contains(cmip_spco2_names, model_group_names.(model_types{q})));
% end
% 
% clear q cmip6_talk_names time_offset

%% putting into atmospheres
% scale_factor = 1./101325 .*10^6;  % atm per pascale times uatm per atm
% 
% 
% for m=1:length(cmip_spco2_names)
%     
%     CMIP5_mon_spco2.(cmip_spco2_names{m}).pco2_uatm = CMIP5_mon_spco2.(cmip_spco2_names{m}).spco2.*scale_factor; % pascales to atm
%     
% end
% 
% clear scale_factor m
%% plotting surface spCO2 to check land and nan values
% [lon_grid, lat_grid] = meshgrid(CMIP5_mon_spco2.lon, CMIP5_mon_spco2.lat);
%
% CMIP5_mon_spco2.lon_grid = lon_grid';
% CMIP5_mon_spco2.lat_grid = lat_grid';
% clear lon_grid lat_grid
%
% for m = 1:length(cmip_spco2_names)
%     % Southern Ocean surface DIC plot . time_range = 2010 to 2020
%
%     clf
%     set(gcf, 'units', 'inches')
%     paper_w = 16; paper_h =9;
%     set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
%
%     mod_vec = datevec(CMIP5_mon_spco2.(cmip_spco2_names{m}).GMT_Matlab);
%     time_index = mod_vec(:,1)>=2010 & mod_vec(:,1)<2020;
%
%     SO_lat_index = CMIP5_mon_spco2.lat<=-35;
%
%     SO_pCO2 = CMIP5_mon_spco2.(cmip_spco2_names{m}).pco2_uatm(:, SO_lat_index, time_index);
%
%     SO_mean_pCO2 = nanmean(SO_pCO2,3);
%
%     pcolor(CMIP5_mon_spco2.lon_grid(:,SO_lat_index), CMIP5_mon_spco2.lat_grid(:,SO_lat_index), SO_mean_pCO2(:,:)); shading flat
%     xlabel('Longitude')
%     ylabel('Latitude')
%     c1 = colorbar;
%     ylabel(c1, 'pCO2 (uatm)')
%     title([(cmip_spco2_names{m}) ' Surface pCO2'], 'interpreter', 'none')
%     caxis([350 450])
%     set(gca, 'ylim', [-85 -35])
%
%     plot_filename = ['spCO2_Surface_' cmip_spco2_names{m}];
%     saveas(gcf, [Plot_out_dir 'spCO2/' plot_filename ''], 'png')
%
%     clear SO_pCO2 SO_mean_pCO2 mod_vec time_index SO_lat_index c1
% end
%
% clear m paper_w paper_h

%% saving spco2 monthly means and std

% pco2_out_seasonal = NaN(length(cmip_spco2_names),12,2);
% 
% for m = 1:length(cmip_spco2_names)
%     
%     for mon = 1:12
%         mod_vec = datevec(CMIP5_mon_spco2.(cmip_spco2_names{m}).GMT_Matlab);
%         time_index = mod_vec(:,2)==mon;
%         
%         lat_index = CMIP5_mon_spco2.lat<=lat_lims(2) & CMIP5_mon_spco2.lat>=lat_lims(1);
%         
%         SO_pco2 = CMIP5_mon_spco2.(cmip_spco2_names{m}).pco2_uatm(:, lat_index, time_index);
%         
%         pco2_out_seasonal(m,mon,1) = nanmean(reshape(SO_pco2,[],1));
%         pco2_out_seasonal(m,mon,2) = nanstd(reshape(SO_pco2,[],1));
%         clear time_index lat_index SO_spco2 mod_vec
%     end
% end
% clear m mon
%% % plotting spCO2 seasonal cycle
% cmap = distinguishable_colors(20);
% plot_filename = 'Obs model Seasonal pco2_v2';
% clf
% subplot(1,1,1)
% hold on
% 
% argo_vec = datevec(argo_SO.surf.GMT_Matlab);
% argo_vec(:,1) = 2016;
% argo_date_single_year = datenum(argo_vec);
% 
% obs_pco2_monthly = NaN(12,2);
% 
% for m=1:12
%     
%     argo_index = argo_vec(:,2)==m;
%     
%     obs_pco2_monthly(m,1) = nanmean([argo_SO.surf.pCO2(argo_index)] );
%     obs_pco2_monthly(m,2) = nanstd([argo_SO.surf.pCO2(argo_index)]);
% end
% 
% d = NaN(length(cmip_spco2_names),1);
% for m = 1:length(cmip_spco2_names)
%     
%     d(m) = plot(1:12, pco2_out_seasonal(m,:,1), 'color', cmap(strmatch(cmip_spco2_names{m}, color_model(:,1), 'exact'),:), 'linewidth', 2);
%     
% end
% e1 = errorbar(1:12, obs_pco2_monthly(:,1), obs_pco2_monthly(:,2), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
% e2 = errorbar(1:12, neur_pCO2_seasonal(:,1), neur_pCO2_seasonal(:,2), 'linewidth', 3, 'color', 'k', 'linestyle', '-.');
% 
% ylabel('spco2')
% xlabel('Month')
% legend([e1; e2; d], ['Obs-Argo' ; 'Obs-Neur'; cmip_spco2_names ], 'interpreter', 'none','location', 'eastoutside')
% title('Seasonal spco2')
% print(gcf, '-dpng', [Plot_out_dir 'spCO2/' plot_filename '.png'])
% 
% clear m plot_filename
% 
% plot_filename = 'Obs model Seasonal pco2 anomaly';
% 
% clf
% set(gcf, 'units', 'inches')
% paper_w = 15; paper_h =8;
% set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
% 
% subplot(1,1,1)
% hold on
% d = NaN(length(cmip_spco2_names),1);
% for m = 1:length(cmip_spco2_names)
%     
%     d(m) = plot(1:12, pco2_out_seasonal(m,:,1) - nanmean(pco2_out_seasonal(m,:,1)), 'color', cmap(strmatch(cmip_spco2_names{m}, color_model(:,1), 'exact'),:), 'linewidth', 2);
%     
% end
% e1 = plot(1:12, obs_pco2_monthly(:,1) - nanmean(obs_pco2_monthly(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
% e2 = plot(1:12, neur_pCO2_seasonal(:,1) - nanmean(neur_pCO2_seasonal(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '-.');
% 
% ylabel('spco2 anomalys')
% xlabel('Month')
% legend([ e1; e2; d], [ 'Obs-Argo'; 'Obs-Neur'; cmip_spco2_names], 'interpreter', 'none','location', 'eastoutside')
% title('Seasonal spco2 anomaly')
% print(gcf, '-dpng', [Plot_out_dir 'spCO2/' plot_filename '.png'])


%% Surface plots
% var_lims=[0 10e-7; 9.8e4 10.3e4];
% 
% for v=1:length(variables)
%     [lon_grid, lat_grid] = meshgrid(CMIP.(variables{v}).lon, CMIP.(variables{v}).lat);
%     
%     CMIP.(variables{v}).lon_grid = lon_grid';
%     CMIP.(variables{v}).lat_grid = lat_grid';
%     clear lon_grid lat_grid
%     
%     
%     temp_names = cmip_names.(variables{v});
%     Plot_out_dir = [home_dir 'Work/Projects/2019_05 SO_C_flux_model_comparison/Plots/'];
%     
%     SO_lat_index = CMIP.(variables{v}).lat<=-35;
%     
%     for m = 1:length(temp_names)
%         % Southern Ocean surface intpp plot . time_range = 2010 to 2020
%         
%         clf
%         set(gcf, 'units', 'inches')
%         paper_w = 16; paper_h =9;
%         set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
%         
%         mod_vec = datevec(CMIP.(variables{v}).(temp_names{m}).GMT_Matlab);
%         time_index = mod_vec(:,1)>=2010 & mod_vec(:,1)<2020;
%         
%         
%         SO_var = CMIP.(variables{v}).(temp_names{m}).(variables{v})(:, SO_lat_index, time_index);
%         
%         SO_mean_var = nanmean(SO_var,3);
%         
%         pcolor(CMIP.(variables{v}).lon_grid(:,SO_lat_index), CMIP.(variables{v}).lat_grid(:,SO_lat_index), SO_mean_var(:,:,1)); shading flat
%         xlabel('Longitude')
%         ylabel('Latitude')
%         c1 = colorbar;
%         ylabel(c1, CMIP.(variables{v}).(temp_names{m}).units)
%         title([temp_names{m} ' ' CMIP.(variables{v}).(temp_names{m}).long_name], 'interpreter', 'none')
%         caxis(var_lims(v,:))
%         set(gca, 'ylim', [-85 -35])
%         
%         plot_filename = ['Surface_' variables{v} '_' temp_names{m}];
%         saveas(gcf, [Plot_out_dir variables{v} '/' plot_filename '_v2'], 'png')
%         
%         clear SO_var SO_mean_var time_index
%         %     pause
%     end
%     
%     clear m SO_lat_index temp_names
% end
%% saving monthly means and std

% intpp_out_seasonal = NaN(length(cmip_intpp_names),12,2);
% 
% for m = 1:length(cmip_intpp_names)
%     
%     for mon = 1:12
%         mod_vec = datevec(CMIP5_mon_intpp.(cmip_intpp_names{m}).GMT_Matlab);
%         time_index = mod_vec(:,2)==mon;
%         
%         lat_index = CMIP5_mon_intpp.lat<=lat_lims(2) & CMIP5_mon_intpp.lat>=lat_lims(1);
%         
%         SO_pp = CMIP5_mon_intpp.(cmip_intpp_names{m}).intpp(:, lat_index, time_index);
%         
%         intpp_out_seasonal(m,mon,1) = nanmean(reshape(SO_pp,[],1));
%         intpp_out_seasonal(m,mon,2) = nanstd(reshape(SO_pp,[],1));
%         
%         clear mod_vec time_index lat_index SO_pp
%     end
%     
% end

%% % plotting seasonal intpp cycle
% plot_filename = 'Obs model Seasonal intpp_v1';
% clf
% subplot(1,1,1)
% hold on
% for m = 1:length(cmip_intpp_names)
%     
%     plot(1:12, intpp_out_seasonal(m,:,1), 'color', cmap(strmatch(cmip_intpp_names{m}, color_model(:,1), 'exact'),:), 'linewidth', 2);
%     
% end
% 
% e1 = errorbar(1:12, NPP_obs_out_seasonal(1,:,1).*npp_scale_factor, NPP_obs_out_seasonal(1,:,2).*npp_scale_factor, 'linewidth', 3, 'color', 'k');
% 
% ylabel('Int. PP mol m-2 s-1')
% xlabel('Month')
% legend([cmip_intpp_names ; 'Cbpm'], 'interpreter', 'none')
% title('Seasonal INTPP')
% print(gcf, '-dpng', [Plot_out_dir plot_filename '.png'])
% 
% clear m mon

%% plotting seasonal intpp cycle for each model type
% 
% % CMIP5_mon_intpp.model_groups.good_mag_good_phase = find(contains(cmip_intpp_names, {'MIROC_ESM', 'MIROC_ESM_CHEM', ...
% %     'HadGEM', 'CESM1_BGC', 'GFDL_ESM4_6'}));
% % CMIP5_mon_intpp.model_groups.large_mag_good_phase = find(contains(cmip_intpp_names,{'MPI', 'NorESM1', 'MPI_ESM1_2_HR_6', 'MPI_ESM1_2_LR_6'}));
% % CMIP5_mon_intpp.model_groups.bad_phase = find(contains(cmip_intpp_names,{'IPSL', 'MRI', 'CNRM_CM5','ESM2G', ...
% %     'CESM2_WACCM_6', 'CESM2_6', 'CNRM_ESM2_1_6', 'UKESM1_0_LL_6', 'CanESM5_6', 'MIROC_ES2L_6', ...
% %     'INM_CM5_0_6','INM_CM4_8_6', 'ACCESS_ESM1_5_6', 'GFDL_CM4_6', 'NorESM2_LM_6', 'NorESM2_MM_6'}));
% % CMIP5_mon_intpp.model_groups.double_peak = find(contains(cmip_intpp_names,  {'CanESM2', 'CMCC_CESM', 'ESM2M'}));
% % CMIP5_mon_intpp.model_groups.other = find(contains(cmip_intpp_names, {  'GISS_E2_H_CC', 'GISS_E2_R_CC', ...
% %     'GISS_E2_R',  'BCC_CSM2_MR_6'   ...
% %      }));
% model_types = fieldnames(CMIP5_mon_intpp.model_groups);
% 
% for q = length(model_types):-1:1
%     plot_filename = ['Model Seasonal intpp v2 ' model_types{q}];
%     
%     clf
%     set(gcf, 'units', 'inches')
%     paper_w = 10; paper_h =8;
%     set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
%     
%     subplot(1,1,1)
%     hold on
%     
%     model_list = CMIP5_mon_intpp.model_groups.(model_types{q});
%     for m = 1: length(model_list)
%         
%         temp_plot = intpp_out_seasonal(model_list(m),:,1);
%         plot(-5:6, [temp_plot(1,7:12,1) temp_plot(1,1:6,1)] , 'color', cmap(strmatch(cmip_intpp_names{model_list(m)}, color_model(:,1), 'exact'),:), 'linewidth', 2);
%         
%         clear temp_plot
%     end
%     
%     
%     e1 = errorbar(-5:6, [NPP_obs_out_seasonal(1,7:12,1).*npp_scale_factor  NPP_obs_out_seasonal(1,1:6,1).*npp_scale_factor], ...
%         [NPP_obs_out_seasonal(1,7:12,2).*npp_scale_factor  NPP_obs_out_seasonal(1,1:6,2).*npp_scale_factor], ...
%         'linewidth', 3, 'color', 'k', 'linestyle', '--');
%     
%     ylabel('intpp mol-2 s-1')
%     xlabel('Month')
%     legend([cmip_intpp_names(model_list) ; 'Obs'], 'interpreter', 'none', 'location', 'eastoutside')
%     title(['Seasonal intpp model subset: ' model_types{q}], 'interpreter', 'none')
%     print(gcf, '-dpng', [Plot_out_dir plot_filename '.png'])
%     
%     clear m plot_filename
%     pause
% end


%% plotting  NPP vs. all model types
% plot_filename = 'Obs model intpp by model_groups_v1';
% clf
% set(gcf, 'units', 'inches')
% paper_w = 10; paper_h =5;
% set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h
% 
% subplot(1,1,1)
% hold on
% 
% % plot_colors = brewermap(5, 'dark2');
% 
% p = [];
% for q = length(model_types):-1:1
%     model_list = CMIP5_mon_intpp.model_groups.(model_types{q});
%     p1 = plot(-5:6, [intpp_out_seasonal(model_list,7:12,1) intpp_out_seasonal(model_list,1:6,1)], 'color', model_group_colors(q,:), 'linewidth', 2);
%     p(q) = p1(1);
%     
% end
% 
% e1 = errorbar(-5:6, [NPP_obs_out_seasonal(1,7:12,1).*npp_scale_factor  NPP_obs_out_seasonal(1,1:6,1).*npp_scale_factor], ...
%     [NPP_obs_out_seasonal(1,7:12,2).*npp_scale_factor  NPP_obs_out_seasonal(1,1:6,2).*npp_scale_factor], ...
%     'linewidth', 3, 'color', 'k', 'linestyle', '--');
% 
% ylabel('PP (mol^-^2 s^-^1)')
% xlabel('Month')
% set(gca, 'xtick', [-5 -3 -1 1 3 5], 'xticklabel',{'July', 'Sept.', 'Nov.', 'Jan.', 'Mar.', 'May'} )
% set(gca, 'fontsize', 20)
% % legend([p e1], 'Good phase and mag.', 'Good phase, large mag.', 'Out of phase', 'Double Peak', 'Other', 'Obs', 'interpreter', 'none', 'location', 'eastoutside')
% title('PP')
% print(gcf, '-dpdf', [Plot_out_dir 'INTPP/' plot_filename '.pdf'])

%% Plotting NPP max vs. model type
% clf
% plot_filename = ['intpp_model_comparison_v2 max_month Lat ' num2str(lat_lims)];
% 
% set(gcf, 'units', 'inches')
% paper_w = 10; paper_h =8;
% set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
% 
% d1 = subplot(1,1,1);
% hold on
% plot_index = 1;
% 
% % plot(plot_index, nansum(NPP_obs_out_seasonal(1, [11 12 1], 1)).*npp_scale_factor, 'rx')
% plot(plot_index, find((NPP_obs_out_seasonal(1,:,1)==max(NPP_obs_out_seasonal(1,:,1)))), 'rx')
% plot_index = plot_index+1;
% % plot([plot_index-0.5 plot_index-0.5], [0 4.5e-6], 'k-')
% 
% for q = 1:length(model_types)
%     model_list = CMIP5_mon_intpp.model_groups.(model_types{q});
%     
%     for m = 1:length(model_list)
%         %         plot(plot_index, nansum(intpp_out_seasonal(model_list(m), [11 12 1], 1)), 'kx')
%         plot(plot_index, find((intpp_out_seasonal(model_list(m),:,1)==max(intpp_out_seasonal(model_list(m),:,1)))), 'kx')
%         
%         plot_index = plot_index+1;
%     end
%     
%     %     plot([plot_index-0.5 plot_index-0.5], [0 4.5e-6], 'k-')
%     
% end
% label_names = {};
% % put all model names into one cell string in order of their types
% for q = 1:length(model_types)
%     for m = 1:length(CMIP5_mon_intpp.model_groups.(model_types{q}))
%         label_names{end+1,1} = cmip_intpp_names{CMIP5_mon_intpp.model_groups.(model_types{q})(m)};
%         
%     end
% end
% 
% for l = 1:length(label_names)
%     label_names{l}(strfind(label_names{l}, '_')) = ' ';
% end
% 
% set(d1, 'xtick', 1:plot_index)
% set(d1, 'xlim', [0 plot_index+1])
% 
% set(d1, 'xticklabel',  ['CBPM' ; label_names])
% xtickangle(d1, 45)
% set(d1, 'ygrid', 'on')
% ylabel(d1, 'Month')
% title('Max month of PP')
% print(gcf, '-dpng', [Plot_out_dir plot_filename '.png'])

%% TS Monthly CMIP5 load
% 
% CMIP5_tos_dir = [home_dir 'Data/Model_Output/CMIP5/tos/regrid/'];
% CMIP5_sos_dir = [home_dir 'Data/Model_Output/CMIP5/sos/regrid/'];
% 
% cmip_tos_files = dir([CMIP5_tos_dir '*.nc']);
% cmip_sos_files = dir([CMIP5_sos_dir '*.nc']);
% 
% clear CMIP5_ts
% 
% cmip_tos_names = cell(length(cmip_tos_files),1);
% %
% time_offset = 0; % differing time stamps is now fixed using cdo commands
% 
% for f=1:length(cmip_tos_files)
%     
%     first_index = strfind(cmip_tos_files(f).name, 'Omon');
%     second_index = strfind(cmip_tos_files(f).name, 'rcp85');
%     mod_name = cmip_tos_files(f).name(first_index+5:second_index-2);
%     disp([mod_name ' started'])
%     
%     mod_name = strrep(mod_name, '-', '_');
%     
%     if ~strcmp(cmip_sos_files(f).name(2:end), cmip_tos_files(f).name(2:end))
%         disp('Mismatch between temp and sal filenames')
%     end
%     time_temp_tos = ncread([CMIP5_tos_dir cmip_tos_files(f).name], 'time');
%     time_temp_sos = ncread([CMIP5_sos_dir cmip_sos_files(f).name], 'time');
%     
%     if ~sum(time_temp_tos==time_temp_sos)==length(time_temp_tos)
%         disp('Mismatch between temperature and salinity time records')
%     end
%     temp_Matlab_time = time_temp_tos + time_offset;
%     
%     if f==1
%         CMIP5_ts.lon = ncread([CMIP5_tos_dir cmip_tos_files(f).name], 'lon');
%         CMIP5_ts.lat = ncread([CMIP5_tos_dir cmip_tos_files(f).name], 'lat');
%     end
%     
%     CMIP5_ts.(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time
%     CMIP5_ts.(mod_name).tos = ncread([CMIP5_tos_dir cmip_tos_files(f).name], 'tos')-273.15;
%     CMIP5_ts.(mod_name).tos_units = 'C';
%     CMIP5_ts.(mod_name).tos_units_old = ncreadatt([CMIP5_tos_dir cmip_tos_files(f).name], 'tos', 'units');
%     CMIP5_ts.(mod_name).tos_long_name = ncreadatt([CMIP5_tos_dir cmip_tos_files(f).name], 'tos', 'long_name');
%     
%     CMIP5_ts.(mod_name).sos = ncread([CMIP5_sos_dir cmip_sos_files(f).name], 'sos');
%     CMIP5_ts.(mod_name).sos_units = ncreadatt([CMIP5_sos_dir cmip_sos_files(f).name], 'sos', 'units');
%     CMIP5_ts.(mod_name).sos_long_name = ncreadatt([CMIP5_sos_dir cmip_sos_files(f).name], 'sos', 'long_name');
%     
%     
%     cmip_tos_names{f} = mod_name;
%     
%     clear mod_name time_temp_sos first_index second_index time_temp_tos
% end
% 
% clear f cmip_tos_files cmip_sos_files time_offset CMIP5_tos_dir CMIP5_sos_dir

%% TS Monthly CMIP6 load

% CMIP6_tos_dir = [home_dir 'Data/Model_Output/CMIP6/tos/regrid/'];
% CMIP6_sos_dir = [home_dir 'Data/Model_Output/CMIP6/sos/regrid/'];
% 
% cmip_tos_files = dir([CMIP6_tos_dir '*.nc']);
% cmip_sos_files = dir([CMIP6_sos_dir '*.nc']);
% 
% cmip6_tos_names = cell(length(cmip_tos_files),1);
% time_offset = 0; % time and calendar has been set in CDO
% 
% 
% for f=1:length(cmip_tos_files)
%     
%     first_index = strfind(cmip_tos_files(f).name, 'Omon');
%     second_index = strfind(cmip_tos_files(f).name, 'ssp585');
%     mod_name = cmip_tos_files(f).name(first_index+5:second_index-2);
%     
%     disp([mod_name ' started'])
%     
%     mod_name = strrep(mod_name, '-', '_');
%     mod_name = [mod_name '_6'];
%     
%     if ~strcmp(cmip_sos_files(f).name(2:end), cmip_tos_files(f).name(2:end))
%         disp('Mismatch between temp and sal filenames')
%     end
%     
%     time_temp_tos = ncread([CMIP6_tos_dir cmip_tos_files(f).name], 'time');
%     time_temp_sos = ncread([CMIP6_sos_dir cmip_sos_files(f).name], 'time');
%     
%     temp_Matlab_time = time_temp_tos + time_offset;
%     
%     if ~sum(time_temp_tos==time_temp_sos)==length(time_temp_tos)
%         disp('Mismatch between temperature and salinity time records')
%     end
%     
%     CMIP5_ts.(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time
%     CMIP5_ts.(mod_name).tos = ncread([CMIP6_tos_dir cmip_tos_files(f).name], 'tos');
%     CMIP5_ts.(mod_name).tos_units = 'C';
%     CMIP5_ts.(mod_name).tos_units_old = ncreadatt([CMIP6_tos_dir cmip_tos_files(f).name], 'tos', 'units');
%     CMIP5_ts.(mod_name).tos_long_name = ncreadatt([CMIP6_tos_dir cmip_tos_files(f).name], 'tos', 'long_name');
%     
%     CMIP5_ts.(mod_name).sos = ncread([CMIP6_sos_dir cmip_sos_files(f).name], 'sos');
%     CMIP5_ts.(mod_name).sos_units = ncreadatt([CMIP6_sos_dir cmip_sos_files(f).name], 'sos', 'units');
%     CMIP5_ts.(mod_name).sos_long_name = ncreadatt([CMIP6_sos_dir cmip_sos_files(f).name], 'sos', 'long_name');
%     
%     cmip6_tos_names{f} = mod_name;
%     
%     clear mod_name time_temp
% end
% 
% clear f cmip_talk_files
% 
% cmip_tos_names = [cmip_tos_names ; cmip6_tos_names];
% 
% 
% for q = 1:length(model_types)
%     CMIP5_ts.model_groups.(model_types{q}) = find(contains(cmip_tos_names, model_group_names.(model_types{q})));
% end
% 
% clear q

%% plotting surface fluxes to check land and nan values
% [lon_grid, lat_grid] = meshgrid(CMIP5_ts.lon, CMIP5_ts.lat);
% 
% CMIP5_ts.lon_grid = lon_grid';
% CMIP5_ts.lat_grid = lat_grid';
% clear lon_grid lat_grid
% 
% Plot_out_dir = [home_dir 'Work/Projects/2019_05 SO_C_flux_model_comparison/Plots/'];
% 
% SO_lat_index = CMIP5_ts.lat<=-35;
% 
% for m = 1:length(cmip_tos_names)
%     % Southern Ocean surface DIC plot . time_range = 2010 to 2020
%     
%     clf
%     set(gcf, 'units', 'inches')
%     paper_w = 16; paper_h =9;
%     set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
%     
%     mod_vec = datevec(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).GMT_Matlab);
%     time_index = mod_vec(:,1)>=2010 & mod_vec(:,1)<2020;
%     
%     SO_SST = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).tos(:, SO_lat_index, time_index);
%     SO_SSS = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).sos(:, SO_lat_index, time_index);
%     
%     SO_mean_SST = nanmean(SO_SST,3);
%     SO_mean_SSS = nanmean(SO_SSS,3);
%     
%     subplot(2,1,1)
%     pcolor(CMIP5_ts.lon_grid(:,SO_lat_index), CMIP5_ts.lat_grid(:,SO_lat_index), SO_mean_SST(:,:)); shading flat
%     xlabel('Longitude')
%     ylabel('Latitude')
%     c1 = colorbar;
%     ylabel(c1, 'SST')
%     title([(cmip_tos_names{m}) ' Surface SST'], 'interpreter', 'none')
%     set(gca, 'ylim', [-85 -35])
%     caxis([-2 25])
%     
%     subplot(2,1,2)
%     pcolor(CMIP5_ts.lon_grid(:,SO_lat_index), CMIP5_ts.lat_grid(:,SO_lat_index), SO_mean_SSS(:,:)); shading flat
%     xlabel('Longitude')
%     ylabel('Latitude')
%     c1 = colorbar;
%     ylabel(c1, 'SSS')
%     title([(cmip_tos_names{m}) ' Surface SSS'], 'interpreter', 'none')
%     set(gca, 'ylim', [-85 -35])
%     caxis([29 35.5])
%     
%     plot_filename = ['TS_Surface_' cmip_tos_names{m}];
%     saveas(gcf, [Plot_out_dir 'TS/' plot_filename '_v6'], 'png')
%     
%     clear SO_mean_SST SO_mean_SSS SO_SST SO_SSS time_index mod_vec
% end
% 
% clear m c1 SO_lat_index paper_h paper_w

%% saving monthly means and std

% sst_out_seasonal = NaN(length(cmip_tos_names),12,2);
% sss_out_seasonal = NaN(length(cmip_tos_names),12,2);
% 
% for m = 1:length(cmip_tos_names)
%     
%     for mon = 1:12
%         mod_vec = datevec(CMIP5_ts.(cmip_tos_names{m}).GMT_Matlab);
%         time_index = mod_vec(:,2)==mon;
%         
%         lat_index = CMIP5_ts.lat<=lat_lims(2) & CMIP5_ts.lat>=lat_lims(1);
%         
%         SO_SST = CMIP5_ts.(cmip_tos_names{m}).tos(:, lat_index, time_index);
%         sst_out_seasonal(m,mon,1) = nanmean(reshape(SO_SST,[],1));
%         sst_out_seasonal(m,mon,2) = nanstd(reshape(SO_SST,[],1));
%         
%         SO_SSS = CMIP5_ts.(cmip_tos_names{m}).sos(:, lat_index, time_index);
%         sss_out_seasonal(m,mon,1) = nanmean(reshape(SO_SSS,[],1));
%         sss_out_seasonal(m,mon,2) = nanstd(reshape(SO_SSS,[],1));
%         
%         clear mod_vec time_index lat_index SO_SST
%     end
%     
% end


%% observation seasonal cycle of T and S (means)

% plot_filename = 'TS_surface_cycle';
% clf
% set(gcf, 'units', 'inches')
% paper_w = 10; paper_h =8;
% set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
% 
% d1= subplot(2,1,1);
% obs_sst_monthly = NaN(12,2);
% obs_sss_monthly = NaN(12,2);
% obs_sol_monthly = NaN(12,2);
% 
% argo_vec = datevec(argo_SO.surf.GMT_Matlab);
% argo_vec(:,1) = 2016;
% argo_date_single_year = datenum(argo_vec);
% p1 = plot(argo_date_single_year, argo_SO.surf.Temp_C, 'xb');
% hold on
% gdap_vec = datevec(gdap_SO.surf.GMT_Matlab);
% gdap_vec(:,1) = 2016;
% gdap_date_single_year = datenum(gdap_vec);
% p2 = plot(gdap_date_single_year, gdap_SO.surf.G2temperature, 'or');
% 
% ylabel('SST')
% datetick('x', 'mmm')
% title(['Surface Data, lat. limits: ' num2str(lat_lims)])
% 
% argo_SO.surf.CO2_sol = CO2_Sol(argo_SO.surf.Temp_C, argo_SO.surf.Sal);
% gdap_SO.surf.CO2_sol = CO2_Sol(gdap_SO.surf.G2temperature, gdap_SO.surf.G2salinity);
% 
% for m=1:12
%     
%     argo_index = argo_vec(:,2)==m;
%     gdap_index = gdap_vec(:,2)==m;
%     
%     obs_sst_monthly(m,1) = nanmean([argo_SO.surf.Temp_C(argo_index) ; gdap_SO.surf.G2temperature(gdap_index)]);
%     obs_sst_monthly(m,2) = nanstd([argo_SO.surf.Temp_C(argo_index) ; gdap_SO.surf.G2temperature(gdap_index)]);
%     
%     obs_sss_monthly(m,1) = nanmean([argo_SO.surf.Sal(argo_index) ; gdap_SO.surf.G2salinity(gdap_index)]);
%     obs_sss_monthly(m,2) = nanstd([argo_SO.surf.Sal(argo_index) ; gdap_SO.surf.G2salinity(gdap_index)]);
%     
%     obs_sol_monthly(m,1) = nanmean([argo_SO.surf.CO2_sol(argo_index) ; gdap_SO.surf.CO2_sol(gdap_index)]);
%     obs_sol_monthly(m,2) = nanstd([argo_SO.surf.CO2_sol(argo_index) ; gdap_SO.surf.CO2_sol(gdap_index)]);
%     
%     clear argo_index gdap_index
% end
% 
% e1 = errorbar(datenum(2016,1:12,15), obs_sst_monthly(:,1), obs_sst_monthly(:,2), 'linewidth', 2, 'color', 'k');
% 
% legend([p1 p2 e1], 'SOCCOM', 'GLODAP', 'Combined mean +/- 1 sd', 'location', 'southeast')
% 
% subplot(2,1,2)
% p1 = plot(argo_date_single_year, argo_SO.surf.Sal, 'xb');
% hold on
% p2 = plot(gdap_date_single_year, gdap_SO.surf.G2salinity, 'or');
% e1 = errorbar(datenum(2016,1:12,15), obs_sss_monthly(:,1), obs_sss_monthly(:,2), 'linewidth', 2, 'color', 'k');
% 
% 
% print(gcf, '-dpng', [Plot_out_dir 'TS/' plot_filename '.png'])
% 
% clear m e1 p2 p1 argo_vec argo_date_single_year gdap_vec gdap_date_single_year paper_h paper_w

%% plotting seasonal SSS SST cycle
% plot_filename = 'Obs model Seasonal SST_SSS_v1';
% clf
% subplot(2,1,1)
% hold on
% for m = 1:length(cmip_tos_names)
%     
%     plot(1:12, sst_out_seasonal(m,:,1), 'color', cmap(strmatch(cmip_tos_names{m}, color_model(:,1), 'exact'),:), 'linewidth', 2);
%     
% end
% 
% e1 = errorbar(1:12, obs_sst_monthly(:,1), obs_sst_monthly(:,2), 'linewidth', 3, 'color', 'k');
% 
% ylabel('\circC')
% xlabel('Month')
% legend([cmip_tos_names ; 'Obs'], 'interpreter', 'none')
% title('Seasonal SST')
% 
% subplot(2,1,2)
% hold on
% for m = 1:length(cmip_tos_names)
%     
%     plot(1:12, sss_out_seasonal(m,:,1), 'color', cmap(strmatch(cmip_tos_names{m}, color_model(:,1), 'exact'),:), 'linewidth', 2);
%     
% end
% 
% e1 = errorbar(1:12, obs_sss_monthly(:,1), obs_sss_monthly(:,2), 'linewidth', 3, 'color', 'k');
% ylabel('SSS')
% xlabel('Month')
% 
% 
% print(gcf, '-dpng', [Plot_out_dir plot_filename '.png'])
% 
% clear m mon

 %% plotting seasonal SST SSS cycle for each model type
% 
% % CMIP5_ts.model_groups.good_mag_good_phase = find(contains(cmip_tos_names, {'MIROC_ESM', 'MIROC_ESM_CHEM', ...
% %     'HadGEM', 'CESM1_BGC', 'GFDL_ESM4_6'}));
% % CMIP5_ts.model_groups.large_mag_good_phase = find(contains(cmip_tos_names, {'MPI', 'NorESM1', 'MPI_ESM1_2_HR_6', 'MPI_ESM1_2_LR_6'}));
% % CMIP5_ts.model_groups.bad_phase = find(contains(cmip_tos_names, {'IPSL', 'MRI', 'CNRM_CM5','ESM2G', ...
% %     'CESM2_WACCM_6', 'CESM2_6', 'CNRM_ESM2_1_6', 'UKESM1_0_LL_6', 'CanESM5_6', 'MIROC_ES2L_6', ...
% %     'INM_CM5_0_6','INM_CM4_8_6', 'ACCESS_ESM1_5_6', 'GFDL_CM4_6', 'NorESM2_LM_6', 'NorESM2_MM_6'}));
% % CMIP5_ts.model_groups.double_peak = find(contains(cmip_tos_names, {'CanESM2', 'CMCC_CESM', 'ESM2M'}));
% % CMIP5_ts.model_groups.other = find(contains(cmip_tos_names, {  'GISS_E2_H_CC', 'GISS_E2_R_CC', ...
% %     'GISS_E2_R',  'BCC_CSM2_MR_6'   ...
% %      }));
% %
% % model_types = fieldnames(CMIP5_ts.model_groups);
% 
% for q = 1:length(model_types)
%     plot_filename = ['Model Seasonal SST SSS v1 ' model_types{q}];
%     
%     clf
%     set(gcf, 'units', 'inches')
%     paper_w = 10; paper_h =8;
%     set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
%     
%     d1 = subplot(1,2,1);
%     hold on
%     d2 = subplot(1,2,2);
%     hold on
%     
%     model_list = CMIP5_ts.model_groups.(model_types{q});
%     for m = 1: length(model_list)
%         
%         temp_plot = sst_out_seasonal(model_list(m),:,1);
%         plot(d1, -5:6, [temp_plot(1,7:12,1) temp_plot(1,1:6,1)] , 'color', cmap(strmatch(cmip_tos_names{model_list(m)}, color_model(:,1), 'exact'),:), 'linewidth', 2);
%         
%         clear temp_plot
%         
%         temp_plot = sss_out_seasonal(model_list(m),:,1);
%         plot(d2, -5:6, [temp_plot(1,7:12,1) temp_plot(1,1:6,1)] , 'color', cmap(strmatch(cmip_tos_names{model_list(m)}, color_model(:,1), 'exact'),:), 'linewidth', 2);
%         
%         clear temp_plot
%     end
%     
%     
%     e1 = errorbar(d1, -5:6, [obs_sst_monthly(7:12,1) ; obs_sst_monthly(1:6,1)], ...
%         [obs_sst_monthly(7:12,2) ; obs_sst_monthly(1:6,2)] , ...
%         'linewidth', 3, 'color', 'k', 'linestyle', '--');
%     
%     e1 = errorbar(d2, -5:6, [obs_sss_monthly(7:12,1) ; obs_sss_monthly(1:6,1)], ...
%         [obs_sss_monthly(7:12,2) ; obs_sss_monthly(1:6,2)] , ...
%         'linewidth', 3, 'color', 'k', 'linestyle', '--');
%     
%     ylabel(d1, 'SST (C)')
%     ylabel(d2, 'SST (C)')
%     set(d1, 'ylim', [0 12])
%     set(d2, 'ylim', [33.5 34.5])
%     xlabel(d2, 'Month')
%     legend(d1, [cmip_tos_names(model_list) ; 'Obs'], 'interpreter', 'none', 'location', 'northwest')
%     title(['Seasonal SST model subset: ' model_types{q}], 'interpreter', 'none')
%     print(gcf, '-dpng', [Plot_out_dir 'TS/' plot_filename '.png'])
%     
%     clear m plot_filename
%     pause
% end
% 
% clear d1 d2 e1 q paper_h paper_w

%% T and S by model group
% 
% plot_filename = 'Obs model TS anomaly by model_groups_v1';
% clf
% set(gcf, 'units', 'inches')
% paper_w = 10; paper_h =10;
% set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
% 
% d1 = subplot(2,1,1);
% hold on
% d2 = subplot(2,1,2);
% hold on
% 
% % plot_colors = brewermap(5, 'dark2');
% 
% p = [];
% for q = length(model_types):-1:1
%     
%     model_list = CMIP5_ts.model_groups.(model_types{q});
%     p1 = plot(d1, 1:12, sst_out_seasonal(model_list,:,1) - nanmean(sst_out_seasonal(model_list,:,1),2), 'color', model_group_colors(q,:), 'linewidth', 2);
%     p2 = plot(d2, 1:12, sss_out_seasonal(model_list,:,1) - nanmean(sss_out_seasonal(model_list,:,1),2), 'color', model_group_colors(q,:), 'linewidth', 2);
%     
%     p(q) = p1(1);
%     %     plot(1:12, DIC_out_seasonal(m,:,1), 'color', cmap(find(contains(color_model(:,1), cmip_monthly_names{m})),:), 'linewidth', 2);
%     
% end
% 
% e1 = plot(d1, 1:12, obs_sst_monthly(:,1) - nanmean(obs_sst_monthly(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
% e2 = plot(d2, 1:12, obs_sss_monthly(:,1) - nanmean(obs_sss_monthly(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
% 
% ylabel(d1, 'SST (\circC)')
% 
% ylabel(d2, 'Salinity')
% xlabel('Month')
% set([d1 d2], 'fontsize', 20, 'xlim', [.5 12.5])
% set([d1 d2], 'xtick', [1 3 5 7 9 11])
% set(d1, 'xticklabel', {})
% set(d2, 'xticklabel',{'Jan.', 'Mar.', 'May', 'July', 'Sept.', 'Nov.'} )
% 
% % legend([p e1], 'Good phase and mag.', 'Good phase, large mag.', 'Out of phase', 'Double Peak', 'Other', 'Obs', 'interpreter', 'none', 'location', 'eastoutside')
% title(d1, 'SST')
% title(d2, 'SSS')
% 
% print(gcf, '-dpdf', [Plot_out_dir 'TS/' plot_filename '.pdf'])

%% calculate solubility
% 
% for q = 1:length(cmip_tos_names)
%     
%     CMIP5_ts.(cmip_tos_names{q}).CO2_sol = CO2_Sol(CMIP5_ts.(cmip_tos_names{q}).tos, CMIP5_ts.(cmip_tos_names{q}).sos);
%     
% end

%% saving monthly solubility means and std

% sol_out_seasonal = NaN(length(cmip_tos_names),12,2);
% 
% for m = 1:length(cmip_tos_names)
%     
%     for mon = 1:12
%         mod_vec = datevec(CMIP5_ts.(cmip_tos_names{m}).GMT_Matlab);
%         time_index = mod_vec(:,2)==mon;
%         
%         lat_index = CMIP5_ts.lat<=lat_lims(2) & CMIP5_ts.lat>=lat_lims(1);
%         
%         SO_sol = CMIP5_ts.(cmip_tos_names{m}).CO2_sol(:, lat_index, time_index);
%         sol_out_seasonal(m,mon,1) = nanmean(reshape(SO_sol,[],1));
%         sol_out_seasonal(m,mon,2) = nanstd(reshape(SO_sol,[],1));
%         
%         clear mod_vec time_index lat_index SO_SST
%     end
%     
% end

%% % plotting seasonal solubility cycle for model group
% plot_filename = 'Obs model Seasonal sol_v2';
% clf
% subplot(1,1,1)
% hold on
% for m = 1:length(sol_out_seasonal)
%     
%     plot(1:12, sol_out_seasonal(m,:,1), 'color', cmap(strmatch(cmip_tos_names{m}, color_model(:,1), 'exact'),:), 'linewidth', 2);
%     
% end
% 
% % e1 = errorbar(1:12, obs_sol_monthly(:,1), obs_sol_monthly(:,2), 'linewidth', 3, 'color', 'k');
% e1 = plot(1:12, obs_sol_monthly(:,1), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
% 
% ylabel('mmol m-3 atm-1')
% xlabel('Month')
% legend([cmip_tos_names ; 'Obs'], 'interpreter', 'none')
% title('Seasonal CO2 Solubility')
% print(gcf, '-dpng', [Plot_out_dir 'TS/' plot_filename '.png'])
% 
% 
% model_types = fieldnames(CMIP5_ts.model_groups);
% 
% for q = 1:length(model_types)
%     plot_filename = ['Model Seasonal Solubility v2 ' model_types{q}];
%     
%     clf
%     set(gcf, 'units', 'inches')
%     paper_w = 10; paper_h =8;
%     set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
%     
%     d1 = subplot(1,1,1);
%     hold on
%     
%     model_list = CMIP5_ts.model_groups.(model_types{q});
%     for m = 1: length(model_list)
%         
%         temp_plot = sol_out_seasonal(model_list(m),:,1);
%         plot(d1, -5:6, [temp_plot(1,7:12,1) temp_plot(1,1:6,1)] , 'color', cmap(strmatch(cmip_tos_names{model_list(m)}, color_model(:,1), 'exact'),:), 'linewidth', 2);
%         
%     end
%     
%     %     e1 = errorbar(d1, -5:6, [obs_sol_monthly(7:12,1) ; obs_sol_monthly(1:6,1)], ...
%     %         [obs_sol_monthly(7:12,2) ; obs_sol_monthly(1:6,2)] , ...
%     %         'linewidth', 3, 'color', 'k', 'linestyle', '--');
%     e1 = plot(d1, -5:6, [obs_sol_monthly(7:12,1) ; obs_sol_monthly(1:6,1)], ...
%         ...
%         'linewidth', 3, 'color', 'k', 'linestyle', '--');
%     
%     
%     ylabel(d1, 'mmol m-3 atm-1')
%     set(d1, 'ylim', [4.5 6.5]*10^4)
%     xlabel(d1, 'Month')
%     legend(d1, [cmip_tos_names(model_list) ; 'Obs'], 'interpreter', 'none', 'location', 'northwest')
%     title(['Seasonal Solubility model subset: ' model_types{q}], 'interpreter', 'none')
%     print(gcf, '-dpng', [Plot_out_dir 'TS/' plot_filename '.png'])
%     
%     clear m plot_filename
%     pause
% end
% 
% clear d1 d2 e1 q paper_h paper_w

%% plotting solubility for all model groups

% plot_filename = 'Obs model Sol anomaly by model_groups_v1';
% clf
% set(gcf, 'units', 'inches')
% paper_w = 10; paper_h =4.5;
% set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
% 
% d1 = subplot(1,1,1);
% hold on
% 
% % plot_colors = brewermap(5, 'dark2');
% % plot_colors(5,:) = [.5 .5 .5];
% p = [];
% for q = length(model_types):-1:1
%     
%     model_list = CMIP5_ts.model_groups.(model_types{q});
%     p1 = plot(d1, 1:12, sol_out_seasonal(model_list,:,1)-nanmean(sol_out_seasonal(model_list,:,1),2), 'color', model_group_colors(q,:), 'linewidth', 2);
%     
%     if q==1
%         set(p1, 'linewidth', 3)
%     end
%     p(q) = p1(1);
%     %     plot(1:12, DIC_out_seasonal(m,:,1), 'color', cmap(find(contains(color_model(:,1), cmip_monthly_names{m})),:), 'linewidth', 2);
%     
% end
% 
% e1 = plot(d1, 1:12, obs_sol_monthly(:,1)-nanmean(obs_sol_monthly(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
% 
% ylabel(d1, 'Solubility (mmol m^-^3 atm^-^1)')
% 
% xlabel('Month')
% set(d1, 'fontsize', 20, 'xlim', [.5 12.5])
% set(d1 , 'xtick', [1 3 5 7 9 11])
% set(d1, 'xticklabel',{'Jan.', 'Mar.', 'May', 'July', 'Sept.', 'Nov.'} )
% 
% % legend([p e1], 'Good phase and mag.', 'Good phase, large mag.', 'Out of phase', 'Double Peak', 'Other', 'Obs', 'interpreter', 'none', 'location', 'eastoutside')
% title(d1, 'Solubility')
% 
% print(gcf, '-dpdf', [Plot_out_dir 'TS/' plot_filename '.pdf'])


% %% spCO2 taylor calculations and diagram using Kathy Kelly's tools
% clear taylor
% % I believe this removes mean, but I can test that:
% taylor.correlation = NaN(size(CMIP.spco2.out_seasonal,1),1);
% taylor.ratio = NaN(size(CMIP.spco2.out_seasonal,1),1);
% taylor.norm_error = NaN(size(CMIP.spco2.out_seasonal,1),1);
% 
% for m = 1:length(cmip_names.spco2)
%     [taylor.correlation(m),taylor.ratio(m),taylor.norm_error(m)]=taylor_eval(neur_pCO2_seasonal(:,1),CMIP.spco2.out_seasonal(m,:,1));
% end
% 
% %% plotting taylor diagram for pCO2
% plot_filename = ['Taylor spCO2'];
% 
% clf
% set(gcf, 'units', 'inches')
% paper_w = 14; paper_h =8;
% set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
% 
% taylor_dist_smb(taylor.correlation, taylor.ratio, [], cmip_names.spco2, color_model, cmap);
% 
% print(gcf, '-dpng', [Plot_out_dir 'spCO2/' plot_filename '.png'])
% 
% %% taylor diagram by model group
% 
% plot_filename = ['Taylor spCO2 by model group'];
% 
% clf
% set(gcf, 'units', 'inches')
% paper_w = 14; paper_h =8;
% set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
% 
% for q = 1:length(model_types)
%     model_list = CMIP.spco2.model_groups.(model_types{q});
%     
%     % make a temp colormap that is all one model type's color
%     temp_color_model = model_group_colors(q,:);
%     temp_cmap = repmat(temp_color_model, length(cmap),1);
%     
%     taylor_dist_smb(taylor.correlation(model_list), taylor.ratio(model_list), [], cmip_names.spco2(model_list), color_model, temp_cmap);
%     
% end
% %
% print(gcf, '-dpng', [Plot_out_dir 'spCO2/' plot_filename '.png'])
% 
% %% trying to use the taylordiag plotting function downloaded from mathworks
% taylor2 = NaN(size(CMIP.spco2.out_seasonal,1)+1,4);
% for ii = 1:length(cmip_names.spco2)
%     % Get statistics from time series:
%     C = allstats(neur_pCO2_seasonal(:,1), CMIP.spco2.out_seasonal(ii,:,1));
%     taylor2(ii+1,:) = C(:,2);
% end
% taylor2(1,:) = C(:,1);
% 
% %% Seasonal pCO2 Anomaly by model group
% 
% % plot_colors = brewermap(5, 'dark2');
% 
% for q = 1:length(model_types)
%     
%     plot_filename = ['Obs model Seasonal pCO2 anomaly by model_groups ' model_types{q}];
%     clf
%     set(gcf, 'units', 'inches')
%     paper_w = 15; paper_h =8;
%     set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
%     
%     subplot(1,1,1)
%     hold on
%     
%     p = [];
%     legend_list = [];
%     
%     model_list = CMIP5_mon_spco2.model_groups.(model_types{q});
%     if ~isempty(model_list)
%         for m = 1:length(model_list)
%             p1 = plot(1:12, pco2_out_seasonal(model_list(m),:,1)-nanmean(pco2_out_seasonal(model_list(m),:,1),2), 'color', cmap(strmatch(cmip_spco2_names{model_list(m)}, color_model(:,1), 'exact'),:), 'linewidth', 2);
%             p(m) = p1(1);
%             legend_list = [legend_list ; {cmip_spco2_names{model_list(m)}}];
%         end
%     else
%         p = plot([-1 -1], [0 0], 'color', model_group_colors(q,:), 'linewidth', 2);
%     end
%     
%     % e1 = errorbar(1:12, obs_dic_monthly(:,1), obs_dic_monthly(:,2), 'linewidth', 3, 'color', 'k');
%     e1 = plot(1:12, obs_pco2_monthly(:,1)-nanmean(obs_pco2_monthly(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
%     
%     ylabel('[pCO2] (/muuatm)')
%     xlabel('Month')
%     set(gca, 'fontsize', 15, 'xlim', [.5 12.5])
%     set(gca, 'xtick', [1 3 5 7 9 11], 'xticklabel',{'Jan.', 'Mar.', 'May', 'July', 'Sept.', 'Nov.'} )
%     
%     legend([p' ; e1], [legend_list ; {'Obs'}], 'interpreter', 'none', 'location', 'eastoutside', 'box', 'off', 'fontsize', 10)
%     title('Seasonal pCO2 anomaly')
%     print(gcf, '-dpng', [Plot_out_dir 'spCO2/' plot_filename '.png'])
% end
% 
% clear p e1 m q
% 
% 
% %% INTPP Primary productivity CMIP5
% 
% CMIP5_intpp_dir = [home_dir 'Data/Model_Output/CMIP5/intpp/regrid/'];
% 
% cmip_talk_files = dir([CMIP5_intpp_dir '*.nc']);
% 
% clear CMIP5_mon_intpp
% 
% cmip_intpp_names = cell(length(cmip_talk_files),1);
% %
% time_offset = 0; % differing time stamps is now fixed using cdo commands
% 
% for f=1:length(cmip_talk_files)
%     
%     first_index = strfind(cmip_talk_files(f).name, 'Omon');
%     second_index = strfind(cmip_talk_files(f).name, 'rcp85');
%     mod_name = cmip_talk_files(f).name(first_index+5:second_index-2);
%     disp([mod_name ' started'])
%     
%     mod_name = strrep(mod_name, '-', '_');
%     
%     time_temp = ncread([CMIP5_intpp_dir cmip_talk_files(f).name], 'time');
%     
%     temp_Matlab_time = time_temp + time_offset;
%     
%     if f==1
%         CMIP5_mon_intpp.lon = ncread([CMIP5_intpp_dir cmip_talk_files(f).name], 'lon');
%         CMIP5_mon_intpp.lat = ncread([CMIP5_intpp_dir cmip_talk_files(f).name], 'lat');
%     end
%     
%     CMIP5_mon_intpp.(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time
%     CMIP5_mon_intpp.(mod_name).intpp = ncread([CMIP5_intpp_dir cmip_talk_files(f).name], 'intpp');
%     CMIP5_mon_intpp.(mod_name).units = ncreadatt([CMIP5_intpp_dir cmip_talk_files(f).name], 'intpp', 'units');
%     CMIP5_mon_intpp.(mod_name).long_name = ncreadatt([CMIP5_intpp_dir cmip_talk_files(f).name], 'intpp', 'long_name');
%     
%     cmip_intpp_names{f} = mod_name;
%     
%     clear mod_name time_temp
% end
% 
% clear f cmip_talk_files
% 
% %% INTPP cmip6 loading
% 
% CMIP6_intpp_dir = [home_dir 'Data/Model_Output/CMIP6/intpp/regrid/'];
% 
% cmip_talk_files = dir([CMIP6_intpp_dir '*.nc']);
% 
% cmip6_intpp_names = cell(length(cmip_talk_files),1);
% time_offset = 0; % time and calendar has been set in CDO
% 
% 
% for f=1:length(cmip_talk_files)
%     
%     first_index = strfind(cmip_talk_files(f).name, 'Omon');
%     second_index = strfind(cmip_talk_files(f).name, 'ssp585');
%     mod_name = cmip_talk_files(f).name(first_index+5:second_index-2);
%     
%     disp([mod_name ' started'])
%     
%     mod_name = strrep(mod_name, '-', '_');
%     mod_name = [mod_name '_6'];
%     
%     time_temp = ncread([CMIP6_intpp_dir cmip_talk_files(f).name], 'time');
%     
%     temp_Matlab_time = time_temp + time_offset;
%     
%     CMIP5_mon_intpp.(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time
%     CMIP5_mon_intpp.(mod_name).intpp = ncread([CMIP6_intpp_dir cmip_talk_files(f).name], 'intpp');
%     CMIP5_mon_intpp.(mod_name).units = ncreadatt([CMIP6_intpp_dir cmip_talk_files(f).name], 'intpp', 'units');
%     CMIP5_mon_intpp.(mod_name).long_name = ncreadatt([CMIP6_intpp_dir cmip_talk_files(f).name], 'intpp', 'long_name');
%     
%     cmip6_intpp_names{f} = mod_name;
%     
%     clear mod_name time_temp
% end
% 
% clear f cmip_talk_files
% 
% cmip_intpp_names = [cmip_intpp_names ; cmip6_intpp_names];
% 
% 
% for q = 1:length(model_types)
%     CMIP5_mon_intpp.model_groups.(model_types{q}) = find(contains(cmip_intpp_names, model_group_names.(model_types{q})));
% end
% 
% clear q
% 
% %% loading CBPM NPP
% NPP_dir = [home_dir 'Data/Data_Products/NPP/CbPM/'];
% npp_files = dir([NPP_dir '*.hdf']);
% 
% clear NPP_obs
% 
% m = 1080;
% n = 2160;
% 
% lat_step = (90--90)/(m-1);
% lon_step = (180--180)/(n-1);
% 
% npp_lat = 90:-lat_step:-90;
% npp_lon = -180:lon_step:180;
% 
% [X, Y] = meshgrid(npp_lon, npp_lat);
% 
% NPP_obs.Matlab_date = NaN(length(npp_files),1);
% NPP_obs.lat = npp_lat;
% NPP_obs.lon = npp_lon;
% NPP_obs.lat_grid = Y;
% NPP_obs.lon_grid = X;
% 
% 
% NPP_obs.cbpm = NaN(m,n,length(npp_files));
% 
% for q = 1:length(npp_files)
%     
%     BB = npp_files(q).name(6:12);
%     NPP_obs.Matlab_date(q) = datenum(BB(1:4), 'YYYY')-1 + str2double(BB(5:7)) + 15;
%     
%     month_npp = hdfread([NPP_dir npp_files(q).name], '/npp', 'Index', {[1  1],[1  1],[m  n]}); % mgC m-2 d-1
%     month_npp = double(month_npp);
%     month_npp(month_npp<-50)=nan;
%     
%     NPP_obs.cbpm(:,:,q) = month_npp;
%     clear month_npp BB
% end
% 
% %% saving observation monthly means and std
% 
% NPP_obs_out_seasonal = NaN(1,12,2);
% 
% % for m = 1:size(NPP_obs_out_seasonal,1)
% 
% for mon = 1:12
%     mod_vec = datevec(NPP_obs.Matlab_date);
%     time_index = mod_vec(:,2)==mon;
%     
%     lat_index = NPP_obs.lat<=lat_lims(2) & NPP_obs.lat>=lat_lims(1);
%     
%     SO_pp = NPP_obs.cbpm(lat_index, :, time_index);
%     
%     NPP_obs_out_seasonal(1,mon,1) = nanmean(reshape(SO_pp,[],1));
%     NPP_obs_out_seasonal(1,mon,2) = nanstd(reshape(SO_pp,[],1));
%     
%     clear mod_vec time_index lat_index SO_pp
% end
% 
% % end
% 
% 
% %% plotting mean cbpm npp
% 
% plot_filename = ['CBPM mean NPP'];
% 
% % Southern Ocean surface intpp plot . time_range = 2010 to 2020
% npp_scale_factor = 1/1000/12/24/60/60;
% clf
% set(gcf, 'units', 'inches')
% paper_w = 16; paper_h =9;
% set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
% 
% % mod_vec = datevec(CMIP5_mon_intpp.(cmip_intpp_names{m}).GMT_Matlab);
% %     time_index = mod_vec(:,1)>=2010 & mod_vec(:,1)<2020;
% 
% SO_lat_index = NPP_obs.lat'<=-35;
% SO_NPP = NPP_obs.cbpm(SO_lat_index, :, :);
% 
% SO_mean_NPP = nanmean(SO_NPP,3);
% 
% pcolor(NPP_obs.lon_grid(SO_lat_index,:), NPP_obs.lat_grid(SO_lat_index,:), SO_mean_NPP(:,:).*npp_scale_factor); shading flat
% xlabel('Longitude')
% ylabel('Latitude')
% c1 = colorbar;
% ylabel(c1, 'NPP mol m^-^2 s^-^1')
% title(['CBPM NPP'], 'interpreter', 'none')
% caxis([0 10e-7])
% set(gca, 'ylim', [-85 -35])
% 
% saveas(gcf, [Plot_out_dir 'Surface_Depth/' plot_filename '_v1'], 'png')
% 
% clear SO_intpp SO_mean_intpp SO_lat_index time_index
% %     pause

%% putting flux into Pg C / mon
% 
% s_per_year = 3600*24*365;
% Pg_per_kg = 1e-12;
% 
% scale_factor = -1.*s_per_year.*Pg_per_kg./12;  % kg m2 s-1 into the ocean to Pg C m-2 mon out of the ocean
% 
% 
% for m=1:length(cmip_fgco2_names)
%     
%     CMIP5_mon_fgco2.(cmip_fgco2_names{m}).Pg_mon.fgco2 = CMIP5_mon_fgco2.(cmip_fgco2_names{m}).fgco2.*scale_factor.*Neur_input.area_neur'; %out of the ocean from kg m-2 s-1 into the ocean
%     
% end
% 
% clear s_per_year Pg_per_kg scale_factor m
% %% plotting surface fluxes to check land and nan values
% [lon_grid, lat_grid] = meshgrid(CMIP5_mon_fgco2.lon, CMIP5_mon_fgco2.lat);
% 
% CMIP5_mon_fgco2.lon_grid = lon_grid';
% CMIP5_mon_fgco2.lat_grid = lat_grid';
% clear lon_grid lat_grid
% 
% Plot_out_dir = [home_dir 'Work/Projects/2019_05 SO_C_flux_model_comparison/Plots/'];
% 
% for m = 1:length(cmip_fgco2_names)
%     % Southern Ocean surface DIC plot . time_range = 2010 to 2020
%     
%     clf
%     set(gcf, 'units', 'inches')
%     paper_w = 16; paper_h =9;
%     set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
%     
%     mod_vec = datevec(CMIP5_mon_fgco2.(cmip_fgco2_names{m}).GMT_Matlab);
%     time_index = mod_vec(:,1)>=2010 & mod_vec(:,1)<2020;
%     
%     SO_lat_index = CMIP5_mon_fgco2.lat<=-35;
%     
%     SO_FGCO2 = CMIP5_mon_fgco2.(cmip_fgco2_names{m}).Pg_mon.fgco2(:, SO_lat_index, time_index);
%     
%     SO_mean_FGCO2 = nanmean(SO_FGCO2,3);
%     
%     pcolor(CMIP5_mon_fgco2.lon_grid(:,SO_lat_index), CMIP5_mon_fgco2.lat_grid(:,SO_lat_index), SO_mean_FGCO2(:,:)); shading flat
%     xlabel('Longitude')
%     ylabel('Latitude')
%     c1 = colorbar;
%     ylabel(c1, 'FGCO2')
%     title([(cmip_fgco2_names{m}) ' Surface FGCO2'], 'interpreter', 'none')
%     caxis([-5e-5 5e-5])
%     set(gca, 'ylim', [-85 -35])
%     
%     plot_filename = ['FGCO2_Surface_' cmip_fgco2_names{m}];
%     saveas(gcf, [Plot_out_dir 'fgco2/' plot_filename '_v7'], 'png')
%     
% end
% 
% clear m


% %% saving fgco2 monthly means and std
% 
% fgco2_out_seasonal = NaN(length(cmip_fgco2_names),12,2);
% fgco2_out_annual = NaN(length(cmip_fgco2_names),2);
% for m = 1:length(cmip_fgco2_names)
%     mod_vec = datevec(CMIP5_mon_fgco2.(cmip_fgco2_names{m}).GMT_Matlab);
%     
%     for mon = 1:12
%         time_index = mod_vec(:,2)==mon;
%         
%         lat_index = CMIP5_mon_fgco2.lat<=lat_lims(2) & CMIP5_mon_fgco2.lat>=lat_lims(1);
%         
%         SO_fgco2 = CMIP5_mon_fgco2.(cmip_fgco2_names{m}).Pg_mon.fgco2(:, lat_index, time_index);
%         
%         % collapse all years into one mean map for each month
%         SO_fgco2_mean = nanmean(SO_fgco2,3);
%         
%         % sum all grid cells to convert to
%         fgco2_out_seasonal(m,mon,1) = nansum(reshape(SO_fgco2_mean,[],1)).*1000; % Pg to Tg
%         %         fgco2_out_seasonal(m,mon,2) = nanstd(reshape(SO_fgco2,[],1));
%         clear time_index lat_index SO_fgco2  SO_fgco2_mean
%     end
%     
%     SO_fgco2 = CMIP5_mon_fgco2.(cmip_fgco2_names{m}).Pg_mon.fgco2(:, CMIP5_mon_fgco2.lat<=-35, :);
%     
%     num_mod_years = length(CMIP5_mon_fgco2.(cmip_fgco2_names{m}).GMT_Matlab)/12;
%     temp_out = NaN(num_mod_years,1);
%     
%     for n = 1:num_mod_years
%         temp_out(n) = nansum(reshape(SO_fgco2(:,:,(n-1)*12+1:(n-1)*12+12),[],1));
%     end
%     fgco2_out_annual(m,1) = nanmean(temp_out);
%     fgco2_out_annual(m,2) = nanstd(temp_out);
%     
%     clear mod_vec
% end
% clear m mon

% %% finding the neural network matching flux
% 
% lat_index = Neur_input.lat<=lat_lims(2) & Neur_input.lat>=lat_lims(1);
% neur_out_seasonal = NaN(1,12,2);
% mod_vec = datevec(Neur_input.time_Matlab);
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
%     neur_out_seasonal(1,mon,1) = nanmean(box_sum)*1000; % Pg to Tg
%     neur_out_seasonal(1,mon,2) = nanstd(box_sum)*1000;
%     
%     clear SO_fgco2 zonal_sum box_sum
% end
% 
% clear lat_index mod_vec time_index

%% plotting seasonal observations DIC cycle

plot_filename = 'Data_surface_cycle';
clf
set(gcf, 'units', 'inches')
paper_w = 10; paper_h =8;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

argo_vec = datevec(argo_SO.surf.GMT_Matlab);
argo_vec(:,1) = 2016;
argo_date_single_year = datenum(argo_vec);
p1 = plot(argo_date_single_year, argo_SO.surf.DIC_LIAR, 'xb');

hold on

gdap_vec = datevec(gdap_SO.surf.GMT_Matlab);
gdap_vec(:,1) = 2016;
gdap_date_single_year = datenum(gdap_vec);
p2 = plot(gdap_date_single_year, gdap_SO.surf.G2tco2, 'or');

ylabel('[DIC]')
datetick('x', 'mmm')
title(['Surface Data, lat. limits: ' num2str(lat_lims)])

% Mean observational seasonal cycle

obs_dic_monthly = NaN(12,2);

for m=1:12
    
    argo_index = argo_vec(:,2)==m;
    gdap_index = gdap_vec(:,2)==m;
    
    obs_dic_monthly(m,1) = nanmean([argo_SO.surf.DIC_LIAR(argo_index) ; gdap_SO.surf.G2tco2(gdap_index)]);
    obs_dic_monthly(m,2) = nanstd([argo_SO.surf.DIC_LIAR(argo_index) ; gdap_SO.surf.G2tco2(gdap_index)]);
end

e1 = errorbar(datenum(2016,1:12,15), obs_dic_monthly(:,1), obs_dic_monthly(:,2), 'linewidth', 2, 'color', 'k');

legend([p1 p2 e1], 'SOCCOM', 'GLODAP', 'Combined mean +/- 1 sd', 'location', 'southeast')
print(gcf, '-dpng', [Plot_out_dir plot_filename '.png'])

clear m e1 p2 p1 argo_vec argo_date_single_year gdap_vec gdap_date_single_year

%% plotting seasonal observations TALK cycle

plot_filename = 'Data_TALK_surface_cycle';
clf
set(gcf, 'units', 'inches')
paper_w = 10; paper_h =8;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

argo_vec = datevec(argo_SO.surf.GMT_Matlab);
argo_vec(:,1) = 2016;
argo_date_single_year = datenum(argo_vec);
p1 = plot(argo_date_single_year, argo_SO.surf.TALK_LIAR, 'xb');

hold on

gdap_vec = datevec(gdap_SO.surf.GMT_Matlab);
gdap_vec(:,1) = 2016;
gdap_date_single_year = datenum(gdap_vec);
p2 = plot(gdap_date_single_year, gdap_SO.surf.G2talk, 'or');

ylabel('[TALK]')
datetick('x', 'mmm')
title(['Surface Data, lat. limits: ' num2str(lat_lims)])

% Mean observational seasonal cycle

obs_talk_monthly = NaN(12,2);

for m=1:12
    
    argo_index = argo_vec(:,2)==m;
    gdap_index = gdap_vec(:,2)==m;
    
    obs_talk_monthly(m,1) = nanmean([argo_SO.surf.TALK_LIAR(argo_index) ; gdap_SO.surf.G2talk(gdap_index)]);
    obs_talk_monthly(m,2) = nanstd([argo_SO.surf.TALK_LIAR(argo_index) ; gdap_SO.surf.G2talk(gdap_index)]);
end

e1 = errorbar(datenum(2016,1:12,15), obs_talk_monthly(:,1), obs_talk_monthly(:,2), 'linewidth', 2, 'color', 'k');

legend([p1 p2 e1], 'SOCCOM', 'GLODAP', 'Combined mean +/- 1 sd', 'location', 'southeast')
print(gcf, '-dpng', [Plot_out_dir plot_filename '.png'])

clear m e1 p2 p1 argo_vec argo_date_single_year gdap_vec gdap_date_single_year
%% DIC monthly CMIP5 LOAD
CMIP5_DIC_dir = [home_dir 'Data/Model_Output/CMIP5/DIC/monthly/regrid/'];

cmip_files = dir([CMIP5_DIC_dir '*.nc']);

clear CMIP5_monthly

cmip_monthly_names = cell(length(cmip_files),1);
time_offset = 0; % differing time stamps is now fixed using cdo commands

for f=1:length(cmip_files)
    first_index = strfind(cmip_files(f).name, 'Omon');
    second_index = strfind(cmip_files(f).name, 'rcp85');
    mod_name = cmip_files(f).name(first_index+5:second_index-2);
    disp([mod_name ' started'])
    
    mod_name = strrep(mod_name, '-', '_');
    
    time_temp = ncread([CMIP5_DIC_dir cmip_files(f).name], 'time');
    
    temp_Matlab_time = time_temp + time_offset;
    %     mod_vec = datevec(temp_Matlab_time);
    %     disp(mod_vec(1:12,:))
    %
    
    if f==1
        CMIP5_monthly.lon = ncread([CMIP5_DIC_dir cmip_files(f).name], 'lon');
        CMIP5_monthly.lat = ncread([CMIP5_DIC_dir cmip_files(f).name], 'lat');
    end
    
    CMIP5_monthly.(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time
    CMIP5_monthly.(mod_name).DIC = ncread([CMIP5_DIC_dir cmip_files(f).name], 'dissic');
    CMIP5_monthly.(mod_name).units = ncreadatt([CMIP5_DIC_dir cmip_files(f).name], 'dissic', 'units');
    CMIP5_monthly.(mod_name).long_name = ncreadatt([CMIP5_DIC_dir cmip_files(f).name], 'dissic', 'long_name');
    
    cmip_monthly_names{f} = mod_name;
    
    if contains(mod_name, 'MRI') || contains(mod_name, 'CNRM')
        CMIP5_monthly.(mod_name).DIC(CMIP5_monthly.(mod_name).DIC<1)=nan;
    end
    
    clear mod_name time_temp
end

clear f cmip_files

%% DIC monthly CMIP6 LOAD

CMIP6_DIC_dir = [home_dir 'Data/Model_Output/CMIP6/DIC/monthly/regrid/'];

cmip_files = dir([CMIP6_DIC_dir '*.nc']);

cmip6_dic_names = cell(length(cmip_files),1);
time_offset = 0; % time and calendar has been set in CDO


for f=1:length(cmip_files)
    
    first_index = strfind(cmip_files(f).name, 'Omon');
    second_index = strfind(cmip_files(f).name, 'ssp585');
    mod_name = cmip_files(f).name(first_index+5:second_index-2);
    
    disp([mod_name ' started'])
    
    mod_name = strrep(mod_name, '-', '_');
    mod_name = [mod_name '_6'];
    
    time_temp = ncread([CMIP6_DIC_dir cmip_files(f).name], 'time');
    
    temp_Matlab_time = time_temp + time_offset;
    
    CMIP5_monthly.(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time
    CMIP5_monthly.(mod_name).DIC = ncread([CMIP6_DIC_dir cmip_files(f).name], 'dissic');
    CMIP5_monthly.(mod_name).units = ncreadatt([CMIP6_DIC_dir cmip_files(f).name], 'dissic', 'units');
    CMIP5_monthly.(mod_name).long_name = ncreadatt([CMIP6_DIC_dir cmip_files(f).name], 'dissic', 'long_name');
    
    cmip6_dic_names{f} = mod_name;
    
    clear mod_name time_temp
end

clear f cmip_files

cmip_monthly_names = [cmip_monthly_names ; cmip6_dic_names];
%% looking at data
m=16;

plot_index = 0;
for mon = 1:round(length(CMIP5_monthly.(cmip_monthly_names{m}).GMT_Matlab)/6):length(CMIP5_monthly.(cmip_monthly_names{m}).GMT_Matlab)
    plot_index = plot_index+1;
    subplot(3,2,plot_index)
    
    pcolor(CMIP5_monthly.(cmip_monthly_names{m}).DIC(:,CMIP5_monthly.lat<-35, mon)'.*1025); shading flat; colorbar; caxis([2000 2250])
end
%% saving monthly DIC means and std

DIC_out_seasonal = NaN(length(cmip_monthly_names),12,2);

for m = 1:length(cmip_monthly_names)
    
    for mon = 1:12
        mod_vec = datevec(CMIP5_monthly.(cmip_monthly_names{m}).GMT_Matlab);
        time_index = mod_vec(:,2)==mon;
        
        lat_index = CMIP5_monthly.lat<=lat_lims(2) & CMIP5_monthly.lat>=lat_lims(1);
        
        SO_DIC = CMIP5_monthly.(cmip_monthly_names{m}).DIC(:, lat_index, time_index);
        
        DIC_out_seasonal(m,mon,1) = nanmean(reshape(SO_DIC,[],1)).*10^3;
        DIC_out_seasonal(m,mon,2) = nanstd(reshape(SO_DIC,[],1)).*10^3;
        
        clear mod_vec time_index lat_index SO_DIC
    end
    
end
clear m mon
%% % plotting seasonal DIC cycle
plot_filename = 'Obs model Seasonal DIC_v2';
clf
subplot(1,1,1)
hold on
for m = 1:length(cmip_monthly_names)
    
    plot(1:12, DIC_out_seasonal(m,:,1), 'color', cmap(find(contains(color_model(:,1), cmip_monthly_names{m})),:), 'linewidth', 2);
    
end

e1 = errorbar(1:12, obs_dic_monthly(:,1), obs_dic_monthly(:,2), 'linewidth', 3, 'color', 'k');

ylabel('[DIC] (umol / l)')
xlabel('Month')
legend([cmip_monthly_names ; 'Obs'], 'interpreter', 'none', 'location', 'eastoutside')
title('Seasonal DIC')
print(gcf, '-dpng', [Plot_out_dir 'DIC/' plot_filename '.png'])

clear m

for q = 1:length(model_types)
    CMIP5_monthly.model_groups.(model_types{q}) = find(contains(cmip_monthly_names, model_group_names.(model_types{q})));
end

clear q
%% Seasonal DIC by model group
plot_filename = 'Obs model Seasonal anomaly DIC by model_groups_v1';
clf
set(gcf, 'units', 'inches')
paper_w = 10; paper_h =7;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

subplot(1,1,1)
hold on

% model_group_colors = brewermap(5, 'dark2');

p = [];
for q = length(model_types):-1:1
    
    model_list = CMIP5_monthly.model_groups.(model_types{q});
    p1 = plot(1:12, DIC_out_seasonal(model_list,:,1)-nanmean(DIC_out_seasonal(model_list,:,1),2), 'color', model_group_colors(q,:), 'linewidth', 2);
    p(q) = p1(1);
    %     plot(1:12, DIC_out_seasonal(m,:,1), 'color', cmap(find(contains(color_model(:,1), cmip_monthly_names{m})),:), 'linewidth', 2);
    
end

e1 = plot(1:12, obs_dic_monthly(:,1)-nanmean(obs_dic_monthly(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '--');

ylabel('[DIC] (\mumol / l)')
xlabel('Month')
set(gca, 'fontsize', 20, 'xlim', [.5 12.5])
set(gca, 'xtick', [1 3 5 7 9 11], 'xticklabel',{'Jan.', 'Mar.', 'May', 'July', 'Sept.', 'Nov.'} )

% legend([p e1], 'Good phase and mag.', 'Good phase, large mag.', 'Out of phase', 'Double Peak', 'Other', 'Obs', 'interpreter', 'none', 'location', 'eastoutside')
title('Seasonal DIC')
print(gcf, '-dpdf', [Plot_out_dir 'DIC/' plot_filename '.pdf'])

%%
for q = 1:length(model_types)
    plot_filename = ['Obs model Seasonal DIC_v2' model_types{q}];
    
    clf
    set(gcf, 'units', 'inches')
    paper_w = 10; paper_h =8;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    
    subplot(1,1,1)
    hold on
    
    model_list = CMIP5_monthly.model_groups.(model_types{q});
    for m = 1: length(model_list)
        
        plot(1:12, DIC_out_seasonal(model_list(m),:,1), 'color', cmap(strmatch(cmip_monthly_names{model_list(m)}, color_model(:,1), 'exact'),:), 'linewidth', 2);
        
    end
    
    e1 = errorbar(1:12, obs_dic_monthly(:,1), obs_dic_monthly(:,2), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
    
    ylabel('[DIC] (umol / l)')
    xlabel('Month')
    legend([cmip_monthly_names(model_list) ; 'Obs'], 'interpreter', 'none', 'location', 'eastoutside')
    title(['Seasonal DIC model subset: ' model_types{q}], 'interpreter', 'none')
    print(gcf, '-dpng', [Plot_out_dir plot_filename '.png'])
    
    clear m plot_filename
    pause
end


%% plotting seasonal DIC anomaly

plot_filename = 'Obs model Seasonal DIC anomaly';
clf
subplot(1,1,1)
hold on
for m = 1:length(cmip_monthly_names)
    
    seasonal_anomaly = DIC_out_seasonal(m,:,1) - nanmean(DIC_out_seasonal(m,:,1));
    
    plot(1:12, seasonal_anomaly, 'color', cmap(find(contains(color_model(:,1), cmip_monthly_names{m})),:), 'linewidth', 2);
    clear seasonal_anomaly
    
end

seasonal_anomaly = obs_dic_monthly(:,1) - nanmean(obs_dic_monthly(:,1));

% e1 = errorbar(1:12, seasonal_anomaly, obs_dic_monthly(:,2), 'linewidth', 3, 'color', 'k');
plot(1:12, seasonal_anomaly,'linewidth', 3, 'color', 'k', 'linestyle', '--');

ylabel('[DIC] (umol / l)')
xlabel('Month')
legend([cmip_monthly_names ; 'Obs'], 'interpreter', 'none')

title('DIC Anomaly')

print(gcf, '-dpng', [Plot_out_dir plot_filename 'no_ebars.png'])

clear m seasonal_anomaly

%% TALK Monthly CMIP5 LOAD

CMIP5_TALK_dir = [home_dir 'Data/Model_Output/CMIP5/talk/monthly/regrid/'];

cmip_talk_files = dir([CMIP5_TALK_dir '*.nc']);

clear CMIP5_mon_talk

cmip_talk_mon_names = cell(length(cmip_talk_files),1);
time_offset = 0; % differing time stamps is now fixed using cdo commands

for f=1:length(cmip_talk_files)
    first_index = strfind(cmip_talk_files(f).name, 'Omon');
    second_index = strfind(cmip_talk_files(f).name, 'rcp85');
    mod_name = cmip_talk_files(f).name(first_index+5:second_index-2);
    disp([mod_name ' started'])
    
    mod_name = strrep(mod_name, '-', '_');
    
    time_temp = ncread([CMIP5_TALK_dir cmip_talk_files(f).name], 'time');
    
    temp_Matlab_time = time_temp + time_offset;
    
    if f==1
        CMIP5_mon_talk.lon = ncread([CMIP5_TALK_dir cmip_talk_files(f).name], 'lon');
        CMIP5_mon_talk.lat = ncread([CMIP5_TALK_dir cmip_talk_files(f).name], 'lat');
    end
    
    CMIP5_mon_talk.(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time
    CMIP5_mon_talk.(mod_name).talk = ncread([CMIP5_TALK_dir cmip_talk_files(f).name], 'talk');
    CMIP5_mon_talk.(mod_name).units = ncreadatt([CMIP5_TALK_dir cmip_talk_files(f).name], 'talk', 'units');
    CMIP5_mon_talk.(mod_name).long_name = ncreadatt([CMIP5_TALK_dir cmip_talk_files(f).name], 'talk', 'long_name');
    
    cmip_talk_mon_names{f} = mod_name;
    
    if contains(mod_name, 'CNRM_CM5') || contains(mod_name, 'MRI_ESM1')
        CMIP5_mon_talk.(mod_name).talk(CMIP5_mon_talk.(mod_name).talk==0)=nan;
    end
    
    clear mod_name time_temp
end

clear f cmip_talk_files

%% TALK Monthly CMIP6 LOAD
CMIP6_TALK_dir = [home_dir 'Data/Model_Output/CMIP6/talk/monthly/regrid/'];

cmip_talk_files = dir([CMIP6_TALK_dir '*.nc']);

cmip6_talk_names = cell(length(cmip_talk_files),1);
time_offset = 0; % time and calendar has been set in CDO


for f=1:length(cmip_talk_files)
    
    first_index = strfind(cmip_talk_files(f).name, 'Omon');
    second_index = strfind(cmip_talk_files(f).name, 'ssp585');
    mod_name = cmip_talk_files(f).name(first_index+5:second_index-2);
    
    disp([mod_name ' started'])
    
    mod_name = strrep(mod_name, '-', '_');
    mod_name = [mod_name '_6'];
    
    time_temp = ncread([CMIP6_TALK_dir cmip_talk_files(f).name], 'time');
    
    temp_Matlab_time = time_temp + time_offset;
    
    CMIP5_mon_talk.(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time
    CMIP5_mon_talk.(mod_name).talk = ncread([CMIP6_TALK_dir cmip_talk_files(f).name], 'talk');
    CMIP5_mon_talk.(mod_name).units = ncreadatt([CMIP6_TALK_dir cmip_talk_files(f).name], 'talk', 'units');
    CMIP5_mon_talk.(mod_name).long_name = ncreadatt([CMIP6_TALK_dir cmip_talk_files(f).name], 'talk', 'long_name');
    
    cmip6_talk_names{f} = mod_name;
    
    clear mod_name time_temp
end

clear f cmip_talk_files

cmip_talk_mon_names = [cmip_talk_mon_names ; cmip6_talk_names];

for q = 1:length(model_types)
    CMIP5_mon_talk.model_groups.(model_types{q}) = find(contains(cmip_talk_mon_names, model_group_names.(model_types{q})));
end

clear q cmip6_talk_names

%% looking at data
m=4;

plot_index = 0;
for mon = 1:round(length(CMIP5_mon_talk.(cmip_talk_mon_names{m}).GMT_Matlab)/6):length(CMIP5_mon_talk.(cmip_talk_mon_names{m}).GMT_Matlab)
    plot_index = plot_index+1;
    subplot(3,2,plot_index)
    
    pcolor(CMIP5_mon_talk.(cmip_talk_mon_names{m}).talk(:,CMIP5_mon_talk.lat<-35, mon)'.*1025); shading flat; colorbar; caxis([2300 2450])
end
%% plotting surface TALK to check land and nan values
[lon_grid, lat_grid] = meshgrid(CMIP5_mon_talk.lon, CMIP5_mon_talk.lat);

CMIP5_mon_talk.lon_grid = lon_grid';
CMIP5_mon_talk.lat_grid = lat_grid';
clear lon_grid lat_grid

for m = 1:length(cmip_talk_mon_names)
    % Southern Ocean surface DIC plot . time_range = 2010 to 2020
    
    clf
    set(gcf, 'units', 'inches')
    paper_w = 16; paper_h =9;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    
    mod_vec = datevec(CMIP5_mon_talk.(cmip_talk_mon_names{m}).GMT_Matlab);
    time_index = mod_vec(:,1)>=2010 & mod_vec(:,1)<2020;
    
    SO_lat_index = CMIP5_mon_talk.lat<=-35;
    
    SO_TALK = CMIP5_mon_talk.(cmip_talk_mon_names{m}).talk(:, SO_lat_index, time_index);
    
    SO_mean_TALK = nanmean(SO_TALK,3);
    
    pcolor(CMIP5_mon_talk.lon_grid(:,SO_lat_index), CMIP5_mon_talk.lat_grid(:,SO_lat_index), SO_mean_TALK(:,:)); shading flat
    xlabel('Longitude')
    ylabel('Latitude')
    c1 = colorbar;
    ylabel(c1, 'TALK (mol m-3)')
    title([(cmip_talk_mon_names{m}) ' Surface TALK'], 'interpreter', 'none')
    caxis([2.2 2.5])
    set(gca, 'ylim', [-85 -35])
    
    plot_filename = ['TALK_Surface_' cmip_talk_mon_names{m}];
    saveas(gcf, [Plot_out_dir 'TALK/' plot_filename ''], 'png')
    
    clear SO_TALK SO_mean_TALK mod_vec time_index SO_lat_index c1
end

clear m

%% saving monthly TALK means and std

TALK_out_seasonal = NaN(length(cmip_talk_mon_names),12,2);

for m = 1:length(cmip_talk_mon_names)
    
    for mon = 1:12
        mod_vec = datevec(CMIP5_mon_talk.(cmip_talk_mon_names{m}).GMT_Matlab);
        time_index = mod_vec(:,2)==mon;
        
        lat_index = CMIP5_mon_talk.lat<=lat_lims(2) & CMIP5_mon_talk.lat>=lat_lims(1);
        
        SO_talk = CMIP5_mon_talk.(cmip_talk_mon_names{m}).talk(:, lat_index, time_index);
        
        TALK_out_seasonal(m,mon,1) = nanmean(reshape(SO_talk,[],1)).*10^3;
        TALK_out_seasonal(m,mon,2) = nanstd(reshape(SO_talk,[],1)).*10^3;
        
        clear mod_vec time_index lat_index SO_DIC
    end
    
end
clear m mon
%% saving monthly DIC - TALK means and std

DIC_TALK_out_seasonal = NaN(length(cmip_talk_mon_names),12,2);

cmip_dic_talk_mon_names = [];

for m = 1:length(cmip_talk_mon_names)
    
    dic_index = find(contains(cmip_monthly_names, cmip_talk_mon_names{m}));
    
    if isempty(dic_index)
        continue
    end
    disp(cmip_talk_mon_names{m})
    disp(cmip_monthly_names{dic_index})
    disp(' ')
    cmip_dic_talk_mon_names = [cmip_dic_talk_mon_names ; {cmip_talk_mon_names{m}}];
    
    for mon = 1:12
        
        mod_vec = datevec(CMIP5_mon_talk.(cmip_talk_mon_names{m}).GMT_Matlab);
        time_index = mod_vec(:,2)==mon;
        
        lat_index = CMIP5_mon_talk.lat<=lat_lims(2) & CMIP5_mon_talk.lat>=lat_lims(1);
        
        SO_dic_talk = CMIP5_monthly.(cmip_talk_mon_names{m}).DIC(:, lat_index, time_index) - CMIP5_mon_talk.(cmip_talk_mon_names{m}).talk(:, lat_index, time_index);
        
        DIC_TALK_out_seasonal(m,mon,1) = nanmean(reshape(SO_dic_talk,[],1)).*10^3;
        DIC_TALK_out_seasonal(m,mon,2) = nanstd(reshape(SO_dic_talk,[],1)).*10^3;
        
        clear mod_vec time_index lat_index SO_DIC
    end
    
    
end
clear m mon

%% plotting seasonal TALK cycle
plot_filename = 'Obs model Seasonal TALK';
clf
subplot(1,1,1)
hold on
for m = 1:length(cmip_talk_mon_names)
    
    plot(1:12, TALK_out_seasonal(m,:,1), 'color', cmap(find(contains(color_model(:,1), cmip_talk_mon_names{m})),:), 'linewidth', 2);
    
end

e1 = errorbar(1:12, obs_talk_monthly(:,1), obs_talk_monthly(:,2), 'linewidth', 3, 'color', 'k');

ylabel('[TALK] (ueq / l)')
xlabel('Month')
legend([cmip_talk_mon_names ; 'Obs'], 'interpreter', 'none', 'location', 'eastoutside', 'box', 'off')
title('Seasonal TALK')
print(gcf, '-dpng', [Plot_out_dir 'TALK/' plot_filename '.png'])

plot_filename = 'Obs model Seasonal TALK anomaly';
clf
set(gcf, 'units', 'inches')
paper_w = 15; paper_h =8;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

subplot(1,1,1)
hold on
for m = 1:length(cmip_talk_mon_names)
    
    plot(1:12, TALK_out_seasonal(m,:,1)-nanmean(TALK_out_seasonal(m,:,1)), 'color', cmap(find(contains(color_model(:,1), cmip_talk_mon_names{m})),:), 'linewidth', 2);
    
end

% e1 = errorbar(1:12, obs_talk_monthly(:,1)-nanmean(obs_talk_monthly(:,1)), obs_talk_monthly(:,2), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
e1 = plot(1:12, obs_talk_monthly(:,1)-nanmean(obs_talk_monthly(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '--');

ylabel('[TALK] (ueq / l)')
xlabel('Month')
set(gca, 'fontsize', 15, 'xlim', [.5 12.5])

l1 =legend([cmip_talk_mon_names ; 'Obs'], 'interpreter', 'none', 'location', 'eastoutside', 'box', 'off');
title('Seasonal TALK anomaly')
print(gcf, '-dpng', [Plot_out_dir 'TALK/' plot_filename '.png'])

clear e1 l1 m

%% Seasonal TALK anomaly by model group (single plot)
plot_filename = 'Obs model Seasonal anomaly TALK by model_groups_v1';
clf
set(gcf, 'units', 'inches')
paper_w = 10; paper_h =7;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

subplot(1,1,1)
hold on

% model_group_colors = brewermap(5, 'dark2');

p = [];
for q = length(model_types)-1:-1:1
    
    model_list = CMIP5_mon_talk.model_groups.(model_types{q});
    p1 = plot(1:12, TALK_out_seasonal(model_list,:,1)-nanmean(TALK_out_seasonal(model_list,:,1),2), 'color', model_group_colors(q,:), 'linewidth', 2);
    p(q) = p1(1);
    %     plot(1:12, DIC_out_seasonal(m,:,1), 'color', cmap(find(contains(color_model(:,1), cmip_monthly_names{m})),:), 'linewidth', 2);
    
end

e1 = plot(1:12, obs_talk_monthly(:,1)-nanmean(obs_talk_monthly(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '--');

ylabel('[TALK] (\mumol / l)')
xlabel('Month')
set(gca, 'fontsize', 20, 'xlim', [.5 12.5])
set(gca, 'xtick', [1 3 5 7 9 11], 'xticklabel',{'Jan.', 'Mar.', 'May', 'July', 'Sept.', 'Nov.'} )

% legend([p e1], 'Good phase and mag.', 'Good phase, large mag.', 'Out of phase', 'Double Peak', 'Other', 'Obs', 'interpreter', 'none', 'location', 'eastoutside')
title('Seasonal TALK')
print(gcf, '-dpdf', [Plot_out_dir 'TALK/' plot_filename '.pdf'])
%% Seasonal TALK Anomaly by model group

% plot_colors = brewermap(5, 'dark2');

for q = 1:length(model_types)
    
    plot_filename = ['Obs model Seasonal Talk anomaly by model_groups ' model_types{q}];
    clf
    set(gcf, 'units', 'inches')
    paper_w = 15; paper_h =8;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    
    subplot(1,1,1)
    hold on
    
    p = [];
    legend_list = [];
    
    model_list = CMIP5_mon_talk.model_groups.(model_types{q});
    if ~isempty(model_list)
        for m = 1:length(model_list)
            p1 = plot(1:12, TALK_out_seasonal(model_list(m),:,1)-nanmean(TALK_out_seasonal(model_list(m),:,1),2), 'color', cmap(find(contains(color_model(:,1), cmip_talk_mon_names{model_list(m)})),:), 'linewidth', 2);
            p(m) = p1(1);
            legend_list = [legend_list ; {cmip_talk_mon_names{model_list(m)}}];
        end
    else
        p = plot([-1 -1], [0 0], 'color', model_group_colors(q,:), 'linewidth', 2);
    end
    
    % e1 = errorbar(1:12, obs_dic_monthly(:,1), obs_dic_monthly(:,2), 'linewidth', 3, 'color', 'k');
    e1 = plot(1:12, obs_talk_monthly(:,1)-nanmean(obs_talk_monthly(:,1)), 'linewidth', 3, 'color', 'k', 'linestyle', '--');
    
    ylabel('[TALK] (ueq / l)')
    xlabel('Month')
    set(gca, 'fontsize', 15, 'xlim', [.5 12.5])
    set(gca, 'xtick', [1 3 5 7 9 11], 'xticklabel',{'Jan.', 'Mar.', 'May', 'July', 'Sept.', 'Nov.'} )
    
    legend([p' ; e1], [legend_list ; {'Obs'}], 'interpreter', 'none', 'location', 'eastoutside', 'box', 'off', 'fontsize', 10)
    title('Seasonal TALK anomaly')
    print(gcf, '-dpng', [Plot_out_dir 'TALK/' plot_filename '.png'])
end

clear p e1 m q


%% Calculating mean model values and gradient

DIC_out_array_names = cell(length(cmip_names),1);
DIC_out_array_names(:,1) = cmip_names;

DIC_out_array = NaN(length(cmip_names),3);
for m = 1:length(cmip_names)
    %
    
    mod_vec = datevec(CMIP5_input.(cmip_names{m}).GMT_Matlab);
    time_index = mod_vec(:,1)>=2010 & mod_vec(:,1)<2020;
    
    lat_index = CMIP5_input.lat<=lat_lims(2) & CMIP5_input.lat>=lat_lims(1);
    
    SO_DIC = CMIP5_input.(cmip_names{m}).DIC(:, lat_index, :, time_index);
    
    % saving the surface concentration
    DIC_out_array(m,2) = nanmean(reshape(SO_DIC(:,:,1,:),[],1)).*10.^3; %umol/l
    
    % find the depth closest to deep_depth (though i've regridded so i know what
    % it is)
    depth_index = min(abs(CMIP5_input.(cmip_names{m}).depth-deep_depth))==abs(CMIP5_input.(cmip_names{m}).depth-deep_depth);
    
    % save the concentration at depth
    DIC_out_array(m,3) = nanmean(reshape(SO_DIC(:,:,depth_index,:),[],1)).*10.^3; %umol/l
    
    % save the difference/gradient
    DIC_out_array(m,4) = DIC_out_array(m,2) - DIC_out_array(m,3);
    clear SO_DIC lat_index mod_vec time_index depth_index
end


%% CMIP5 DIC Annual LOAD
clear CMIP5_input
CMIP5_DIC_dir = [home_dir 'Data/Model_Output/CMIP5/DIC/regrid/'];

cmip_files = dir([CMIP5_DIC_dir '*.nc']);
%
clear CMIP5_input

% load([CMIP5_DIC_dir 'masks.mat'])
cmip_names = cell(length(cmip_files),1);
time_offset = 0; % time and calendar has been set in CDO

for f=1:length(cmip_files)
    first_index = strfind(cmip_files(f).name, 'Oyr');
    second_index = strfind(cmip_files(f).name, 'rcp85');
    mod_name = cmip_files(f).name(first_index+4:second_index-2);
    disp([mod_name ' started'])
    %     if ~isempty(strfind(cmip_files(f).name, 'CMCC-CESM'))
    %         time_offset = datenum(2005,01, 01);
    %     elseif ~isempty(strfind(cmip_files(f).name, 'HadGEM2-CC'))
    %         time_offset = datenum(1960,12, 01);
    %     elseif ~isempty(strfind(cmip_files(f).name, 'HadGEM2-ES'))
    %         time_offset = datenum(1861,12, 01);
    %     elseif ~isempty(strfind(cmip_files(f).name, 'IPSL-CM5B-LR'))  ||  ...
    %             ~isempty(strfind(cmip_files(f).name, 'GFDL')) || ...
    %             ~isempty(strfind(cmip_files(f).name, 'CNRM-CM5')) || ...
    %             ~isempty(strfind(cmip_files(f).name, 'inmcm4')) || ...
    %             ~isempty(strfind(cmip_files(f).name, 'GISS'))
    %         time_offset = datenum(2006, 01, 01);
    %     elseif ~isempty(strfind(cmip_files(f).name, 'NorESM1-ME'))
    %         time_offset = datenum(1800,01, 01);
    %     elseif ~isempty(strfind(cmip_files(f).name, 'CESM1-BGC'))
    %         time_offset = datenum(0001,01, 01);
    %     elseif ~isempty(strfind(cmip_files(f).name, 'MRI-ESM1'))
    %         time_offset = datenum(1851,01, 01);
    %     else
    %         time_offset = datenum(1850, 1,1); % MPI MIROC
    %     end
    
    mod_name = strrep(mod_name, '-', '_');
    
    time_temp = ncread([CMIP5_DIC_dir cmip_files(f).name], 'time');
    
    temp_Matlab_time = time_temp + time_offset;
    
    %       mod_vec = datevec(temp_Matlab_time);
    %     disp(mod_vec)
    %
    if f==1
        CMIP5_input.lon = ncread([CMIP5_DIC_dir cmip_files(f).name], 'lon');
        CMIP5_input.lat = ncread([CMIP5_DIC_dir cmip_files(f).name], 'lat');
    end
    
    try
        temp_depth = ncread([CMIP5_DIC_dir cmip_files(f).name], 'zlev');
    catch
        temp_depth = ncread([CMIP5_DIC_dir cmip_files(f).name], 'lev');
    end
    
    CMIP5_input.(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time
    CMIP5_input.(mod_name).depth = temp_depth;
    CMIP5_input.(mod_name).DIC = ncread([CMIP5_DIC_dir cmip_files(f).name], 'dissic');
    CMIP5_input.(mod_name).units = ncreadatt([CMIP5_DIC_dir cmip_files(f).name], 'dissic', 'units');
    CMIP5_input.(mod_name).long_name = ncreadatt([CMIP5_DIC_dir cmip_files(f).name], 'dissic', 'long_name');
    
    cmip_names{f} = mod_name;
    
    if contains(mod_name, 'MRI') || contains(mod_name, 'CNRM')
        CMIP5_input.(mod_name).DIC(CMIP5_input.(mod_name).DIC<1)=nan;
    end
    
    clear mod_name temp_depth
end

%% CMIP6 DIC Annual LOAD

CMIP6_DIC_dir = [home_dir 'Data/Model_Output/CMIP6/DIC/regrid/'];

cmip_files = dir([CMIP6_DIC_dir '*.nc']);

cmip6_dic_annual_names = cell(length(cmip_files),1);
time_offset = 0; % time and calendar has been set in CDO


for f=1:length(cmip_files)
    
    first_index = strfind(cmip_files(f).name, 'Oyr');
    second_index = strfind(cmip_files(f).name, 'ssp585');
    mod_name = cmip_files(f).name(first_index+4:second_index-2);
    
    disp([mod_name ' started'])
    
    mod_name = strrep(mod_name, '-', '_');
    mod_name = [mod_name '_6'];
    
    time_temp = ncread([CMIP6_DIC_dir cmip_files(f).name], 'time');
    
    temp_Matlab_time = time_temp + time_offset;
    try
        temp_depth = ncread([CMIP6_DIC_dir cmip_files(f).name], 'zlev');
    catch
        temp_depth = ncread([CMIP6_DIC_dir cmip_files(f).name], 'lev');
    end
    
    CMIP5_input.(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time
    CMIP5_input.(mod_name).depth = temp_depth;
    
    CMIP5_input.(mod_name).DIC = ncread([CMIP6_DIC_dir cmip_files(f).name], 'dissic');
    CMIP5_input.(mod_name).units = ncreadatt([CMIP6_DIC_dir cmip_files(f).name], 'dissic', 'units');
    CMIP5_input.(mod_name).long_name = ncreadatt([CMIP6_DIC_dir cmip_files(f).name], 'dissic', 'long_name');
    
    cmip6_dic_annual_names{f} = mod_name;
    
    clear mod_name time_temp temp_depth
end

clear f cmip_files

cmip_names = [cmip_names ; cmip6_dic_annual_names];
%% DIC plots
[lon_grid, lat_grid] = meshgrid(CMIP5_input.lon, CMIP5_input.lat);

CMIP5_input.lon_grid = lon_grid';
CMIP5_input.lat_grid = lat_grid';
clear lon_grid lat_grid

for m = 1:length(cmip_names)
    % Southern Ocean surface DIC plot . time_range = 2010 to 2020
    
    clf
    set(gcf, 'units', 'inches')
    paper_w = 16; paper_h =9;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    
    mod_vec = datevec(CMIP5_input.(cmip_names{m}).GMT_Matlab);
    time_index = mod_vec(:,1)>=2010 & mod_vec(:,1)<2020;
    
    SO_lat_index = CMIP5_input.lat<=-35;
    
    SO_DIC = CMIP5_input.(cmip_names{m}).DIC(:, SO_lat_index, :, time_index);
    
    SO_mean_DIC = nanmean(SO_DIC,4);
    
    pcolor(CMIP5_input.lon_grid(:,SO_lat_index), CMIP5_input.lat_grid(:,SO_lat_index), SO_mean_DIC(:,:,1).*10^3); shading flat
    xlabel('Longitude')
    ylabel('Latitude')
    c1 = colorbar;
    ylabel(c1, '[DIC] \mumol l^-^1')
    title([(cmip_names{m}) ' Surface DIC'], 'interpreter', 'none')
    caxis([1950 2300])
    set(gca, 'ylim', [-85 -35])
    
    plot_filename = ['Surface_DIC_' cmip_names{m}];
    saveas(gcf, [Plot_out_dir 'Surface_Depth/' plot_filename '_v3'], 'png')
    
    % Southern Ocean 1000m DIC plot . time_range = 2010 to 2020
    clf
    set(gcf, 'units', 'inches')
    paper_w = 16; paper_h =9;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    
    depth_index = min(abs(CMIP5_input.(cmip_names{m}).depth-1000))==abs(CMIP5_input.(cmip_names{m}).depth-1000);
    
    pcolor(CMIP5_input.lon_grid(:,SO_lat_index), CMIP5_input.lat_grid(:,SO_lat_index), SO_mean_DIC(:,:,depth_index).*10^3); shading flat
    xlabel('Longitude')
    ylabel('Latitude')
    c1 = colorbar;
    ylabel(c1, '[DIC] \mumol l^-^1')
    title([(cmip_names{m}) ' ' num2str(CMIP5_input.(cmip_names{m}).depth(depth_index)) ' m DIC'], 'interpreter', 'none')
    caxis([2180 2350])
    set(gca, 'ylim', [-85 -35])
    
    plot_filename = ['DIC_at_depth_' cmip_names{m}];
    saveas(gcf, [Plot_out_dir 'Surface_Depth/' plot_filename '_v3'], 'png')
    
    clear SO_mean_DIC SO_DIC SO_lat_index time_index
end

clear m

%% FGCO2 monthly CMIP5 LOAD
% load monthly output:

%  Loading NN product
% annual mean

CMIP5_fgco2_dir = [home_dir 'Data/Model_Output/CMIP5/fgco2/regrid/'];

cmip_talk_files = dir([CMIP5_fgco2_dir '*.nc']);

clear CMIP5_mon_fgco2

cmip_fgco2_names = cell(length(cmip_talk_files),1);
%
time_offset = 0; % differing time stamps is now fixed using cdo commands

for f=1:length(cmip_talk_files)
    
    first_index = strfind(cmip_talk_files(f).name, 'Omon');
    second_index = strfind(cmip_talk_files(f).name, 'rcp85');
    mod_name = cmip_talk_files(f).name(first_index+5:second_index-2);
    disp([mod_name ' started'])
    %     if ~isempty(strfind(cmip_talk_files(f).name, 'CMCC-CESM'))
    %         time_offset = datenum(2005,12, 01);
    %     elseif ~isempty(strfind(cmip_talk_files(f).name, 'HadGEM2-CC'))  %%  360 Day Calendar????
    %         time_offset = datenum(1960,9, 01);
    %     elseif ~isempty(strfind(cmip_talk_files(f).name, 'HadGEM2-ES'))
    %         time_offset = datenum(1861,14, 01);
    %     elseif ~isempty(strfind(cmip_talk_files(f).name, 'IPSL-CM5B-LR'))  ||  ...
    %             ~isempty(strfind(cmip_talk_files(f).name, 'GFDL')) || ...
    %             ~isempty(strfind(cmip_talk_files(f).name, 'CNRM-CM5')) || ...
    %             ~isempty(strfind(cmip_talk_files(f).name, 'inmcm4')) || ...
    %             ~isempty(strfind(cmip_talk_files(f).name, 'GISS'))
    %         time_offset = datenum(2006, 01, 01);
    %     elseif ~isempty(strfind(cmip_talk_files(f).name, 'NorESM1-ME'))
    %         time_offset = datenum(1800,03, 01);
    %     elseif ~isempty(strfind(cmip_talk_files(f).name, 'CESM1-BGC'))
    %         time_offset = datenum(0001,05, 01);
    %     elseif ~isempty(strfind(cmip_talk_files(f).name, 'MRI-ESM1'))
    %         time_offset = datenum(1851,01, 01);
    %     elseif ~isempty(strfind(cmip_talk_files(f).name, 'CanESM'))
    %         time_offset = datenum(1850, 2,1);
    %     else
    %         time_offset = datenum(1850, 1,1); % MPI MIROC
    %     end
    
    mod_name = strrep(mod_name, '-', '_');
    
    time_temp = ncread([CMIP5_fgco2_dir cmip_talk_files(f).name], 'time');
    
    temp_Matlab_time = time_temp + time_offset;
    %     mod_vec = datevec(temp_Matlab_time);
    %     disp(mod_vec(1:12,:)); clear mod_vec
    
    
    if f==1
        CMIP5_mon_fgco2.lon = ncread([CMIP5_fgco2_dir cmip_talk_files(f).name], 'lon');
        CMIP5_mon_fgco2.lat = ncread([CMIP5_fgco2_dir cmip_talk_files(f).name], 'lat');
    end
    
    CMIP5_mon_fgco2.(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time
    CMIP5_mon_fgco2.(mod_name).fgco2 = ncread([CMIP5_fgco2_dir cmip_talk_files(f).name], 'fgco2');
    CMIP5_mon_fgco2.(mod_name).units = ncreadatt([CMIP5_fgco2_dir cmip_talk_files(f).name], 'fgco2', 'units');
    CMIP5_mon_fgco2.(mod_name).long_name = ncreadatt([CMIP5_fgco2_dir cmip_talk_files(f).name], 'fgco2', 'long_name');
    
    cmip_fgco2_names{f} = mod_name;
    
    clear mod_name time_temp
end

clear f cmip_talk_files

%% FGCO2 monthly CMIP6 LOAD

CMIP6_fgco2_dir = [home_dir 'Data/Model_Output/CMIP6/fgco2/regrid/'];

cmip_talk_files = dir([CMIP6_fgco2_dir '*.nc']);

cmip6_fgco2_names = cell(length(cmip_talk_files),1);
time_offset = 0; % time and calendar has been set in CDO


for f=1:length(cmip_talk_files)
    
    first_index = strfind(cmip_talk_files(f).name, 'Omon');
    second_index = strfind(cmip_talk_files(f).name, 'ssp585');
    mod_name = cmip_talk_files(f).name(first_index+5:second_index-2);
    
    disp([mod_name ' started'])
    
    mod_name = strrep(mod_name, '-', '_');
    mod_name = [mod_name '_6'];
    
    time_temp = ncread([CMIP6_fgco2_dir cmip_talk_files(f).name], 'time');
    
    temp_Matlab_time = time_temp + time_offset;
    
    CMIP5_mon_fgco2.(mod_name).GMT_Matlab = temp_Matlab_time; clear temp_Matlab_time
    CMIP5_mon_fgco2.(mod_name).fgco2 = ncread([CMIP6_fgco2_dir cmip_talk_files(f).name], 'fgco2');
    CMIP5_mon_fgco2.(mod_name).units = ncreadatt([CMIP6_fgco2_dir cmip_talk_files(f).name], 'fgco2', 'units');
    CMIP5_mon_fgco2.(mod_name).long_name = ncreadatt([CMIP6_fgco2_dir cmip_talk_files(f).name], 'fgco2', 'long_name');
    
    cmip6_fgco2_names{f} = mod_name;
    
    %     if contains(mod_name, 'MRI') || contains(mod_name, 'CNRM') || contains(mod_name, 'GISS') || contains(mod_name, 'MIROC')
    %         CMIP5_mon_fgco2.(mod_name).fgco2(CMIP5_mon_fgco2.(mod_name).fgco2==0)=nan;
    %     end
    
    clear mod_name time_temp first_index second_index
end

clear f cmip_talk_files time_offset

cmip_fgco2_names = [cmip_fgco2_names ; cmip6_fgco2_names];
