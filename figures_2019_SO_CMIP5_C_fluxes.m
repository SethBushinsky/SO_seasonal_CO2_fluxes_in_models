Plot_manus_dir = [home_dir '/Work/Manuscripts/2019_06 SO CMIP Comparison/figures/'];
%% %%%% New code 2021_02_08
% Figures for manuscript
% Using ingested data from CMIP5_plotting.m and
% Carbon_mapped_product_analyisis.m



%% Figure 1 Zonal integral flux diagrams - mapped c flux products
v = 9;
years = C_input.years;
product_names = C_input.product_names;
run_names = C_input.run_names;
runs = C_input.runs;
regions = C_input.regions;

% first make some general figures
for p = 1
    for y=1:2
        for q=1:2
            
            plot_filename = ['Zonally_integrated_flux_' product_names{p} ' ' years{y} ' '  runs{q}];
            clf
            set(gcf, 'units', 'inches')
            paper_w = 10; paper_h =8;
            set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
            
            
            %             mod_vec = datevec(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).GMT_Matlab);
            
            lat_index = C_input.(product_names{p}).(years{y}).lat>=-80 & C_input.(product_names{p}).(years{y}).lat<=-35;
            
            temp_array = NaN(sum(lat_index), 12);
            for mon = 1:12
                date_index = C_input.(product_names{p}).(years{y}).Pg_mon.date_vec(:,2)==mon & C_input.(product_names{p}).(years{y}).Pg_mon.date_vec(:,1)>=2015;
                CC = C_input.(product_names{p}).(years{y}).Pg_mon.(runs{q})(:, lat_index, date_index).*1000; % Pg mon-1 to Tg mon-1
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
            title([product_names{p} ' ' years{y} ' '  runs{q}], 'interpreter', 'none')
            set(gca, 'fontsize', 18)
            
            print(gcf, '-dpng', [Plot_manus_dir plot_filename '.png'])
        end
    end
end

%% Actual Figure 1
years = C_input.years;
product_names = C_input.product_names;
run_names = C_input.run_names;
runs = C_input.runs;
regions = C_input.regions;


p_year = 'y2021';
p = 3;


lat_index = C_input.(product_names{p}).(p_year).lat>=-80 & C_input.(product_names{p}).(p_year).lat<=-35;

% save SOCAT_only, SOCCOM_SOCAT into temp_array
obs_flux_array = NaN(3, sum(lat_index), 12);
obs_pCO2_array = NaN(3, sum(lat_index), 12);

for q = 1:2
    for mon = 1:12
        date_index = C_input.(product_names{p}).(p_year).Pg_mon.date_vec(:,2)==mon & C_input.(product_names{p}).(p_year).Pg_mon.date_vec(:,1)>=2015;
        CC = C_input.(product_names{p}).(p_year).Pg_mon.(runs{q})(:, lat_index, date_index).*1000; % Pg mon-1 to Tg mon-1
        DD = nanmean(CC,3);
        EE = nansum(DD,1);
        
        obs_flux_array(q, :, mon) = EE'; % Tg Mon-1
        
        CC = C_input.(product_names{p}).(p_year).spco2.(runs{q})(:, lat_index, date_index); % fCO2 currently for Neural Network, needs to be fixed
        DD = nanmean(CC,3);
        EE = nanmean(DD,1);
        
        obs_pCO2_array(q, :, mon) = EE'; % Tg Mon-1
        
        
    end
end

% difference goes into the 3rd index
obs_flux_array(3,:,:) = obs_flux_array(2, :, :) - obs_flux_array(1, :, :);
clear EE CC DD date_index mon q lat_index
%%
plot_filename = ['Figure 1AB - C mapped product analysis: ' product_names{p} ' ' years{y}];

color_map = brewermap(30, 'RdYlBu');
color_map = flipud(color_map);

clf
set(gcf, 'units', 'inches')
paper_w = 20; paper_h =6;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
set(gcf, 'colormap', color_map)

lat_x = CMIP.(variables{v}).lat(lat_index);
lat_lab = repmat(lat_x, 1, 12);

mon_lab = repmat(1:12, length(lat_lab),1);

d = NaN(2,1);
c = NaN(2,1);
for q = 1:2
    d(q) = subplot(1,3,q);
    
    
    pcolor(mon_lab, lat_lab, squeeze(obs_flux_array(q,:,:))); shading flat
    caxis([-10 10])
    c(q) = colorbar;
    
end

xlabel(d(1), 'Months');  xlabel(d(2), 'Months')
ylabel(d(1), 'Latitude')
ylabel(c(2), 'Tg C mon^-^1 \circLat^-^1')
% title([product_names{p} ' ' years{y} ' '  runs{q}], 'interpreter', 'none')
set(d, 'fontsize', 18)

print(gcf, '-dpng', [Plot_manus_dir plot_filename '.png'])

%% Figure 1C difference

plot_filename = ['Figure 1C - C mapped product analysis difference: ' product_names{p} ' ' years{y}];

color_map = brewermap(30, 'RdBu');
color_map = flipud(color_map);

clf
set(gcf, 'units', 'inches')
paper_w = 20; paper_h =6;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
set(gcf, 'colormap', color_map)

d = NaN(1,1);
c = NaN(1,1);
d(1) = subplot(1,3,3);

pcolor(mon_lab, lat_lab, squeeze(obs_flux_array(3,:,:))); shading flat
caxis([-5 5])
c(1) = colorbar;



xlabel(d(1), 'Months');
ylabel(d(1), 'Latitude')
ylabel(c(1), 'Tg C mon^-^1 \circLat^-^1')
% title([product_names{p} ' ' years{y} ' '  runs{q}], 'interpreter', 'none')
set(d, 'fontsize', 18)

print(gcf, '-dpng', [Plot_manus_dir plot_filename '.png'])

%% Figure 1 option 3 - Annual / Summer / winter / seasonal integral
new_bounds = load([data_dir 'ARGO_O2_Floats/Front_definitions/Gray_5_regions/regional_boundaries_5zone.mat']);
new_bounds.lon_saf_360 = new_bounds.lon_saf;
new_bounds.lon_saf_360(new_bounds.lon_saf_360<0) = new_bounds.lon_saf_360(new_bounds.lon_saf_360<0)+360;
new_bounds.lon_lat_saf_360 = sortrows([new_bounds.lon_saf_360' new_bounds.lat_saf']);
p = 3;

plot_filename = ['Figure 1_v5_ ' product_names{p} 'annual_summer_winter_integral_flux' plot_ver];

title_size = 13;
clf
set(gcf, 'units', 'inches')
paper_w = 15; paper_h = 8.5;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

d = NaN(20);
orig_position = NaN(8,4);
p_index=0;

v = 9;
SO_lat_index = CMIP.(variables{v}).lat<=-35;
[lon_grid, lat_grid] = meshgrid(CMIP.(variables{v}).lon, CMIP.(variables{v}).lat);

CMIP.lon_grid = lon_grid';
CMIP.lat_grid = lat_grid';
clear lon_grid lat_grid

axis_font_size = 10;

set(gcf, 'colormap', flipud(brewermap(30, 'RdBu')))

c_lims = [-.05 .05];
for q = 1:2
    seasons = {'Annual', 1:12; 'Summer', [12 1 2]; 'Winter' [6 7 8]};
    for s = 1:size(seasons,1)
        p_index = p_index+1;
        
        d(p_index) = subplot(2,4,p_index);
        
        date_index =  sum(C_input.(product_names{p}).y2021.date_vec(:,1)>=2015 & C_input.(product_names{p}).y2021.date_vec(:,2)==seasons{s,2},2)>0;
        CC = C_input.(product_names{p}).y2021.Pg_mon.(runs{q})(:, SO_lat_index, date_index); % mol m-2 yr-1
        avg_neur = nanmean(CC,3).*10^3; % mol m-2 yr-1 or Tg C mon-1

        SO_mean_var_lon_shift = NaN(size(avg_neur,1), size(avg_neur,2), size(avg_neur,3));
        SO_mean_var_lon_shift(1:180, :, :) = avg_neur(181:end,:,:);
        SO_mean_var_lon_shift(181:end, :, :) = avg_neur(1:180,:,:);
        
        % if v==9
        %     SO_mean_var_lon_shift = SO_mean_var_lon_shift./C_input.Neur.y2021.area(SO_lat_index,:)'.*10^15; % g C m-2 yr-1 from Pg C yr-1 ; %
        % end
        
        
        pcolor(CMIP.lon_grid(:,SO_lat_index), CMIP.lat_grid(:,SO_lat_index), SO_mean_var_lon_shift); shading flat; %colorbar
        hold on
        
        plot(new_bounds.lon_lat_saf_360(:,1), new_bounds.lon_lat_saf_360(:,2), 'k-', 'linewidth', 2)
        plot([1 360], [poleward_lat_lim poleward_lat_lim], 'k-', 'linewidth',2)
        
        orig_position(p_index,:) = get(gca, 'position');
        if q==2 && s==2
            
            c1 = colorbar('location', 'southoutside');
            ylabel(c1, 'Tg C mon^-^1 \circLat^-^1');
        end
        caxis(c_lims)
        title(seasons{s,1}, 'fontsize', title_size)
        set(gca, 'fontsize', axis_font_size)
        set(gca, 'ylim', [-80 -35])
    end
    
    p_index = p_index+1;
    
    d(p_index) = subplot(2,4,p_index);
    lat_index = C_input.(product_names{p}).(p_year).lat>=-80 & C_input.(product_names{p}).(p_year).lat<=-35;
    
    lat_x = CMIP.(variables{v}).lat(lat_index);
    lat_lab = repmat(lat_x, 1, 12);
    
    mon_lab = repmat(1:12, length(lat_lab),1);
    
    d(p_index) = subplot(2,4,p_index);
    
    pcolor(mon_lab, lat_lab, squeeze(obs_flux_array(q,:,:))); shading flat
    caxis([-10 10])
    c(q) = colorbar;
    
    set(gca, 'fontsize', axis_font_size)
    ylabel(d(1), 'Latitude')
    ylabel(c(q), 'Tg C mon^-^1 \circLat^-^1')
    title([runs{q}], 'interpreter', 'none')
    
end
    xlabel(d(4), 'Months');  xlabel(d(8), 'Months')


set(d(6), 'position', orig_position(6,:));

print(gcf, '-dpng', [Plot_manus_dir plot_filename '.png'])


clear d c mon_lab lat_lab lat_x lat_index p_index SO_lat_index SO_mean_lon_shift avg_neur CC date_index c_lims title_size q s v p paper_h paper_w
%% Supplemental figure 1: Zonal integral flux diagrams for all models
% running for spCO2 as well
models_to_skip = {'BCC_CSM2_MR_6', 'inmcm4', 'MIROC_ES2L_6'};
% v = 9;
v=1;
if v==9
    c_lims = [-10 10];
    color_map = brewermap(30, 'RdYlBu');
    color_map = flipud(color_map);
    
    
elseif v==1
    c_lims = [350 450];
    color_map = inferno;
    color_map = (color_map);
    
    
end
for r = 1:2
    clf
    set(gcf, 'units', 'inches')
    paper_w = 8.5; paper_h = 11;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    
    d = NaN(20);
    p_index=0;
    
    if r==1
        first = 1;
        last = 18;
    elseif r==2
        first=19;
        last = length(cmip_names.(variables{v}));
    end
    plot_filename = ['Figure S1_Zonally_integrated_' variables{v} '_all_models_' num2str(r)];
    if r==1
        for q = 1:2
            p_index = p_index+1;
            d(p_index) = subplot(5,4,p_index);
            if v==9
                obs_array = obs_flux_array;
            elseif v==1
                obs_array = obs_pCO2_array;
            end
            pcolor(mon_lab, lat_lab, squeeze(obs_array(q,:,:))); shading flat
            caxis(c_lims)
            
            title(runs{q}, 'interpreter', 'none', 'fontsize', 11)
        end
    end
    for m = first:last % length(cmip_names.(variables{v}))
        if sum(strcmp(cmip_names.(variables{v}){m}, models_to_skip))>0
            continue
        end
        p_index = p_index+1;
        
        
        mod_vec = datevec(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).GMT_Matlab);
        
        lat_index = CMIP.(variables{v}).lat>=-80 & CMIP.(variables{v}).lat<=-35;
        
        temp_array = NaN(sum(lat_index), 12);
        for mon = 1:12
            date_index = mod_vec(:,2)==mon;
            CC = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, lat_index, date_index);
            DD = nanmean(CC,3);
            
            if v==9
                EE = nansum(DD,1);
            elseif v==1
                EE = nanmean(DD,1);
            end
            temp_array(:, mon) = EE'; % Tg Mon-1 or uatm
        end
        
        
        
        lat_x = CMIP.(variables{v}).lat(lat_index);
        lat_lab = repmat(lat_x, 1, 12);
        
        mon_lab = repmat(1:12, length(lat_lab),1);
        
        d(p_index) = subplot(5,4,p_index);
        pcolor(mon_lab, lat_lab, temp_array); shading flat
        caxis(c_lims)
        
        title(cmip_names.(variables{v}){m}, 'interpreter', 'none', 'fontsize', 11)
        %     set(gca, 'fontsize', 18)
        
    end
    
    set(gcf, 'colormap', color_map)
    
    print(gcf, '-dpdf', [Plot_manus_dir plot_filename plot_ver '.pdf'])
end

c1 = colorbar;
%     xlabel('Months')
%     ylabel('Latitude')
ylabel(c1, 'Tg C mon^-^1 \circLat^-^1')

print(gcf, '-dpdf', [Plot_manus_dir plot_filename 'w_colorbar.pdf'])

%% Figure 2
var_mean_lims = var_lims;

var_mean_lims(2,:) = [0 1200];
var_mean_lims(4,:) = [0 450];
var_mean_lims(5,:) = [2 11];
var_mean_lims(6,:) = [-.14 .14];
var_mean_lims(7,:) = [2070 2300];
var_mean_lims(8,:) = [2260 2440];
var_mean_lims(9,:) = [-350 350];
var_mean_lims(13,:) = [4e4 7.5e4];

var_anom_lims(1,:) = [-30 25];
var_anom_lims(2,:) = [-600 900];
var_anom_lims(4,:) = [-150 300];
var_anom_lims(5,:) = [-2.6 3.5];
var_anom_lims(7,:) = [-45 45];
var_anom_lims(8,:) = [-6 8];
var_anom_lims(9,:) = [-350 350];
var_anom_lims(13,:) = [-6000 5000];


anomaly = 0;
if anomaly==1
    anomaly_text = 'anomaly ';
else
    anomaly_text=[];
end

v = 9;

plot_filename = ['Figure 2 Obs model Seasonal ' anomaly_text variables{v} plot_ver];
clf
set(gcf, 'units', 'inches')
paper_w = 10; paper_h =12;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

subplot(2,1,1)
hold on
legend_names = {};
% plot([1 12], [0 0], '--k')
for m =  1:length(cmip_names.(variables{v}))
    % [l, a] = boundedline(1:12, DIC_out_seasonal(m,:,1), DIC_out_seasonal(m,:,2));
    % a.FaceAlpha = 0.3;
    
    if isnan(CMIP.(variables{v}).out_seasonal(m,1,1))
        continue
    end
    if anomaly==1
        plot(1:12, CMIP.(variables{v}).out_seasonal(m,:,1)-nanmean(CMIP.(variables{v}).out_seasonal(m,:,1)), 'color', cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:), 'linewidth', 3);
    else
        plot(1:12, CMIP.(variables{v}).out_seasonal(m,:,1), 'color', cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:), 'linewidth', 3);
    end
    
    legend_names{end+1,1} = cmip_names.(variables{v}){m};
end

if v==9
    if anomaly==1
        e1 = errorbar(1:12, obs.(variables{v}).Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1)- ...
            nanmean( obs.(variables{v}).Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1)), ...
            obs.(variables{v}).Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 4, 'color', 'k', 'linestyle', '--');
    else
        e1 = errorbar(1:12, obs.(variables{v}).Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1), ...
            obs.(variables{v}).Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 4, 'color', 'k', 'linestyle', '--');
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
set(gca, 'fontsize', 12, 'xlim', [1 12])
set(l1, 'fontsize', 9)
% title(['Seasonal ' variables{v}])
title('Seasonal Sea-Air CO_2 flux')

% Plotting taylor diagrams
rms_cutoff_for_good = .75;
out_of_phase_corr_cutoff = 0;

subplot(2,1,2)
legend_on = 0;
for v = 9%[1 2 4 5 6 7 8 9 13]
    %     plot_filename = ['Taylor ' variables{v}];
    %
    %     clf
    %     set(gcf, 'units', 'inches')
    %     paper_w = 14; paper_h =8;
    %     set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    %
    DDD = taylor_dist_smb(obs.(variables{v}).correlation, obs.(variables{v}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, rms_cutoff_for_good, out_of_phase_corr_cutoff);
    title('Fit to observations')
    
    set(gca, 'fontsize', 12)
    %
    %     print(gcf, '-dpng', [Plot_out_dir variables{v} '/' plot_filename 'leg ' num2str(legend_on) '_v4_theta.png'])
end

clear paper_w paper_h legend_on

print(gcf, '-dpdf', [Plot_manus_dir '/' plot_filename '.pdf'])
print(gcf, '-dpng', [Plot_manus_dir '/' plot_filename '.png'])

%% Figure 2 - 4 variable option

var_mean_lims = var_lims;

var_mean_lims(2,:) = [0 1200];
var_mean_lims(4,:) = [0 450];
var_mean_lims(5,:) = [2 11];
var_mean_lims(6,:) = [-.14 .14];
var_mean_lims(7,:) = [2070 2300];
var_mean_lims(8,:) = [2260 2440];
var_mean_lims(9,:) = [-350 350];
var_mean_lims(13,:) = [4e4 7.5e4];

var_anom_lims(1,:) = [-30 25];
var_anom_lims(2,:) = [-600 900];
var_anom_lims(4,:) = [-150 300];
var_anom_lims(5,:) = [-2.6 3.5];
var_anom_lims(7,:) = [-45 45];
var_anom_lims(8,:) = [-6 8];
var_anom_lims(9,:) = [-350 350];
var_anom_lims(13,:) = [-6000 5000];


anomaly = 1;
if anomaly==1
    anomaly_text = 'anomaly ';
else
    anomaly_text=[];
end

plot_filename = ['Figure 2_v3 Obs model Seasonal ' anomaly_text ' fgco2 spco2 dic tos ' plot_ver];
clf
set(gcf, 'units', 'inches')
paper_w = 9; paper_h =11;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

plot_index = 0;
seas_comp_vars = fieldnames(obs);

for sv = [8 6 4 1]

    v = find(strncmp(seas_comp_vars{sv}, variables, 4));
    if length(v)>1 % cludge since dissic and dissic_yr were getting confused
        v = strmatch(seas_comp_vars{sv}, variables, 'exact');
    end
    
    plot_index = plot_index+1;
    
    subplot(4,2,plot_index)
    hold on
    legend_names = {};
    % plot([1 12], [0 0], '--k')
    for m =  1:length(cmip_names.(variables{v}))
        % [l, a] = boundedline(1:12, DIC_out_seasonal(m,:,1), DIC_out_seasonal(m,:,2));
        % a.FaceAlpha = 0.3;
        
        if isnan(CMIP.(variables{v}).out_seasonal(m,1,1))
            continue
        end
        if anomaly==1
            if sv==8
                  plot(1:12, CMIP.(variables{v}).out_seasonal_mol_C_m2_yr(m,:,1) - nanmean(CMIP.(variables{v}).out_seasonal_mol_C_m2_yr(m,:,1)), 'color', cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:), 'linewidth', 3);
            else
                plot(1:12, CMIP.(variables{v}).out_seasonal(m,:,1)-nanmean(CMIP.(variables{v}).out_seasonal(m,:,1)), 'color', cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:), 'linewidth', 3);
            end
        else
            plot(1:12, CMIP.(variables{v}).out_seasonal(m,:,1), 'color', cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:), 'linewidth', 3);
        end
        
        legend_names{end+1,1} = cmip_names.(variables{v}){m};
    end
    
    if v==9 || v==1
        if anomaly==1
            e1 = errorbar(1:12, obs.(seas_comp_vars{sv}).Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1)- ...
                nanmean( obs.(seas_comp_vars{sv}).Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1)), ...
                obs.(seas_comp_vars{sv}).Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 4, 'color', 'k', 'linestyle', '--');
        else
            e1 = errorbar(1:12, obs.(seas_comp_vars{sv}).Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1), ...
                obs.(seas_comp_vars{sv}).Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 4, 'color', 'k', 'linestyle', '--');
        end
    else
        if anomaly==1
            e1 = plot(1:12, obs.(seas_comp_vars{sv}).out_seasonal(:,1) - ...
                nanmean(obs.(seas_comp_vars{sv}).out_seasonal(:,1)), 'linewidth', 4, 'color', 'k', 'linestyle', '--');
        else
            e1 = plot(1:12, obs.(seas_comp_vars{sv}).out_seasonal(:,1), 'linewidth', 4, 'color', 'k', 'linestyle', '--');
        end
    end
    ylabel([seas_comp_vars{sv} ' ' anomaly_text ' (' (CMIP.(variables{v}).(cmip_names.(variables{v}){1}).units) ')'], 'interpreter', 'none')
    
    xlabel('Month')
%     l1 = legend([legend_names ; 'Obs'], 'interpreter', 'none', 'location', 'eastoutside');
    set(gca, 'fontsize', 12, 'xlim', [1 12])
%     set(l1, 'fontsize', 9)
    title(seas_comp_vars{sv}, 'interpreter', 'none')

    plot_index = plot_index+1;

    % Plotting taylor diagrams
    subplot(4,2,plot_index)
    legend_on = 0;
    
    rms_cutoff_for_good = .75;
    out_of_phase_corr_cutoff = 0;
    
    if ~isempty(strfind(seas_comp_vars{sv}, 'fgco2'))
        DDD = taylor_dist_smb_for_manuscript(obs.(seas_comp_vars{sv}).correlation, obs.(seas_comp_vars{sv}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, ...
            rms_cutoff_for_good, out_of_phase_corr_cutoff);
    else
        DDD = taylor_dist_smb_for_manuscript(obs.(seas_comp_vars{sv}).correlation, obs.(seas_comp_vars{sv}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, [], []);
    end
    title('Fit to observations')
    
    set(gca, 'fontsize', 12)
    set(gca, 'ycolor', 'white')

    clear paper_w paper_h legend_on
end

% print(gcf, '-dpdf', [Plot_manus_dir '/' plot_filename '.pdf'])
print(gcf, '-dpng', [Plot_manus_dir '/' plot_filename '.png'])

%% Figure 3 - side by side pCO2/SST/DIC seasonal cycle and contour plot

clf
set(gcf, 'units', 'inches')
paper_w = 15; paper_h =14;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

set(gcf, 'colormap', brewermap(30, 'Spectral'))

plot_filename = 'Fig_3_Toy model pCO2';


main_var = 'dissic';
v = 7;

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

blues = brewermap(10,'Blues');
greens = brewermap(10, 'Greens');
purples = brewermap(10,'Purples');
oranges = brewermap(10,'oranges');
PurpleRed = brewermap(9,'PuRd');
% now test plots to run
dpsd = {[6 6]; [3  9]; [3 3 9 9];[6 6];[3 3 9 9]};
dap = {[6 16]; [11 11];[6 16 6 16];[11 11];[6 16 6 16]};
tap = {[3 3 ];[3 3];[3 3 3 3] ;[2 4];[4 4 4 4]};

plot_colors = {[blues(5,:) ; blues(9,:)];...
    [greens(5,:); greens(9,:) ]; ...
    [purples(4,:); purples(6,:); purples(8,:); purples(10,:)];...
    [oranges(5,:) ; oranges(9,:)];...
    [PurpleRed(4,:); PurpleRed(5,:); PurpleRed(6,:); PurpleRed(7,:)]};

% set up 3 columns - one for DIC changes alone, one for SST changes alone,
% and one for both
tos_amp_per_plot = {0 ;0; 0; [-50 50]; 50};
sub_v = 5;

col_titles = {'DIC Amp.'; 'DIC Timing'; {'DIC Amp. +', 'DIC Timing'}; 'SST Amp.'; {'DIC Amp. +', 'DIC Timing + SST Amp.'}};

for cc = 1:length(tos_amp_per_plot)
    tos_amp_per = tos_amp_per_plot{cc};

    d = NaN(length(tos_amp_per));
    contour_pos = NaN(length(tos_amp_per),4);
    for z = 1: length(tos_amp_per)

        tt = find(adjust_vars.adjust_tos_amp_percent==tos_amp_per(z));

        % plot pCO2 correlation arrays for different scenarios:
        pCO2_grid = NaN(length(adjust_vars.(['adjust_' main_var '_amp_percent'])), length(adjust_vars.(['adjust_' main_var '_phase_shift_days'])));

        for dd =1: length(adjust_vars.(['adjust_' main_var '_amp_percent']))
            pCO2_grid(dd,:) = idealized_test_out_2(:,dd,1,tt,1,talk_ap,1,1,1);
        end

        d(z) = subplot(5,5,15+cc+5*(z-1));

        [C, h] = contourf( adjust_vars.(['adjust_' main_var '_phase_shift_days']), adjust_vars.(['adjust_' main_var '_amp_percent']),pCO2_grid, 'levellist', -1:0.05:1, 'linestyle', 'none'); colorbar; caxis([-1 1])
        hold on
        [C1, h1] = contour( adjust_vars.(['adjust_' main_var '_phase_shift_days']),adjust_vars.(['adjust_' main_var '_amp_percent']), pCO2_grid, 'levellist', [-0.5:0.5:0.5], 'linestyle', '-', 'linewidth', 2, 'color', 'k');
        clabel(C1, h1)
        xlabel('DIC timing (days)')
        ylabel('\Delta DIC amp. % ')
        title(['\Delta SST amp. ' num2str(tos_amp_per(z)) ' %']);
        contourcbar("off")

        contour_pos(z,:) = get(d(z),'position');
    end

    % plot base DIC, SST, pCO2
    d2 = subplot(5,5,cc);
    hold on
    plot(dic_orig, '-k', 'linewidth', 3)
    if cc==1
        ylabel('DIC (\mumol kg^-^1)')
    end
    set(d2, 'ylim', [2165 2240])
    title(col_titles{cc})


    d3 = subplot(5,5,cc+5);
    hold on
    plot(tos_orig, '-k', 'linewidth', 3)
    if cc==1
        ylabel('SST (\circC)')
    end
    set(d3, 'ylim', [1 6])

    d1 = subplot(5,5,cc+10);
    hold on
    p1 = plot(pco2_orig, '-k', 'linewidth', 3);
    if cc==1
    ylabel('pCO_2 (\muatm)')
    end
    set(d1, 'ylim', [340 450])
    xlabel('Month')


    % now plot test symbols overlaid
    for qq = 1:length(dpsd{cc})

        pco2_test = squeeze(pco2_idealized(dpsd{cc}(qq),dap{cc}(qq),1,tap{cc}(qq),1,talk_ap,1,1,:));
        dic_test = squeeze(dic_idealized(dpsd{cc}(qq),dap{cc}(qq),1,tap{cc}(qq),1,talk_ap,1,1,:));
        tos_test = squeeze(tos_idealized(dpsd{cc}(qq),dap{cc}(qq),1,tap{cc}(qq),1,talk_ap,1,1,:));

        pco2_correlation = idealized_test_out_2(dpsd{cc}(qq),dap{cc}(qq),1,tap{cc}(qq),1,talk_ap,1,1,1);

        plot(d2, dic_test,'--', 'linewidth', 3, 'color', plot_colors{cc}(qq,:));
        plot(d3, tos_test,'--r', 'linewidth', 3, 'color', plot_colors{cc}(qq,:));

        plot(d1, pco2_test,'--r', 'linewidth', 3, 'color', plot_colors{cc}(qq,:));

        contour_index = find(tos_amp_per_plot{cc} == adjust_vars.adjust_tos_amp_percent(tap{cc}(qq)));

        plot(d(contour_index), 0, 0, '*k', 'markersize', 10)
       p1 =  plot(d(contour_index),  adjust_vars.adjust_dissic_phase_shift_days(dpsd{cc}(qq)), ...
            adjust_vars.adjust_dissic_amp_percent(dap{cc}(qq)), 'markersize', 15);
       p1.Marker = 'o';
       p1.MarkerEdgeColor = 'k';
       p1.MarkerFaceColor = plot_colors{cc}(qq,:);
%        set(p1, 'marker', 's', 'markeredgecolor', 'k', 'markerfacecolor', 'color', plot_colors{cc}(qq,:));
%         scatter(d(contour_index), adjust_vars.adjust_dissic_phase_shift_days(dpsd{cc}(qq)), ...
%             adjust_vars.adjust_dissic_amp_percent(dap{cc}(qq)), 200, pco2_correlation, 'filled', 'markeredgecolor', 'k')

    end

    for z = 1: length(tos_amp_per)
    height_adjust = 0.03;

        if cc<4
            set(d(z), 'position', contour_pos(z,:) +[0 -0.12 0 height_adjust])

            if cc==2
                second_pos = get(d(z), 'position');
            end
        elseif cc==4 && z==1
            set(d(z), 'position', contour_pos(z,:) +[0 -0.03 0 height_adjust])
        elseif cc==4 && z==2
            set(d(z), 'position', contour_pos(z,:) +[0 -0.07 0 height_adjust])
            %             new_pos = get(d(z), 'position');
            bottom_pos = get(d(z), 'position');

        end
    end
end

cb1 = contourcbar(d(contour_index), 'location', 'southoutside');
cb1_pos = get(cb1, 'position');
set(d(z), 'position', [contour_pos(z,1) bottom_pos(2) contour_pos(z,3) contour_pos(z,4)+height_adjust])
set(cb1, 'position', [second_pos(1) second_pos(2)-.11 cb1_pos(3)+.04 cb1_pos(4)+.02])
title(cb1, 'pCO_2 Correlation', 'fontweight', 'bold')
set(cb1, 'fontsize', 14)
print(gcf, '-dpng', [Plot_manus_dir '/' plot_filename '.png'])

%%

for qq = 1:length(dpsd)
    
    
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

%         print(gcf, '-dpng', '-r400', [Plot_out_dir 'Sensitivity_tests/' plot_filename plot_ver])
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
%     print(gcf, '-dpng', '-r400', [Plot_out_dir 'Sensitivity_tests/' plot_filename plot_ver])
    
    pause
end
% legend(d1, legend_names, 'location', 'northwest')
% plot(d1, harm.spco2.seasonal_fit, 'k--')


%% Supplemental Figure 2 - mean flux maps with SAF overlaid

% var_cmaps.fgco2 = %flipud(brewermap(30, 'RdBu'));
% var_cmaps.fgco2 = flipud(brewermap(30, 'RdBu'));
v=9; % plotting fgco2 only
v=1; % try an spCO2 plot as well - should do Summer minus Winter if you are going to plot spCO2 like this.
if v==9
    c_lims = [-25 25];
elseif v==1
    c_lims = [350 450];
end
new_bounds = load([data_dir 'ARGO_O2_Floats/Front_definitions/Gray_5_regions/regional_boundaries_5zone.mat']);
new_bounds.lon_saf_360 = new_bounds.lon_saf;
new_bounds.lon_saf_360(new_bounds.lon_saf_360<0) = new_bounds.lon_saf_360(new_bounds.lon_saf_360<0)+360;
new_bounds.lon_lat_saf_360 = sortrows([new_bounds.lon_saf_360' new_bounds.lat_saf']);

title_size = 7;
for r = 1:2
    
    clf
    set(gcf, 'units', 'inches')
    paper_w = 11; paper_h = 8.5;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
    
    d = NaN(20);
    p_index=0;
    
    if r==1
        first = 1;
        last = 21;
    elseif r==2
        first=22;
        last = length(cmip_names.(variables{v}));
    end
    plot_filename = ['Figure S2_Mean_Surface_' variables{v} '_all_models_' num2str(r)];
    
    
    
    SO_lat_index = CMIP.(variables{v}).lat<=-35;
    [lon_grid, lat_grid] = meshgrid(CMIP.(variables{v}).lon, CMIP.(variables{v}).lat);
    
    CMIP.lon_grid = lon_grid';
    CMIP.lat_grid = lat_grid';
    clear lon_grid lat_grid
    
    
    set(gcf, 'colormap', flipud(brewermap(30, 'RdBu')))
    
    
    %     if r==1
    p_index = p_index+1;
    
    date_index =  C_input.Neur.y2021.Pg_mon.date_vec(:,1)>=2015;
    if v==9
        CC = C_input.Neur.y2021.Pg_mon.SOCCOM_SOCAT(:, SO_lat_index, date_index); % Pg mon-1
        annual_neur = nansum(CC,3)./(size(CC,3)./12); % Pg yr-1
    else
        CC = C_input.Neur.y2021.spco2.SOCCOM_SOCAT(:, SO_lat_index, date_index); % uatm
        annual_neur = nanmean(CC,3);
    end
    
    SO_mean_var_lon_shift = NaN(size(annual_neur,1), size(annual_neur,2), size(annual_neur,3));
    SO_mean_var_lon_shift(1:180, :, :) = annual_neur(181:end,:,:);
    SO_mean_var_lon_shift(181:end, :, :) = annual_neur(1:180,:,:);
    
    if v==9
        SO_mean_var_lon_shift = SO_mean_var_lon_shift./C_input.Neur.y2021.area(SO_lat_index,:)'.*10^15; % g C m-2 yr-1 from Pg C yr-1 ; %
    end
    
    d(p_index) = subplot(5,4,p_index);
    
    pcolor(CMIP.lon_grid(:,SO_lat_index), CMIP.lat_grid(:,SO_lat_index), SO_mean_var_lon_shift); shading flat; %colorbar
    hold on
    
    plot(new_bounds.lon_lat_saf_360(:,1), new_bounds.lon_lat_saf_360(:,2), 'k-', 'linewidth', 2)
    plot([1 360], [poleward_lat_lim poleward_lat_lim], 'k-', 'linewidth',2)
    
    caxis(c_lims)
    title('SOCCOM SOCAT', 'fontsize', title_size)
    set(gca, 'fontsize', 6)
    set(gca, 'ylim', [-80 -35])
    
    %     end
    
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
        
        for dd = [1 num_depths]
            %             clf
            %             set(gcf, 'units', 'inches')
            %             paper_w = 16; paper_h =9;
            %             set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
            %             color_map(parula(70))
            %             set(gcf, 'colormap', var_cmaps.(variables{v}));
            mod_vec = datevec(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).GMT_Matlab);
            time_index = mod_vec(:,1)>=2010 & mod_vec(:,1)<2020;
            
            if num_depths==1
                SO_var = CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, SO_lat_index, time_index);
            else
                SO_var = squeeze(CMIP.(variables{v}).(cmip_names.(variables{v}){m}).(variables{v})(:, SO_lat_index, dd, time_index));
            end
            
            SO_mean_var = nanmean(SO_var,3); % Tg C mon-1
            
            if v==9
                SO_mean_var_gC_m2_yr = SO_mean_var./C_input.Neur.y2021.area(SO_lat_index,:)'.*12.*10^12; % g C m-2 yr-1 from Tg C mon-1
            elseif v==1 % pCO2
                SO_mean_var_gC_m2_yr = SO_mean_var;
            end
            %             subplot(1,1,1)
            d(p_index) = subplot(5,4,p_index);
            
            
            pcolor(CMIP.lon_grid(:,SO_lat_index), CMIP.lat_grid(:,SO_lat_index), SO_mean_var_gC_m2_yr); shading flat
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
            caxis(c_lims)
            set(gca, 'ylim', [-80 -35])
            
            
        end
    end
    %     pause
    print(gcf, '-dpdf', '-r400', [Plot_manus_dir plot_filename plot_ver '.pdf'])
    
    
    if r==1
        c1 = colorbar;
        ylabel(c1, 'g C m^-^2 yr^-^1')
        print(gcf, '-dpdf', '-r400', [Plot_manus_dir plot_filename 'w_colorbar' plot_ver '.pdf'])
    end
    clear SO_var SO_mean_var plot_filename SO_SSS time_index mod_vec
    
end

clear m c1 SO_lat_index paper_h paper_w dd num_depths



%% %%%%% Old code
% %% ingest SOSE data
% % SOSE_dir = [home_dir 'Data/Model_Output/SOSE/2013-2017v2_ITER122/'];
% SOSE_dir = [home_dir 'Data/Model_Output/SOSE/2013-2017v2_ITER122_1_6deg/'];
% SOSE_co2_flux_file = 'bsose_i122_2013to2017_monthly_surfCO2flx.nc';
% SOSE_pco2_file = 'bsose_i122_2013to2017_monthly_pCO2.nc';
%
% SOSE_time = double(ncread([SOSE_dir SOSE_co2_flux_file], 'time'));
% SOSE.Matlab_time = SOSE_time/(60*60*24)+datenum('dec-1-2012')-15; % subtracting 15 days b/c the current time is giving me time stamps at the end of (or after) each month
%
% SOSE.lat = ncread([SOSE_dir SOSE_co2_flux_file], 'YC');
% SOSE.lon = ncread([SOSE_dir SOSE_co2_flux_file], 'XC');
% SOSE.area = ncread([SOSE_dir SOSE_co2_flux_file], 'rA');
%
% SOSE.co2_flux = ncread([SOSE_dir SOSE_co2_flux_file], 'BLGCFLX');
% SOSE.co2_flux_units = 'mol_m-2_s-1_to_ocean';
% SOSE.pco2 = ncread([SOSE_dir SOSE_pco2_file], 'BLGPCO2').*10.^6;
% SOSE.pco2_units = 'uatm';
% SOSE.Pg_mon.co2_flux = SOSE.co2_flux.*-(60.*60.*24.*365./12).*SOSE.area.*12.0107./(10.^15)   ;% mol m-2 s-1 into the ocean to Pg C mon out of the ocean
% SOSE.Pg_mon.co2_flux_units = 'Pg_C_mon-1';
%
% %% ingest CMIP5 model output
% clear CMIP5_input
% CMIP5_dir = [home_dir 'Data/Model_Output/CMIP5/CO2_Fluxes/'];
%
% cmip_files = dir([CMIP5_dir '*.nc']);
% CMIP5_input.Matlab_time = datenum(1990,1:240,15);
%
% load([CMIP5_dir 'masks.mat'])
% cmip_names = cell(length(cmip_files),1);
%
% for f=1:length(cmip_files)
%     if f==1
%         CMIP5_input.lon = ncread([CMIP5_dir cmip_files(f).name], 'longitude');
%         CMIP5_input.lat = ncread([CMIP5_dir cmip_files(f).name], 'latitude');
%         CMIP5_input.area = mask.standard360x180.ocn_area';
%
%     end
%     first_index = strfind(cmip_files(f).name, 'Omon');
%     second_index = strfind(cmip_files(f).name, 'rcp85');
%
%     if ~isempty(strfind(cmip_files(f).name, 'cesm'))  % not using for now
%         var_name = 'FG_CO2';
%         mod_name = 'CESM1_BGC_ens1';
%         adjust = 1; % not actually true, should change to adjust units to match others
%
%     elseif ~isempty(strfind(cmip_files(f).name, 'dic'))  % not using for now
%         var_name = 'dic_stf';
%         mod_name = 'GFDL_ESM2M_ens1';
%         adjust = 1; % not actually true, should change to adjust units to match others
%     elseif  ~isempty(strfind(cmip_files(f).name, 'Can'))
%         % CANESM units are in Kg CO2 not Kg C
%         var_name = 'fgco2';
%         mod_name = cmip_files(f).name(first_index+5:second_index-2);
%         mod_name = strrep(mod_name, '-', '_');
%         adjust = 12/32; % 12kg C / 32kg CO2
%     else
%         var_name = 'fgco2';
%         mod_name = cmip_files(f).name(first_index+5:second_index-2);
%         mod_name = strrep(mod_name, '-', '_');
%         adjust = 1;
%     end
%
%     CMIP5_input.(mod_name).co2_flux = ncread([CMIP5_dir cmip_files(f).name], var_name).*adjust;
%     CMIP5_input.(mod_name).units = ncreadatt([CMIP5_dir cmip_files(f).name], var_name, 'units');
%     cmip_names{f} = mod_name;
% end
%
% %% CMIP5 models into Pg C mon-1
% s_per_year = 3600*24*365;
% Pg_per_kg = 1e-12;
%
%
% scale_factor = -s_per_year.*Pg_per_kg./12;  % kg m2 s-1 into the ocean to Pg C m-2 mon out of the ocean
%
%
% for f = 1:length(cmip_names)
%
%     CMIP5_input.(cmip_names{f}).Pg_mon.co2_flux = CMIP5_input.(cmip_names{f}).co2_flux.*scale_factor.*CMIP5_input.area;
%
% end
%
%
% %% ESM2M SO CO2 flux analysis
%
% model_dir = '/Users/sb17/Documents/Data/Model_Output/MOM5/temp_output_Suki_non_bubble/';
%
% surf_flux_file = 'ocean_topaz_a_fluxes.201101-202012.dic_stf.nc';
%
%
% surf_flux.co2_flux = ncread([model_dir surf_flux_file], 'dic_stf');
% surf_flux.co2_flux_units = 'mol_m2_s-1';
%
% % surf_flux.lat_grid = ncread([model_dir surf_flux_file], 'geolat_t');
% surf_flux.lat = ncread([model_dir surf_flux_file], 'yt_ocean');
%
%
% % surf_flux.lon_grid = ncread([model_dir surf_flux_file], 'geolon_t');
% surf_flux.lon = ncread([model_dir surf_flux_file], 'xt_ocean');
% % surf_flux.lon_grid = ncread([model_dir surf_flux_file], 'geolon_t');
%
% surf_flux.area = ncread([model_dir '../bubble_one_day_test/00010101.ocean_static.nc'], 'area_t');
% surf_flux.area_units = 'm2';
% surf_flux.time = ncread([model_dir surf_flux_file], 'time');
% surf_flux.time_Matlab = surf_flux.time + datenum('2006-01-01');
%
% %% in Pg C
% surf_flux.Pg_mon.co2_flux = surf_flux.co2_flux.*-12.0107./12./(10.^15).*surf_flux.area.*60*60*24*365; % Pg mon-1 out of the ocean from mol m-2 s-1 into the ocean
% surf_flux.Pg_mon.units = 'Pg_C_mon-1';
%
% %% calculate mean months
% temp_vector = datevec(surf_flux.time_Matlab);
%
% surf_flux.annual = NaN(size(surf_flux.co2_flux,1), size(surf_flux.co2_flux,2),12);
% for m = 1:12
%     date_index = temp_vector(:,2)==m;
%     surf_flux.annual(:,:,m) = nanmean(surf_flux.co2_flux(:,:,date_index),3); % mol/m2/sec into the ocean
%
%     clear date_index
% end
%
% surf_flux.annual_units = ' mol_m2_sec';
% clear temp_vector
%
% %% Areal plot compared to landschutzer
% % annual mean
% neural_dir = [home_dir 'Data/Data_Products/CO2_fluxes/Landshuster_Neural/2018_08_30/'];
% load([neural_dir 'neural_network_results_v2.mat'])
% %% Line plots of appropriate zonal sum vs. lat
% clear zonal_flux
%
% runs = {'SOCCOM_only', 'SOCCOM_SOCAT', 'SOCAT_only'};
%
% model_type = {'Neural_Network'; 'Jena_Interp'; 'SOSE'; 'ESM2M'};
% sub_plot_lats = [-62 -45];
%
%
% model_type = [model_type ; cmip_names];
% for mod = [1 3 4:length(model_type)]
%     if mod>=3
%         r_max = 1;
%     else
%         r_max=3;
%     end
%     for r=1:r_max
%
%         if mod==1
%
%             monthly_time_rec = Neur_input.time_Matlab;
%             lat_vec = Neur_input.lat;
%             co2_flux_Pg_mon_lon_lat_time = Neur_input.Pg_mon.(runs{r});
%             title_text = [model_type{mod} '_' runs{r}];
%             box_height = Neur_input.lat(2) - Neur_input.lat(1); % latitude box height in degrees.  For seting flux equal to flux / deg lat.
%             start_date = datenum('Jan-1-2014');
%             end_date = datenum('dec-15-2017');
%         elseif mod==2
%             monthly_time_rec = Jena_input.Pg_mon.time_Matlab;
%             lat_vec = Jena_input.lat;
%             co2_flux_Pg_mon_lon_lat_time = Jena_input.Pg_mon.(runs{r});
%             title_text = [model_type{mod} '_' runs{r}];
%             box_height = Jena_input.lat(2) - Jena_input.lat(1); % latitude box height in degrees.  For seting flux equal to flux / deg lat.
%             start_date = datenum('Jan-1-2014');
%             end_date = datenum('dec-15-2017');
%         elseif mod==3
%             monthly_time_rec = SOSE.Matlab_time;
%             lat_vec = SOSE.lat;
%             co2_flux_Pg_mon_lon_lat_time = SOSE.Pg_mon.co2_flux;
%             title_text = [model_type{mod} '_iter122'];
%             box_height = diff(SOSE.lat); % latitude box height in degrees.  For seting flux equal to flux / deg lat.
%             box_height = [box_height(1) ; box_height];
%             start_date = datenum('Jan-1-2014');
%             end_date = datenum('dec-15-2017');
%         elseif mod==4
%             monthly_time_rec = surf_flux.time_Matlab;
%             lat_vec = surf_flux.lat;
%             co2_flux_Pg_mon_lon_lat_time = surf_flux.Pg_mon.co2_flux;
%             title_text = 'ESM2M RCP 8.5';
%             box_height =  diff(surf_flux.lat); % latitude box height in degrees.  For seting flux equal to flux / deg lat.
%             box_height = [box_height(1) ; box_height];
%             start_date = datenum('Jan-1-2014');
%             end_date = datenum('dec-15-2017');
%
%         elseif mod>4
%             monthly_time_rec = CMIP5_input.Matlab_time;
%             lat_vec = CMIP5_input.lat;
%             co2_flux_Pg_mon_lon_lat_time = CMIP5_input.(model_type{mod}).Pg_mon.co2_flux;
%             title_text = model_type{mod};
%             box_height =  diff(lat_vec); % latitude box height in degrees.  For seting flux equal to flux / deg lat.
%             box_height = [box_height(1) ; box_height];
%             start_date = datenum('Jan-15-1995');
%             end_date = datenum('dec-15-2009');
%         end
%
%         start_index = find(min(abs(monthly_time_rec - start_date)) == abs(monthly_time_rec - start_date));
%         end_index = find(min(abs(monthly_time_rec - end_date)) == abs(monthly_time_rec - end_date));
%         out_array = NaN(end_index - start_index+1, length(lat_vec));
%         mon_index = 0;
%         for m = start_index:end_index
%             mon_index = mon_index+1;
%             temp_month = co2_flux_Pg_mon_lon_lat_time(:,:,m);
%             zonal_sum = nansum(temp_month,1)';
%             %     cumul_sum = nancumsum(zonal_sum);
%
%
%             out_array(mon_index,:) = zonal_sum;
%         end
%
%         lat_range_map = out_array;
%         lat_range_map(:, lat_vec>sub_plot_lats(2) | lat_vec<sub_plot_lats(1)) = nan;
%         lat_range_map_sum = nansum(lat_range_map,2);
%         %         lat_range_map_std = nanstd(lat_range_map');
%
%         if mod==1 || mod==2
%             zonal_flux.([model_type{mod} '_' runs{r}]).lat_sum(:,1) = lat_range_map_sum;
%             %             zonal_flux.([model_type{mod} '_' runs{r}]).lat_sum(:,2) = lat_range_map_std';
%         else
%             zonal_flux.([model_type{mod}]).lat_sum(:,1) = lat_range_map_sum;
%             %             zonal_flux.([model_type{mod}]).lat_sum(:,2) = lat_range_map_std;
%         end
%     end
% end
%
%
% %%
% zonal_fields = fieldnames(zonal_flux);
% for z = 1:length(zonal_fields)
%
%
%     for m=1:12
%
%         zonal_flux.(zonal_fields{z}).annual= NaN(12,2);
%
%     end
%
%     for m=1:12
%
%         zonal_flux.(zonal_fields{z}).annual(m,1)= nanmean(zonal_flux.(zonal_fields{z}).lat_sum(m:12:end)).*1000; % Pg to Tg
%         zonal_flux.(zonal_fields{z}).annual(m,2)= nanstd(zonal_flux.(zonal_fields{z}).lat_sum(m:12:end)).*1000; % Pg to Tg
%
%     end
%
% end
%
%
% %%
% plot_filename = 'NN plus all models';
% font_size = 14;
%
% clf
% set(gcf, 'units', 'inches')
% paper_w = 12; paper_h =8;
% set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
%
% subplot(1,1,1)
% hold on
% clear p
% plot_names = [];
% plot_colors = NaN(length(zonal_fields),3);
% cmap = distinguishable_colors(length(zonal_fields));
%
% plot_index = 0;
% plot([0 12.5],[0 0], 'k-')
% match_NN =[6 8 9 11 12];
% inverse_NN = [4 7 10 16];
% other_NN = [5 13 14 15];
%
% for z = 4:length(zonal_fields)
%     plot_index = plot_index+1;
%     annual_mean = zonal_flux.(zonal_fields{z}).annual(:,1);
%     seasonal_anomaly = annual_mean - nanmean(annual_mean);
%     p(plot_index) = plot(1:12,  seasonal_anomaly);
%     set(p(plot_index), 'color', cmap(z,:));
%     clear annual_mean seasonal_anomaly
%     plot_names{plot_index} = zonal_fields{z};
%     plot_colors(z,:) = get(p(plot_index), 'color');
%
% end
%
% z=2;
% annual_mean = zonal_flux.(zonal_fields{z}).annual(:,1);
% seasonal_anomaly = annual_mean - nanmean(annual_mean);
% p0 = plot(1:12,  seasonal_anomaly);
% set(p0, 'linewidth', 5, 'color', 'k', 'linestyle', '--')
%
% legend([p p0], [plot_names  'NN - SOCCOM + SOCAT'], 'location', 'eastoutside', 'interpreter', 'none')
%
% set(p, 'linewidth', 2)
%
% clear annual_mean seasonal_anomaly
% xlabel('Month')
% ylabel('Zonal integral flux anomaly (Tg C mon^-^1)')
% set(gca, 'fontsize', font_size, 'ylim', [-150 170])
%
% print(gcf,'-dpng', [Plot_out_dir plot_filename '.png'])
%
% %% Look at wintertime peak or trough in outgassing relative to latitude
% plot_filename = 'CMIP_zonal_integrated_flux_all_months';
% model_vec = datevec(CMIP5_input.Matlab_time);
% months_match = [5:10];
% winter_index = model_vec(:,2)==months_match & model_vec(:,1)>1999;
% winter_index = sum(winter_index,2)==1;
% clf
%
% set(gcf, 'units', 'inches')
% paper_w = 12; paper_h =8;
% set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
%
% d1 =subplot(1,1,1);
% hold on
% % d2 = subplot(2,1,2);
% % hold on
% clear p_cmip
% plot_index = 0;
%
% for f = 1:length(cmip_names)
%     plot_index = plot_index+1;
%
%     AA = CMIP5_input.(cmip_names{f}).Pg_mon.co2_flux(:,CMIP5_input.lat<-35,winter_index');
%     BB = squeeze(nansum(AA,1));
%     CC = nanmean(BB,2);
%
%
%     CMIP5_input.(cmip_names{f}).AA = AA;
%     CMIP5_input.(cmip_names{f}).BB = BB;
%     CMIP5_input.(cmip_names{f}).CC = CC;
%
%
%
%     p_cmip(plot_index) =plot(d1, CC, CMIP5_input.lat(CMIP5_input.lat<-35), 'color', cmap(find(strcmp(zonal_fields, cmip_names{f})),:),...
%         'linewidth', 2);
%
%     %     plot(d2, nancumsum(CC),  CMIP5_input.lat(CMIP5_input.lat<-35))
% end
%
% SOSE_vec = datevec(SOSE.Matlab_time);
% winter_index_SOSE  = SOSE_vec(:,2)==months_match;
% winter_index_SOSE = sum(winter_index_SOSE,2)==1;
% AA = SOSE.Pg_mon.co2_flux(:,SOSE.lat<-35, winter_index_SOSE');
% BB = squeeze(nansum(AA,1));
% CC = nanmean(BB,2);
% p_sose = plot(d1, CC./diff(SOSE.lat(SOSE.lat<-34.9)), SOSE.lat(SOSE.lat<-35),  'color', cmap(find(strcmp(zonal_fields, 'SOSE')),:),...
%     'linewidth', 2);
% %
% ESM2M_vec = datevec(surf_flux.time_Matlab);
% winter_index_ESM2M  = ESM2M_vec(:,2)==months_match;
% winter_index_ESM2M = sum(winter_index_ESM2M,2)==1;
% AA = surf_flux.Pg_mon.co2_flux(:,surf_flux.lat<-35, winter_index_ESM2M');
% BB = squeeze(nansum(AA,1));
% CC = nanmean(BB,2);
% p_ESM2M = plot(d1, CC, surf_flux.lat(surf_flux.lat<-35),  'color', cmap(find(strcmp(zonal_fields, 'ESM2M')),:),...
%     'linewidth', 2);
%
% NN_vec = datevec(Neur_input.time_Matlab);
% winter_index_NN  = NN_vec(:,2)==months_match & NN_vec(:,1)>2014;
% winter_index_NN = sum(winter_index_NN,2)==1;
% AA = Neur_input.Pg_mon.SOCCOM_SOCAT(:,Neur_input.lat<-35, winter_index_NN');
% BB = squeeze(nansum(AA,1));
% CC = nanmean(BB,2);
% p_neur = plot(d1, CC, Neur_input.lat(Neur_input.lat<-35),  'color', 'k',...
%     'linewidth', 4, 'linestyle', '--');
%
% load([home_dir 'Data/ARGO_O2_Floats/Front_definitions/Gray_5_regions/regional_boundaries_5zone_SMB.mat']);
%
% p(1) = plot(d1, 0.012, nanmean(five_region_bounds.lat_pf));
% p(2) = plot(d1, 0.012, nanmax(five_region_bounds.lat_pf)) ;
% p(3) = plot(d1, 0.012, nanmin(five_region_bounds.lat_pf(five_region_bounds.lat_pf>-85) )) ;
%
% set(p(1), 'marker', 's', 'color', 'k')
% set(p(2), 'marker', 's', 'color', 'k')
% set(p(3), 'marker', 's', 'color', 'k')
%
% clear annual_mean seasonal_anomaly
% xlabel('Zonally integrated flux (Pg C mon^-^1)')
% ylabel('Latitude (\circC)')
% set(gca, 'fontsize', 18, 'xlim', [-.014 0.011], 'ylim', [-80 -35])
%
%
% % print(gcf,'-dpng', [Plot_out_dir plot_filename '.png'])
%
% legend([p_cmip p_sose p_ESM2M p_neur], [cmip_names'  'SOSE' 'ESM2M' 'NN - SOCCOM + SOCAT'], 'location', 'eastoutside', 'interpreter', 'none')
%
% title(['Zonal mean, months: ' num2str(months_match)])
%
% print(gcf,'-dpng', [Plot_out_dir plot_filename 'months ' num2str(months_match) '_legend.png'])
%
%
% %% Mercator projection maps for comparison to Mongwe et al. 2018
%
% for z = 1:3%length(zonal_fields)
%
%     if z<4
%         r =find(strcmp(runs, zonal_fields{z}(16:end)));
%     end
%
%     clf
%     set(gcf, 'units', 'inches')
%     paper_w = 16; paper_h =9;
%
%     color_map = brewermap(30, 'RdBu');
%     color_map = flipud(color_map);
%     set(gcf, 'colormap', color_map)
%     coast = load('coast');
%     set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
%     boundary_width=1.5;
%
%     ph = NaN(12,1);
%     load([home_dir 'Data/ARGO_O2_Floats/Front_definitions/Gray_5_regions/regional_boundaries_5zone.mat']);
%     data_comparison = {'SOCCOM only' 'SOCAT + SOCCOM' ; ...
%         'SOCAT + SOCCOM' 'SOCAT only'};
%
%     runs = {'SOCCOM_only', 'SOCCOM_SOCAT', 'SOCAT_only'};
%     %
%     esm2m_base_scaling = -1.*60.*60.*24*365; %mol/m2/yr from mol/m2/sec into the ocean
%     % SECONDS_IN_YEAR = 60*60*24*365;
%
%     plot_filename = ['Mercator_Neural_network_' zonal_fields{z} ];
%
%     for q = 1:3
%         if q==1
%             months_match = 1:12;
%         elseif q==2
%             months_match = 5:10;
%
%         elseif q==3
%             months_match =[11 12 1 2 3 4];
%         end
%         if z<4
%             time_vec = datevec(Neur_input.recent.time_Matlab);
%             min_year = 2014;
%             data_orig = Neur_input.recent.(runs{r});  % mol m-2 yr-1 to atmos
%
%             model_lat = Neur_input.lat;
%             model_lon = Neur_input.lon;
%
%         elseif z==4 % SOSE
%             time_vec = datevec(SOSE.Matlab_time);
%             data_orig = SOSE.co2_flux.*60*60*24*365*-1; % mol m-2 yr-1 to atmos from mol m-2 s-1 to ocean
%             min_year = 2010;
%
%             model_lat = SOSE.lat;
%             model_lon = SOSE.lon;
%
%         elseif z==5 %ESM2M
%             time_vec = datevec(surf_flux.time_Matlab);
%             data_orig = surf_flux.co2_flux.*60*60*24*365*-1; % mol m-2 yr-1 to atmos from mol m-2 s-1 to ocean
%             min_year = 2010;
%
%             model_lat = surf_flux.lat;
%             model_lat(end) = model_lat(end)-0.1;
%             model_lon = surf_flux.lon;
%
%             model_lon(model_lon<-180) = model_lon(model_lon<-180)+360;
%         else % CMIP5 models
%             s_per_year = 3600*24*365;
%
%
%             scale_factor = -s_per_year.*1000*1/12.0107;  % kg m2 s-1 into the ocean to mol m-2 yr-1 out of the ocean
%
%
%             time_vec = datevec(CMIP5_input.Matlab_time);
%             data_orig = CMIP5_input.(zonal_fields{z}).co2_flux.*scale_factor; % mol m-2 yr-1 to atmos from kg m2 s-1 into the ocean
%             min_year = 1999;
%
%             model_lat = CMIP5_input.lat;
%             model_lon = CMIP5_input.lon;
%
%         end
%
%         R = georasterref('RasterSize', [length(model_lat) length(model_lon)], 'RasterInterpretation', 'Cells', ...
%             'LatitudeLimits', [min(model_lat)-.5 max(model_lat)+.5], 'LongitudeLimits', [min(model_lon)-.5 max(model_lon)+.5]);
%
%         month_index_NN  = time_vec(:,2)==months_match & time_vec(:,1)>=min_year;
%         month_index_NN = sum(month_index_NN,2)==1;
%
%         data1 = nanmean(data_orig(:,:,month_index_NN),3)';
%
%         data1 = data1.*12.0107; % g C m-2 yr-1;
%
%
%         ph(1) = subplot(3,1,q);
%
%         % Creates a polar stereographic plot with the origin and bounds below
%         % axesm('Mercator','Origin',[-90 0],'MapLatLimit',[-90 -34], 'FFaceColor', [.9 .9 .9])
%         A1 = axesm('Mercator', 'FFaceColor', [.9 .9 .9], 'MapLatLimit',[-80 -30]);
%
%         if q==3
%             axis off; framem on; gridm on; mlabel on; plabel on;
%
%         else
%             axis off; framem on; gridm on; mlabel off; plabel on;
%
%         end
%         setm(gca,'MLabelParallel',-80, 'fontsize', 12)
%         hold on
%
%
%         temp_output = data1;
%         temp_output(isnan(temp_output))=0;
%         meshm(temp_output, R)
%
%
%         geoshow(coast.lat,coast.long,'DisplayType','polygon', 'facecolor', [.5 .5 .5])
%         clear temp_output
%         set(ph(1), 'clim', [-30 30])
%         geoshow(gca, lat_siz, lon_siz, 'displaytype', 'line', 'linewidth', boundary_width, 'color', 'k') % Seasonal Ice Zone
%         geoshow(gca, lat_pf, lon_pf, 'displaytype', 'line', 'linewidth', boundary_width, 'color', 'k') % polar front
%         geoshow(gca, lat_saf, lon_saf, 'displaytype', 'line', 'linewidth', boundary_width, 'color', 'k') % Subantarctic Front
%         geoshow(gca, lat_stf, lon_stf, 'displaytype', 'line', 'linewidth', boundary_width, 'color', 'k') % Subtropical Front
%
%         c1 = colorbar;
%         if q==2
%             ylabel(c1, 'Sea-Air Flux: g C m^-^2 yr^-^1')
%
%             cb_pos = get(c1, 'position');
%         end
%         set(c1, 'fontsize', 18)
%
%         set(gca, 'color', [.5 .5 .5]);
%         t1 = title( [zonal_fields{z} ' months: ' num2str(months_match)], 'interpreter', 'none', 'fontsize', 20);
%         t_pos = get(t1, 'position');
%
%         clear data1 time_vec data_orig min_year model_lat model_lon
%     end
%
%
%     saveas(gcf, [Plot_out_dir plot_filename], 'png')
%
% end