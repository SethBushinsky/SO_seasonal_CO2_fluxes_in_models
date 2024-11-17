% Plotting code for Bushinsky et al. CMIP SO Flux comparison paper (to be
% titled)

%%
script_name = 'Bushinsky_et_al_CMIP_model_eval_figure_plotting.m';
fig_dir = [home_dir 'Work/Manuscripts/2019_06 SO CMIP Comparison/figures/'];

% load processed data:
% seasonal_file = 'seasonal_cycles_w_model_type_matched_2023_10_23.mat';
% seasonal_file = 'seasonal_cycles_w_model_type_matched_2023_11_07.mat';
% seasonal_file = 'seasonal_cycles_w_model_type_matched_2024_02_28.mat';
% seasonal_file = 'seasonal_cycles_w_model_type_matched_2024_04_07.mat';
seasonal_file = 'seasonal_cycles_w_model_type_matched_2024_10_28.mat';
load([fig_dir '../data/' seasonal_file])
seas_comp_vars = fieldnames(obs);

toy_model_file = 'toy_model_output_2024_10_10.mat';
load([fig_dir '../data/' toy_model_file])
sensitivity_results = 'sensitivity_test_results2024_10_10.mat';
load([fig_dir '../data/' sensitivity_results])

c_input_file = 'Carbon_mapped_product_analysis_output_2024_04_15.mat';
load([fig_dir '../data/' c_input_file])


%% matching variable names to names for printing:

var_plot_names = {'tos'  'SST' '\circC' ;
    'dissic' 'DIC' '\mumol l^-^1';
    'spco2' 'pCO_2' '\muatm' ;
    'fgco2' 'CO_2 flux' 'mol C m^-^2 yr^-^1' ;
    'mlotst' 'MLD' 'm';
    'intpp' 'NPP_{int}' 'mg C m^-^2 d^-^1';
    'mld' 'MLD' 'm';
    'talk' 'TA' '\mueq l^-^1';
    'sos' 'SSS' ''};

month_names = {'January' 'February' 'March' 'April' 'May' 'June' 'July' 'August' 'September' 'October' 'November' 'December'};
% set GISS (6) to a different color for clarity:
cmap(50,:) = cmap(14,:);
%% Figure 1 option 3 - Annual / Summer / winter / seasonal integral
% years = C_input.years;
% product_names = C_input.product_names;
% run_names = C_input.run_names;
% runs = C_input.runs;
% regions = C_input.regions;
% p_year = 'y2023';
% 
% p = 3;
% 
% 
% lat_index = C_input.(product_names{p}).(p_year).lat>=-80 & C_input.(product_names{p}).(p_year).lat<=-35;
% 
% % save SOCAT_only, SOCCOM_SOCAT into temp_array
% obs_flux_array = NaN(3, sum(lat_index), 12);
% obs_pCO2_array = NaN(3, sum(lat_index), 12);
% 
% for q = 1:2
%     for mon = 1:12
%         date_index = C_input.(product_names{p}).(p_year).Pg_mon.date_vec(:,2)==mon & C_input.(product_names{p}).(p_year).Pg_mon.date_vec(:,1)>=2010 & C_input.(product_names{p}).(p_year).Pg_mon.date_vec(:,1)<=2019;
%         CC = C_input.(product_names{p}).(p_year).Pg_mon.(runs{q})(:, lat_index, date_index).*1000; % Pg mon-1 to Tg mon-1
%         DD = nanmean(CC,3);
%         EE = nansum(DD,1);
% 
%         obs_flux_array(q, :, mon) = EE'; % Tg Mon-1
% 
%         CC = C_input.(product_names{p}).(p_year).spco2.(runs{q})(:, lat_index, date_index); % fCO2 currently for Neural Network, needs to be fixed
%         DD = nanmean(CC,3);
%         EE = nanmean(DD,1);
% 
%         obs_pCO2_array(q, :, mon) = EE'; % Tg Mon-1
% 
% 
%     end
% end
% 
% % difference goes into the 3rd index
% obs_flux_array(3,:,:) = obs_flux_array(2, :, :) - obs_flux_array(1, :, :);
% clear EE CC DD date_index mon q lat_index
% 
% 
% new_bounds = load([data_dir 'ARGO_O2_Floats/Front_definitions/Gray_5_regions/regional_boundaries_5zone.mat']);
% new_bounds.lon_saf_360 = new_bounds.lon_saf;
% new_bounds.lon_saf_360(new_bounds.lon_saf_360<0) = new_bounds.lon_saf_360(new_bounds.lon_saf_360<0)+360;
% new_bounds.lon_lat_saf_360 = sortrows([new_bounds.lon_saf_360' new_bounds.lat_saf']);
% p = 3;
% 
% plot_filename = ['Figure 1_ ' product_names{p} 'annual_summer_winter_integral_flux' plot_ver];
% 
% title_size = 13;
% clf
% set(gcf, 'units', 'inches')
% paper_w = 15; paper_h = 8.5;
% set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);
% 
% d = NaN(20);
% orig_position = NaN(8,4);
% p_index=0;
% 
% v = 9;
% SO_lat_index = CMIP.(variables{v}).lat<=-35;
% [lon_grid, lat_grid] = meshgrid(CMIP.(variables{v}).lon, CMIP.(variables{v}).lat);
% 
% CMIP.lon_grid = lon_grid';
% CMIP.lat_grid = lat_grid';
% clear lon_grid lat_grid
% 
% axis_font_size = 10;
% 
% set(gcf, 'colormap', flipud(brewermap(30, 'RdBu')))
% 
% c_lims = [-.05 .05];
% % save out data for plotting in python instead
% flux_out = [];
% for q = 1:2
%     flux_out.(runs{q}) = NaN(3, 360, 55);
%     seasons = {'Annual', 1:12; 'Summer', [12 1 2]; 'Winter' [6 7 8]};
%     for s = 1:size(seasons,1)
%         p_index = p_index+1;
% 
%         d(p_index) = subplot(2,4,p_index);
% 
%         date_index =  sum(C_input.(product_names{p}).(p_year).date_vec(:,1)>=2010 & ...
%             C_input.(product_names{p}).(p_year).date_vec(:,1)<=2019 & ...
%             C_input.(product_names{p}).(p_year).date_vec(:,2)==seasons{s,2},2)>0;
%         CC = C_input.(product_names{p}).(p_year).Pg_mon.(runs{q})(:, SO_lat_index, date_index); % mol m-2 yr-1
%         avg_neur = nanmean(CC,3).*10^3; % mol m-2 yr-1 or Tg C mon-1
% 
%         SO_mean_var_lon_shift = NaN(size(avg_neur,1), size(avg_neur,2), size(avg_neur,3));
%         SO_mean_var_lon_shift(1:180, :, :) = avg_neur(181:end,:,:);
%         SO_mean_var_lon_shift(181:end, :, :) = avg_neur(1:180,:,:);
% 
%         % if v==9
%         %     SO_mean_var_lon_shift = SO_mean_var_lon_shift./C_input.Neur.(p_year).area(SO_lat_index,:)'.*10^15; % g C m-2 yr-1 from Pg C yr-1 ; %
%         % end
% 
% 
%         pcolor(CMIP.lon_grid(:,SO_lat_index), CMIP.lat_grid(:,SO_lat_index), SO_mean_var_lon_shift); shading flat; %colorbar
%         hold on
%         flux_out.(runs{q})(s,:,:) = SO_mean_var_lon_shift;
%         flux_out.lon_grid = CMIP.lon_grid(:,SO_lat_index);
%         flux_out.lat_grid = CMIP.lat_grid(:,SO_lat_index);
%         plot(new_bounds.lon_lat_saf_360(:,1), new_bounds.lon_lat_saf_360(:,2), 'k-', 'linewidth', 2)
%         plot([1 360], [poleward_lat_lim poleward_lat_lim], 'k-', 'linewidth',2)
% 
%         orig_position(p_index,:) = get(gca, 'position');
%         if q==2 && s==2
% 
%             c1 = colorbar('location', 'southoutside');
%             ylabel(c1, 'Tg C mon^-^1 \circLat^-^1');
%         end
%         caxis(c_lims)
%         title(seasons{s,1}, 'fontsize', title_size)
%         set(gca, 'fontsize', axis_font_size)
%         set(gca, 'ylim', [-80 -35])
%     end
% 
%     p_index = p_index+1;
% 
%     d(p_index) = subplot(2,4,p_index);
%     lat_index = C_input.(product_names{p}).(p_year).lat>=-80 & C_input.(product_names{p}).(p_year).lat<=-35;
% 
%     lat_x = CMIP.(variables{v}).lat(lat_index);
%     lat_lab = repmat(lat_x, 1, 12);
% 
%     mon_lab = repmat(1:12, length(lat_lab),1);
% 
%     d(p_index) = subplot(2,4,p_index);
% 
%     pcolor(mon_lab, lat_lab, squeeze(obs_flux_array(q,:,:))); shading flat
%     caxis([-10 10])
%     c(q) = colorbar;
% 
%     set(gca, 'fontsize', axis_font_size)
%     ylabel(d(1), 'Latitude')
%     ylabel(c(q), 'Tg C mon^-^1 \circLat^-^1')
%     title([runs{q}], 'interpreter', 'none')
% 
% end
% xlabel(d(4), 'Months');  xlabel(d(8), 'Months')
% 
% 
% set(d(6), 'position', orig_position(6,:));
% 
% % print(gcf, '-dpng', [fig_dir plot_filename '.png'])
% print(gcf, '-dpdf',  '-r300',[fig_dir plot_filename '.pdf'])
% save([home_dir 'Work/Manuscripts/2019_06 SO CMIP Comparison/data/fig_1_flux_output.mat'], ...
%     'flux_out', 'mon_lab', 'lat_lab', 'obs_flux_array', 'plot_ver')
% 
% 
% clear d c mon_lab lat_lab lat_x lat_index p_index SO_lat_index SO_mean_lon_shift avg_neur CC date_index c_lims title_size q s v p paper_h paper_w

%% Figure 2 - Plotting 4 variable seasonal cycles
% cmap = distinguishable_colors(20);

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
    anomaly_text = 'anomaly';
else
    anomaly_text=[];
end

plot_filename = ['Figure 2_v4 Obs model Seasonal ' anomaly_text ' fgco2 spco2 dic tos ' plot_ver];
clf
set(gcf, 'units', 'inches')
paper_w = 12; paper_h =10;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

plot_index = 0;
d = NaN(8,1);
for sv = [8 6 4 1]

    v = find(strncmp(seas_comp_vars{sv}, variables, 4));
    if length(v)>1 % cludge since dissic and dissic_yr were getting confused
        v = strmatch(seas_comp_vars{sv}, variables, 'exact');
    end
    if sv==8 %|| sv==6
        max_rel_amp = 7;
    elseif sv==6
        max_rel_amp = 3.5;
    else
        max_rel_amp = 2.5;
    end
    plot_index = plot_index+1;

    d(plot_index) = subplot(4,3,plot_index);
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
                plot(1:12, CMIP.(variables{v}).out_seasonal_mol_C_m2_yr(m,:,1) - nanmean(CMIP.(variables{v}).out_seasonal_mol_C_m2_yr(m,:,1)), 'color', [cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:) .5], 'linewidth', 3);
            else
                plot(1:12, CMIP.(variables{v}).out_seasonal(m,:,1)-nanmean(CMIP.(variables{v}).out_seasonal(m,:,1)), 'color', [cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:) .5], 'linewidth', 3);
            end
        else
            plot(1:12, CMIP.(variables{v}).out_seasonal(m,:,1), 'color', [cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:) .5], 'linewidth', 3);

        end

        legend_names{end+1,1} = cmip_names.(variables{v}){m};
    end

    if v==9 || v==1
        if anomaly==1
            % e1 = errorbar(1:12, obs.(seas_comp_vars{sv}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,1)- ...
            %     nanmean( obs.(seas_comp_vars{sv}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,1)), ...
            %     obs.(seas_comp_vars{sv}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 4, 'color', 'k', 'linestyle', '-.');
             e1 = plot(1:12, obs.(seas_comp_vars{sv}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,1)- ...
                nanmean( obs.(seas_comp_vars{sv}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,1)), ...
                'linewidth', 4, 'color', 'k', 'linestyle', '-.');
            
        else
            % e1 = errorbar(1:12, obs.(seas_comp_vars{sv}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,1), ...
            %     obs.(seas_comp_vars{sv}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 4, 'color', 'k', 'linestyle', '-.');
         e1 = plot(1:12, obs.(seas_comp_vars{sv}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,1), ...
                 'linewidth', 4, 'color', 'k', 'linestyle', '-.');
     
        end
    else
        if anomaly==1
            e1 = plot(1:12, obs.(seas_comp_vars{sv}).out_seasonal(:,1) - ...
                nanmean(obs.(seas_comp_vars{sv}).out_seasonal(:,1)), 'linewidth', 4, 'color', 'k', 'linestyle', '-.');
        else
            e1 = plot(1:12, obs.(seas_comp_vars{sv}).out_seasonal(:,1), 'linewidth', 4, 'color', 'k', 'linestyle', '-.');
        end
    end

    var_label_index = strncmp(seas_comp_vars{sv}, var_plot_names(:,1), 4);
    if sum(var_label_index>0)
        ylabel(var_plot_names{var_label_index,3})
        %         t1 = title(var_plot_names{var_label_index,2});
        %         old_t1_pos = t1.Position;
        %         set(d(plot_index), t1.Position, old_t1_pos+[8 0 0])

    else
        ylabel([seas_comp_vars{sv} ' ' anomaly_text ' (' (CMIP.(variables{v}).(cmip_names.(variables{v}){1}).units) ')'], 'interpreter', 'none')
        title(seas_comp_vars{sv}, 'interpreter', 'none')

    end

   
    %     l1 = legend([legend_names ; 'Obs'], 'interpreter', 'none', 'location', 'eastoutside');
    set(gca, 'fontsize', 12, 'xlim', [1 12])
    %     set(l1, 'fontsize', 9)
    y_lims = get(gca, 'ylim');
    
    % if sv==1
    %     text(-2, y_lims(2)+diff(y_lims)*-.08, [var_plot_names{var_label_index,2} ':'], 'fontweight', 'bold', 'fontsize', 14)
    % elseif sv==4
    %     text(-2, y_lims(2)+diff(y_lims)*.28, [var_plot_names{var_label_index,2} ':'], 'fontweight', 'bold', 'fontsize', 14)
    % elseif sv==6
    %     text(-2, y_lims(2)+diff(y_lims)*.24, [var_plot_names{var_label_index,2} ':'], 'fontweight', 'bold', 'fontsize', 14)
    % else
    %     text(-2, y_lims(2)+diff(y_lims)*.22, [var_plot_names{var_label_index,2} ':'], 'fontweight', 'bold', 'fontsize', 14)
    % end
    if plot_index==1
        title(['a. ' var_plot_names{var_label_index,2} ' seasonal anomaly'])
    elseif plot_index==4
        title(['b. ' var_plot_names{var_label_index,2} ' seasonal anomaly'])
    elseif plot_index==7
        title(['c. ' var_plot_names{var_label_index,2} ' seasonal anomaly'])
    elseif plot_index==10
        title(['d. ' var_plot_names{var_label_index,2} ' seasonal anomaly'])
    end
    set(gca, 'titlehorizontalalignment', 'left')
    if plot_index==10
        xlabel('Month')
    end
    plot_index = plot_index+1;

    % Plotting taylor diagrams
    subplot(4,3,plot_index)
    legend_on = 0;

    rms_cutoff_for_good = .75;
    out_of_phase_corr_cutoff = 0;


    correlation_std = std(obs.(seas_comp_vars{sv}).annual.correlation,1,2, 'omitnan');
    ratio_std = std(obs.(seas_comp_vars{sv}).annual.ratio,1,2, 'omitnan');

    if ~isempty(strfind(seas_comp_vars{sv}, 'fgco2'))
        % taylor_dist_smb_for_manuscript(obs.(seas_comp_vars{sv}).correlation, obs.(seas_comp_vars{sv}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, ...
        %     rms_cutoff_for_good, out_of_phase_corr_cutoff, max_rel_amp);


        taylor_dist_smb_for_manuscript_uncertainty(obs.(seas_comp_vars{sv}).correlation, correlation_std, obs.(seas_comp_vars{sv}).ratio, ratio_std, [], cmip_names.(variables{v}), color_model, cmap, legend_on, ...
            rms_cutoff_for_good, out_of_phase_corr_cutoff, max_rel_amp);
    else
       
        % taylor_dist_smb_for_manuscript(obs.(seas_comp_vars{sv}).correlation, obs.(seas_comp_vars{sv}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, [], [], max_rel_amp);
         taylor_dist_smb_for_manuscript_uncertainty(obs.(seas_comp_vars{sv}).correlation,  correlation_std, ...
             obs.(seas_comp_vars{sv}).ratio,  ratio_std, ...
             [], cmip_names.(variables{v}), color_model, cmap, legend_on, [], [], max_rel_amp);
    end
    %     title('Fit to observations')
    set(gca, 'YColor', 'none')

    set(gca, 'fontsize', 12)
    %     set(gca, 'ycolor', 'white')
    % text(-max_rel_amp*4, max_rel_amp+.5, [var_plot_names{var_label_index,2} ':'], 'fontweight', 'bold', 'fontsize', 14)
    % if plot_index==8
    %     text(2,max_rel_amp+.05,'Correlation','fontsize',14)
    %     xlabel(['Relative Amplitud' ...
    %         'e'])
    % end
    if plot_index==2
        title(['e. ' var_plot_names{var_label_index,2} ' Taylor diagram'])
    elseif plot_index==5
        title(['f. ' var_plot_names{var_label_index,2} ' Taylor diagram'])
    elseif plot_index==8
        title(['g. ' var_plot_names{var_label_index,2} ' Taylor diagram'])
    elseif plot_index==11
        title(['h. ' var_plot_names{var_label_index,2} ' Taylor diagram'])
    end
    set(gca, 'titlehorizontalalignment', 'left')
    if plot_index==11
        text(1.85,1.5+.3,'Correlation','fontsize',14)
        xlabel('Relative amplitude')
    end
    
     plot_index = plot_index+1;

    % Plotting taylor diagrams
    subplot(4,3,plot_index)
    legend_on = 0;

    rms_cutoff_for_good = .75;
    out_of_phase_corr_cutoff = 0;

    correlation_std = std(obs.(seas_comp_vars{sv}).annual.correlation,1,2, 'omitnan');
    ratio_std = std(obs.(seas_comp_vars{sv}).annual.ratio,1,2, 'omitnan');
    if ~isempty(strfind(seas_comp_vars{sv}, 'fgco2'))
        % taylor_dist_smb_for_manuscript(obs.(seas_comp_vars{sv}).correlation, obs.(seas_comp_vars{sv}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, ...
        %     rms_cutoff_for_good, out_of_phase_corr_cutoff, 2);

          taylor_dist_smb_for_manuscript_uncertainty(obs.(seas_comp_vars{sv}).correlation, correlation_std, ...
              obs.(seas_comp_vars{sv}).ratio, ratio_std, ...
              [], cmip_names.(variables{v}), color_model, cmap, legend_on, ...
            rms_cutoff_for_good, out_of_phase_corr_cutoff, 2);

    else
        % taylor_dist_smb_for_manuscript(obs.(seas_comp_vars{sv}).correlation, obs.(seas_comp_vars{sv}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, [], [], 2);
        taylor_dist_smb_for_manuscript_uncertainty(obs.(seas_comp_vars{sv}).correlation, correlation_std, ...
            obs.(seas_comp_vars{sv}).ratio, ratio_std, ...
            [], cmip_names.(variables{v}), color_model, cmap, legend_on, [], [], 2);
    end
    %     title('Fit to observations')
    set(gca, 'YColor', 'none')

    set(gca, 'fontsize', 12)
    %     set(gca, 'ycolor', 'white')
    % text(-max_rel_amp*1.3, max_rel_amp+.2, var_plot_names{var_label_index,2}, 'fontweight', 'bold')
    if plot_index==9 || plot_index==12
        set(gca, 'xlim', [0 2])
        set(gca, 'ylim', [0 1])
    end
    if plot_index==12
        xlabel('Relative amplitude')
    end
   
    if plot_index==3
        title(['i. ' var_plot_names{var_label_index,2} ' Taylor diagram, zoomed'])
    elseif plot_index==6
        title(['j. ' var_plot_names{var_label_index,2} ' Taylor diagram, zoomed'])
    elseif plot_index==9
        title(['k. ' var_plot_names{var_label_index,2} ' Taylor diagram, zoomed'])
    elseif plot_index==12
        title(['l. ' var_plot_names{var_label_index,2} ' Taylor diagram, zoomed'])
    end
    set(gca, 'titlehorizontalalignment', 'left')
    clear paper_w paper_h legend_on
end

print(gcf, '-dpdf', '-r600', [fig_dir '/' plot_filename '.pdf'])
% print(gcf, '-dpng', '-r300', [fig_dir '/' plot_filename '.png'])
clear DDD v sv plot_index max_rel_amp d anomaly anomaly_text

%% Plotting a legend
legend_names = {};
% use CO_2 flux, plot all at 0,0, and then make a legend that covers it -
% multiple columns if need be
clf
set(gcf, 'units', 'inches')
paper_w = 10.2; paper_h =2.1;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

subplot(1,1,1); hold on
sv = 8;
v = find(strncmp(seas_comp_vars{sv}, variables, 4));

for m =  1:length(cmip_names.(variables{v}))
    plot(1:2, CMIP.(variables{v}).out_seasonal(m,1:2,1), 'color', [cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:)], 'linewidth', 1, ...
        'marker', color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4}, 'markersize', 8, ...
        'markerfacecolor', [cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:)], 'markeredgecolor', 'k');

    temp_name = cmip_names.(variables{v}){m};
    temp_name = strrep(temp_name, '_', '-');
    temp_name = strrep(temp_name, '-6', ' (6)');
    legend_names{end+1,1} = temp_name;

end
e1 = plot(1:2, obs.dissic.out_seasonal(1:2,1), 'linewidth', 2, 'color', 'k', 'linestyle', '-.');
legend_names{end+1,1} = 'Observations';
legend(legend_names, 'fontsize', 10, 'numcolumns', 5);

set(gca, 'Xcolor', 'none', 'Ycolor', 'none', 'xlim', [-2 -1])
% print(gcf, '-dpng', [fig_dir '/' 'Model_Legend.png'])
print(gcf, '-dpdf', '-r300', [fig_dir '/' 'Figure 2_Model_Legend' plot_ver '.pdf'])
clear e1 sv v legend_names

% hLegend = legend;

%% Plotting a legend without lines or observations
legend_names = {};
% use CO_2 flux, plot all at 0,0, and then make a legend that covers it -
% multiple columns if need be
clf
set(gcf, 'units', 'inches')
paper_w = 12.2; paper_h =1.8;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

subplot(1,1,1); hold on
sv = 8;
v = find(strncmp(seas_comp_vars{sv}, variables, 4));

for m =  1:length(cmip_names.(variables{v}))
    plot(1, CMIP.(variables{v}).out_seasonal(m,1,1), 'color', 'k', 'linewidth', 1, 'linestyle', 'none',...
        'marker', color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4}, 'markersize', 10, 'markerfacecolor', [cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:)]);

    temp_name = cmip_names.(variables{v}){m};
    temp_name = strrep(temp_name, '_', '-');
    temp_name = strrep(temp_name, '-6', ' (6)');
    legend_names{end+1,1} = temp_name;

end
legend(legend_names, 'fontsize', 10, 'numcolumns', 6,'location', 'north')
set(gca, 'Xcolor', 'none', 'Ycolor', 'none', 'xlim', [-2 -1])
print(gcf, '-dpdf', '-r300', [fig_dir '/' 'Figure 2_Model_Legend_no_line_no_obs' plot_ver '.pdf'])
clear e1 sv v legend_names

%% Plotting a legend without lines
legend_names = {};
% use CO_2 flux, plot all at 0,0, and then make a legend that covers it -
% multiple columns if need be
clf
set(gcf, 'units', 'inches')
paper_w = 12.2; paper_h =1.8;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

subplot(1,1,1); hold on
sv = 8;
v = find(strncmp(seas_comp_vars{sv}, variables, 4));

for m =  1:length(cmip_names.(variables{v}))
    plot(1, CMIP.(variables{v}).out_seasonal(m,1,1), 'color', 'k', 'linewidth', 1, 'linestyle', 'none',...
        'marker', color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4}, 'markersize', 10, 'markerfacecolor', [cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:)]);

    temp_name = cmip_names.(variables{v}){m};
    temp_name = strrep(temp_name, '_', '-');
    temp_name = strrep(temp_name, '-6', ' (6)');
    legend_names{end+1,1} = temp_name;

end
e1 = plot(1:2, obs.dissic.out_seasonal(1:2,1), 'linewidth', 2, 'color', 'k', 'linestyle', 'none', 'marker', 'x', 'markersize', 15);
legend_names{end+1,1} = 'Observations';
legend(legend_names, 'fontsize', 10, 'numcolumns', 6,'location', 'north')
set(gca, 'Xcolor', 'none', 'Ycolor', 'none', 'xlim', [-2 -1])
% print(gcf, '-dpng', [fig_dir '/' 'Model_Legend.png'])
print(gcf, '-dpdf', '-r300', [fig_dir '/' 'Figure 2_Model_Legend_no_line' plot_ver '.pdf'])
clear e1 sv v legend_names
%% Plotting a vertical legend without lines
legend_names = {};
% use CO_2 flux, plot all at 0,0, and then make a legend that covers it -
% multiple columns if need be
clf
set(gcf, 'units', 'inches')
paper_w = 2.4; paper_h =9.5;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

subplot(1,1,1); hold on
sv = 8;
v = find(strncmp(seas_comp_vars{sv}, variables, 4));

for m =  1:length(cmip_names.(variables{v}))
    plot(1, CMIP.(variables{v}).out_seasonal(m,1,1), 'color', 'k', 'linewidth', 1, 'linestyle', 'none',...
        'marker', color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4}, 'markersize', 10, 'markerfacecolor', [cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:)]);

    temp_name = cmip_names.(variables{v}){m};
    temp_name = strrep(temp_name, '_', '-');
    temp_name = strrep(temp_name, '-6', ' (6)');
    legend_names{end+1,1} = temp_name;

end
e1 = plot(1:2, obs.dissic.out_seasonal(1:2,1), 'linewidth', 2, 'color', 'k', 'linestyle', 'none', 'marker', 'x', 'markersize', 15);
legend_names{end+1,1} = 'Observations';
legend(legend_names, 'fontsize', 10, 'numcolumns', 1,'location', 'north')
set(gca, 'Xcolor', 'none', 'Ycolor', 'none', 'xlim', [-2 -1])
% print(gcf, '-dpng', [fig_dir '/' 'Model_Legend.png'])
print(gcf, '-dpdf', '-r300', [fig_dir '/' 'Figure 2_Model_Legend_vertical_no_line' plot_ver '.pdf'])
clear e1 sv v legend_names
%% Figure SQ - Plotting extra variables seasonal cycles
% cmap = distinguishable_colors(20);

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
    anomaly_text = 'anomaly';
else
    anomaly_text=[];
end

plot_filename = ['Figure SQ_extra Obs model Seasonal ' anomaly_text ' fgco2 spco2 dic tos ' plot_ver];
clf
set(gcf, 'units', 'inches')
paper_w = 12; paper_h =9;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

plot_index = 0;
d = NaN(8,1);
for sv = [2 5 10 11]

    v = find(strncmp(seas_comp_vars{sv}, variables, 4));
    if length(v)>1 % cludge since dissic and dissic_yr were getting confused
        v = strmatch(seas_comp_vars{sv}, variables, 'exact');
    end
    if sv==8 %|| sv==6
        max_rel_amp = 7;
    elseif sv==6
        max_rel_amp = 3.5;
    elseif sv==11
        max_rel_amp = 6.5;
    elseif sv==10
        max_rel_amp = 2;
    else
        max_rel_amp = 3.5;
    end
    plot_index = plot_index+1;

    d(plot_index) = subplot(4,3,plot_index);
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
                plot(1:12, CMIP.(variables{v}).out_seasonal_mol_C_m2_yr(m,:,1) - nanmean(CMIP.(variables{v}).out_seasonal_mol_C_m2_yr(m,:,1)), 'color', [cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:) .5], 'linewidth', 3);
            else
                plot(1:12, CMIP.(variables{v}).out_seasonal(m,:,1)-nanmean(CMIP.(variables{v}).out_seasonal(m,:,1)), 'color', [cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:) .5], 'linewidth', 3);
            end
        else
            plot(1:12, CMIP.(variables{v}).out_seasonal(m,:,1), 'color', [cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:) .5], 'linewidth', 3);

        end

        legend_names{end+1,1} = cmip_names.(variables{v}){m};
    end

    if v==9 || v==1
        if anomaly==1
            e1 = errorbar(1:12, obs.(seas_comp_vars{sv}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,1)- ...
                nanmean( obs.(seas_comp_vars{sv}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,1)), ...
                obs.(seas_comp_vars{sv}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 4, 'color', 'k', 'linestyle', '-.');
        else
            e1 = errorbar(1:12, obs.(seas_comp_vars{sv}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,1), ...
                obs.(seas_comp_vars{sv}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 4, 'color', 'k', 'linestyle', '-.');
        end
    else
        if anomaly==1
            e1 = plot(1:12, obs.(seas_comp_vars{sv}).out_seasonal(:,1) - ...
                nanmean(obs.(seas_comp_vars{sv}).out_seasonal(:,1)), 'linewidth', 4, 'color', 'k', 'linestyle', '-.');
        else
            e1 = plot(1:12, obs.(seas_comp_vars{sv}).out_seasonal(:,1), 'linewidth', 4, 'color', 'k', 'linestyle', '-.');
        end
    end

    var_label_index = strncmp(seas_comp_vars{sv}, var_plot_names(:,1), 4);
    if sum(var_label_index>0)
        ylabel(var_plot_names{var_label_index,3})
        %         t1 = title(var_plot_names{var_label_index,2});
        %         old_t1_pos = t1.Position;
        %         set(d(plot_index), t1.Position, old_t1_pos+[8 0 0])

    else
        ylabel([seas_comp_vars{sv} ' ' anomaly_text ' (' (CMIP.(variables{v}).(cmip_names.(variables{v}){1}).units) ')'], 'interpreter', 'none')
        title(seas_comp_vars{sv}, 'interpreter', 'none')

    end
    if plot_index==1
        title(['a. ' var_plot_names{var_label_index,2} ' seasonal anomaly'])
    elseif plot_index==4
        title(['b. ' var_plot_names{var_label_index,2} ' seasonal anomaly'])
    elseif plot_index==7
        title(['c. ' var_plot_names{var_label_index,2} ' seasonal anomaly'])
    elseif plot_index==10
        title(['d. ' var_plot_names{var_label_index,2} ' seasonal anomaly'])
    end
    set(gca, 'titlehorizontalalignment', 'left')

    if plot_index==10
        xlabel('Month')
    end
    %     l1 = legend([legend_names ; 'Obs'], 'interpreter', 'none', 'location', 'eastoutside');
    set(gca, 'fontsize', 12, 'xlim', [1 12])
    %     set(l1, 'fontsize', 9)
    y_lims = get(gca, 'ylim');

    % if sv==11
    %   text(-2, y_lims(2)+diff(y_lims)*-.05, [var_plot_names{var_label_index,2} ':'], 'fontweight', 'bold', 'fontsize', 14)
    % else
    %  text(-2, y_lims(2)+diff(y_lims)*.2, [var_plot_names{var_label_index,2} ':'], 'fontweight', 'bold', 'fontsize', 14)
    % 
    % end
    plot_index = plot_index+1;

    % Plotting taylor diagrams
    subplot(4,3,plot_index)
    legend_on = 0;

    rms_cutoff_for_good = .75;
    out_of_phase_corr_cutoff = 0;

    correlation_std = std(obs.(seas_comp_vars{sv}).annual.correlation,1,2, 'omitnan');
    ratio_std = std(obs.(seas_comp_vars{sv}).annual.ratio,1,2, 'omitnan');

    if ~isempty(strfind(seas_comp_vars{sv}, 'fgco2'))
        % DDD = taylor_dist_smb_for_manuscript(obs.(seas_comp_vars{sv}).correlation, obs.(seas_comp_vars{sv}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, ...
        %     rms_cutoff_for_good, out_of_phase_corr_cutoff, max_rel_amp);
       taylor_dist_smb_for_manuscript_uncertainty(obs.(seas_comp_vars{sv}).correlation, correlation_std, obs.(seas_comp_vars{sv}).ratio, ratio_std, [], cmip_names.(variables{v}), color_model, cmap, legend_on, ...
            rms_cutoff_for_good, out_of_phase_corr_cutoff, max_rel_amp);
    else
        % DDD = taylor_dist_smb_for_manuscript(obs.(seas_comp_vars{sv}).correlation, obs.(seas_comp_vars{sv}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, [], [], max_rel_amp);
        taylor_dist_smb_for_manuscript_uncertainty(obs.(seas_comp_vars{sv}).correlation,  correlation_std, ...
            obs.(seas_comp_vars{sv}).ratio,  ratio_std, ...
            [], cmip_names.(variables{v}), color_model, cmap, legend_on, [], [], max_rel_amp);
    end
    %     title('Fit to observations')
    set(gca, 'YColor', 'none')

    set(gca, 'fontsize', 12)
    %     set(gca, 'ycolor', 'white')
    % text(-max_rel_amp*1.3, max_rel_amp+.2, var_plot_names{var_label_index,2}, 'fontweight', 'bold')
    % if plot_index==8
    %     text(2,max_rel_amp+.05,'Correlation','fontsize',14)
    %     xlabel(['Relative Amplitud' ...
    %         'e'])
    % end
    if plot_index==2
        title(['e. ' var_plot_names{var_label_index,2} ' Taylor diagram'])
    elseif plot_index==5
        title(['f. ' var_plot_names{var_label_index,2} ' Taylor diagram'])
    elseif plot_index==8
        title(['g. ' var_plot_names{var_label_index,2} ' Taylor diagram'])
    elseif plot_index==11
        title(['h. ' var_plot_names{var_label_index,2} ' Taylor diagram'])
    end
    set(gca, 'titlehorizontalalignment', 'left')

    if plot_index==11
        text(5,4.5,'Correlation','fontsize',14)

        xlabel('Relative amplitude')
    end
     plot_index = plot_index+1;

    % Plotting taylor diagrams
    subplot(4,3,plot_index)
    legend_on = 0;

    rms_cutoff_for_good = .75;
    out_of_phase_corr_cutoff = 0;

    correlation_std = std(obs.(seas_comp_vars{sv}).annual.correlation,1,2, 'omitnan');
    ratio_std = std(obs.(seas_comp_vars{sv}).annual.ratio,1,2, 'omitnan');

    if ~isempty(strfind(seas_comp_vars{sv}, 'fgco2'))
        % DDD = taylor_dist_smb_for_manuscript(obs.(seas_comp_vars{sv}).correlation, obs.(seas_comp_vars{sv}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, ...
        %     rms_cutoff_for_good, out_of_phase_corr_cutoff, 2);

        taylor_dist_smb_for_manuscript_uncertainty(obs.(seas_comp_vars{sv}).correlation, correlation_std, ...
            obs.(seas_comp_vars{sv}).ratio, ratio_std, ...
            [], cmip_names.(variables{v}), color_model, cmap, legend_on, ...
            rms_cutoff_for_good, out_of_phase_corr_cutoff, 2);

    elseif ~isempty(strfind(seas_comp_vars{sv}, 'talk'))
        % DDD = taylor_dist_smb_for_manuscript(obs.(seas_comp_vars{sv}).correlation, obs.(seas_comp_vars{sv}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, [], [], 1.5);
        taylor_dist_smb_for_manuscript_uncertainty(obs.(seas_comp_vars{sv}).correlation, correlation_std, ...
            obs.(seas_comp_vars{sv}).ratio, ratio_std, ...
            [], cmip_names.(variables{v}), color_model, cmap, legend_on, [], [], 1.5);
    else
        % DDD = taylor_dist_smb_for_manuscript(obs.(seas_comp_vars{sv}).correlation, obs.(seas_comp_vars{sv}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, [], [], 2);
        taylor_dist_smb_for_manuscript_uncertainty(obs.(seas_comp_vars{sv}).correlation, correlation_std, ...
            obs.(seas_comp_vars{sv}).ratio, ratio_std, ...
            [], cmip_names.(variables{v}), color_model, cmap, legend_on, [], [], 2);
    end
    %     title('Fit to observations')
    set(gca, 'YColor', 'none')

    set(gca, 'fontsize', 12)
    %     set(gca, 'ycolor', 'white')
    % text(-max_rel_amp*1.3, max_rel_amp+.2, var_plot_names{var_label_index,2}, 'fontweight', 'bold')
    if plot_index==3 || plot_index==9 || plot_index==12
        set(gca, 'xlim', [0 2])
        set(gca, 'ylim', [0 1])
    end
    if plot_index==12
        xlabel('Relative Amplitude')
    end
    if plot_index==3
        title(['i. ' var_plot_names{var_label_index,2} ' Taylor diagram, zoomed'])
    elseif plot_index==6
        title(['j. ' var_plot_names{var_label_index,2} ' Taylor diagram, zoomed'])
    elseif plot_index==9
        title(['k. ' var_plot_names{var_label_index,2} ' Taylor diagram, zoomed'])
    elseif plot_index==12
        title(['l. ' var_plot_names{var_label_index,2} ' Taylor diagram, zoomed'])
    end
    set(gca, 'titlehorizontalalignment', 'left')
    clear paper_w paper_h legend_on
end

print(gcf, '-dpdf', '-r300', [fig_dir '/' plot_filename '.pdf'])
% print(gcf, '-dpng', '-r300', [fig_dir '/' plot_filename '.png'])
clear DDD v sv plot_index max_rel_amp d anomaly anomaly_text
%% Print out range in different variables:

for v = [1 2 5 6 7 8 9 14]
    tests = {'correlation', 'ratio', 'norm_error'};
    disp(variables{v})

    for tt=1:length(tests)

        disp([tests{tt} '- min: ' num2str(min(obs.(variables{v}).(tests{tt})),2) ' max: '  num2str(max(obs.(variables{v}).(tests{tt})),2) ' mean: '  num2str(nanmean(obs.(variables{v}).(tests{tt})),2)])
    end
    disp(' ')
end
%% save out variants used for each model to go into supplement
ensembleTable = table;


for m = 1:length(cmip_names.fgco2)
    currentModel = cmip_names.fgco2{m};
    model_name = table({currentModel}, 'VariableNames', {'Model_Name'});
    
    if isfield(CMIP.fgco2.(cmip_names.fgco2{m}), 'ensemble_member')
        variant = CMIP.fgco2.(cmip_names.fgco2{m}).ensemble_member;
    else
        variant = '-';
    end
    model_variant = table({variant}, 'VariableNames', {'Variant'});
 
    newRow = [model_name model_variant];

    ensembleTable = [ensembleTable; newRow];

end

save([fig_dir '../spreadsheets/ensemble_members' plot_ver '.mat'], 'ensembleTable');
writetable(ensembleTable, [fig_dir '../spreadsheets/ensemble_members' plot_ver '.csv']);

clear ensembleTable newRow model_variant variant model_name m currentModel
%% % save out Taylor diagram results into a table for supplement
resultsTable = table;
tests = {'correlation', 'ratio', 'norm_error'};

% loop through every model:
for m = 1:length(cmip_names.fgco2)
    % tempTable = table;
    % tempTable.Model_Name = cmip_names.fgco2{m};
    currentModel = cmip_names.fgco2{m};
    newRow = table({currentModel}, 'VariableNames', {'Model_Name'});
    for v = [9 1 7 5 6 8 14 2]

        
        mod_match_index = strcmp(cmip_names.(variables{v}), cmip_names.fgco2{m});

        % disp(variables{v})

        for tt=1:length(tests)
        
            test_val = obs.(variables{v}).(tests{tt})(mod_match_index);
            % tempTable = table({variables{v}}, {tests{tt}}, test_val, {'Variable', 'Test', 'Value'});

            % Append the temporary table to the results table
            % resultsTable = [resultsTable; tempTable];


            % disp([tests{tt} '- min: ' num2str(min(obs.(variables{v}).(tests{tt})),2) ' max: '  num2str(max(obs.(variables{v}).(tests{tt})),2) ' mean: '  num2str(nanmean(obs.(variables{v}).(tests{tt})),2)])
            newCol = table({test_val}, 'VariableNames', {[variables{v} '_' tests{tt}]});
            
            newRow = [newRow newCol];
        end
        % disp(' ')
    end
    resultsTable = [resultsTable; newRow];

end

save([fig_dir '../spreadsheets/Table_taylor_results' plot_ver '.mat'], 'resultsTable');
writetable(resultsTable, [fig_dir '../spreadsheets/Table_taylor_results' plot_ver '.csv']);
%% Figure 3 - side by side pCO2/SST/DIC seasonal cycle and contour plot

clf
set(gcf, 'units', 'inches')
paper_w = 16; paper_h =14;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

set(gcf, 'colormap', brewermap(30, 'Spectral'))

plot_filename = 'Figure 3_Toy model pCO2_flipped_simpler_c';

disp(' ')

main_var = 'dissic';
v = 7;

% copied idealized test_out_2 to know order of indexes
% idealized_test_out_2 = NaN(length(adjust_dissic_phase_shift_days), length(adjust_dissic_amp_percent), ...
%     length(adjust_tos_phase_shift_days ), length(adjust_tos_amp_percent), ...
%     length(adjust_talk_phase_shift_days), length(adjust_talk_amp_percent),  ...
%     length(adjust_sos_phase_shift_days), length(adjust_sos_amp_percent), 3);
% legend_names = {};

%indexes for different scenarios
temp_amp_percent = 0;
tap =  adjust_vars.adjust_tos_amp_percent==temp_amp_percent;

talk_amplitude_percent = 0;
talk_ap = adjust_vars.adjust_talk_amp_percent==talk_amplitude_percent;

talk_day_shift = 0;
tpsd  = adjust_vars.adjust_talk_phase_shift_days==talk_day_shift;


dic_day_shift = 0;
dpsd  = adjust_vars.adjust_dissic_phase_shift_days==dic_day_shift;

dic_amplitude_percent = 0;
dap = adjust_vars.adjust_dissic_amp_percent==dic_amplitude_percent;

pco2_orig = squeeze(pco2_idealized(dpsd,dap,1,tap,tpsd,talk_ap,1,1,:));
dic_orig = squeeze(dic_idealized(dpsd,dap,1,tap,tpsd,talk_ap,1,1,:));
tos_orig = squeeze(tos_idealized(dpsd,dap,1,tap,tpsd,talk_ap,1,1,:));
talk_orig = squeeze(talk_idealized(dpsd,dap,1,tap,tpsd,talk_ap,1,1,:));

blues = brewermap(10,'Blues');
greens = brewermap(10, 'Greens');
purples = brewermap(10,'Purples');
oranges = brewermap(10,'oranges');
PurpleRed = brewermap(9,'PuRd');
% % now test plots to
% dic_day_shift = {[0 0]; [-30  30]; [-30 -30 30 30];[0 0];[-30 -30 30 30]};
% dic_amplitude_percent = {[-50 50]; [0 0];[-50 50 -50 50];[0 0];[-50 50 -50 50]};
% temp_amp_percent = {[0 0];[0 0];[0 0 0 0] ;[-50 50];[50 50 50 50]};

% changing to TA plots
dic_day_shift = {[0 0]; [-30  30]; [0 0];[0 0];[0 0]};
dic_amplitude_percent = {[-50 50]; [0 0];[0 0];[0 0];[0 0]};
temp_amp_percent = {[0 0];[0 0];[-50 50];[0 0];[0 0]};
talk_amplitude_percent = {[0 0];[0 0];[0 0];[-60 60];[0 0]};
talk_day_shift = {[0 0];[0 0];[0 0];[0 0];[-75 75]};

% dpsd = {[6 6]; [3  9]; [3 3 9 9];[6 6];[3 3 9 9]};
% dap = {[6 16]; [11 11];[6 16 6 16];[11 11];[6 16 6 16]};
% tap = {[3 3 ];[3 3];[3 3 3 3] ;[2 4];[4 4 4 4]};

plot_colors = {[blues(5,:) ; blues(9,:)];...
    [greens(5,:); greens(9,:) ]; ...
    [purples(4,:); purples(6,:); purples(8,:); purples(10,:)];...
    [oranges(5,:) ; oranges(9,:)];...
    [PurpleRed(4,:); PurpleRed(5,:); PurpleRed(6,:); PurpleRed(7,:)]};

% set up 4 columns - one for DIC changes alone, one for SST changes alone,
% and one for both
tos_amp_per_plot = {0 ;0; [-50 50]; [0 0]; [0 0]};
talk_amp_per_plot = {0 ;0; [0 0]; [-60 60]; [0 0]};
talk_day_shift_plot = {0 ;0; [0 0]; [0 0]; [-75 75]};

% col_titles = {'DIC Amp.'; 'DIC Timing'; {'DIC Amp. +', 'DIC Timing'}; 'SST Amp.'; {'DIC Amp. +', 'DIC Timing + SST Amp.'}};
col_titles = {'a.        DIC Amp.'; 'f.        DIC Timing'; 'k.        SST Amp.'; 'q.        TA Amp.'; 'w.        TA Timing'};

for cc = 1:length(tos_amp_per_plot)
    tos_amp_per = tos_amp_per_plot{cc};
    talk_ap_per = talk_amp_per_plot{cc};
    talk_day = talk_day_shift_plot{cc};

    d = NaN(length(tos_amp_per));
    contour_pos = NaN(length(tos_amp_per),4);

    for z = 1: length(tos_amp_per)

        tt = adjust_vars.adjust_tos_amp_percent==tos_amp_per(z);
        talk_ap = adjust_vars.adjust_talk_amp_percent==talk_ap_per(z);
        tpsd = adjust_vars.adjust_talk_phase_shift_days==talk_day(z);

        % plot pCO2 correlation arrays for different scenarios:
        pCO2_grid = NaN(length(adjust_vars.(['adjust_' main_var '_amp_percent'])), length(adjust_vars.(['adjust_' main_var '_phase_shift_days'])));

        for dd =1: length(adjust_vars.(['adjust_' main_var '_amp_percent']))
            pCO2_grid(dd,:) = idealized_test_out_2(:,dd,1,tt,tpsd,talk_ap,1,1,1);
        end

        d(z) = subplot(6,5,20+cc+5*(z-1));

        [C, h] = contourf( adjust_vars.(['adjust_' main_var '_phase_shift_days']), adjust_vars.(['adjust_' main_var '_amp_percent']),pCO2_grid, 'levellist', -1:0.05:1, 'linestyle', 'none'); colorbar; caxis([-1 1])
        hold on
        [C1, h1] = contour( adjust_vars.(['adjust_' main_var '_phase_shift_days']),adjust_vars.(['adjust_' main_var '_amp_percent']), pCO2_grid, 'levellist', [-0.5:0.5:0.5], 'linestyle', '-', 'linewidth', 2, 'color', 'k');
        clabel(C1, h1)
        xlabel('DIC timing (days)')
        ylabel('\Delta DIC amp. % ')
        if cc==1
            title('e.')
        elseif cc==2
            title('j.')
        elseif cc==3 && z==1
            title(['o. \Delta SST amp.: ' num2str(tos_amp_per(z)) ' %']);
        elseif cc==3 && z==2
            title(['p. \Delta SST amp.: ' num2str(tos_amp_per(z)) ' %']);
        elseif cc==4 && z==1
            title(['u. \Delta TA amp.: ' num2str(talk_ap_per(z)) ' %']);
        elseif cc==4 && z==2
            title(['v. \Delta TA amp.: ' num2str(talk_ap_per(z)) ' %']);
        elseif cc==5 && z==1
            title(['aa. \Delta TA Timing: ' num2str(talk_day(z)) ' days']);
        elseif cc==5 && z==2
            title(['bb. \Delta TA Timing: ' num2str(talk_day(z)) ' days']);
        end
        set(gca, 'titlehorizontalalignment', 'left')
        contourcbar("off")

        contour_pos(z,:) = get(d(z),'position');
    end

    % plot base DIC, SST, pCO2
    d2 = subplot(6,5,cc);
    hold on
    plot(dic_orig, '-k', 'linewidth', 3)
    if cc==1
        ylabel('DIC (\mumol l^-^1)')
    end
    set(d2, 'ylim', [2165 2240])
    title(col_titles{cc})

    set(gca, 'titlehorizontalalignment', 'left')

    d3 = subplot(6,5,cc+5);
    hold on
    plot(tos_orig, '-k', 'linewidth', 3)
    if cc==1
        ylabel('SST (\circC)')
    end
    set(d3, 'ylim', [1 6])

    dTA = subplot(6,5,cc+10);
    hold on
    plot(talk_orig, '-k', 'linewidth', 3)
    if cc==1
        ylabel('TA  (\mumol l^-^1)')
    end
    set(dTA, 'ylim', [2335 2360])


    d1 = subplot(6,5,cc+15);
    hold on
    p1 = plot(pco2_orig, '-k', 'linewidth', 3);
    if cc==1
        ylabel('pCO_2 (\muatm)')
    end
    set(d1, 'ylim', [340 450])
    xlabel('Month')


    % now plot test symbols overlaid
    for qq = 1:length(dic_day_shift{cc})

        dpsd = adjust_vars.adjust_dissic_phase_shift_days==dic_day_shift{cc}(qq);
        dap = adjust_vars.adjust_dissic_amp_percent==dic_amplitude_percent{cc}(qq);
        tap =  adjust_vars.adjust_tos_amp_percent==temp_amp_percent{cc}(qq);
        talk_ap = adjust_vars.adjust_talk_amp_percent==talk_amplitude_percent{cc}(qq);
        tpsd = adjust_vars.adjust_talk_phase_shift_days==talk_day_shift{cc}(qq);


        pco2_test = squeeze(pco2_idealized(dpsd,dap,1,tap,tpsd,talk_ap,1,1,:));
        dic_test = squeeze(dic_idealized(dpsd,dap,1,tap,tpsd,talk_ap,1,1,:));
        tos_test = squeeze(tos_idealized(dpsd,dap,1,tap,tpsd,talk_ap,1,1,:));
        talk_test = squeeze(talk_idealized(dpsd,dap,1,tap,tpsd,talk_ap,1,1,:));

        pco2_correlation = idealized_test_out_2(dpsd,dap,1,tap,tpsd,talk_ap,1,1,1);
                                      
        disp(['DIC day shift: ' num2str(dic_day_shift{cc}(qq)) ...
            ', DIC amp percent: ' num2str(dic_amplitude_percent{cc}(qq)) ...
            ', SST amp percent: ' num2str(temp_amp_percent{cc}(qq)) ...
            ', TA amp percent: ' num2str(talk_amplitude_percent{cc}(qq)) ...
            ', TA day shift: ' num2str(talk_day_shift{cc}(qq)) ...
            ', pCO2 corr: ' num2str(round(pco2_correlation,2))])
        plot(d2, dic_test,'--', 'linewidth', 3, 'color', plot_colors{cc}(qq,:));
        plot(d3, tos_test,'--', 'linewidth', 3, 'color', plot_colors{cc}(qq,:));
        plot(d1, pco2_test,'--', 'linewidth', 3, 'color', plot_colors{cc}(qq,:));
        plot(dTA, talk_test,'--', 'linewidth', 3, 'color', plot_colors{cc}(qq,:));

        if cc<4
            contour_index = find(tos_amp_per_plot{cc} == adjust_vars.adjust_tos_amp_percent(tap));
        elseif cc==4
            contour_index = find(talk_amp_per_plot{cc} == adjust_vars.adjust_talk_amp_percent(talk_ap));
        elseif cc==5
            contour_index = find(talk_day_shift_plot{cc} == adjust_vars.adjust_talk_phase_shift_days(tpsd));

        end
        plot(d(contour_index), 0, 0, '*w', 'markersize', 10)
        p1 =  plot(d(contour_index),  adjust_vars.adjust_dissic_phase_shift_days(dpsd), ...
            adjust_vars.adjust_dissic_amp_percent(dap), 'markersize', 15);
        p1.Marker = 'o';
        p1.MarkerEdgeColor = 'k';
        p1.MarkerFaceColor = plot_colors{cc}(qq,:);
        %        set(p1, 'marker', 's', 'markeredgecolor', 'k', 'markerfacecolor', 'color', plot_colors{cc}(qq,:));
        %         scatter(d(contour_index), adjust_vars.adjust_dissic_phase_shift_days(dpsd{cc}(qq)), ...
        %             adjust_vars.adjust_dissic_amp_percent(dap{cc}(qq)), 200, pco2_correlation, 'filled', 'markeredgecolor', 'k')

    end
    if cc==1
        title(d3, 'b.'); set(d3, 'titlehorizontalalignment', 'left')
        title(dTA, 'c.'); set(dTA, 'titlehorizontalalignment', 'left')
        title(d1, 'd.'); set(d1, 'titlehorizontalalignment', 'left')
    elseif cc==2
        title(d3, 'g.'); set(d3, 'titlehorizontalalignment', 'left')
        title(dTA, 'h.'); set(dTA, 'titlehorizontalalignment', 'left')
        title(d1, 'i.'); set(d1, 'titlehorizontalalignment', 'left')
    elseif cc==3
        title(d3, 'l.'); set(d3, 'titlehorizontalalignment', 'left')
        title(dTA, 'm.'); set(dTA, 'titlehorizontalalignment', 'left')
        title(d1, 'n.'); set(d1, 'titlehorizontalalignment', 'left')
    elseif cc==4
        title(d3, 'r.'); set(d3, 'titlehorizontalalignment', 'left')
        title(dTA, 's.'); set(dTA, 'titlehorizontalalignment', 'left')
        title(d1, 't.'); set(d1, 'titlehorizontalalignment', 'left')
    elseif cc==5
        title(d3, 'x.'); set(d3, 'titlehorizontalalignment', 'left')
        title(dTA, 'y.'); set(dTA, 'titlehorizontalalignment', 'left')
        title(d1, 'z.'); set(d1, 'titlehorizontalalignment', 'left')
    end

    for z = 1: length(tos_amp_per)
        height_adjust = 0.02;

        if cc<3
            set(d(z), 'position', contour_pos(z,:) +[0 -0.12 0 height_adjust])

            if cc==2
                second_pos = get(d(z), 'position');
            end
        elseif z==1
            set(d(z), 'position', contour_pos(z,:) +[0 -0.03 0 height_adjust])
        elseif z==2
            set(d(z), 'position', contour_pos(z,:) +[0 -0.07 0 height_adjust])
            %             new_pos = get(d(z), 'position');
            % bottom_pos = get(d(z), 'position');

        end
    end
end
disp(' ')
cb1 = contourcbar(d(contour_index), 'location', 'southoutside');
cb1_pos = get(cb1, 'position');
% set(d(z), 'position', [contour_pos(z,1) bottom_pos(2) contour_pos(z,3) contour_pos(z,4)+height_adjust])
set(cb1, 'position', [second_pos(1)-.1 second_pos(2)+.15 cb1_pos(3)+.04 cb1_pos(4)+.02])
title(cb1, 'pCO_2 Correlation', 'fontweight', 'bold')
set(cb1, 'fontsize', 14)
print(gcf, '-dpdf', '-r300', [fig_dir '/' plot_filename plot_ver '.pdf'])

%% Figure 4. Contour plots of pCO2 correlation against DISSIC amplitude and phase shifts with models overlaid
set(gcf, 'colormap', brewermap(30, 'Spectral'))

v = 7;
main_var = 'dissic';

sub_v = 5;
sub_var_name = 'adjust_tos_amp_percent';

model_plot = 1;

% try plotting different variables for the scatter colors
pco2_corr_plot = 1;

% for plotting other colors than model pCO2 correlation:


vp = 4; % mlotst max / min
vp = 2; % intpp
if pco2_corr_plot==0 && vp==4
    plot_title_add = 'mlotst max div min';
    min_max = [2 7];
elseif pco2_corr_plot==0 && vp==2
    plot_title_add = 'jan intpp';
    min_max = [100 1300];
end

if pco2_corr_plot==0
    alt_color_map = brewermap(30, 'PuRd');
    alt_color_map = alt_color_map(1:20,:);
    grad_step = (min_max(2)-min_max(1))./length(alt_color_map);
end
% first, find all points with the correct sub_v amplitude and shift, then put
% into a matric of ampl rows and phase columns

% copied idealized test_out_2 to know order of indexes
% idealized_test_out_2 = NaN(length(adjust_dissic_phase_shift_days), length(adjust_dissic_amp_percent), ...
%     length(adjust_tos_phase_shift_days ), length(adjust_tos_amp_percent), ...
%     length(adjust_talk_phase_shift_days), length(adjust_talk_amp_percent),  ...
%     length(adjust_sos_phase_shift_days), length(adjust_sos_amp_percent), 3);
dh = NaN(6,1);
l_h = NaN(6,1);
talk_amp_percent = 0;
tap = adjust_vars.adjust_talk_amp_percent==talk_amp_percent;

talk_day_shift = 0;
tpsd = adjust_vars.adjust_talk_phase_shift_days==talk_day_shift;

% for ta = 1%5%1:length(adjust_vars.(sub_var_3_name))
subplot_index = 0;
clf
set(gcf, 'units', 'inches')
paper_w = 12; paper_h =16;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

plot_filename = ['Figure 4 Contour_correlation ' variables{v} ' subplots by ' variables{sub_v} ' and TALK phase_b'];

if model_plot==1
    plot_filename = [plot_filename '_model_overlay'];
end
if pco2_corr_plot==0
    plot_filename = [plot_filename '_' plot_title_add];

end

tos_amp_per_plot = {0 ;50; 125};
talk_day_shift = {0; 100};

for tt = 1:length(tos_amp_per_plot)
    if tt<3
        sub_v_amp_bin = 25;
    else
        sub_v_amp_bin = 50;
    end
    for ta_n = 1:length(talk_day_shift)
        talk_day_shift_bin = 50;
        tpsd = adjust_vars.adjust_talk_phase_shift_days==talk_day_shift{ta_n};

        % if ta_n==length(adjust_talk_phase_shift_days)
        %     talk_day_shift_bin = (adjust_talk_phase_shift_days(tpsd) - adjust_talk_phase_shift_days(tpsd-1))/2;
        % else
        %     talk_day_shift_bin = (adjust_talk_phase_shift_days(tpsd+1) - adjust_talk_phase_shift_days(tpsd))/2;
        % end
        legend_names = {};
        sc_h = [];

        sub_v_amp_percent=tos_amp_per_plot{tt};
        tos_ap = adjust_vars.adjust_tos_amp_percent==tos_amp_per_plot{tt};

        sub_v_shift_days = 0;

        subplot_index = subplot_index+1;
        if subplot_index==6 % skip final panel w/ no models
            continue
        end
        % if tt==2
        %     subplot_index = subplot_index+1;
        % end
        dh(subplot_index) = subplot(3,2,subplot_index);

        pCO2_grid = NaN(length(adjust_vars.(['adjust_' main_var '_amp_percent'])), length(adjust_vars.(['adjust_' main_var '_phase_shift_days'])));

        for dd =1: length(adjust_vars.(['adjust_' main_var '_amp_percent']))

            pCO2_grid(dd,:) = idealized_test_out_2(:,dd,1,tos_ap,tpsd,tap,1,1,1);
        end

        [C, h] = contourf( adjust_vars.(['adjust_' main_var '_phase_shift_days']), adjust_vars.(['adjust_' main_var '_amp_percent']),pCO2_grid, 'levellist', -1:0.05:1, 'linestyle', 'none');
        c_l = colorbar;
        caxis([-1 1])
        hold on
        [C1, h1] = contour( adjust_vars.(['adjust_' main_var '_phase_shift_days']),adjust_vars.(['adjust_' main_var '_amp_percent']), pCO2_grid, 'levellist', [-0.5:0.5:0.5], 'linestyle', '-', 'linewidth', 2, 'color', 'k');
        clabel(C1, h1);
        ylabel(c_l, 'Model pCO_2 corr. to obs.', 'fontsize', 10)

        var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);

        xlabel([var_plot_names{var_label_index,2} ' timing shift (days)'])
        ylabel([var_plot_names{var_label_index,2} ' Amplitude (% diff)'])

        sub_var_label_index = strncmp(variables{sub_v}, var_plot_names(:,1), 4);

        %         xlabel([variables{v} ' Shift (days)'])
        %         ylabel([variables{v} ' Amplitude (% diff)'])

        %         title([(variables{sub_v}) ' amplitude percent ' num2str(sub_v_amp_percent)]);
        title({[var_plot_names{sub_var_label_index,2} ' amp. range: ' num2str(sub_v_amp_percent-sub_v_amp_bin) ' to ' num2str(sub_v_amp_percent+sub_v_amp_bin) ...
            '%,'], ['TA timing shift: ' num2str(adjust_vars.adjust_talk_phase_shift_days(tpsd)- talk_day_shift_bin) ' to ' num2str(adjust_vars.adjust_talk_phase_shift_days(tpsd)+ talk_day_shift_bin) ' days']})
        if model_plot==0
            continue
        end
        x = -49;
        y = 107;
        if subplot_index==1
            text(x, y, 'a.', 'fontsize', 12)
        elseif subplot_index==2
            text(x,y, 'b.', 'fontsize', 12)
        elseif subplot_index==3
            text(x,y, 'c.', 'fontsize', 12)
        elseif subplot_index==4
            text(x,y, 'd.', 'fontsize', 12)
        elseif subplot_index==5
            text(x,y, 'e.', 'fontsize', 12)
        elseif subplot_index==6
            text(x,y, 'f.', 'fontsize', 12)
        end
        % overlay scatter plots with models that fit into different sub_v
        % amplitude bins
        % will need to adjust bin ranges if you modify the number of bins here:
        % sub_v_amp_bin = 25;

        for m = 1:length(cmip_names.spco2)

            mod_talk_index = strcmp(cmip_names.talk, cmip_names.spco2{m});

            if sum(mod_talk_index)==0 % if there is no talk, then it is hard to know if talk is at all reasonable and not causing issues
                continue
            end

            mod_sub_v_index = strcmp(cmip_names.(variables{sub_v}), cmip_names.spco2{m});
            sub_v_amp_per_diff = (harm_mod.(variables{sub_v}).amp(mod_sub_v_index,1) - harm.(variables{sub_v}).amp(1))./harm.(variables{sub_v}).amp(1)*100;

            if isempty(sub_v_amp_per_diff)
                continue
            end
            % only plot models that fall in each sub_v amplitude range
            if sub_v_amp_per_diff>=sub_v_amp_percent - sub_v_amp_bin && sub_v_amp_per_diff<sub_v_amp_percent + sub_v_amp_bin

                mod_var_index = strcmp(cmip_names.(variables{v}), cmip_names.spco2{m});


                % number of days off a model is in phase - negative is earlier, positive is later
                var_phase_shift_days = ( harm.(variables{v}).phase(1) - harm_mod.(variables{v}).phase(mod_var_index,1))*365.25./(2*pi);
                var_amp_per_diff = (harm_mod.(variables{v}).amp(mod_var_index,1) - harm.(variables{v}).amp(1))./harm.(variables{v}).amp(1)*100;
                model_marker = color_model{strcmp(cmip_names.(variables{v}){mod_var_index}, color_model(:,1)),4};
                if isempty(var_phase_shift_days)
                    continue
                end

                % phase shift
                talk_phase_shift_days = (harm.talk.phase(1) - harm_mod.talk.phase(mod_talk_index,1))*365.25./(2*pi);

                if talk_phase_shift_days>=adjust_vars.adjust_talk_phase_shift_days(tpsd) - talk_day_shift_bin && ...
                        talk_phase_shift_days<adjust_vars.adjust_talk_phase_shift_days(tpsd) + talk_day_shift_bin

                    if pco2_corr_plot==1

                        mod_pco2_corr = obs.spco2.correlation(m);

                        sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k', 'linewidth', 1.5);
                        temp_name = cmip_names.spco2{m};
                        temp_name = strrep(temp_name, '_', '-');
                        temp_name = strrep(temp_name, '-6', ' (6)');
                        legend_names{end+1,1} = temp_name;
                        disp([temp_name ' ' num2str(round(mod_pco2_corr,2))])


                    else

                        mod_match_index = strcmp(cmip_names.(variables{vp}), cmip_names.spco2{m});
                        if sum(mod_match_index)==0
                            disp([cmip_names.spco2{m} ' missing ' variables{v}])
                            continue
                        end

                        if vp==4
                            var_c = max(CMIP.(variables{vp}).out_seasonal(mod_match_index,:,1))./min(CMIP.(variables{vp}).out_seasonal(mod_match_index,:,1)) ;
                        elseif vp==2
                            mon = 1; % january
                            var_c = CMIP.(variables{vp}).out_seasonal(mod_match_index,mon,1);
                        end

                        marker_color = alt_color_map(round((var_c-min_max(1)+grad_step)./(min_max(2) - min_max(1)+grad_step).*length(alt_color_map)),:);
                        %                     plot(var_phase_shift_days, var_amp_per_diff, 'markeredgecolor', 'k', 'markerfacecolor', marker_color)
                        plot(var_phase_shift_days, var_amp_per_diff, 'o', 'markeredgecolor', 'k', 'markerfacecolor', marker_color, 'markersize', 15)

                    end

                end
            end
        end
        %         pause
        if ~isempty(legend_names)

            l_h(subplot_index) = legend(sc_h, legend_names, 'location', 'southoutside', 'fontsize', 9, 'numcolumns', 2);
        end
    end

    if pco2_corr_plot==0
        % make a subplot that acts as a secondary colorbar for the plotted
        % variable (if not pCO2_corr)
        subplot(3,2,2); hold on

        for c  = min_max(1):grad_step:min_max(2)-grad_step

            marker_color = alt_color_map(round(((c-min_max(1)+grad_step)./(min_max(2) - min_max(1)+grad_step)).*length(alt_color_map)),:);

            p1 = patch([c c+grad_step c+grad_step c],[0 0 1 1], marker_color);
            p1.LineStyle = 'none';

        end
        set(gca, 'ytick', [])
        title(plot_title_add)
    end
end
pause(.2)
sub_pos = NaN(subplot_index,4);
leg_pos = NaN(subplot_index,4);

% for sp = 1:size(sub_pos,1)
%     sub_pos(sp,:) = get(dh(sp), 'Position');
% end

% for sp = 1:6
%     set(dh(sp), 'position', [sub_pos(sp,1) sub_pos(sp,2) sub_pos(2,3)-.3 sub_pos(2,4)])
% end

% % get legend position
% for sp = 1:subplot_index
%     try
%         leg_pos(sp,:) = get(l_h(sp), 'Position');
%     catch
% 
%     end
% end
% %
% % % adjust legend position
% for sp = 3:4
%     if sp==3
%         y_offset = .0005;
%         x_offset = .002;
%     else
%         y_offset = .002;
%         x_offset = .002;
% 
%     end
%     % elseif sp==2
%     %     y_offset = .15;
%     % % else
%     %     y_offset = 0.05;
%     % end
%     set(l_h(sp), 'position', [leg_pos(sp,1)+x_offset leg_pos(sp,2)+y_offset leg_pos(sp,3) leg_pos(sp,4)])
% 
% end

% standardize axis sizes
% get legend position
for sp = 1:subplot_index
    try
        ax_pos(sp,:) = get(dh(sp), 'Position');
    catch

    end
end
% currently plot 2 has a good height, so try to mimic that. need to match
% row y positions afterwards too
height = ax_pos(2,4);
row_1_y = ax_pos(2,2);
row_2_y = ax_pos(4,2);
row_3_y = ax_pos(5,2);

sp=1;
set(dh(sp), 'position', [ax_pos(sp,1) row_1_y ax_pos(sp,3) height])
sp=2;
set(dh(sp), 'position', [ax_pos(sp,1) row_1_y ax_pos(sp,3) height])
sp=3;
set(dh(sp), 'position', [ax_pos(sp,1) row_2_y ax_pos(sp,3) height])
sp = 4;
set(dh(sp), 'position', [ax_pos(sp,1) row_2_y ax_pos(sp,3) height])
sp = 5;
set(dh(sp), 'position', [ax_pos(sp,1) row_3_y ax_pos(sp,3) height])

x = [0.25 0.7];
y = [0.97 0.97];
annotation('textarrow', x, y, 'string', 'TA timing ', 'fontsize', 14, 'linewidth', 3, 'fontweight', 'bold')

x = [0.05 0.05];
y = [0.9 0.2];
annotation('textarrow', x, y, 'string', {'SST'; 'amplitude'}, 'fontsize', 14, 'linewidth', 3, 'fontweight', 'bold')

print(gcf, '-dpdf', [fig_dir plot_filename plot_ver])
% end

%% supplementary figures - all ranges of TA, SST, DIC plots

set(gcf, 'colormap', brewermap(30, 'Spectral'))

v = 7;
main_var = 'dissic';

sub_v = 5;
sub_var_name = 'adjust_tos_amp_percent';

clear sub_var_3_name
model_plot = 1;

% try plotting different variables for the scatter colors
pco2_corr_plot = 1;


% first, find all points with the correct sub_v amplitude and shift, then put
% into a matric of ampl rows and phase columns

% copied idealized test_out_2 to know order of indexes
% idealized_test_out_2 = NaN(length(adjust_dissic_phase_shift_days), length(adjust_dissic_amp_percent), ...
%     length(adjust_tos_phase_shift_days ), length(adjust_tos_amp_percent), ...
%     length(adjust_talk_phase_shift_days), length(adjust_talk_amp_percent),  ...
%     length(adjust_sos_phase_shift_days), length(adjust_sos_amp_percent), 3);
dh = NaN(5,1);
l_h = NaN(5,1);

tos_amp_percent = 0;

talk_day_shift = {0; 100};
tos_amp_per_plot = {0 ;50; 125};
talk_amp_per_plot = {-60; 0; 60};
for ta_n = 1:length(talk_day_shift)

    tpsd = adjust_vars.adjust_talk_phase_shift_days==talk_day_shift{ta_n};

    subplot_index = 0;
    clf
    set(gcf, 'units', 'inches')
    paper_w = 20; paper_h =20;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

    plot_filename = ['Figure SZ Contour_correlation ' variables{v} ' subplots by ' variables{sub_v} ' and talk_phase_shift ' num2str(adjust_vars.adjust_talk_phase_shift_days(tpsd)) '_b'];
    if model_plot==1
        plot_filename = [plot_filename '_model_overlay'];
    end
    if pco2_corr_plot==0
        plot_filename = [plot_filename '_' plot_title_add];

    end
    talk_day_shift_bin = 50;


    for tos_n = 1:length(tos_amp_per_plot)
        if tos_n<3
            sub_v_amp_bin = 25;
        else
            sub_v_amp_bin = 50;
        end
        sub_v_amp_percent=tos_amp_per_plot{tos_n};

        for tap_n = 1:length(talk_amp_per_plot)
            talk_amp_bin = 30;
            tap = adjust_vars.adjust_talk_amp_percent==talk_amp_per_plot{tap_n};

            legend_names = {};
            sc_h = [];
            tos_amp_percent=adjust_vars.(sub_var_name)(tos_n);
            tt = adjust_vars.adjust_tos_amp_percent==tos_amp_per_plot{tos_n};

            sub_v_shift_days = 0;

            subplot_index = subplot_index+1;
            % if tt==2
            %     subplot_index = subplot_index+1;
            % end
            dh(subplot_index) = subplot(length(tos_amp_per_plot),length(talk_amp_per_plot),subplot_index);

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
                pCO2_grid(dd,:) = idealized_test_out_2(:,dd,1,tt,tpsd,tap,1,1,1);
            end

            [C, h] = contourf(adjust_vars.(['adjust_' main_var '_phase_shift_days']), adjust_vars.(['adjust_' main_var '_amp_percent']),pCO2_grid, 'levellist', -1:0.05:1, 'linestyle', 'none');
            c_l = colorbar;
            caxis([-1 1])
            hold on
            [C1, h1] = contour(adjust_vars.(['adjust_' main_var '_phase_shift_days']),adjust_vars.(['adjust_' main_var '_amp_percent']), pCO2_grid, 'levellist', [-0.5:0.5:0.5], 'linestyle', '-', 'linewidth', 2, 'color', 'k');
            clabel(C1, h1);
            ylabel(c_l, 'Model pCO_2 corr. to obs.', 'fontsize', 10)

            var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);

            xlabel([var_plot_names{var_label_index,2} ' Shift (days)'])
            ylabel([var_plot_names{var_label_index,2} ' Amplitude (% diff)'])

            sub_var_label_index = strncmp(variables{sub_v}, var_plot_names(:,1), 4);

            %         xlabel([variables{v} ' Shift (days)'])
            %         ylabel([variables{v} ' Amplitude (% diff)'])

            %         title([(variables{sub_v}) ' amplitude percent ' num2str(sub_v_amp_percent)]);
            title({[var_plot_names{sub_var_label_index,2} ' amplitude range: ' num2str(sub_v_amp_percent-sub_v_amp_bin) ' to ' num2str(sub_v_amp_percent+sub_v_amp_bin) ' %,'] ...
                ['TALK amplitude: ' num2str(talk_amp_per_plot{tap_n}-talk_amp_bin) ' to ' num2str(talk_amp_per_plot{tap_n}+talk_amp_bin) ' %']})
            if model_plot==0
                continue
            end

            % overlay scatter plots with models that fit into different sub_v
            % amplitude bins
            % will need to adjust bin ranges if you modify the number of bins here:
            % sub_v_amp_bin = 25;

            for m = 1:length(cmip_names.spco2)

                mod_talk_index = strcmp(cmip_names.talk, cmip_names.spco2{m});

                if sum(mod_talk_index)==0 % if there is no talk, then it is hard to know if talk is at all reasonable and not causing issues
                    continue
                end

                mod_sub_v_index = strcmp(cmip_names.(variables{sub_v}), cmip_names.spco2{m});
                sub_v_amp_per_diff = (harm_mod.(variables{sub_v}).amp(mod_sub_v_index,1) - harm.(variables{sub_v}).amp(1))./harm.(variables{sub_v}).amp(1)*100;

                if isempty(sub_v_amp_per_diff)
                    continue
                end
                % only plot models that fall in each sub_v amplitude range
                % (temperature amplitude percent)
                if sub_v_amp_per_diff>=sub_v_amp_percent - sub_v_amp_bin && sub_v_amp_per_diff<sub_v_amp_percent + sub_v_amp_bin

                    % check talk amplitude and talk phase as well
                    talk_amp_per_diff = (harm_mod.talk.amp(mod_talk_index,1) - harm.talk.amp(1))./harm.talk.amp(1)*100;

                    if talk_amp_per_diff>=adjust_vars.adjust_talk_amp_percent(tap) - talk_amp_bin && ...
                            talk_amp_per_diff<adjust_vars.adjust_talk_amp_percent(tap) + talk_amp_bin

                        % phase shift
                        talk_phase_shift_days = (harm.talk.phase(1) - harm_mod.talk.phase(mod_talk_index,1))*365.25./(2*pi);

                        if talk_phase_shift_days>=adjust_vars.adjust_talk_phase_shift_days(tpsd) - talk_day_shift_bin && ...
                                talk_phase_shift_days<adjust_vars.adjust_talk_phase_shift_days(tpsd) + talk_day_shift_bin

                            mod_var_index = strcmp(cmip_names.(variables{v}), cmip_names.spco2{m});



                            var_phase_shift_days = (harm.(variables{v}).phase(1) - harm_mod.(variables{v}).phase(mod_var_index,1))*365.25./(2*pi);
                            var_amp_per_diff = (harm_mod.(variables{v}).amp(mod_var_index,1) - harm.(variables{v}).amp(1))./harm.(variables{v}).amp(1)*100;
                            model_marker = color_model{strcmp(cmip_names.(variables{v}){mod_var_index}, color_model(:,1)),4};
                            if isempty(var_phase_shift_days)
                                continue
                            end

                            if pco2_corr_plot==1

                                mod_pco2_corr = obs.spco2.correlation(m);

                                sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 120, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
                                temp_name = cmip_names.spco2{m};
                                temp_name = strrep(temp_name, '_', '-');
                                temp_name = strrep(temp_name, '-6', ' (6)');
                                legend_names{end+1,1} = temp_name;
                                disp([temp_name ' ' num2str(mod_pco2_corr)])


                            else

                                mod_match_index = strcmp(cmip_names.(variables{vp}), cmip_names.spco2{m});
                                if sum(mod_match_index)==0
                                    disp([cmip_names.spco2{m} ' missing ' variables{v}])
                                    continue
                                end

                                if vp==4
                                    var_c = max(CMIP.(variables{vp}).out_seasonal(mod_match_index,:,1))./min(CMIP.(variables{vp}).out_seasonal(mod_match_index,:,1)) ;
                                elseif vp==2
                                    mon = 1; % january
                                    var_c = CMIP.(variables{vp}).out_seasonal(mod_match_index,mon,1);
                                end

                                marker_color = alt_color_map(round((var_c-min_max(1)+grad_step)./(min_max(2) - min_max(1)+grad_step).*length(alt_color_map)),:);
                                %                     plot(var_phase_shift_days, var_amp_per_diff, 'markeredgecolor', 'k', 'markerfacecolor', marker_color)
                                plot(var_phase_shift_days, var_amp_per_diff, 'o', 'markeredgecolor', 'k', 'markerfacecolor', marker_color, 'markersize', 15)

                            end
                            %                 disp(cmip_names.spco2{m})
                            %                 disp(m)
                            %                 disp(var_phase_shift_days)
                            %                 disp(var_amp_per_diff)
                            %
                            %                 disp(mod_pco2_corr)

                            %                                 pause
                        end
                    end
                end
            end
            %         pause
            if ~isempty(legend_names)
                l_h(subplot_index) = legend(sc_h, legend_names, 'location', 'north', 'fontsize', 10, 'numcolumns', 2);
            end
        end



    end

    pause(.2)
    sub_pos = NaN(subplot_index,4);
    leg_pos = NaN(subplot_index,4);

    % for sp = 1:size(sub_pos,1)
    %     sub_pos(sp,:) = get(dh(sp), 'Position');
    % end
    %
    % for sp = 1:3
    %     set(dh(sp), 'position', [sub_pos(sp,1) sub_pos(sp,2) sub_pos(2,3)-.3 sub_pos(2,4)])
    % end
    %
    % % get legend position
    % for sp = 1:size(sub_pos,1)
    %     leg_pos(sp,:) = get(l_h(sp), 'Position');
    % end
    %
    % % adjust legend position
    % for sp = 1:3
    %     if sp==1
    %         y_offset = .08;
    %     elseif sp==2
    %         y_offset = .15;
    %     else
    %         y_offset = 0.05;
    %     end
    %     set(l_h(sp), 'position', [leg_pos(sp,1)+0.13 leg_pos(sp,2)+y_offset leg_pos(sp,3) leg_pos(sp,4)])
    %
    % end

    print(gcf, '-dpdf', [fig_dir plot_filename plot_ver])
    % pause
end

%% Figure 5 - SST plots
% axis_font_size = 13;
% r_text_size = 12;
% 
% plot_filename = 'Figure 5_Var_comparison SST and MLD relationships_multi panel option';
% 
% p_col = 2;
% p_row = 3;
% 
% clf
% set(gcf, 'units', 'inches')
% paper_w = 10; paper_h =13;
% set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h
% 
% subplot(p_row,p_col,1);
% hold on
% 
% % y axis variable choices
% seas_amplitude = 1;
% dissic_vert_gradient=0;
% sv2_name = 'tos';
% sv2 = find(strncmp(seas_comp_vars, sv2_name,4));
% v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
% if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
%     v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
% end
% 
% % %% only applies if seas_amplitude is off
% tests = {'norm_error';'correlation' ; 'ratio'};
% test_names = {'normalized error'; 'correlation' ; 'Amplitude Ratio'};
% 
% tt = 2;
% % %%
% 
% 
% % x-axis variable choices
% alt_x=0; % 0: x axis is one individual month for variable sv
% % 1: x axis is ratio of max to min
% % 2: x axis is seasonal amplitude of sv
% mon = 3;
% dd = 12;
% 
% wmo_on = 0; % takes precedence over alt_x
% if wmo_on==0
%     sv_name = 'mld';
%     sv = find(strncmp(seas_comp_vars, sv_name,4));
%     v = find(strncmp(seas_comp_vars{sv}, variables, 4));
%     if length(v)>1 % cludge since dissic and dissic_yr were getting confused
%         v = strmatch(seas_comp_vars{sv}, variables, 'exact');
%     end
% else
%     v=10;
% end
% 
% temp_array =[];
% temp_names = {};
% legend_names = {};
% sc_h = [];
% 
% for m = 1:length(cmip_names.(variables{v}))
%     mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
% 
%     if sum(mod_match)>0
%         % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
%             plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);
% 
%             model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};
% 
%             %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
%             temp_name = cmip_names.(variables{v}){m};
%             temp_name = strrep(temp_name, '_', '-');
%             temp_name = strrep(temp_name, '-6', ' (6)');
%             legend_names{end+1,1} = temp_name;
%             %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])
% 
% 
% 
%             if seas_amplitude ==1
%                 var_2 = max(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) - min(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) ;
%             else
%                 var_2 = obs.(variables{v2}).(tests{tt})(mod_match);
% 
%             end
% 
%             if dissic_vert_gradient==1
%                 if CMIP.dissic_yr.out_annual(m,1,1)==0 % there is an error in CESM2_6 depth coordinate so the interpolation is not working properly
%                     continue
%                 end
%                 var_1 = CMIP.dissic_yr.out_annual(m,1,1) - CMIP.dissic_yr.out_annual(m,dd,1) ;
% 
%             else
%                 if wmo_on==1
%                     var_1 = CMIP.wmo.out_seasonal(m,dd,mon,1) ;
%                 elseif alt_x==0
%                     var_1 = CMIP.(variables{v}).out_seasonal(m,mon,1);
%                 elseif alt_x==1
%                     var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
%                 elseif alt_x==2
%                     var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
% 
%                 end
%             end
%             if isnan(var_1) || isnan(var_2)
%                 continue
%             end
% 
%             sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
%                 'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
%             if alt_x==1 && var_1>20
%                 disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
%                 plot(var_1,	var_2 , 'marker', 'o', 'color', ...
%                     'k', 'markerfacecolor', 'none','markersize', 20, 'linestyle', 'none');
%                 continue
%             end
%             temp_names{end+1,1} = cmip_names.(variables{v}){m};
%             temp_array(end+1,1) = var_1;
%             temp_array(end,2) = var_2;
%         % end
%     end
% 
% end
% 
% if seas_amplitude~=1 && tt~=1 % if plotting correlation or ratio, "obs" equals 1.
%     obs_y = 1;
% elseif seas_amplitude~=1 % if plotting normalized error, "obs" equals 0
%     obs_y=0;
% elseif seas_amplitude==1
%     obs_y = max(obs.(variables{v2}).out_seasonal(:,1)) - min(obs.(variables{v2}).out_seasonal(:,1));
% end
% 
% if wmo_on==0
%     if dissic_vert_gradient==1
%         obs_annual_mean = squeeze(nanmean(obs.dissic.out_seasonal(:,1,:),1));
%         var_1_obs = obs_annual_mean(1,1) - obs_annual_mean(dd,1);
%     elseif alt_x==1
%         var_1_obs = max(obs.(variables{v}).out_seasonal(:,1))./(min(obs.(variables{v}).out_seasonal(:,1)));
%     elseif alt_x==0
%         var_1_obs = obs.(variables{v}).out_seasonal(mon,1);
%     end
% 
%     sc_h(end+1) = plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10);
%     legend_names{end+1,1} = 'Observations';
% 
% end
% 
% var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);
% 
% if sum(var_label_index>0)
%     if seas_amplitude==1
%         comp_label = [var_plot_names{var_label_index,2} ' seasonal amp. (' var_plot_names{var_label_index,3} ')' ];
%     else
%         comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
%     end
% 
% else
%     if seas_amplitude==1
%         comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
%     else
%         comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
%     end
% 
% end
% dt = datetime(2024, mon, 1);
% abbreviated_month = month(dt, 'short');
% 
% var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
% if dissic_vert_gradient==1
%     x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
% elseif wmo_on==1
%     x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
% else
%     if alt_x==0
%         x_label = [abbreviated_month{1} '. ' var_plot_names{var_label_index,2}  ' (' var_plot_names{var_label_index,3} ')'];
%     else
%         x_label = [variables{v} ' max divided by min'];
%     end
% end
% xlabel( x_label, 'interpreter', 'none')
% ylabel(comp_label)
% grid on
% 
% [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
% x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
% y_plot = m.*x_plot+b;
% plot(x_plot, y_plot, 'k-')
% % title(['r= ' num2str(r,2)])
% x_lim = get(gca, 'xlim');
% y_lim = get(gca, 'ylim');
% text(x_lim(2)- diff(x_lim)*.25, y_lim(2)-diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
% 
% % legend(sc_h, legend_names, 'location', 'southoutside', 'fontsize', 10, 'numcolumns', 2);
% 
% set(gca, 'fontsize', axis_font_size)
% 
% %%%%%%%%% plotting SST Amp vs. Winter month:
% subplot(p_row,p_col,2);
% hold on
% 
% % y axis variable choices
% seas_amplitude = 1;
% dissic_vert_gradient=0;
% sv2_name = 'tos';
% sv2 = find(strncmp(seas_comp_vars, sv2_name,4));
% v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
% if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
%     v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
% end
% 
% % %% only applies if seas_amplitude is off
% tests = {'norm_error';'correlation' ; 'ratio'};
% test_names = {'normalized error'; 'correlation' ; 'Amplitude Ratio'};
% 
% tt = 2;
% % %%
% 
% 
% % x-axis variable choices
% alt_x=0; % 0: x axis is one individual month for variable sv
% % 1: x axis is ratio of max to min
% % 2: x axis is seasonal amplitude of sv
% mon = 9;
% dd = 12;
% 
% wmo_on = 0; % takes precedence over alt_x
% if wmo_on==0
%     sv_name = 'mld';
%     sv = find(strncmp(seas_comp_vars, sv_name,4));
%     v = find(strncmp(seas_comp_vars{sv}, variables, 4));
%     if length(v)>1 % cludge since dissic and dissic_yr were getting confused
%         v = strmatch(seas_comp_vars{sv}, variables, 'exact');
%     end
% else
%     v=10;
% end
% 
% temp_array =[];
% temp_names = {};
% legend_names = {};
% sc_h = [];
% 
% for m = 1:length(cmip_names.(variables{v}))
%     mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
% 
%     if sum(mod_match)>0
%         % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
%             plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);
% 
%             model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};
% 
%             %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
%             temp_name = cmip_names.(variables{v}){m};
%             temp_name = strrep(temp_name, '_', '-');
%             temp_name = strrep(temp_name, '-6', ' (6)');
%             legend_names{end+1,1} = temp_name;
%             %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])
% 
% 
% 
%             if seas_amplitude ==1
%                 var_2 = max(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) - min(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) ;
%             else
%                 var_2 = obs.(variables{v2}).(tests{tt})(mod_match);
% 
%             end
% 
%             if dissic_vert_gradient==1
%                 if CMIP.dissic_yr.out_annual(m,1,1)==0 % there is an error in CESM2_6 depth coordinate so the interpolation is not working properly
%                     continue
%                 end
%                 var_1 = CMIP.dissic_yr.out_annual(m,1,1) - CMIP.dissic_yr.out_annual(m,dd,1) ;
% 
%             else
%                 if wmo_on==1
%                     var_1 = CMIP.wmo.out_seasonal(m,dd,mon,1) ;
%                 elseif alt_x==0
%                     var_1 = CMIP.(variables{v}).out_seasonal(m,mon,1);
%                 elseif alt_x==1
%                     var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
%                 elseif alt_x==2
%                     var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
% 
%                 end
%             end
%             if isnan(var_1) || isnan(var_2)
%                 continue
%             end
% 
%             sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
%                 'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
% 
%             if alt_x==1 && var_1>20
%                 disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
%                 plot(var_1,	var_2 , 'marker', 'o', 'color', ...
%                     'k', 'markerfacecolor', 'none','markersize', 24, 'linestyle', 'none');
%                 continue
%             end
%             temp_names{end+1,1} = cmip_names.(variables{v}){m};
%             temp_array(end+1,1) = var_1;
%             temp_array(end,2) = var_2;
%         % end
%     end
% 
% 
% 
% end
% 
% if seas_amplitude~=1 && tt~=1 % if plotting correlation or ratio, "obs" equals 1.
%     obs_y = 1;
% elseif seas_amplitude~=1 % if plotting normalized error, "obs" equals 0
%     obs_y=0;
% elseif seas_amplitude==1
%     obs_y = max(obs.(variables{v2}).out_seasonal(:,1)) - min(obs.(variables{v2}).out_seasonal(:,1));
% end
% 
% if wmo_on==0
%     if dissic_vert_gradient==1
%         obs_annual_mean = squeeze(nanmean(obs.dissic.out_seasonal(:,1,:),1));
%         var_1_obs = obs_annual_mean(1,1) - obs_annual_mean(dd,1);
%     elseif alt_x==1
%         var_1_obs = max(obs.(variables{v}).out_seasonal(:,1))./(min(obs.(variables{v}).out_seasonal(:,1)));
%     elseif alt_x==0
%         var_1_obs = obs.(variables{v}).out_seasonal(mon,1);
%     end
% 
%     sc_h(end+1) =  plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10);
%     legend_names{end+1,1} = 'Observations';
% 
% end
% 
% var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);
% 
% if sum(var_label_index>0)
%     if seas_amplitude==1
%         comp_label = [var_plot_names{var_label_index,2} ' seasonal amp. (' var_plot_names{var_label_index,3} ')' ];
%     else
%         comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
%     end
% 
% else
%     if seas_amplitude==1
%         comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
%     else
%         comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
%     end
% 
% end
% dt = datetime(2024, mon, 1);
% abbreviated_month = month(dt, 'short');
% 
% var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
% if dissic_vert_gradient==1
%     x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
% elseif wmo_on==1
%     x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
% else
%     if alt_x==0
%         x_label = [abbreviated_month{1} '. ' var_plot_names{var_label_index,2}  ' (' var_plot_names{var_label_index,3} ')'];
%     else
%         x_label = [variables{v} ' max divided by min'];
%     end
% end
% xlabel( x_label, 'interpreter', 'none')
% ylabel(comp_label)
% grid on
% [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
% x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
% y_plot = m.*x_plot+b;
% plot(x_plot, y_plot, 'k-')
% % title(['r= ' num2str(r,2)])
% x_lim = get(gca, 'xlim');
% y_lim = get(gca, 'ylim');
% text(x_lim(2)- diff(x_lim)*.25, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
% 
% % legend(sc_h, legend_names, 'location', 'southoutside', 'fontsize', 10, 'numcolumns', 2);
% 
% set(gca, 'fontsize', axis_font_size)
% 
% %%%%%%%%% MLD Max/ Min
% subplot(p_row,p_col,3);
% hold on
% 
% % y axis variable choices
% seas_amplitude = 1;
% dissic_vert_gradient=0;
% sv2_name = 'tos';
% sv2 = find(strncmp(seas_comp_vars, sv2_name,4));
% v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
% if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
%     v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
% end
% 
% % %% only applies if seas_amplitude is off
% tests = {'norm_error';'correlation' ; 'ratio'};
% test_names = {'normalized error'; 'correlation' ; 'Amplitude Ratio'};
% 
% tt = 2;
% % %%
% 
% 
% % x-axis variable choices
% alt_x=1; % 0: x axis is one individual month for variable sv
% % 1: x axis is ratio of max to min
% % 2: x axis is seasonal amplitude of sv
% mon = 3;
% dd = 12;
% 
% wmo_on = 0; % takes precedence over alt_x
% if wmo_on==0
%     sv_name = 'mld';
%     sv = find(strncmp(seas_comp_vars, sv_name,4));
%     v = find(strncmp(seas_comp_vars{sv}, variables, 4));
%     if length(v)>1 % cludge since dissic and dissic_yr were getting confused
%         v = strmatch(seas_comp_vars{sv}, variables, 'exact');
%     end
% else
%     v=10;
% end
% 
% 
% temp_array =[];
% temp_names = {};
% legend_names = {};
% sc_h = [];
% 
% for m = 1:length(cmip_names.(variables{v}))
%     mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
% 
%     if sum(mod_match)>0
%         % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
%             plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);
% 
%             model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};
% 
%             %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
%             temp_name = cmip_names.(variables{v}){m};
%             temp_name = strrep(temp_name, '_', '-');
%             temp_name = strrep(temp_name, '-6', ' (6)');
%             legend_names{end+1,1} = temp_name;
%             %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])
% 
% 
% 
%             if seas_amplitude ==1
%                 var_2 = max(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) - min(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) ;
%             else
%                 var_2 = obs.(variables{v2}).(tests{tt})(mod_match);
% 
%             end
% 
%             if dissic_vert_gradient==1
%                 if CMIP.dissic_yr.out_annual(m,1,1)==0 % there is an error in CESM2_6 depth coordinate so the interpolation is not working properly
%                     continue
%                 end
%                 var_1 = CMIP.dissic_yr.out_annual(m,1,1) - CMIP.dissic_yr.out_annual(m,dd,1) ;
% 
%             else
%                 if wmo_on==1
%                     var_1 = CMIP.wmo.out_seasonal(m,dd,mon,1) ;
%                 elseif alt_x==0
%                     var_1 = CMIP.(variables{v}).out_seasonal(m,mon,1);
%                 elseif alt_x==1
%                     var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
%                 elseif alt_x==2
%                     var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
% 
%                 end
%             end
%             if isnan(var_1) || isnan(var_2)
%                 continue
%             end
% 
%             sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
%                 'k', 'markerfacecolor', plot_color','markersize', 14, 'linestyle', 'none');
%             if alt_x==1 && var_1>20
%                 disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
%                 plot(var_1,	var_2 , 'marker', 'o', 'color', ...
%                     'k', 'markerfacecolor', 'none','markersize', 24, 'linestyle', 'none');
%                 continue
%             end
%             temp_names{end+1,1} = cmip_names.(variables{v}){m};
%             temp_array(end+1,1) = var_1;
%             temp_array(end,2) = var_2;
%         % end
%     end
% 
% end
% 
% if seas_amplitude~=1 && tt~=1 % if plotting correlation or ratio, "obs" equals 1.
%     obs_y = 1;
% elseif seas_amplitude~=1 % if plotting normalized error, "obs" equals 0
%     obs_y=0;
% elseif seas_amplitude==1
%     obs_y = max(obs.(variables{v2}).out_seasonal(:,1)) - min(obs.(variables{v2}).out_seasonal(:,1));
% end
% 
% if wmo_on==0
%     if dissic_vert_gradient==1
%         obs_annual_mean = squeeze(nanmean(obs.dissic.out_seasonal(:,1,:),1));
%         var_1_obs = obs_annual_mean(1,1) - obs_annual_mean(dd,1);
%     elseif alt_x==1
%         var_1_obs = max(obs.(variables{v}).out_seasonal(:,1))./(min(obs.(variables{v}).out_seasonal(:,1)));
%     elseif alt_x==0
%         var_1_obs = obs.(variables{v}).out_seasonal(mon,1);
%     end
% 
%     sc_h(end+1) = plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10);
%     legend_names{end+1,1} = 'Observations';
% 
% end
% 
% var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);
% 
% if sum(var_label_index>0)
%     if seas_amplitude==1
%         comp_label = [var_plot_names{var_label_index,2} ' seasonal amp. (' var_plot_names{var_label_index,3} ')' ];
%     else
%         comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
%     end
% 
% else
%     if seas_amplitude==1
%         comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
%     else
%         comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
%     end
% 
% end
% 
% var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
% if dissic_vert_gradient==1
%     x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
% elseif wmo_on==1
%     x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
% else
%     if alt_x==0
%         x_label = [var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ') from month  ' num2str(mon)];
%     else
%         x_label = [var_plot_names{var_label_index,2} ' max divided by min'];
%     end
% end
% xlabel( x_label, 'interpreter', 'none')
% ylabel(comp_label)
% grid on
% [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
% x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
% y_plot = m.*x_plot+b;
% plot(x_plot, y_plot, 'k-')
% % title(['r= ' num2str(r,2)])
% x_lim = get(gca, 'xlim');
% y_lim = get(gca, 'ylim');
% text(x_lim(2)- diff(x_lim)*.25, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
% 
% 
% leg_x_shift = .4;
% 
% l1 = legend(sc_h, legend_names, 'location', 'south', 'fontsize', 10, 'numcolumns', 2);
% l1_pos = get(l1, 'Position');
% set(l1, 'Position', l1_pos+[leg_x_shift 0 0 0])
% set(gca, 'fontsize', axis_font_size)
% 
% % plotting Taylor RMS vs each other
% subplot(p_row,p_col,5)
% % now also do the other comparisons (i.e. correlation vs. correlation)
% filter_on=0;
% if filter_on==1
%     disp('Warning, some results filtered from regression analysis')
% end
% % example spco2 match vs. intpp
% tests = {'norm_error';'correlation' ; 'ratio'};
% test_names = {'normalized error'; 'correlation' ; 'amplitude ratio'};
% % legend_on=0;
% group_color = 2;
% set(gcf, 'colormap', turbo)
% v3_name = 'mld'; % variable for harmonic fit scatter color
% v3 = find(strncmp(v3_name, variables, 4));
% 
% 
% harm_comp = 'offset';
% 
% for sv_name = {['mld']}% [1 2 3 4 5 6 8 9 10] %1:length(seas_comp_vars)
%     sv = find(strncmp(seas_comp_vars, sv_name,4));
% 
%     for tt = 3%:length(tests)
%         for qq = 1% 1:length(tests)
%             %             if strcmp(variables{v}, 'wmo') || strcmp(variables{v}, 'psl') || strcmp(variables{v}, 'dissic_yr') || strcmp(variables{v}, 'talk_yr') || strcmp(variables{v}, 'thetao')
%             %                 continue
%             %             end
% 
%             % find matching v
%             v = find(strncmp(seas_comp_vars{sv}, variables, 4));
%             if length(v)>1 % cludge since dissic and dissic_yr were getting confused
%                 v = strmatch(seas_comp_vars{sv}, variables, 'exact');
%             end
% 
%             plot_index = 0;
% 
%             %             plot_filename = ['Taylor ' seas_comp_vars{sv} ' ' tests{qq} ' vs. ' tests{tt} ' other vars_model_groups=' num2str(group_color) ' filter ' num2str(filter_on)];
%             %             if group_color==2
%             %                 plot_filename = ['Taylor ' seas_comp_vars{sv} ' ' tests{qq} ' vs. ' tests{tt} ' other vars_model_groups=' num2str(group_color) '_' variables{v3} '_' ...
%             %                     harm_comp ' filter ' num2str(filter_on)];
%             %
%             %             end
%             for sv2_name = {['tos']}%[1 2 3 4 5 6 8 9 10]
%                 sv2 = find(strncmp(seas_comp_vars, sv2_name,4));
%                 if sv2==sv
%                     continue
%                     %                 elseif strcmp(variables{v2}, 'wmo') || strcmp(variables{v2}, 'psl') || strcmp(variables{v2}, 'dissic_yr') || strcmp(variables{v2}, 'talk_yr') || strcmp(variables{v2}, 'thetao')
%                     %                     continue
%                 end
% 
%                 v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
%                 if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
%                     v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
%                 end
% 
%                 plot_index = plot_index+1;
% 
%                 %                 subplot(3,3,plot_index)
% 
%                 hold on
%                 %                 grid on
% 
%                 temp_array = [];
%                 temp_color = [];
%                 sc_h = [];
%                 legend_names = {};
% 
%                 for m = 1:length(cmip_names.(variables{v}))
% 
% 
%                     % find the matching model
%                     mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
% 
%                     if sum(mod_match)>0
%                         % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
% 
%                             if group_color==1
%                                 plot_color = model_group_colors(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3},:);
%                             elseif group_color==0
%                                 plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);
% 
%                             end
% 
%                             if group_color==0 || group_color==1
%                                 plot(obs.(variables{v}).(tests{qq})(m), obs.(variables{v2}).(tests{tt})(mod_match), '.', 'color', ...
%                                     plot_color, 'markersize', 20)
%                             elseif group_color==2 % plotting color based on harmonic fit info
%                                 mod_match_2 = strcmp(cmip_names.(variables{v3}), cmip_names.(variables{v}){m});
% 
%                                 if sum(mod_match_2)>0
%                                     %                                     mod_pco2_corr = obs.spco2.correlation(m);
%                                     model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};
% 
%                                     %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
%                                     temp_name = cmip_names.(variables{v}){m};
%                                     temp_name = strrep(temp_name, '_', '-');
%                                     temp_name = strrep(temp_name, '-6', ' (6)');
%                                     legend_names{end+1,1} = temp_name;
%                                     %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])
% 
% 
%                                     harm_diff = harm_mod.(variables{v3}).(harm_comp)(mod_match_2) - harm.(variables{v3}).(harm_comp); % difference in phase between model and obs
% 
%                                     sc_h(end+1) = scatter(obs.(variables{v}).(tests{qq})(m), obs.(variables{v2}).(tests{tt})(mod_match), 100, harm_diff, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
%                                     c1 = colorbar;
%                                     temp_color(end+1) = harm_diff;
%                                 else
%                                     plot(obs.(variables{v}).(tests{qq})(m), obs.(variables{v2}).(tests{tt})(mod_match), 'o', 'color', ...
%                                         'k', 'markersize', 7)
%                                 end
% 
%                                 var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
%                                 ylabel(c1, ['Model ' var_plot_names{var_label_index,2} ' ' harm_comp ' (' var_plot_names{var_label_index,3} ')'])
% 
%                             end
%                             temp_array(end+1,1) = obs.(variables{v}).(tests{qq})(m);
%                             temp_array(end,2) = obs.(variables{v2}).(tests{tt})(mod_match);
% 
%                         end
%                     % end
%                     clear plot_color
%                 end
%                 if group_color==2
%                     c_lim = caxis;
%                     %                     caxis([-max(abs(c_lim)) max(abs(c_lim))])
%                     caxis([-nanstd(temp_color) nanstd(temp_color)]*2.5)
%                 end
% 
%                 var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
%                 if sum(var_label_index>0)
%                     xlabel( [var_plot_names{var_label_index,2} ' ' test_names{qq}], 'interpreter', 'none')
%                 else
%                     xlabel( [variables{v} ' ' test_names{qq}], 'interpreter', 'none')
%                 end
% 
%                 var_label_index = strncmp(variables{v2}, var_plot_names(:,1), 4);
%                 if sum(var_label_index>0)
%                     ylabel([var_plot_names{var_label_index,2} ' ' test_names{tt}], 'interpreter', 'none')
%                 else
%                     ylabel([variables{v2} ' ' test_names{tt}], 'interpreter', 'none')
% 
%                 end
%                 if filter_on==1
%                     temp_array(temp_array(:,1)>3,1)=nan;
%                     temp_array = temp_array(~isnan(temp_array(:,1)),:);
% 
%                 end
% 
%                 %                 [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
%                 %                 x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
%                 %                 y_plot = m.*x_plot+b;
%                 %                 plot(x_plot, y_plot, 'k-')
%                 %                 if filter_on==0
%                 %                     title(['r= ' num2str(r,2)])
%                 %                 else
%                 %                     title(['filt r= ' num2str(r,2)])
%                 %                 end
%                 if tt>1
%                     plot(get(gca, 'xlim'), [1 1], '-k')
%                 end
% 
%                 if tt==3
%                     orig_y_lim = get(gca, 'ylim');
% 
%                     if orig_y_lim(1)<0
%                         orig_y_lim(1)=0;
%                     end
% 
%                     set(gca, 'ylim', orig_y_lim)
%                 end
% 
%                 if tt==2
%                     orig_y_lim = get(gca, 'ylim');
% 
%                     if orig_y_lim(1)<-1
%                         orig_y_lim(1)=-1;
%                     end
%                     if orig_y_lim(2)>1
%                         orig_y_lim(2)=1;
%                     end
% 
%                     set(gca, 'ylim', orig_y_lim)
%                 end
% 
%                 if qq>1
%                     plot([1 1], get(gca, 'ylim'), '-k')
%                 end
%             end
% 
%             %             subplot(3,3,9)
%             %             hold on
%             %             for m = 1:length(model_types)
%             %                 plot(0,0, '.', 'color', model_group_colors(m,:), 'markersize', 25)
%             %
%             %             end
%             %             if legend_on ==1
% 
%             %             end
%             %             print(gcf, '-dpng', [Plot_out_dir variables{v} '/' plot_filename '_v8_test.png'])
%         end
%     end
% end
% l2 = legend(sc_h, legend_names, 'location', 'south', 'fontsize', 10, 'numcolumns', 2);
% l2_pos = get(l2, 'Position');
% set(l2, 'Position', l2_pos+[.5 0 0 0])
% grid on
% set(gca, 'fontsize', axis_font_size)
% 
% annotation('textbox', [0.05, 0.05, 1, 0], 'String', plot_filename, 'EdgeColor', 'none', 'interpreter', 'none');
% 
% print(gcf, '-dpng', [fig_dir plot_filename plot_ver '.png'])
%% Figure 5 - all months option
axis_font_size = 13;
r_text_size = 12;

plot_filename = 'Figure S_Var_comparison SST and MLD relationships_all months';

p_col = 4;
p_row = 3;

clf
set(gcf, 'units', 'inches')
paper_w = 15; paper_h =13;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h

for mon = 1:12
    subplot(p_row,p_col,mon);
    hold on

    % y axis variable choices
    seas_amplitude = 1;
    dissic_vert_gradient=0;
    sv2_name = 'tos';
    sv2 = find(strncmp(seas_comp_vars, sv2_name,4));
    v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
    if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
        v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
    end

    % %% only applies if seas_amplitude is off
    tests = {'norm_error';'correlation' ; 'ratio'};
    test_names = {'normalized error'; 'correlation' ; 'Amplitude Ratio'};

    tt = 2;
    % %%


    % x-axis variable choices
    alt_x=0; % 0: x axis is one individual month for variable sv
    % 1: x axis is ratio of max to min
    % 2: x axis is seasonal amplitude of sv
    % mon = 3;
    dd = 12;

    wmo_on = 0; % takes precedence over alt_x
    if wmo_on==0
        sv_name = 'mld';
        sv = find(strncmp(seas_comp_vars, sv_name,4));
        v = find(strncmp(seas_comp_vars{sv}, variables, 4));
        if length(v)>1 % cludge since dissic and dissic_yr were getting confused
            v = strmatch(seas_comp_vars{sv}, variables, 'exact');
        end
    else
        v=10;
    end

    temp_array =[];
    temp_names = {};
    legend_names = {};
    sc_h = [];

    for m = 1:length(cmip_names.(variables{v}))
        mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});

        if sum(mod_match)>0
            % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
                plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);

                model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};

                %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
                temp_name = cmip_names.(variables{v}){m};
                temp_name = strrep(temp_name, '_', '-');
                temp_name = strrep(temp_name, '-6', ' (6)');
                legend_names{end+1,1} = temp_name;
                %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])



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
                    elseif alt_x==1
                        var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
                    elseif alt_x==2
                        var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;

                    end
                end
                if isnan(var_1) || isnan(var_2)
                    continue
                end

                sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
                    'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
                if alt_x==1 && var_1>20
                    disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
                    plot(var_1,	var_2 , 'marker', 'o', 'color', ...
                        'k', 'markerfacecolor', 'none','markersize', 20, 'linestyle', 'none');
                    continue
                end
                temp_names{end+1,1} = cmip_names.(variables{v}){m};
                temp_array(end+1,1) = var_1;
                temp_array(end,2) = var_2;
            % end
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

        sc_h(end+1) = plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10);
        legend_names{end+1,1} = 'Observations';

    end

    var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);

    if sum(var_label_index>0)
        if seas_amplitude==1
            comp_label = [var_plot_names{var_label_index,2} ' seasonal amp. (' var_plot_names{var_label_index,3} ')' ];

        else
            comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
        end

    else
        if seas_amplitude==1
            comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];

        else
            comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
        end

    end
    dt = datetime(2024, mon, 1);
    abbreviated_month = month(dt, 'short');

    var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
    if dissic_vert_gradient==1
        x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
    elseif wmo_on==1
        x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
    else
        if alt_x==0
            % x_label = [abbreviated_month{1} '. ' var_plot_names{var_label_index,2}  ' (' var_plot_names{var_label_index,3} ')'];
            x_label = [abbreviated_month{1} '.'];

        else
            x_label = [variables{v} ' max divided by min'];
        end
    end
    title( x_label, 'interpreter', 'none')
    x = 2;
    y = 8.2;
    letter_size = 13;
    if mon==1
        text(x, y, 'a.', 'fontsize', letter_size)
    elseif mon==2
        text(x,y, 'b.', 'fontsize', letter_size)
    elseif mon==3
        text(x,y, 'c.', 'fontsize', letter_size)
    elseif mon==4
        text(x,y, 'd.', 'fontsize', letter_size)
    elseif mon==5
        text(x,y, 'e.', 'fontsize', letter_size)
    elseif mon==6
        text(x,y, 'f.', 'fontsize', letter_size)
    elseif mon==7
        text(x,y, 'g.', 'fontsize', letter_size)
    elseif mon==8
        text(x,y, 'h.', 'fontsize', letter_size)
    elseif mon==9
        text(x,y, 'i.', 'fontsize', letter_size)
    elseif mon==10
        text(x,y, 'j.', 'fontsize', letter_size)
    elseif mon==11
        text(x,y, 'k.', 'fontsize', letter_size)
    elseif mon==12
        text(x,y, 'l.', 'fontsize', letter_size)
    end
    if mon==10
        x1 = xlabel('Month MLD (m)');
        x_pos = get(x1, 'Position');
        set(x1, 'position', x_pos+[120 -.5 0], 'fontweight', 'bold')
    end
    grid on

    [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
    x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
    y_plot = m.*x_plot+b;
    plot(x_plot, y_plot, 'k-')
    [~, ~, R_2, significant] = Sokal_Rohlf_regression_significance(temp_array(:,1), temp_array(:,2));

    % title(['r= ' num2str(r,2)])
    if sv==10
        set(gca, 'xlim', [0 230])
    end
    if sv2==1
        set(gca, 'ylim', [2 8])
    end
    x_lim = get(gca, 'xlim');
    y_lim = get(gca, 'ylim');
    if significant==1
        text(x_lim(2)- diff(x_lim)*.25, y_lim(2)-diff(y_lim)*.1, ['R^2: ' num2str(r^2,2) '^*'], 'fontsize', r_text_size, 'fontweight', 'bold')
    else
        text(x_lim(2)- diff(x_lim)*.25, y_lim(2)-diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
    end
    if mon==5
        y1 = ylabel(comp_label);
        y1_pos = get(y1, 'Position');
        set(y1, 'position', y1_pos+[-20 0 0], 'fontweight', 'bold')
    end
    % legend(sc_h, legend_names, 'location', 'southoutside', 'fontsize', 10, 'numcolumns', 2);

    set(gca, 'fontsize', axis_font_size)
end


% annotation('textbox', [0.05, 0.05, 1, 0], 'String', plot_filename, 'EdgeColor', 'none', 'interpreter', 'none');

% print(gcf, '-dpng', [fig_dir plot_filename plot_ver '.png'])
print(gcf, '-dpdf', [fig_dir plot_filename plot_ver '.pdf'], '-r300')

%% Figure 6 - DIC physical plots

% axis_font_size = 13;
% r_text_size = 12;
% 
% plot_filename = 'Figure 6_Var_comparison DIC and MLD relationships_multi panel option';
% 
% p_col = 3;
% p_row = 3;
% leg_x_shift = .4;
% 
% clf
% set(gcf, 'units', 'inches')
% paper_w = 15; paper_h =12;
% set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h
% 
% subplot(p_row,p_col,4);
% hold on
% 
% % y axis variable choices
% seas_amplitude = 1;
% dissic_vert_gradient=0;
% sv2_name = 'dissic';
% sv2 = find(strncmp(seas_comp_vars, sv2_name,4));
% v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
% if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
%     v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
% end
% 
% % %% only applies if seas_amplitude is off
% tests = {'norm_error';'correlation' ; 'ratio'};
% test_names = {'normalized error'; 'correlation' ; 'Amplitude Ratio'};
% 
% tt = 2;
% 
% % x-axis variable choices
% alt_x=0; % 0: x axis is one individual month for variable sv
% % 1: x axis is ratio of max to min
% % 2: x axis is seasonal amplitude of sv
% mon = 3;
% dd = 12;
% 
% wmo_on = 0; % takes precedence over alt_x
% if wmo_on==0
%     sv_name = 'mld';
%     sv = find(strncmp(seas_comp_vars, sv_name,4));
%     v = find(strncmp(seas_comp_vars{sv}, variables, 4));
%     if length(v)>1 % cludge since dissic and dissic_yr were getting confused
%         v = strmatch(seas_comp_vars{sv}, variables, 'exact');
%     end
% else
%     v=10;
% end
% 
% temp_array =[];
% temp_names = {};
% legend_names = {};
% sc_h = [];
% 
% for m = 1:length(cmip_names.(variables{v}))
%     mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
% 
%     if sum(mod_match)>0
%         % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
%             plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);
% 
%             model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};
% 
%             %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
%             temp_name = cmip_names.(variables{v}){m};
%             temp_name = strrep(temp_name, '_', '-');
%             temp_name = strrep(temp_name, '-6', ' (6)');
%             legend_names{end+1,1} = temp_name;
%             %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])
% 
% 
% 
%             if seas_amplitude ==1
%                 var_2 = max(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) - min(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) ;
%             else
%                 var_2 = obs.(variables{v2}).(tests{tt})(mod_match);
% 
%             end
% 
%             if dissic_vert_gradient==1
%                 if CMIP.dissic_yr.out_annual(m,1,1)==0 % there is an error in CESM2_6 depth coordinate so the interpolation is not working properly
%                     continue
%                 end
%                 var_1 = CMIP.dissic_yr.out_annual(m,1,1) - CMIP.dissic_yr.out_annual(m,dd,1) ;
% 
%             else
%                 if wmo_on==1
%                     var_1 = CMIP.wmo.out_seasonal(m,dd,mon,1) ;
%                 elseif alt_x==0
%                     var_1 = CMIP.(variables{v}).out_seasonal(m,mon,1);
%                 elseif alt_x==1
%                     var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
%                 elseif alt_x==2
%                     var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
% 
%                 end
%             end
%             if isnan(var_1) || isnan(var_2)
%                 continue
%             end
% 
%             sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
%                 'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
%             if alt_x==1 && var_1>20
%                 disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
%                 plot(var_1,	var_2 , 'marker', 'o', 'color', ...
%                     'k', 'markerfacecolor', 'none','markersize', 24, 'linestyle', 'none');
%                 continue
%             end
%             temp_names{end+1,1} = cmip_names.(variables{v}){m};
%             temp_array(end+1,1) = var_1;
%             temp_array(end,2) = var_2;
%         % end
%     end
% 
% end
% 
% if seas_amplitude~=1 && tt~=1 % if plotting correlation or ratio, "obs" equals 1.
%     obs_y = 1;
% elseif seas_amplitude~=1 % if plotting normalized error, "obs" equals 0
%     obs_y=0;
% elseif seas_amplitude==1
%     obs_y = max(obs.(variables{v2}).out_seasonal(:,1)) - min(obs.(variables{v2}).out_seasonal(:,1));
% end
% 
% if wmo_on==0
%     if dissic_vert_gradient==1
%         obs_annual_mean = squeeze(nanmean(obs.dissic.out_seasonal(:,1,:),1));
%         var_1_obs = obs_annual_mean(1,1) - obs_annual_mean(dd,1);
%     elseif alt_x==1
%         var_1_obs = max(obs.(variables{v}).out_seasonal(:,1))./(min(obs.(variables{v}).out_seasonal(:,1)));
%     elseif alt_x==0
%         var_1_obs = obs.(variables{v}).out_seasonal(mon,1);
%     end
% 
%     plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10)
% end
% 
% var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);
% 
% if sum(var_label_index>0)
%     if seas_amplitude==1
%         comp_label = [var_plot_names{var_label_index,2} ' seasonal amp. (' var_plot_names{var_label_index,3} ')' ];
%     else
%         comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
%     end
% 
% else
%     if seas_amplitude==1
%         comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
%     else
%         comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
%     end
% 
% end
% dt = datetime(2024, mon, 1);
% abbreviated_month = month(dt, 'short');
% 
% var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
% if dissic_vert_gradient==1
%     x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
% elseif wmo_on==1
%     x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
% else
%     if alt_x==0
%         x_label = [abbreviated_month{1} '. ' var_plot_names{var_label_index,2}  ' (' var_plot_names{var_label_index,3} ')'];
%     else
%         x_label = [variables{v} ' max divided by min'];
%     end
% end
% xlabel( x_label, 'interpreter', 'none')
% ylabel(comp_label)
% 
% [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
% x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
% y_plot = m.*x_plot+b;
% plot(x_plot, y_plot, 'k-')
% % title(['r= ' num2str(r,2)])
% x_lim = get(gca, 'xlim');
% y_lim = get(gca, 'ylim');
% text(x_lim(2)- diff(x_lim)*.4, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
% 
% grid on
% 
% % legend(sc_h, legend_names, 'location', 'south', 'fontsize', 10, 'numcolumns', 2);
% 
% set(gca, 'fontsize', axis_font_size)
% 
% %%%%%%%%% plotting DIC Amp vs. Winter month:
% subplot(p_row,p_col,5);
% hold on
% 
% % y axis variable choices
% seas_amplitude = 1;
% dissic_vert_gradient=0;
% sv2_name = 'dissic';
% sv2 = find(strncmp(seas_comp_vars, sv2_name,4));
% v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
% if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
%     v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
% end
% 
% % %% only applies if seas_amplitude is off
% tests = {'norm_error';'correlation' ; 'ratio'};
% test_names = {'normalized error'; 'correlation' ; 'Amplitude Ratio'};
% 
% tt = 2;
% % %%
% 
% 
% % x-axis variable choices
% alt_x=0; % 0: x axis is one individual month for variable sv
% % 1: x axis is ratio of max to min
% % 2: x axis is seasonal amplitude of sv
% mon = 9;
% dd = 12;
% 
% wmo_on = 0; % takes precedence over alt_x
% if wmo_on==0
%     sv_name = 'mld';
%     sv = find(strncmp(seas_comp_vars, sv_name,4));
%     v = find(strncmp(seas_comp_vars{sv}, variables, 4));
%     if length(v)>1 % cludge since dissic and dissic_yr were getting confused
%         v = strmatch(seas_comp_vars{sv}, variables, 'exact');
%     end
% else
%     v=10;
% end
% 
% temp_array =[];
% temp_names = {};
% legend_names = {};
% sc_h = [];
% 
% for m = 1:length(cmip_names.(variables{v}))
%     mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
% 
%     if sum(mod_match)>0
%         % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
%             plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);
% 
%             model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};
% 
%             %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
%             temp_name = cmip_names.(variables{v}){m};
%             temp_name = strrep(temp_name, '_', '-');
%             temp_name = strrep(temp_name, '-6', ' (6)');
%             legend_names{end+1,1} = temp_name;
%             %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])
% 
% 
% 
%             if seas_amplitude ==1
%                 var_2 = max(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) - min(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) ;
%             else
%                 var_2 = obs.(variables{v2}).(tests{tt})(mod_match);
% 
%             end
% 
%             if dissic_vert_gradient==1
%                 if CMIP.dissic_yr.out_annual(m,1,1)==0 % there is an error in CESM2_6 depth coordinate so the interpolation is not working properly
%                     continue
%                 end
%                 var_1 = CMIP.dissic_yr.out_annual(m,1,1) - CMIP.dissic_yr.out_annual(m,dd,1) ;
% 
%             else
%                 if wmo_on==1
%                     var_1 = CMIP.wmo.out_seasonal(m,dd,mon,1) ;
%                 elseif alt_x==0
%                     var_1 = CMIP.(variables{v}).out_seasonal(m,mon,1);
%                 elseif alt_x==1
%                     var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
%                 elseif alt_x==2
%                     var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
% 
%                 end
%             end
%             if isnan(var_1) || isnan(var_2)
%                 continue
%             end
% 
%             sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
%                 'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
%             if alt_x==1 && var_1>20
%                 disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
%                 plot(var_1,	var_2 , 'marker', 'o', 'color', ...
%                     'k', 'markerfacecolor', 'none','markersize', 24, 'linestyle', 'none');
%                 continue
%             end
%             temp_names{end+1,1} = cmip_names.(variables{v}){m};
%             temp_array(end+1,1) = var_1;
%             temp_array(end,2) = var_2;
%         % end
%     end
% 
% 
% 
% end
% 
% if seas_amplitude~=1 && tt~=1 % if plotting correlation or ratio, "obs" equals 1.
%     obs_y = 1;
% elseif seas_amplitude~=1 % if plotting normalized error, "obs" equals 0
%     obs_y=0;
% elseif seas_amplitude==1
%     obs_y = max(obs.(variables{v2}).out_seasonal(:,1)) - min(obs.(variables{v2}).out_seasonal(:,1));
% end
% 
% if wmo_on==0
%     if dissic_vert_gradient==1
%         obs_annual_mean = squeeze(nanmean(obs.dissic.out_seasonal(:,1,:),1));
%         var_1_obs = obs_annual_mean(1,1) - obs_annual_mean(dd,1);
%     elseif alt_x==1
%         var_1_obs = max(obs.(variables{v}).out_seasonal(:,1))./(min(obs.(variables{v}).out_seasonal(:,1)));
%     elseif alt_x==0
%         var_1_obs = obs.(variables{v}).out_seasonal(mon,1);
%     end
% 
%     sc_h(end+1) = plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10);
%     legend_names{end+1,1} = 'Observations';
% 
% end
% 
% var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);
% 
% if sum(var_label_index>0)
%     if seas_amplitude==1
%         comp_label = [var_plot_names{var_label_index,2} ' seasonal amp. (' var_plot_names{var_label_index,3} ')' ];
%     else
%         comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
%     end
% 
% else
%     if seas_amplitude==1
%         comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
%     else
%         comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
%     end
% 
% end
% dt = datetime(2024, mon, 1);
% abbreviated_month = month(dt, 'short');
% 
% var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
% if dissic_vert_gradient==1
%     x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
% elseif wmo_on==1
%     x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
% else
%     if alt_x==0
%         x_label = [abbreviated_month{1} '. ' var_plot_names{var_label_index,2}  ' (' var_plot_names{var_label_index,3} ')'];
%     else
%         x_label = [variables{v} ' max divided by min'];
%     end
% end
% xlabel( x_label, 'interpreter', 'none')
% ylabel(comp_label)
% grid on
% [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
% x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
% y_plot = m.*x_plot+b;
% plot(x_plot, y_plot, 'k-')
% % title(['r= ' num2str(r,2)])
% x_lim = get(gca, 'xlim');
% y_lim = get(gca, 'ylim');
% text(x_lim(2)- diff(x_lim)*.25, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
% 
% % legend(sc_h, legend_names, 'location', 'south', 'fontsize', 10, 'numcolumns', 2);
% 
% set(gca, 'fontsize', axis_font_size)
% 
% %%%%%%%%% MLD Max/ Min
% subplot(p_row,p_col,6);
% hold on
% 
% % y axis variable choices
% seas_amplitude = 1;
% dissic_vert_gradient=0;
% sv2_name = 'dissic';
% sv2 = find(strncmp(seas_comp_vars, sv2_name,4));
% v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
% if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
%     v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
% end
% 
% % %% only applies if seas_amplitude is off
% tests = {'norm_error';'correlation' ; 'ratio'};
% test_names = {'normalized error'; 'correlation' ; 'Amplitude Ratio'};
% 
% tt = 2;
% % %%
% 
% 
% % x-axis variable choices
% alt_x=1; % 0: x axis is one individual month for variable sv
% % 1: x axis is ratio of max to min
% % 2: x axis is seasonal amplitude of sv
% mon = 3;
% dd = 12;
% 
% wmo_on = 0; % takes precedence over alt_x
% if wmo_on==0
%     sv_name = 'mld';
%     sv = find(strncmp(seas_comp_vars, sv_name,4));
%     v = find(strncmp(seas_comp_vars{sv}, variables, 4));
%     if length(v)>1 % cludge since dissic and dissic_yr were getting confused
%         v = strmatch(seas_comp_vars{sv}, variables, 'exact');
%     end
% else
%     v=10;
% end
% 
% 
% temp_array =[];
% temp_names = {};
% legend_names = {};
% sc_h = [];
% 
% for m = 1:length(cmip_names.(variables{v}))
%     mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
% 
%     if sum(mod_match)>0
%         % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
%             plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);
% 
%             model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};
% 
%             %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
%             temp_name = cmip_names.(variables{v}){m};
%             temp_name = strrep(temp_name, '_', '-');
%             temp_name = strrep(temp_name, '-6', ' (6)');
%             legend_names{end+1,1} = temp_name;
%             %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])
% 
% 
% 
%             if seas_amplitude ==1
%                 var_2 = max(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) - min(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) ;
%             else
%                 var_2 = obs.(variables{v2}).(tests{tt})(mod_match);
% 
%             end
% 
%             if dissic_vert_gradient==1
%                 if CMIP.dissic_yr.out_annual(m,1,1)==0 % there is an error in CESM2_6 depth coordinate so the interpolation is not working properly
%                     continue
%                 end
%                 var_1 = CMIP.dissic_yr.out_annual(m,1,1) - CMIP.dissic_yr.out_annual(m,dd,1) ;
% 
%             else
%                 if wmo_on==1
%                     var_1 = CMIP.wmo.out_seasonal(m,dd,mon,1) ;
%                 elseif alt_x==0
%                     var_1 = CMIP.(variables{v}).out_seasonal(m,mon,1);
%                 elseif alt_x==1
%                     var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
%                 elseif alt_x==2
%                     var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
% 
%                 end
%             end
%             if isnan(var_1) || isnan(var_2)
%                 continue
%             end
% 
%             sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
%                 'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
%             if alt_x==1 && var_1>20
%                 disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
%                 plot(var_1,	var_2 , 'marker', 'o', 'color', ...
%                     'k', 'markerfacecolor', 'none','markersize', 20, 'linestyle', 'none');
%                 continue
%             end
%             temp_names{end+1,1} = cmip_names.(variables{v}){m};
%             temp_array(end+1,1) = var_1;
%             temp_array(end,2) = var_2;
%         % end
%     end
% 
% 
% 
% end
% 
% if seas_amplitude~=1 && tt~=1 % if plotting correlation or ratio, "obs" equals 1.
%     obs_y = 1;
% elseif seas_amplitude~=1 % if plotting normalized error, "obs" equals 0
%     obs_y=0;
% elseif seas_amplitude==1
%     obs_y = max(obs.(variables{v2}).out_seasonal(:,1)) - min(obs.(variables{v2}).out_seasonal(:,1));
% end
% 
% if wmo_on==0
%     if dissic_vert_gradient==1
%         obs_annual_mean = squeeze(nanmean(obs.dissic.out_seasonal(:,1,:),1));
%         var_1_obs = obs_annual_mean(1,1) - obs_annual_mean(dd,1);
%     elseif alt_x==1
%         var_1_obs = max(obs.(variables{v}).out_seasonal(:,1))./(min(obs.(variables{v}).out_seasonal(:,1)));
%     elseif alt_x==0
%         var_1_obs = obs.(variables{v}).out_seasonal(mon,1);
%     end
% 
%     plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10)
% end
% 
% var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);
% 
% if sum(var_label_index>0)
%     if seas_amplitude==1
%         comp_label = [var_plot_names{var_label_index,2} ' seasonal amp. (' var_plot_names{var_label_index,3} ')' ];
%     else
%         comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
%     end
% 
% else
%     if seas_amplitude==1
%         comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
%     else
%         comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
%     end
% 
% end
% 
% var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
% if dissic_vert_gradient==1
%     x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
% elseif wmo_on==1
%     x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
% else
%     if alt_x==0
%         x_label = [var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ') from month  ' num2str(mon)];
%     else
%         x_label = [var_plot_names{var_label_index,2} ' max divided by min'];
%     end
% end
% xlabel( x_label, 'interpreter', 'none')
% ylabel(comp_label)
% 
% [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
% x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
% y_plot = m.*x_plot+b;
% plot(x_plot, y_plot, 'k-')
% grid on
% % title(['r= ' num2str(r,2)])
% x_lim = get(gca, 'xlim');
% y_lim = get(gca, 'ylim');
% text(x_lim(2)- diff(x_lim)*.25, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
% 
% % legend(sc_h, legend_names, 'location', 'south', 'fontsize', 10, 'numcolumns', 2);
% 
% set(gca, 'fontsize', axis_font_size)
% 
% % annotation('textbox', [0.05, 0.05, 1, 0], 'String', plot_filename, 'EdgeColor', 'none', 'interpreter', 'none');
% % print(gcf, '-dpng', [fig_dir plot_filename plot_ver '.png'])
% %
% % %% DIC Physical - D and E
% % plot_filename = [plot_filename(1:end-4) ' _DE'];
% %
% % clf
% % set(gcf, 'units', 'inches')
% % paper_w = 10; paper_h =8;
% % set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h
% %
% % p_row = 2;
% % p_col = 1;
% %%%%%% plotting Taylor RMS vs each other
% subplot(p_row,p_col,7)
% % now also do the other comparisons (i.e. correlation vs. correlation)
% filter_on=0;
% if filter_on==1
%     disp('Warning, some results filtered from regression analysis')
% end
% % example spco2 match vs. intpp
% tests = {'norm_error';'correlation' ; 'ratio'};
% test_names = {'normalized error'; 'correlation' ; 'amplitude ratio'};
% % legend_on=0;
% group_color = 2;
% set(gcf, 'colormap', turbo)
% v3_name = 'mld'; % variable for harmonic fit scatter color
% v3 = find(strncmp(v3_name, variables, 4));
% 
% harm_comp = 'offset';
% 
% for sv = {['mld']}% [1 2 3 4 5 6 8 9 10] %1:length(seas_comp_vars)
%     sv = find(strncmp(seas_comp_vars, sv_name,4));
% 
%     for tt = 3%:length(tests)
%         for qq = 1% 1:length(tests)
%             %             if strcmp(variables{v}, 'wmo') || strcmp(variables{v}, 'psl') || strcmp(variables{v}, 'dissic_yr') || strcmp(variables{v}, 'talk_yr') || strcmp(variables{v}, 'thetao')
%             %                 continue
%             %             end
% 
%             % find matching v
%             v = find(strncmp(seas_comp_vars{sv}, variables, 4));
%             if length(v)>1 % cludge since dissic and dissic_yr were getting confused
%                 v = strmatch(seas_comp_vars{sv}, variables, 'exact');
%             end
% 
%             plot_index = 0;
% 
%             %             plot_filename = ['Taylor ' seas_comp_vars{sv} ' ' tests{qq} ' vs. ' tests{tt} ' other vars_model_groups=' num2str(group_color) ' filter ' num2str(filter_on)];
%             %             if group_color==2
%             %                 plot_filename = ['Taylor ' seas_comp_vars{sv} ' ' tests{qq} ' vs. ' tests{tt} ' other vars_model_groups=' num2str(group_color) '_' variables{v3} '_' ...
%             %                     harm_comp ' filter ' num2str(filter_on)];
%             %
%             %             end
%             for sv2_name = {['dissic']}%[1 2 3 4 5 6 8 9 10]
%                 sv2 = find(strncmp(seas_comp_vars, sv2_name,4));
% 
%                 if sv2==sv
%                     continue
%                     %                 elseif strcmp(variables{v2}, 'wmo') || strcmp(variables{v2}, 'psl') || strcmp(variables{v2}, 'dissic_yr') || strcmp(variables{v2}, 'talk_yr') || strcmp(variables{v2}, 'thetao')
%                     %                     continue
%                 end
% 
%                 v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
%                 if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
%                     v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
%                 end
% 
%                 plot_index = plot_index+1;
% 
%                 %                 subplot(3,3,plot_index)
% 
%                 hold on
%                 %                 grid on
% 
%                 temp_array = [];
%                 temp_color = [];
%                 sc_h = [];
%                 legend_names = {};
% 
%                 for m = 1:length(cmip_names.(variables{v}))
% 
% 
%                     % find the matching model
%                     mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
% 
%                     if sum(mod_match)>0
%                         % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
% 
%                             if group_color==1
%                                 plot_color = model_group_colors(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3},:);
%                             elseif group_color==0
%                                 plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);
% 
%                             end
% 
%                             if group_color==0 || group_color==1
%                                 plot(obs.(variables{v}).(tests{qq})(m), obs.(variables{v2}).(tests{tt})(mod_match), '.', 'color', ...
%                                     plot_color, 'markersize', 20)
%                             elseif group_color==2 % plotting color based on harmonic fit info
%                                 mod_match_2 = strcmp(cmip_names.(variables{v3}), cmip_names.(variables{v}){m});
% 
%                                 if sum(mod_match_2)>0
%                                     %                                     mod_pco2_corr = obs.spco2.correlation(m);
%                                     model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};
% 
%                                     %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
%                                     temp_name = cmip_names.(variables{v}){m};
%                                     temp_name = strrep(temp_name, '_', '-');
%                                     temp_name = strrep(temp_name, '-6', ' (6)');
%                                     legend_names{end+1,1} = temp_name;
%                                     %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])
% 
% 
%                                     harm_diff = harm_mod.(variables{v3}).(harm_comp)(mod_match_2) - harm.(variables{v3}).(harm_comp); % difference in phase between model and obs
% 
%                                     sc_h(end+1) = scatter(obs.(variables{v}).(tests{qq})(m), obs.(variables{v2}).(tests{tt})(mod_match), 100, harm_diff, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
%                                     c1 = colorbar;
%                                     temp_color(end+1) = harm_diff;
%                                 else
%                                     plot(obs.(variables{v}).(tests{qq})(m), obs.(variables{v2}).(tests{tt})(mod_match), 'o', 'color', ...
%                                         'k', 'markersize', 7)
%                                 end
% 
%                                 var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
%                                 ylabel(c1, ['Model ' var_plot_names{var_label_index,2} ' ' harm_comp ' (' var_plot_names{var_label_index,3} ')'])
% 
%                             end
%                             temp_array(end+1,1) = obs.(variables{v}).(tests{qq})(m);
%                             temp_array(end,2) = obs.(variables{v2}).(tests{tt})(mod_match);
% 
%                         % end
%                     end
%                     clear plot_color
%                 end
%                 if group_color==2
%                     c_lim = caxis;
%                     %                     caxis([-max(abs(c_lim)) max(abs(c_lim))])
%                     caxis([-nanstd(temp_color) nanstd(temp_color)]*1.5)
%                 end
% 
%                 var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
%                 if sum(var_label_index>0)
%                     xlabel( [var_plot_names{var_label_index,2} ' ' test_names{qq}], 'interpreter', 'none')
%                 else
%                     xlabel( [variables{v} ' ' test_names{qq}], 'interpreter', 'none')
%                 end
% 
%                 var_label_index = strncmp(variables{v2}, var_plot_names(:,1), 4);
%                 if sum(var_label_index>0)
%                     ylabel([var_plot_names{var_label_index,2} ' ' test_names{tt}], 'interpreter', 'none')
%                 else
%                     ylabel([variables{v2} ' ' test_names{tt}], 'interpreter', 'none')
% 
%                 end
%                 if filter_on==1
%                     temp_array(temp_array(:,1)>3,1)=nan;
%                     temp_array = temp_array(~isnan(temp_array(:,1)),:);
% 
%                 end
% 
%                 %                 [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
%                 %                 x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
%                 %                 y_plot = m.*x_plot+b;
%                 %                 plot(x_plot, y_plot, 'k-')
%                 %                 if filter_on==0
%                 %                     title(['r= ' num2str(r,2)])
%                 %                 else
%                 %                     title(['filt r= ' num2str(r,2)])
%                 %                 end
%                 if tt>1
%                     plot(get(gca, 'xlim'), [1 1], '-k')
%                 end
% 
%                 if tt==3
%                     orig_y_lim = get(gca, 'ylim');
% 
%                     if orig_y_lim(1)<0
%                         orig_y_lim(1)=0;
%                     end
% 
%                     set(gca, 'ylim', orig_y_lim)
%                 end
% 
%                 if tt==2
%                     orig_y_lim = get(gca, 'ylim');
% 
%                     if orig_y_lim(1)<-1
%                         orig_y_lim(1)=-1;
%                     end
%                     if orig_y_lim(2)>1
%                         orig_y_lim(2)=1;
%                     end
% 
%                     set(gca, 'ylim', orig_y_lim)
%                 end
% 
%                 if qq>1
%                     plot([1 1], get(gca, 'ylim'), '-k')
%                 end
%             end
% 
%             %             subplot(3,3,9)
%             %             hold on
%             %             for m = 1:length(model_types)
%             %                 plot(0,0, '.', 'color', model_group_colors(m,:), 'markersize', 25)
%             %
%             %             end
%             %             if legend_on ==1
% 
%             %             end
%             %             print(gcf, '-dpng', [Plot_out_dir variables{v} '/' plot_filename '_v8_test.png'])
%         end
%     end
% end
% l2 = legend(sc_h, legend_names, 'location', 'south', 'fontsize', 10, 'numcolumns', 2);
% l2_pos = get(l2, 'Position');
% set(l2, 'Position', l2_pos+[.3 -.03 0 0])
% 
% set(gca, 'fontsize', axis_font_size)
% 
% %%%%%% DIC Amp vs. TOS Amp.
% subplot(p_row,p_col,1);
% 
% hold on
% 
% % y axis variable choices
% seas_amplitude = 1;
% dissic_vert_gradient=0;
% sv2_name = 'dissic';
% sv2 = find(strncmp(seas_comp_vars, sv2_name,4));
% v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
% if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
%     v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
% end
% 
% % %% only applies if seas_amplitude is off
% tests = {'norm_error';'correlation' ; 'ratio'};
% test_names = {'normalized error'; 'correlation' ; 'Amplitude Ratio'};
% 
% tt = 2;
% 
% % x-axis variable choices
% alt_x=2; % 0: x axis is one individual month for variable sv
% % 1: x axis is ratio of max to min
% % 2: x axis is seasonal amplitude of sv
% mon = 3;
% dd = 12;
% 
% wmo_on = 0; % takes precedence over alt_x
% if wmo_on==0
%     sv_name = 'tos';
%     sv = find(strncmp(seas_comp_vars, sv_name,4));
%     v = find(strncmp(seas_comp_vars{sv}, variables, 4));
%     if length(v)>1 % cludge since dissic and dissic_yr were getting confused
%         v = strmatch(seas_comp_vars{sv}, variables, 'exact');
%     end
% else
%     v=10;
% end
% 
% temp_array =[];
% temp_names = {};
% legend_names = {};
% sc_h = [];
% 
% for m = 1:length(cmip_names.(variables{v}))
%     mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
% 
%     if sum(mod_match)>0
%         % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
%             plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);
% 
%             model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};
% 
%             %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
%             temp_name = cmip_names.(variables{v}){m};
%             temp_name = strrep(temp_name, '_', '-');
%             temp_name = strrep(temp_name, '-6', ' (6)');
%             legend_names{end+1,1} = temp_name;
%             %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])
% 
% 
% 
%             if seas_amplitude ==1
%                 var_2 = max(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) - min(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) ;
%             else
%                 var_2 = obs.(variables{v2}).(tests{tt})(mod_match);
% 
%             end
% 
%             if dissic_vert_gradient==1
%                 if CMIP.dissic_yr.out_annual(m,1,1)==0 % there is an error in CESM2_6 depth coordinate so the interpolation is not working properly
%                     continue
%                 end
%                 var_1 = CMIP.dissic_yr.out_annual(m,1,1) - CMIP.dissic_yr.out_annual(m,dd,1) ;
% 
%             else
%                 if wmo_on==1
%                     var_1 = CMIP.wmo.out_seasonal(m,dd,mon,1) ;
%                 elseif alt_x==0
%                     var_1 = CMIP.(variables{v}).out_seasonal(m,mon,1);
%                 elseif alt_x==1
%                     var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
%                 elseif alt_x==2
%                     var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
% 
%                 end
%             end
%             if isnan(var_1) || isnan(var_2)
%                 continue
%             end
% 
%             sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
%                 'k', 'markerfacecolor', plot_color','markersize', 14, 'linestyle', 'none');
%             if alt_x==1 && var_1>20
%                 disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
%                 plot(var_1,	var_2 , 'marker', 'o', 'color', ...
%                     'k', 'markerfacecolor', 'none','markersize', 20, 'linestyle', 'none');
%                 continue
%             end
%             temp_names{end+1,1} = cmip_names.(variables{v}){m};
%             temp_array(end+1,1) = var_1;
%             temp_array(end,2) = var_2;
%         % end
%     end
% 
% end
% 
% if seas_amplitude~=1 && tt~=1 % if plotting correlation or ratio, "obs" equals 1.
%     obs_y = 1;
% elseif seas_amplitude~=1 % if plotting normalized error, "obs" equals 0
%     obs_y=0;
% elseif seas_amplitude==1
%     obs_y = max(obs.(variables{v2}).out_seasonal(:,1)) - min(obs.(variables{v2}).out_seasonal(:,1));
% end
% 
% if wmo_on==0
%     if dissic_vert_gradient==1
%         obs_annual_mean = squeeze(nanmean(obs.dissic.out_seasonal(:,1,:),1));
%         var_1_obs = obs_annual_mean(1,1) - obs_annual_mean(dd,1);
%     elseif alt_x==1
%         var_1_obs = max(obs.(variables{v}).out_seasonal(:,1))./(min(obs.(variables{v}).out_seasonal(:,1)));
%     elseif alt_x==0
%         var_1_obs = obs.(variables{v}).out_seasonal(mon,1);
%     elseif alt_x==2
%         var_1_obs = max(obs.(variables{v}).out_seasonal(:,1)) - (min(obs.(variables{v}).out_seasonal(:,1)));
% 
%     end
% 
%     sc_h(end+1) = plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10);
%     legend_names{end+1,1} = 'Observations';
% 
% end
% 
% var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);
% 
% if sum(var_label_index>0)
%     if seas_amplitude==1
%     comp_label = [var_plot_names{var_label_index,2} ' seasonal amp. (' var_plot_names{var_label_index,3} ')' ];
%     else
%         comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
%     end
% 
% else
%     if seas_amplitude==1
%         comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
%     else
%         comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
%     end
% 
% end
% dt = datetime(2024, mon, 1);
% abbreviated_month = month(dt, 'short');
% 
% var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
% if dissic_vert_gradient==1
%     x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
% elseif wmo_on==1
%     x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
% else
%     if alt_x==0
%         x_label = [abbreviated_month{1} ' ' var_plot_names{var_label_index,2}  ' (' var_plot_names{var_label_index,3} ')'];
%     elseif alt_x==2
%         x_label = [var_plot_names{var_label_index,2} ' seasonal amplitude (' var_plot_names{var_label_index,3} ')'];
% 
%     else
%         x_label = [variables{v} ' max divided by min'];
%     end
% end
% xlabel( x_label)
% ylabel(comp_label)
% grid on
% [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
% x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
% y_plot = m.*x_plot+b;
% plot(x_plot, y_plot, 'k-')
% % title(['r= ' num2str(r,2)])
% x_lim = get(gca, 'xlim');
% y_lim = get(gca, 'ylim');
% text(x_lim(2)- diff(x_lim)*.25, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
% 
% 
% l1 = legend(sc_h, legend_names, 'location', 'eastoutside', 'fontsize', 10, 'numcolumns', 2);
% l1_pos = get(l1, 'Position');
% set(l1, 'Position', l1_pos+[.25 .03 0 0])
% 
% 
% 
% set(gca, 'fontsize', axis_font_size)
% 
% annotation('textbox', [0.05, 0.05, 1, 0], 'String', plot_filename, 'EdgeColor', 'none', 'interpreter', 'none');
% print(gcf, '-dpng', [fig_dir plot_filename plot_ver '.png'])

%% Figure 6 - all months option
axis_font_size = 13;
r_text_size = 12;

plot_filename = 'Figure S_Var_comparison DIC and MLD relationships_all months';

p_col = 4;
p_row = 3;

clf
set(gcf, 'units', 'inches')
paper_w = 15; paper_h =13;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h

for mon = 1:12
    subplot(p_row,p_col,mon);
    hold on

    % y axis variable choices
    seas_amplitude = 1;
    dissic_vert_gradient=0;
    sv2_name = 'dissic';
    sv2 = find(strncmp(seas_comp_vars, sv2_name,4));
    v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
    if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
        v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
    end

    % %% only applies if seas_amplitude is off
    tests = {'norm_error';'correlation' ; 'ratio'};
    test_names = {'normalized error'; 'correlation' ; 'Amplitude Ratio'};

    tt = 2;
    % %%


    % x-axis variable choices
    alt_x=0; % 0: x axis is one individual month for variable sv
    % 1: x axis is ratio of max to min
    % 2: x axis is seasonal amplitude of sv
    % mon = 3;
    dd = 12;

    wmo_on = 0; % takes precedence over alt_x
    if wmo_on==0
        sv_name = 'mld';
        sv = find(strncmp(seas_comp_vars, sv_name,4));
        v = find(strncmp(seas_comp_vars{sv}, variables, 4));
        if length(v)>1 % cludge since dissic and dissic_yr were getting confused
            v = strmatch(seas_comp_vars{sv}, variables, 'exact');
        end
    else
        v=10;
    end

    temp_array =[];
    temp_names = {};
    legend_names = {};
    sc_h = [];

    for m = 1:length(cmip_names.(variables{v}))
        mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});

        if sum(mod_match)>0
            % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
                plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);

                model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};

                %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
                temp_name = cmip_names.(variables{v}){m};
                temp_name = strrep(temp_name, '_', '-');
                temp_name = strrep(temp_name, '-6', ' (6)');
                legend_names{end+1,1} = temp_name;
                %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])



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
                    elseif alt_x==1
                        var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
                    elseif alt_x==2
                        var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;

                    end
                end
                if isnan(var_1) || isnan(var_2)
                    continue
                end

                sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
                    'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
                if alt_x==1 && var_1>20
                    disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
                    plot(var_1,	var_2 , 'marker', 'o', 'color', ...
                        'k', 'markerfacecolor', 'none','markersize', 20, 'linestyle', 'none');
                    continue
                end
                temp_names{end+1,1} = cmip_names.(variables{v}){m};
                temp_array(end+1,1) = var_1;
                temp_array(end,2) = var_2;
            % end
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

        sc_h(end+1) = plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10);
        legend_names{end+1,1} = 'Observations';

    end

    var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);

    if sum(var_label_index>0)
        if seas_amplitude==1
            comp_label = [var_plot_names{var_label_index,2} ' seasonal amp. (' var_plot_names{var_label_index,3} ')' ];

        else
            comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
        end

    else
        if seas_amplitude==1
            comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];

        else
            comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
        end

    end
    dt = datetime(2024, mon, 1);
    abbreviated_month = month(dt, 'short');

    var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
    if dissic_vert_gradient==1
        x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
    elseif wmo_on==1
        x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
    else
        if alt_x==0
            % x_label = [abbreviated_month{1} '. ' var_plot_names{var_label_index,2}  ' (' var_plot_names{var_label_index,3} ')'];
            x_label = [abbreviated_month{1} '.'];

        else
            x_label = [variables{v} ' max divided by min'];
        end
    end
    title( x_label, 'interpreter', 'none')
   
    x = 2;
    y = 85;
    letter_size = 13;
    if mon==1
        text(x, y, 'a.', 'fontsize', letter_size)
    elseif mon==2
        text(x,y, 'b.', 'fontsize', letter_size)
    elseif mon==3
        text(x,y, 'c.', 'fontsize', letter_size)
    elseif mon==4
        text(x,y, 'd.', 'fontsize', letter_size)
    elseif mon==5
        text(x,y, 'e.', 'fontsize', letter_size)
    elseif mon==6
        text(x,y, 'f.', 'fontsize', letter_size)
    elseif mon==7
        text(x,y, 'g.', 'fontsize', letter_size)
    elseif mon==8
        text(x,y, 'h.', 'fontsize', letter_size)
    elseif mon==9
        text(x,y, 'i.', 'fontsize', letter_size)
    elseif mon==10
        text(x,y, 'j.', 'fontsize', letter_size)
    elseif mon==11
        text(x,y, 'k.', 'fontsize', letter_size)
    elseif mon==12
        text(x,y, 'l.', 'fontsize', letter_size)
    end
    
    if mon==10
        x1 = xlabel('Month MLD (m)');
        x_pos = get(x1, 'Position');
        set(x1, 'position', x_pos+[120 -10 0], 'fontweight', 'bold')
    end
    grid on

    [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
    x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
    y_plot = m.*x_plot+b;
    plot(x_plot, y_plot, 'k-')
    [~, ~, R_2, significant] = Sokal_Rohlf_regression_significance(temp_array(:,1), temp_array(:,2));

    % title(['r= ' num2str(r,2)])
    if sv==10
        set(gca, 'xlim', [0 230])
    end
    if sv2==1
        set(gca, 'ylim', [2 8])
    elseif sv2==4
        set(gca, 'ylim', [5 80])
    end
    x_lim = get(gca, 'xlim');
    y_lim = get(gca, 'ylim');
    if significant==1
        text(x_lim(2)- diff(x_lim)*.25, y_lim(2)-diff(y_lim)*.1, ['R^2: ' num2str(r^2,2) '^*'], 'fontsize', r_text_size, 'fontweight', 'bold')
    else
        text(x_lim(2)- diff(x_lim)*.25, y_lim(2)-diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
    end
    % legend(sc_h, legend_names, 'location', 'southoutside', 'fontsize', 10, 'numcolumns', 2);
    if mon==5
        y1 = ylabel(comp_label);
        y1_pos = get(y1, 'Position');
        set(y1, 'position', y1_pos+[-20 0 0], 'fontweight', 'bold')
    end
    set(gca, 'fontsize', axis_font_size)
end


% annotation('textbox', [0.05, 0.05, 1, 0], 'String', plot_filename, 'EdgeColor', 'none', 'interpreter', 'none');

print(gcf, '-dpdf', [fig_dir plot_filename plot_ver '.pdf'], '-r300')
% print(gcf, '-dpng', [fig_dir plot_filename plot_ver '.png'])

%% New figure - DIC, SST, and TA relationships 
axis_font_size = 13;
r_text_size = 12;

plot_filename = 'Figure 5_new_DIC SST TA';

p_col = 2;
p_row = 3;
leg_x_shift = .4;

clf
set(gcf, 'units', 'inches')
paper_w = 10; paper_h =12;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h



%%%%%%%%% DIC MLD Max/ Min
subplot(p_row,p_col,1);
hold on

% y axis variable choices
seas_amplitude = 1;
dissic_vert_gradient=0;
sv2_name = 'dissic';
sv2 = find(strncmp(seas_comp_vars, sv2_name,4));
v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
    v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
end

% %% only applies if seas_amplitude is off
tests = {'norm_error';'correlation' ; 'ratio'};
test_names = {'normalized error'; 'correlation' ; 'Amplitude Ratio'};

tt = 2;
% %%


% x-axis variable choices
alt_x=1; % 0: x axis is one individual month for variable sv
% 1: x axis is ratio of max to min
% 2: x axis is seasonal amplitude of sv
mon = 3;
dd = 12;

wmo_on = 0; % takes precedence over alt_x
if wmo_on==0
    sv_name = 'mld';
    sv = find(strncmp(seas_comp_vars, sv_name,4));
    v = find(strncmp(seas_comp_vars{sv}, variables, 4));
    if length(v)>1 % cludge since dissic and dissic_yr were getting confused
        v = strmatch(seas_comp_vars{sv}, variables, 'exact');
    end
else
    v=10;
end


temp_array =[];
temp_names = {};
legend_names = {};
sc_h = [];

for m = 1:length(cmip_names.(variables{v}))
    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});

    if sum(mod_match)>0
        % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
            plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);

            model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};

            %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
            temp_name = cmip_names.(variables{v}){m};
            temp_name = strrep(temp_name, '_', '-');
            temp_name = strrep(temp_name, '-6', ' (6)');
            legend_names{end+1,1} = temp_name;
            %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])



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
                elseif alt_x==1
                    var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
                elseif alt_x==2
                    var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;

                end
            end
            if isnan(var_1) || isnan(var_2)
                continue
            end

            sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
                'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
            if alt_x==1 && var_1>20
                disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
                plot(var_1,	var_2 , 'marker', 'o', 'color', ...
                    'k', 'markerfacecolor', 'none','markersize', 20, 'linestyle', 'none');
                continue
            end
            temp_names{end+1,1} = cmip_names.(variables{v}){m};
            temp_array(end+1,1) = var_1;
            temp_array(end,2) = var_2;
        % end
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

var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);

if sum(var_label_index>0)
    if seas_amplitude==1
        comp_label = [var_plot_names{var_label_index,2} ' seasonal amp. (' var_plot_names{var_label_index,3} ')' ];
    else
        comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
    end

else
    if seas_amplitude==1
        comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
    else
        comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
    end

end

var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
if dissic_vert_gradient==1
    x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
elseif wmo_on==1
    x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
else
    if alt_x==0
        x_label = [var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ') from month  ' num2str(mon)];
    else
        x_label = [var_plot_names{var_label_index,2} ' max divided by min'];
    end
end
xlabel( x_label, 'interpreter', 'none')
ylabel(comp_label)

[m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
y_plot = m.*x_plot+b;
[~, ~, R_2, significant] = Sokal_Rohlf_regression_significance(temp_array(:,1), temp_array(:,2));

plot(x_plot, y_plot, 'k-')
grid on
text(2.2, 105, 'a.', 'fontsize', 13)

% title(['r= ' num2str(r,2)])
x_lim = get(gca, 'xlim');
y_lim = get(gca, 'ylim');
if significant==1
    text(x_lim(2)- diff(x_lim)*.2, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2) '^*'], 'fontsize', r_text_size, 'fontweight', 'bold')
else
    text(x_lim(2)- diff(x_lim)*.2, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
end 
clear significant R_2
% legend(sc_h, legend_names, 'location', 'south', 'fontsize', 10, 'numcolumns', 2);

set(gca, 'fontsize', axis_font_size)

%%%%%%%% Harmonic fit comparison between DIC phase and Int. PP amplitude
fits = {'amp'; 'phase'; 'offset'};
fit_names = {'amplitude'; 'phase' ; 'offset'};

harm_mod_vars = fieldnames(harm_mod);

for hv_name = {['intpp']}% 1:length(harm_mod_vars) % 7 - intpp
    hv = find(strncmp(harm_mod_vars, hv_name,4));

    if strcmp(harm_mod_vars{hv}, 'DIC_Alk')
        continue
    end
    v = find(strncmp(harm_mod_vars{hv}, variables, 4));
    if length(v)>1 % cludge since dissic and dissic_yr were getting confused
        v = strmatch(harm_mod_vars{hv}, variables, 'exact');
    end

    for tt = 2%:length(fits)
        for qq = 1%:length(fits)

            legend_names = {};
            sc_h = [];

            for hv2_name = {['dissic']}%:length(harm_mod_vars)
                hv2 = find(strncmp(harm_mod_vars, hv2_name,4));

                if hv2==hv || strcmp(harm_mod_vars{hv2}, 'DIC_Alk')
                    continue
                end
                v2 = find(strncmp(harm_mod_vars{hv2}, variables, 4));
                if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
                    v2 = strmatch(harm_mod_vars{hv2}, variables, 'exact');
                end
                %                 plot_inde x = plot_index+1;

                subplot(p_row,p_col,2)
                hold on
                grid on
                temp_array = [];
                for m = 1:length(cmip_names.(variables{v}))
                    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
                    %                     disp(sum(mod_match))
                    if sum(mod_match)>0
                        % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
                            plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);

                            model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};

                            %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
                            temp_name = cmip_names.(variables{v}){m};
                            temp_name = strrep(temp_name, '_', '-');
                            temp_name = strrep(temp_name, '-6', ' (6)');
                            legend_names{end+1,1} = temp_name;

                            sc_h(end+1) = plot(harm_mod.(variables{v}).(fits{qq})(m), harm_mod.(variables{v2}).(fits{tt})(mod_match), 'marker', model_marker, ...
                                'color', ...
                                'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');

                            temp_array(end+1,1) = harm_mod.(variables{v}).(fits{qq})(m,1);
                            temp_array(end,2) = harm_mod.(variables{v2}).(fits{tt})(mod_match,1);
                            clear plot_color
                            %                             disp(cmip_names.(variables{v2}){mod_match})

                            %                             pause
                        % end

                    end
                    %                     pause
                end
                var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);

                xlabel( [ var_plot_names{var_label_index,2} ' ' fit_names{qq} ' (' var_plot_names{var_label_index,3} ')'])

                var_label_index = strncmp(variables{v2}, var_plot_names(:,1), 4);

                ylabel([ var_plot_names{var_label_index,2} ' ' fit_names{tt}])

                [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
                x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
                y_plot = m.*x_plot+b;
                plot(x_plot, y_plot, 'k-');
                [~, ~, R_2, significant] = Sokal_Rohlf_regression_significance(temp_array(:,1), temp_array(:,2));

                text()
                %                 title(['r= ' num2str(r,2)])

                % add obs
                sc_h(end+1) = plot(harm.(variables{v}).(fits{qq})(1), harm.(variables{v2}).(fits{tt})(1), 'xk', 'linewidth', 2, 'markersize', 10);
                legend_names{end+1,1} = 'Observations';

            end
            %             print(gcf, '-dpng', [Plot_out_dir variables{v} '/' plot_filename '.png'])
            % legend(sc_h, legend_names, 'location', 'southoutside', 'fontsize', 10, 'numcolumns', 2);

            x_lim = get(gca, 'xlim');
            y_lim = get(gca, 'ylim');
        end
    end
end
text(5, 3.08, 'b.', 'fontsize', 13)

set(gca, 'fontsize', axis_font_size)
if significant==1
    text(x_lim(2)- diff(x_lim)*.2, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2) '^*'], 'fontsize', r_text_size, 'fontweight', 'bold')
else
    text(x_lim(2)- diff(x_lim)*.2, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
end
clear significant

%%%%%%%% SST amp vs MLD max/min
subplot(p_row,p_col,3);
hold on

% y axis variable choices
seas_amplitude = 1;
dissic_vert_gradient=0;
sv2_name = 'tos';
sv2 = find(strncmp(seas_comp_vars, sv2_name,4));
v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
    v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
end

% %% only applies if seas_amplitude is off
tests = {'norm_error';'correlation' ; 'ratio'};
test_names = {'normalized error'; 'correlation' ; 'Amplitude Ratio'};

tt = 2;
% %%


% x-axis variable choices
alt_x=1; % 0: x axis is one individual month for variable sv
% 1: x axis is ratio of max to min
% 2: x axis is seasonal amplitude of sv
mon = 3;
dd = 12;

wmo_on = 0; % takes precedence over alt_x
if wmo_on==0
    sv_name = 'mld';
    sv = find(strncmp(seas_comp_vars, sv_name,4));
    v = find(strncmp(seas_comp_vars{sv}, variables, 4));
    if length(v)>1 % cludge since dissic and dissic_yr were getting confused
        v = strmatch(seas_comp_vars{sv}, variables, 'exact');
    end
else
    v=10;
end


temp_array =[];
temp_names = {};
legend_names = {};
sc_h = [];

for m = 1:length(cmip_names.(variables{v}))
    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});

    if sum(mod_match)>0
        % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
            plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);

            model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};

            %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
            temp_name = cmip_names.(variables{v}){m};
            temp_name = strrep(temp_name, '_', '-');
            temp_name = strrep(temp_name, '-6', ' (6)');
            legend_names{end+1,1} = temp_name;
            %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])



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
                elseif alt_x==1
                    var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
                elseif alt_x==2
                    var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;

                end
            end
            if isnan(var_1) || isnan(var_2)
                continue
            end

            sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
                'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
            if alt_x==1 && var_1>20
                disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
                plot(var_1,	var_2 , 'marker', 'o', 'color', ...
                    'k', 'markerfacecolor', 'none','markersize', 20, 'linestyle', 'none');
                continue
            end
            temp_names{end+1,1} = cmip_names.(variables{v}){m};
            temp_array(end+1,1) = var_1;
            temp_array(end,2) = var_2;
        % end
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

var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);

if sum(var_label_index>0)
    if seas_amplitude==1
        comp_label = [var_plot_names{var_label_index,2} ' seasonal amp. (' var_plot_names{var_label_index,3} ')' ];
    else
        comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
    end

else
    if seas_amplitude==1
        comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
    else
        comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
    end

end

var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
if dissic_vert_gradient==1
    x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
elseif wmo_on==1
    x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
else
    if alt_x==0
        x_label = [var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ') from month  ' num2str(mon)];
    else
        x_label = [var_plot_names{var_label_index,2} ' max divided by min'];
    end
end
xlabel( x_label, 'interpreter', 'none')
ylabel(comp_label)

[m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
y_plot = m.*x_plot+b;
[~, ~, R_2, significant] = Sokal_Rohlf_regression_significance(temp_array(:,1), temp_array(:,2));

plot(x_plot, y_plot, 'k-')
grid on
text(2.2, 8.6, 'c.', 'fontsize', 13)

% title(['r= ' num2str(r,2)])
x_lim = get(gca, 'xlim');
y_lim = get(gca, 'ylim');
if significant==1
    text(x_lim(2)- diff(x_lim)*.2, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2) '^*'], 'fontsize', r_text_size, 'fontweight', 'bold')
else
    text(x_lim(2)- diff(x_lim)*.2, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
end
clear significant
% legend(sc_h, legend_names, 'location', 'south', 'fontsize', 10, 'numcolumns', 2);

set(gca, 'fontsize', axis_font_size)


%%%%%%%% TA amp vs SOS Amp
subplot(p_row,p_col,5);
hold on

% y axis variable choices
seas_amplitude = 1;
dissic_vert_gradient=0;
sv2_name = 'talk';
sv2 = find(strncmp(seas_comp_vars, sv2_name,4));
v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
    v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
end

% %% only applies if seas_amplitude is off
tests = {'norm_error';'correlation' ; 'ratio'};
test_names = {'normalized error'; 'correlation' ; 'Amplitude Ratio'};

tt = 2;
% %%


% x-axis variable choices
alt_x=2; % 0: x axis is one individual month for variable sv
% 1: x axis is ratio of max to min
% 2: x axis is seasonal amplitude of sv
mon = 3;
dd = 12;

wmo_on = 0; % takes precedence over alt_x
if wmo_on==0
    sv_name = 'sos';
    sv = find(strncmp(seas_comp_vars, sv_name,4));
    v = find(strncmp(seas_comp_vars{sv}, variables, 4));
    if length(v)>1 % cludge since dissic and dissic_yr were getting confused
        v = strmatch(seas_comp_vars{sv}, variables, 'exact');
    end
else
    v=10;
end


temp_array =[];
temp_names = {};
legend_names = {};
sc_h = [];

for m = 1:length(cmip_names.(variables{v}))
    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});

    if sum(mod_match)>0
        % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
            plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);

            model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};

            %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
            temp_name = cmip_names.(variables{v}){m};
            temp_name = strrep(temp_name, '_', '-');
            temp_name = strrep(temp_name, '-6', ' (6)');
            legend_names{end+1,1} = temp_name;
            %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])



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
                elseif alt_x==1
                    var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
                elseif alt_x==2
                    var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;

                end
            end
            if isnan(var_1) || isnan(var_2)
                continue
            end

            sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
                'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
            if alt_x==1 && var_1>20
                disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
                plot(var_1,	var_2 , 'marker', 'o', 'color', ...
                    'k', 'markerfacecolor', 'none','markersize', 20, 'linestyle', 'none');
                continue
            end
            temp_names{end+1,1} = cmip_names.(variables{v}){m};
            temp_array(end+1,1) = var_1;
            temp_array(end,2) = var_2;
        % end
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
    elseif alt_x==2
        var_1_obs =  max(obs.(variables{v}).out_seasonal(:,1)) - min(obs.(variables{v}).out_seasonal(:,1));

    end

    plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10)
end

var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);

if sum(var_label_index>0)
    if seas_amplitude==1
        comp_label = [var_plot_names{var_label_index,2} ' seasonal amp. (' var_plot_names{var_label_index,3} ')' ];
    else
        comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
    end

else
    if seas_amplitude==1
        comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
    else
        comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
    end

end

var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
if dissic_vert_gradient==1
    x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
elseif wmo_on==1
    x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
else
    if alt_x==0
        x_label = [var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ') from month  ' num2str(mon)];
    else
        x_label = [var_plot_names{var_label_index,2} ' max divided by min'];
    end
end
xlabel( x_label, 'interpreter', 'none')
ylabel(comp_label)

[m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
y_plot = m.*x_plot+b;
[~, ~, R_2, significant] = Sokal_Rohlf_regression_significance(temp_array(:,1), temp_array(:,2));

plot(x_plot, y_plot, 'k-')
grid on
text(.055, 16.2, 'd.', 'fontsize', 13)

% title(['r= ' num2str(r,2)])
x_lim = get(gca, 'xlim');
y_lim = get(gca, 'ylim');
if significant==1
    text(x_lim(2)- diff(x_lim)*.2, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2) '^*'], 'fontsize', r_text_size, 'fontweight', 'bold')
else
    text(x_lim(2)- diff(x_lim)*.2, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
end
clear significant
set(gca, 'fontsize', axis_font_size)

%%%%%%%% Harmonic fit comparison between TA phase and Int. PP amplitude
fits = {'amp'; 'phase'; 'offset'};
fit_names = {'amplitude'; 'phase' ; 'offset'};

harm_mod_vars = fieldnames(harm_mod);

for hv_name = {['intpp']}% 1:length(harm_mod_vars) % 7 - intpp
    hv = find(strncmp(harm_mod_vars, hv_name,4));

    if strcmp(harm_mod_vars{hv}, 'DIC_Alk')
        continue
    end
    v = find(strncmp(harm_mod_vars{hv}, variables, 4));
    if length(v)>1 % cludge since dissic and dissic_yr were getting confused
        v = strmatch(harm_mod_vars{hv}, variables, 'exact');
    end

    for tt = 2%:length(fits)
        for qq = 1%:length(fits)

            legend_names = {};
            sc_h = [];

            for hv2_name = {['talk']}%:length(harm_mod_vars)
                hv2 = find(strncmp(harm_mod_vars, hv2_name,4));

                if hv2==hv || strcmp(harm_mod_vars{hv2}, 'DIC_Alk')
                    continue
                end
                v2 = find(strncmp(harm_mod_vars{hv2}, variables, 4));
                if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
                    v2 = strmatch(harm_mod_vars{hv2}, variables, 'exact');
                end
                %                 plot_inde x = plot_index+1;

                subplot(p_row,p_col,6)
                hold on
                grid on
                temp_array = [];
                for m = 1:length(cmip_names.(variables{v}))
                    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
                    %                     disp(sum(mod_match))
                    if sum(mod_match)>0
                        % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
                            plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);

                            model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};

                            %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
                            temp_name = cmip_names.(variables{v}){m};
                            temp_name = strrep(temp_name, '_', '-');
                            temp_name = strrep(temp_name, '-6', ' (6)');
                            legend_names{end+1,1} = temp_name;

                            sc_h(end+1) = plot(harm_mod.(variables{v}).(fits{qq})(m), harm_mod.(variables{v2}).(fits{tt})(mod_match), 'marker', model_marker, ...
                                'color', ...
                                'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');

                            temp_array(end+1,1) = harm_mod.(variables{v}).(fits{qq})(m,1);
                            temp_array(end,2) = harm_mod.(variables{v2}).(fits{tt})(mod_match,1);
                            clear plot_color
                            %                             disp(cmip_names.(variables{v2}){mod_match})

                            %                             pause
                        % end

                    end
                    %                     pause
                end
                var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);

                xlabel( [ var_plot_names{var_label_index,2} ' ' fit_names{qq} ' (' var_plot_names{var_label_index,3} ')'])

                var_label_index = strncmp(variables{v2}, var_plot_names(:,1), 4);

                ylabel([ var_plot_names{var_label_index,2} ' ' fit_names{tt}])

                [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
                x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
                y_plot = m.*x_plot+b;
                plot(x_plot, y_plot, 'k-');
                % text()
                [~, ~, R_2, significant] = Sokal_Rohlf_regression_significance(temp_array(:,1), temp_array(:,2));
                %                 title(['r= ' num2str(r,2)])

                % add obs
                sc_h(end+1) = plot(harm.(variables{v}).(fits{qq})(1), harm.(variables{v2}).(fits{tt})(1), 'xk', 'linewidth', 2, 'markersize', 10);
                legend_names{end+1,1} = 'Observations';

            end
            %             print(gcf, '-dpng', [Plot_out_dir variables{v} '/' plot_filename '.png'])
            % legend(sc_h, legend_names, 'location', 'southoutside', 'fontsize', 10, 'numcolumns', 2);

            x_lim = get(gca, 'xlim');
            y_lim = get(gca, 'ylim');
        end
    end
end
text(5, 3.2, 'e.', 'fontsize', 13)

set(gca, 'fontsize', axis_font_size)
if significant==1
    text(x_lim(2)- diff(x_lim)*.2, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2) '^*'], 'fontsize', r_text_size, 'fontweight', 'bold')
else
    text(x_lim(2)- diff(x_lim)*.2, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
end
clear significant
% annotation('textbox', [0.05, 0.05, 1, 0], 'String', plot_filename, 'EdgeColor', 'none', 'interpreter', 'none');
print(gcf, '-dpdf', [fig_dir plot_filename plot_ver '.pdf'], '-r300')

%% Figure correlations, supplement - DIC vs SST and DIC vs MLD ampl
axis_font_size = 13;
r_text_size = 12;

plot_filename = 'Figure SCorr_DIC_SST';

p_col = 2;
p_row = 1;
leg_x_shift = .4;

clf
set(gcf, 'units', 'inches')
paper_w = 10; paper_h =5.9;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h


%%%%%% DIC Amp vs. TOS Amp.
subplot(p_row,p_col,1);

hold on

% y axis variable choices
seas_amplitude = 1;
dissic_vert_gradient=0;
sv2_name = 'dissic';
sv2 = find(strncmp(seas_comp_vars, sv2_name,4));
v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
    v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
end

% %% only applies if seas_amplitude is off
tests = {'norm_error';'correlation' ; 'ratio'};
test_names = {'normalized error'; 'correlation' ; 'Amplitude Ratio'};

tt = 2;

% x-axis variable choices
alt_x=2; % 0: x axis is one individual month for variable sv
% 1: x axis is ratio of max to min
% 2: x axis is seasonal amplitude of sv
mon = 3;
dd = 12;

wmo_on = 0; % takes precedence over alt_x
if wmo_on==0
    sv_name = 'tos';
    sv = find(strncmp(seas_comp_vars, sv_name,4));
    v = find(strncmp(seas_comp_vars{sv}, variables, 4));
    if length(v)>1 % cludge since dissic and dissic_yr were getting confused
        v = strmatch(seas_comp_vars{sv}, variables, 'exact');
    end
else
    v=10;
end

temp_array =[];
temp_names = {};
legend_names = {};
sc_h = [];

for m = 1:length(cmip_names.(variables{v}))
    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});

    if sum(mod_match)>0
        % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
            plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);

            model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};

            %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
            temp_name = cmip_names.(variables{v}){m};
            temp_name = strrep(temp_name, '_', '-');
            temp_name = strrep(temp_name, '-6', ' (6)');
            legend_names{end+1,1} = temp_name;
            %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])



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
                elseif alt_x==1
                    var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
                elseif alt_x==2
                    var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;

                end
            end
            if isnan(var_1) || isnan(var_2)
                continue
            end

            sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
                'k', 'markerfacecolor', plot_color','markersize', 14, 'linestyle', 'none');
            if alt_x==1 && var_1>20
                disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
                plot(var_1,	var_2 , 'marker', 'o', 'color', ...
                    'k', 'markerfacecolor', 'none','markersize', 20, 'linestyle', 'none');
                continue
            end
            temp_names{end+1,1} = cmip_names.(variables{v}){m};
            temp_array(end+1,1) = var_1;
            temp_array(end,2) = var_2;
        % end
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
    elseif alt_x==2
        var_1_obs = max(obs.(variables{v}).out_seasonal(:,1)) - (min(obs.(variables{v}).out_seasonal(:,1)));

    end

    sc_h(end+1) = plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10);
    legend_names{end+1,1} = 'Observations';

end

var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);

if sum(var_label_index>0)
    if seas_amplitude==1
    comp_label = [var_plot_names{var_label_index,2} ' seasonal amp. (' var_plot_names{var_label_index,3} ')' ];
    else
        comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
    end

else
    if seas_amplitude==1
        comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
    else
        comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
    end

end
dt = datetime(2024, mon, 1);
abbreviated_month = month(dt, 'short');

var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
if dissic_vert_gradient==1
    x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
elseif wmo_on==1
    x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
else
    if alt_x==0
        x_label = [abbreviated_month{1} ' ' var_plot_names{var_label_index,2}  ' (' var_plot_names{var_label_index,3} ')'];
    elseif alt_x==2
        x_label = [var_plot_names{var_label_index,2} ' seasonal amplitude (' var_plot_names{var_label_index,3} ')'];

    else
        x_label = [variables{v} ' max divided by min'];
    end
end
xlabel( x_label)
ylabel(comp_label)
grid on
text(2.1, 85, 'a.', 'fontsize', 13)
[m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
y_plot = m.*x_plot+b;
[~, ~, R_2, significant] = Sokal_Rohlf_regression_significance(temp_array(:,1), temp_array(:,2));

plot(x_plot, y_plot, 'k-')
% title(['r= ' num2str(r,2)])
x_lim = get(gca, 'xlim');
y_lim = get(gca, 'ylim');
if significant==1
    text(x_lim(2)- diff(x_lim)*.2, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2) '^*'], 'fontsize', r_text_size, 'fontweight', 'bold')
else
    text(x_lim(2)- diff(x_lim)*.2, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
end
% 
% l1 = legend(sc_h, legend_names, 'location', 'eastoutside', 'fontsize', 10, 'numcolumns', 2);
% l1_pos = get(l1, 'Position');
% set(l1, 'Position', l1_pos+[.5 .03 0 0])



set(gca, 'fontsize', axis_font_size)


% %%%%%%%%% MLD Max/ Min
% subplot(p_row,p_col,2);
% hold on
% 
% % y axis variable choices
% seas_amplitude = 1;
% dissic_vert_gradient=0;
% sv2_name = 'dissic';
% sv2 = find(strncmp(seas_comp_vars, sv2_name,4));
% v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
% if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
%     v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
% end
% 
% % %% only applies if seas_amplitude is off
% tests = {'norm_error';'correlation' ; 'ratio'};
% test_names = {'normalized error'; 'correlation' ; 'Amplitude Ratio'};
% 
% tt = 2;
% % %%
% 
% 
% % x-axis variable choices
% alt_x=1; % 0: x axis is one individual month for variable sv
% % 1: x axis is ratio of max to min
% % 2: x axis is seasonal amplitude of sv
% mon = 3;
% dd = 12;
% 
% wmo_on = 0; % takes precedence over alt_x
% if wmo_on==0
%     sv_name = 'mld';
%     sv = find(strncmp(seas_comp_vars, sv_name,4));
%     v = find(strncmp(seas_comp_vars{sv}, variables, 4));
%     if length(v)>1 % cludge since dissic and dissic_yr were getting confused
%         v = strmatch(seas_comp_vars{sv}, variables, 'exact');
%     end
% else
%     v=10;
% end
% 
% 
% temp_array =[];
% temp_names = {};
% legend_names = {};
% sc_h = [];
% 
% for m = 1:length(cmip_names.(variables{v}))
%     mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
% 
%     if sum(mod_match)>0
%         % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
%             plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);
% 
%             model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};
% 
%             %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
%             temp_name = cmip_names.(variables{v}){m};
%             temp_name = strrep(temp_name, '_', '-');
%             temp_name = strrep(temp_name, '-6', ' (6)');
%             legend_names{end+1,1} = temp_name;
%             %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])
% 
% 
% 
%             if seas_amplitude ==1
%                 var_2 = max(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) - min(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) ;
%             else
%                 var_2 = obs.(variables{v2}).(tests{tt})(mod_match);
% 
%             end
% 
%             if dissic_vert_gradient==1
%                 if CMIP.dissic_yr.out_annual(m,1,1)==0 % there is an error in CESM2_6 depth coordinate so the interpolation is not working properly
%                     continue
%                 end
%                 var_1 = CMIP.dissic_yr.out_annual(m,1,1) - CMIP.dissic_yr.out_annual(m,dd,1) ;
% 
%             else
%                 if wmo_on==1
%                     var_1 = CMIP.wmo.out_seasonal(m,dd,mon,1) ;
%                 elseif alt_x==0
%                     var_1 = CMIP.(variables{v}).out_seasonal(m,mon,1);
%                 elseif alt_x==1
%                     var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
%                 elseif alt_x==2
%                     var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
% 
%                 end
%             end
%             if isnan(var_1) || isnan(var_2)
%                 continue
%             end
% 
%             sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
%                 'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
%             if alt_x==1 && var_1>20
%                 disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
%                 plot(var_1,	var_2 , 'marker', 'o', 'color', ...
%                     'k', 'markerfacecolor', 'none','markersize', 20, 'linestyle', 'none');
%                 continue
%             end
%             temp_names{end+1,1} = cmip_names.(variables{v}){m};
%             temp_array(end+1,1) = var_1;
%             temp_array(end,2) = var_2;
%         % end
%     end
% 
% 
% 
% end
% 
% if seas_amplitude~=1 && tt~=1 % if plotting correlation or ratio, "obs" equals 1.
%     obs_y = 1;
% elseif seas_amplitude~=1 % if plotting normalized error, "obs" equals 0
%     obs_y=0;
% elseif seas_amplitude==1
%     obs_y = max(obs.(variables{v2}).out_seasonal(:,1)) - min(obs.(variables{v2}).out_seasonal(:,1));
% end
% 
% if wmo_on==0
%     if dissic_vert_gradient==1
%         obs_annual_mean = squeeze(nanmean(obs.dissic.out_seasonal(:,1,:),1));
%         var_1_obs = obs_annual_mean(1,1) - obs_annual_mean(dd,1);
%     elseif alt_x==1
%         var_1_obs = max(obs.(variables{v}).out_seasonal(:,1))./(min(obs.(variables{v}).out_seasonal(:,1)));
%     elseif alt_x==0
%         var_1_obs = obs.(variables{v}).out_seasonal(mon,1);
%     end
% 
%     plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10)
% end
% 
% var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);
% 
% if sum(var_label_index>0)
%     if seas_amplitude==1
%         comp_label = [var_plot_names{var_label_index,2} ' seasonal amp. (' var_plot_names{var_label_index,3} ')' ];
%     else
%         comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
%     end
% 
% else
%     if seas_amplitude==1
%         comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
%     else
%         comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
%     end
% 
% end
% 
% var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
% if dissic_vert_gradient==1
%     x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
% elseif wmo_on==1
%     x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
% else
%     if alt_x==0
%         x_label = [var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ') from month  ' num2str(mon)];
%     else
%         x_label = [var_plot_names{var_label_index,2} ' max divided by min'];
%     end
% end
% xlabel( x_label, 'interpreter', 'none')
% ylabel(comp_label)
% 
% [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
% x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
% y_plot = m.*x_plot+b;
% plot(x_plot, y_plot, 'k-')
% grid on
% text(2.2, 95, 'b.', 'fontsize', 13)
% 
% % title(['r= ' num2str(r,2)])
% x_lim = get(gca, 'xlim');
% y_lim = get(gca, 'ylim');
% text(x_lim(2)- diff(x_lim)*.25, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
% 
% % legend(sc_h, legend_names, 'location', 'south', 'fontsize', 10, 'numcolumns', 2);
% 
% set(gca, 'fontsize', axis_font_size)

% annotation('textbox', [0.05, 0.05, 1, 0], 'String', plot_filename, 'EdgeColor', 'none', 'interpreter', 'none');
% print(gcf, '-dpdf', [fig_dir plot_filename plot_ver '.pdf'], '-r300')

% %% Figure 8 - DIC Biological
% r_text_size = 12;
% axis_font_size = 13;
% 
% plot_filename = ['Figure 8_DIC and Intpp relationships' plot_ver];
% 
% p_col = 2;
% p_row = 1;
% 
% clf
% set(gcf, 'units', 'inches')
% paper_w = 10; paper_h =5.5;
% set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h

subplot(p_row,p_col,2);
hold on
grid on

% y axis variable choices
seas_amplitude = 1;
dissic_vert_gradient=0;
sv2_name = 'dissic';
sv2 = find(strncmp(seas_comp_vars, sv2_name,4));
v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
    v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
end

% %% only applies if seas_amplitude is off
tests = {'norm_error';'correlation' ; 'ratio'};
test_names = {'normalized error'; 'correlation' ; 'Amplitude Ratio'};

tt = 2;

% x-axis variable choices
alt_x=0; % 0: x axis is one individual month for variable sv
% 1: x axis is ratio of max to min
% 2: x axis is seasonal amplitude of sv
mon = 1;
dd = 12;

wmo_on = 0; % takes precedence over alt_x
if wmo_on==0
    sv_name = 'intpp';
    sv = find(strncmp(seas_comp_vars, sv_name,4));
    v = find(strncmp(seas_comp_vars{sv}, variables, 4));
    if length(v)>1 % cludge since dissic and dissic_yr were getting confused
        v = strmatch(seas_comp_vars{sv}, variables, 'exact');
    end
else
    v=10;
end

temp_array =[];
temp_names = {};
legend_names = {};
sc_h = [];

for m = 1:length(cmip_names.(variables{v}))
    mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});

    if sum(mod_match)>0
        % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
            plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);

            model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};

            %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
            temp_name = cmip_names.(variables{v}){m};
            temp_name = strrep(temp_name, '_', '-');
            temp_name = strrep(temp_name, '-6', ' (6)');
            legend_names{end+1,1} = temp_name;
            %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])



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
                elseif alt_x==1
                    var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
                elseif alt_x==2
                    var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;

                end
            end
            if isnan(var_1) || isnan(var_2)
                continue
            end

            sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
                'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
            if alt_x==1 && var_1>20
                disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
                plot(var_1,	var_2 , 'marker', 'o', 'color', ...
                    'k', 'markerfacecolor', 'none','markersize', 24, 'linestyle', 'none');
                continue
            end
            temp_names{end+1,1} = cmip_names.(variables{v}){m};
            temp_array(end+1,1) = var_1;
            temp_array(end,2) = var_2;
        % end
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

    sc_h(end+1) = plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10);
    legend_names{end+1,1} = 'Observations';
end

var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);

if sum(var_label_index>0)
    if seas_amplitude==1
        comp_label = [var_plot_names{var_label_index,2}  ' seasonal amplitude (' var_plot_names{var_label_index,3} ')'];
    else
        comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
    end

else
    if seas_amplitude==1
        comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
    else
        comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
    end

end
text(10, 85, 'b.', 'fontsize', 13)

var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
if dissic_vert_gradient==1
    x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
elseif wmo_on==1
    x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
else
    if alt_x==0
        x_label = [month_names{mon} ' ' var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ')'];
    else
        x_label = [variables{v} ' max divided by min'];
    end
end
xlabel( x_label)
ylabel(comp_label)

[m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
y_plot = m.*x_plot+b;
plot(x_plot, y_plot, 'k-')
[~, ~, R_2, significant] = Sokal_Rohlf_regression_significance(temp_array(:,1), temp_array(:,2));

% title(['r= ' num2str(r,2)])
% l2 = legend(sc_h, legend_names, 'location', 'east', 'fontsize', 10, 'numcolumns', 2);
% l2_pos = get(l2, 'Position');
% set(l2, 'Position', l2_pos+[.3 0 0 0])

x_lim = get(gca, 'xlim');
y_lim = get(gca, 'ylim');

set(gca, 'fontsize', axis_font_size)
if significant==1
    text(x_lim(2)- diff(x_lim)*.2, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2) '^*'], 'fontsize', r_text_size, 'fontweight', 'bold')
else
    text(x_lim(2)- diff(x_lim)*.2, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
end 
clear significant R_2
% %%%%%%%% Harmonic fit comparison between DIC phase and Int. PP amplitude
% fits = {'amp'; 'phase'; 'offset'};
% fit_names = {'amplitude'; 'phase' ; 'offset'};
% 
% harm_mod_vars = fieldnames(harm_mod);
% 
% for hv_name = {['intpp']}% 1:length(harm_mod_vars) % 7 - intpp
%     hv = find(strncmp(harm_mod_vars, hv_name,4));
% 
%     if strcmp(harm_mod_vars{hv}, 'DIC_Alk')
%         continue
%     end
%     v = find(strncmp(harm_mod_vars{hv}, variables, 4));
%     if length(v)>1 % cludge since dissic and dissic_yr were getting confused
%         v = strmatch(harm_mod_vars{hv}, variables, 'exact');
%     end
% 
%     for tt = 2%:length(fits)
%         for qq = 1%:length(fits)
% 
%             legend_names = {};
%             sc_h = [];
% 
%             for hv2_name = {['dissic']}%:length(harm_mod_vars)
%                 hv2 = find(strncmp(harm_mod_vars, hv2_name,4));
% 
%                 if hv2==hv || strcmp(harm_mod_vars{hv2}, 'DIC_Alk')
%                     continue
%                 end
%                 v2 = find(strncmp(harm_mod_vars{hv2}, variables, 4));
%                 if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
%                     v2 = strmatch(harm_mod_vars{hv2}, variables, 'exact');
%                 end
%                 %                 plot_inde x = plot_index+1;
% 
%                 subplot(p_row,p_col,1)
%                 hold on
%                 grid on
%                 temp_array = [];
%                 for m = 1:length(cmip_names.(variables{v}))
%                     mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
%                     %                     disp(sum(mod_match))
%                     if sum(mod_match)>0
%                         % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
%                             plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);
% 
%                             model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};
% 
%                             %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
%                             temp_name = cmip_names.(variables{v}){m};
%                             temp_name = strrep(temp_name, '_', '-');
%                             temp_name = strrep(temp_name, '-6', ' (6)');
%                             legend_names{end+1,1} = temp_name;
% 
%                             sc_h(end+1) = plot(harm_mod.(variables{v}).(fits{qq})(m), harm_mod.(variables{v2}).(fits{tt})(mod_match), 'marker', model_marker, ...
%                                 'color', ...
%                                 'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
% 
%                             temp_array(end+1,1) = harm_mod.(variables{v}).(fits{qq})(m,1);
%                             temp_array(end,2) = harm_mod.(variables{v2}).(fits{tt})(mod_match,1);
%                             clear plot_color
%                             %                             disp(cmip_names.(variables{v2}){mod_match})
% 
%                             %                             pause
%                         % end
% 
%                     end
%                     %                     pause
%                 end
%                 var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
% 
%                 xlabel( [ var_plot_names{var_label_index,2} ' ' fit_names{qq} ' (' var_plot_names{var_label_index,3} ')'])
% 
%                 var_label_index = strncmp(variables{v2}, var_plot_names(:,1), 4);
% 
%                 ylabel([ var_plot_names{var_label_index,2} ' ' fit_names{tt}])
% 
%                 [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
%                 x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
%                 y_plot = m.*x_plot+b;
%                 plot(x_plot, y_plot, 'k-');
%                 text()
%                 %                 title(['r= ' num2str(r,2)])
% 
%                 % add obs
%                 sc_h(end+1) = plot(harm.(variables{v}).(fits{qq})(1), harm.(variables{v2}).(fits{tt})(1), 'xk', 'linewidth', 2, 'markersize', 10);
%                 legend_names{end+1,1} = 'Observations';
% 
%             end
%             %             print(gcf, '-dpng', [Plot_out_dir variables{v} '/' plot_filename '.png'])
%             % legend(sc_h, legend_names, 'location', 'southoutside', 'fontsize', 10, 'numcolumns', 2);
% 
%             x_lim = get(gca, 'xlim');
%             y_lim = get(gca, 'ylim');
%         end
%     end
% end
% text(5, 3.05, 'a.', 'fontsize', 13)
% 
% set(gca, 'fontsize', axis_font_size)
% text(x_lim(2)- diff(x_lim)*.2, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)

% annotation('textbox', [0.05, 0.05, 1, 0], 'String', [script_name ': ' plot_filename], 'EdgeColor', 'none', 'interpreter', 'none');
print(gcf, '-dpdf', [fig_dir plot_filename plot_ver '.pdf'], '-r300')
%% Figure 9 - pCO2

r_text_size = 12;
axis_font_size = 15;

plot_filename = ['Figure S_pCO2 relationships' plot_ver];

p_col = 3;
p_row = 1;

clf
set(gcf, 'units', 'inches')
paper_w = 18; paper_h =6;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h



% y axis variable choices
seas_amplitude_list = [  0 0 0]; % 0 is off, 1 is on
dissic_vert_gradient=0;

y_sv2 = {'spco2' 'spco2' 'spco2'};
% %% only applies if seas_amplitude is off
tests = {'norm_error';'correlation' ; 'ratio'};
test_names = {'normalized error'; 'correlation' ; 'amplitude ratio'};

% tt = 2;
test_list = [ 1 3 3];

% x-axis variable choices
alt_x_list=[3 3 3 3]; % 0: x axis is one individual month for variable sv
% 1: x axis is ratio of max to min
% 2: x axis is seasonal amplitude of sv
% 3: choose a test
dd = 12;
test_list_2 = [2 3 2];

wmo_on = 0; % takes precedence over alt_x

% x_sv = [4 1 9 10 10];
x_sv = {'dissic' 'intpp' 'mld'};
mon_list = [ nan nan nan];


subplot_num = 0;
for ss = 1:length(seas_amplitude_list)
    temp_array =[];
    temp_names = {};
    legend_names = {};
    sc_h = [];
    mon = mon_list(ss);

    seas_amplitude = seas_amplitude_list(ss);
    alt_x = alt_x_list(ss);
    tt = test_list(ss);
    tt_x = test_list_2(ss);

    subplot_num = subplot_num+1;
    subplot(p_row,p_col,subplot_num);
    hold on
    grid on
    if wmo_on==0
        v = find(strncmp(x_sv{ss}, variables, 4));
        if length(v)>1 % cludge since dissic and dissic_yr were getting confused
            v = strmatch(x_sv{ss}, variables, 'exact');
        end
    else
        v=10;
    end

    sv2_name = y_sv2{ss}; % 4 - DIC, 6 - spco2
    sv2 = find(strncmp(seas_comp_vars, sv2_name,4));

    v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
    if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
        v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
    end

    for m = 1:length(cmip_names.(variables{v}))
        mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});

        if sum(mod_match)>0
            % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
                plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);

                model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};

                %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
                temp_name = cmip_names.(variables{v}){m};
                temp_name = strrep(temp_name, '_', '-');
                temp_name = strrep(temp_name, '-6', ' (6)');
                %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])



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
                    elseif alt_x==1
                        var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
                    elseif alt_x==2
                        var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
                    elseif alt_x==3
                        var_1 = obs.(variables{v}).(tests{tt_x})(m);
                    end
                end
                if isnan(var_1) || isnan(var_2)
                    continue
                end

                sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
                    'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
                legend_names{end+1,1} = temp_name;

                if alt_x==1 && var_1>20
                    disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
                    plot(var_1,	var_2 , 'marker', 'o', 'color', ...
                        'k', 'markerfacecolor', 'none','markersize', 24, 'linestyle', 'none');
                    continue
                end
                temp_names{end+1,1} = cmip_names.(variables{v}){m};
                temp_array(end+1,1) = var_1;
                temp_array(end,2) = var_2;
            % end
        end

    end

    if seas_amplitude~=1 && tt~=1 % if plotting correlation or ratio, "obs" equals 1.
        obs_y = 1;
    elseif seas_amplitude~=1 % if plotting normalized error, "obs" equals 0
        obs_y=0;
    elseif seas_amplitude==1
        if v2==1
            obs_y = max(obs.(variables{v2}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,1)) - ...
                min(obs.(variables{v2}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,1));
        else
            obs_y = max(obs.(variables{v2}).out_seasonal(:,1)) - min(obs.(variables{v2}).out_seasonal(:,1));
        end
    end

    if wmo_on==0
        if dissic_vert_gradient==1
            obs_annual_mean = squeeze(nanmean(obs.dissic.out_seasonal(:,1,:),1));
            var_1_obs = obs_annual_mean(1,1) - obs_annual_mean(dd,1);
        elseif alt_x==0
            var_1_obs = obs.(variables{v}).out_seasonal(mon,1);
        elseif alt_x==1
            var_1_obs = max(obs.(variables{v}).out_seasonal(:,1))./(min(obs.(variables{v}).out_seasonal(:,1)));
        elseif alt_x==2
            var_1_obs = max(obs.(variables{v}).out_seasonal(:,1)) - min(obs.(variables{v}).out_seasonal(:,1));
        elseif alt_x==3 && tt_x==2
            var_1_obs = 1; % correlation
        end

        sc_h(end+1) = plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10);
        legend_names{end+1,1} = 'Observations';
    end

    var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);

    if sum(var_label_index>0)
        if seas_amplitude==1
            comp_label = [var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ') seasonal amplitude'];
        else

            comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
            
        end

    else
        if seas_amplitude==1
            comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
        else
            comp_label = [seas_comp_vars{sv2} ' ' test_names{tt}];
        end

    end

    var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
    if dissic_vert_gradient==1
        x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
    elseif wmo_on==1
        x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
    else
        if alt_x==0
            x_label = [month_names{mon} ' ' var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ')'];
        elseif alt_x==1
            x_label = [var_plot_names{var_label_index,2} ' max divided by min'];
        elseif alt_x==2
            x_label = [var_plot_names{var_label_index,2} ' amp. (' var_plot_names{var_label_index,3} ')'];
        elseif alt_x==3
            x_label = [var_plot_names{var_label_index,2} ' ' test_names{tt_x}];
        else
            x_label = ' ';
        end
    end
    xlabel( x_label)
    ylabel(comp_label)
    if subplot_num==1
        text(.71, 3.1, 'a.', 'fontsize', axis_font_size)
    elseif subplot_num==2
        text(.1, 4.12, 'b.', 'fontsize', axis_font_size)

    elseif subplot_num==3
        text(.922, 4.12, 'c.', 'fontsize', axis_font_size)
    end

    [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
    x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
    y_plot = m.*x_plot+b;
    x_lim = get(gca, 'xlim');
    y_lim = get(gca, 'ylim');

    if subplot_num~=5
        plot(x_plot, y_plot, 'k-')
        text(x_lim(2)- diff(x_lim)*.35, y_lim(2)-diff(y_lim)*.05, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
    end
    % title(['r= ' num2str(r,2)])
    % if subplot_num==2
    %     l2 = legend(sc_h, legend_names, 'location', 'south', 'fontsize', 9, 'numcolumns', 2);
    %     l2_pos = get(l2, 'Position');
    %     set(l2, 'Position', l2_pos+[.5 .1 0 0])
    % 
    % end


    set(gca, 'fontsize', axis_font_size)
    % pause
end
% annotation('textbox', [0.05, 0.05, 1, 0], 'String', [script_name ': ' plot_filename], 'EdgeColor', 'none', 'interpreter', 'none');
print(gcf, '-dpdf', [fig_dir plot_filename '.pdf'], '-r300')

%% Figure 7 substitution summary plot
dataTable_out.orig_pco2_corr(dataTable_out.orig_pco2_corr==0) = nan;
dataTable_out.orig_pco2_error(dataTable_out.orig_pco2_error==0) = nan;
clear comparisons
% comparisons.dic = ...
%     {{'orig_dic_phase_offset_days' 'dic_phase' 'pco2_corr_improvement'} {'orig_pco2_corr' 'dic_phase' 'pco2_corr_improvement'}     {'orig_pco2_error' 'dic_phase'}; ...
%     {'orig_dic_amp_offset' 'dic_amp' 'pco2_corr_improvement'}           {'orig_pco2_corr' 'dic_amp' 'pco2_corr_improvement'}       {'orig_pco2_error' 'dic_amp'};...
%     { }                                                                 {'orig_pco2_corr' 'dic_phase_amp' 'pco2_corr_improvement'} {'orig_pco2_error' 'dic_phase_amp' }};
% 
% comparisons.sst = ...
%     {{'orig_sst_phase_offset_days' 'sst_phase' 'pco2_corr_improvement'} {'orig_pco2_corr' 'sst_phase' 'pco2_corr_improvement'}     {'orig_pco2_error' 'sst_phase'}; ...
%     {'orig_sst_amp_offset' 'sst_amp' 'pco2_corr_improvement'}           {'orig_pco2_corr' 'sst_amp' 'pco2_corr_improvement'}       {'orig_pco2_error' 'sst_amp'};...
%     { }                                                                 {'orig_pco2_corr' 'sst_phase_amp' 'pco2_corr_improvement'} {'orig_pco2_error' 'sst_phase_amp' }};        
% 
% comparisons.talk = ...
%     {{'orig_talk_phase_offset_days' 'talk_phase' 'pco2_corr_improvement'} {'orig_pco2_corr' 'talk_phase' 'pco2_corr_improvement'}     {'orig_pco2_error' 'talk_phase'}; ...
%     {'orig_talk_amp_offset' 'talk_amp' 'pco2_corr_improvement'}           {'orig_pco2_corr' 'talk_amp' 'pco2_corr_improvement'}       {'orig_pco2_error' 'talk_amp'};...
%     { }                                                                 {'orig_pco2_corr' 'talk_phase_amp' 'pco2_corr_improvement'} {'orig_pco2_error' 'talk_phase_amp' }}; 
% 
% comparisons.all = ...
%     { {'orig_pco2_corr' 'dic_phase_amp' 'pco2_corr_improvement'}  {'orig_pco2_corr' 'sst_phase_amp' 'pco2_corr_improvement'}   {'orig_pco2_corr' 'dic_phase_amp_sst_phase_amp' 'pco2_corr_improvement'}  {'orig_pco2_corr' 'talk_phase_amp' 'pco2_corr_improvement'}  {'orig_pco2_corr' 'dic_sst_ta' 'pco2_corr_improvement'}}; 

comparisons.all = ...
    { {'orig_dic_phase_offset_days' 'dic_phase' 'pco2_corr_improvement' 'DIC timing' 'Days'}  ...
    {'orig_dic_amp_offset' 'dic_amp' 'pco2_corr_improvement' 'DIC amp.' '\mumol l^-^1'}  ...
    {'orig_sst_amp_offset' 'sst_amp' 'pco2_corr_improvement' 'SST amp.' '\circC'}  ...
    {'orig_talk_phase_offset_days' 'talk_phase' 'pco2_corr_improvement' 'TA timing' 'Days'}  ...
    {'orig_talk_amp_offset' 'talk_amp' 'pco2_corr_improvement' 'TA amp.' '\mumol l^-^1'}}; 

nrows = 2;
ncols = 3;

plot_groups = fieldnames(comparisons);
for p=1:length(plot_groups)
    plot_filename = ['Figure 7_Substitution_results ' plot_groups{p} plot_ver    ];
    clf
    set(gcf, 'units', 'inches')
%     paper_w = size(comparisons.(plot_groups{p}),2)*2.7; paper_h = size(comparisons.(plot_groups{p}),1)*2.5;
    paper_w = 10; paper_h = 7;

    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

    plot_index = 0;
    for i = 1:size(comparisons.(plot_groups{p}),1)
        for l = 1:size(comparisons.(plot_groups{p}),2)
            plot_index = plot_index+1;
            plot_comp = comparisons.(plot_groups{p}){i,l};
            if isempty(plot_comp)
                continue
            end
            
            subplot(nrows,ncols,plot_index); hold on
            plot_comp = comparisons.(plot_groups{p}){i,l};
            if isempty(plot_comp)
                continue
            end
                        y = 1.6;
            if plot_index==1
                text(-48, y, 'a.', 'fontsize', 12)
                plot([-50 50], [0 0], 'k-')
            elseif plot_index==2
                text(-19,y, 'b.', 'fontsize', 12)
                plot([-20 20], [0 0], 'k-')
            elseif plot_index==3
                text(-.9,y, 'c.', 'fontsize', 12)
                plot([-1 3], [0 0], 'k-')
            elseif plot_index==4
                text(-47,y, 'd.', 'fontsize', 12)
                plot([-50 150], [0 0], 'k-')
            elseif plot_index==5
                text(-5.8,y, 'e.', 'fontsize', 12)
                plot([-6 2], [0 0], 'k-')

            end
            for m =  1:length(cmip_names.spco2)
                color = cmap(strcmp(cmip_names.spco2{m}, color_model(:,1)),:);
                marker = color_model{strcmp(cmip_names.spco2{m}, color_model(:,1)),4};

                if size(plot_comp,2)>=3 && strcmp(plot_comp{3}, 'pco2_corr_improvement')

                    y_data = dataTable_out.([plot_comp{1,2} '_adj_pco2_corr'])(m) - dataTable_out.orig_pco2_corr(m);
                else
                    y_data = dataTable_out.([plot_comp{1,2} '_adj_pco2_error'])(m);
%                     y_label = ''
                end
                plot(dataTable_out.(plot_comp{1,1})(m), y_data, 'color', 'k', 'marker', marker, ...
                    'markerfacecolor', color, 'markersize', 10)
            end
            grid on
            hold on
            
%             y_lims = get(gca, 'YLim');
            plot([0 0],[-.3 1.5],  'k-')
            xlabel(['Orig. ' plot_comp{1,4} ' offset (' plot_comp{1,5} ')'])
            if strcmp(plot_comp{1}, 'orig_pco2_corr')
                plot([1 -1], [0 2], 'k--', 'linewidth', 2)
                ylabel('pCO_2 corr improvement')
            elseif strcmp(plot_comp{1}, 'orig_pco2_error')
                plot(x_lims, x_lims, 'k--', 'linewidth', 2)
                ylabel('New pCO_2 error')
            else
                if plot_index==1 || plot_index==4
                    ylabel('pCO_2 corr. improvement')
                end               
                set(gca, 'ylim', [-.3 1.5])

            end

            % x_lims = get(gca, 'XLim');

            title(['Adjusting ' plot_comp{1,4}], 'interpreter', 'none')
        end

    end
%     print(gcf, '-dpdf', [Plot_out_dir 'Sensitivity_tests/' plot_filename])
    print(gcf, '-dpdf', [home_dir 'Work/Manuscripts/2019_06 SO CMIP Comparison/figures/' plot_filename], '-r300')
end
%% Figure SW - pCO2 vs CO2 flux

r_text_size = 12;
axis_font_size = 13;

plot_filename = ['Figure SW_pCO2 CO2 flux' plot_ver];

p_col = 3;
p_row = 1;

clf
set(gcf, 'units', 'inches')
paper_w = 14; paper_h =5.5;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h



% y axis variable choices
seas_amplitude_list = [  0 0 0 ]; % 0 is off, 1 is on
dissic_vert_gradient=0;

y_sv2 = {'fgco2_mol_C_m2_yr' 'fgco2_mol_C_m2_yr' 'fgco2_mol_C_m2_yr' 'fgco2_mol_C_m2_yr' 'fgco2_mol_C_m2_yr'};
% %% only applies if seas_amplitude is off
tests = {'norm_error';'correlation' ; 'ratio'};
test_names = {'normalized error'; 'correlation' ; 'amplitude Ratio'};

% tt = 2;
test_list = [ 1 2 3 1 1];

% x-axis variable choices
alt_x_list=[3 3 3 3 3]; % 0: x axis is one individual month for variable sv
% 1: x axis is ratio of max to min
% 2: x axis is seasonal amplitude of sv
% 3: choose a test
dd = 12;
test_list_2 = [1 2 3 2 2];

wmo_on = 0; % takes precedence over alt_x

% x_sv = [4 1 9 10 10];
x_sv = {'spco2' 'spco2' 'spco2' 'spco2' 'spco2'};
mon_list = [ nan nan nan nan nan];


subplot_num = 0;
for ss = 1:length(seas_amplitude_list)
    temp_array =[];
    temp_names = {};
    legend_names = {};
    sc_h = [];
    mon = mon_list(ss);

    seas_amplitude = seas_amplitude_list(ss);
    alt_x = alt_x_list(ss);
    tt = test_list(ss);
    tt_x = test_list_2(ss);

    subplot_num = subplot_num+1;
    subplot(p_row,p_col,subplot_num);
    hold on
    grid on
    if wmo_on==0
        v = find(strncmp(x_sv{ss}, variables, 4));
        if length(v)>1 % cludge since dissic and dissic_yr were getting confused
            v = strmatch(x_sv{ss}, variables, 'exact');
        end
    else
        v=10;
    end

    sv2_name = y_sv2{ss}; % 4 - DIC, 6 - spco2
    sv2 = find(strncmp(seas_comp_vars, sv2_name,6));

    v2 = find(strncmp(seas_comp_vars{sv2}, variables, 4));
    if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
        v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
    end

    for m = 1:length(cmip_names.(variables{v}))
        mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});

        if sum(mod_match)>0
            % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
                plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);

                model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};

                %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
                temp_name = cmip_names.(variables{v}){m};
                temp_name = strrep(temp_name, '_', '-');
                temp_name = strrep(temp_name, '-6', ' (6)');
                %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])



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
                    elseif alt_x==1
                        var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
                    elseif alt_x==2
                        var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
                    elseif alt_x==3
                        var_1 = obs.(variables{v}).(tests{tt_x})(m);
                    end
                end
                if isnan(var_1) || isnan(var_2)
                    continue
                end

                sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
                    'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
                legend_names{end+1,1} = temp_name;

                if alt_x==1 && var_1>20
                    disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
                    plot(var_1,	var_2 , 'marker', 'o', 'color', ...
                        'k', 'markerfacecolor', 'none','markersize', 24, 'linestyle', 'none');
                    continue
                elseif alt_x==3 && strcmp(y_sv2{ss}, 'fgco2_mol_C_m2_yr') && var_2>4
                    disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
                    plot(var_1,	var_2 , 'marker', 'o', 'color', ...
                        'k', 'markerfacecolor', 'none','markersize', 24, 'linestyle', 'none');
                    continue
                end

                temp_names{end+1,1} = cmip_names.(variables{v}){m};
                temp_array(end+1,1) = var_1;
                temp_array(end,2) = var_2;
            % end
        end

    end

    if seas_amplitude~=1 && tt~=1 % if plotting correlation or ratio, "obs" equals 1.
        obs_y = 1;
    elseif seas_amplitude~=1 % if plotting normalized error, "obs" equals 0
        obs_y=0;
    elseif seas_amplitude==1
        if v2==1
            obs_y = max(obs.(variables{v2}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,1)) - ...
                min(obs.(variables{v2}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,1));
        else
            obs_y = max(obs.(variables{v2}).out_seasonal(:,1)) - min(obs.(variables{v2}).out_seasonal(:,1));
        end
    end

    if wmo_on==0
        if dissic_vert_gradient==1
            obs_annual_mean = squeeze(nanmean(obs.dissic.out_seasonal(:,1,:),1));
            var_1_obs = obs_annual_mean(1,1) - obs_annual_mean(dd,1);
        elseif alt_x==0
            var_1_obs = obs.(variables{v}).out_seasonal(mon,1);
        elseif alt_x==1
            var_1_obs = max(obs.(variables{v}).out_seasonal(:,1))./(min(obs.(variables{v}).out_seasonal(:,1)));
        elseif alt_x==2
            var_1_obs = max(obs.(variables{v}).out_seasonal(:,1)) - min(obs.(variables{v}).out_seasonal(:,1));
        elseif alt_x==3 && tt_x==2
            var_1_obs = 1; % correlation
        elseif alt_x==3 && tt_x==1 % normalized error
            var_1_obs = 0;
        end

        sc_h(end+1) = plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10);
        legend_names{end+1,1} = 'Observations';
    end

    var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);

    if sum(var_label_index>0)
        if seas_amplitude==1
            comp_label = [var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ') seasonal amplitude'];
        else
            comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
        end

    else
        if seas_amplitude==1
            comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
        else
            comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
        end

    end

    var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
    if dissic_vert_gradient==1
        x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
    elseif wmo_on==1
        x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
    else
        if alt_x==0
            x_label = [month_names{mon} ' ' var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ')'];
        elseif alt_x==1
            x_label = [var_plot_names{var_label_index,2} ' max divided by min'];
        elseif alt_x==2
            x_label = [var_plot_names{var_label_index,2} ' amp. (' var_plot_names{var_label_index,3} ')'];
        elseif alt_x==3
            x_label = [var_plot_names{var_label_index,2} ' ' tests{tt_x}];
        else
            x_label = ' ';
        end
    end
    xlabel( x_label)
    ylabel(comp_label)

    [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
    x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
    y_plot = m.*x_plot+b;
    x_lim = get(gca, 'xlim');
    y_lim = get(gca, 'ylim');

    if subplot_num~=5
        plot(x_plot, y_plot, 'k-')
        text(x_lim(2)- diff(x_lim)*.25, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
    end
    % title(['r= ' num2str(r,2)])
    % if subplot_num==2
    %     l2 = legend(sc_h, legend_names, 'location', 'south', 'fontsize', 10, 'numcolumns', 2);
    %     l2_pos = get(l2, 'Position');
    %     set(l2, 'Position', l2_pos+[0 -.5 0 0])
    % 
    % end


    set(gca, 'fontsize', axis_font_size)
    % pause
end
% annotation('textbox', [0.05, 0.05, 1, 0], 'String', [script_name ': ' plot_filename], 'EdgeColor', 'none', 'interpreter', 'none');
print(gcf, '-dpdf', [fig_dir plot_filename '.pdf'], '-r300')

%% Figure 8 - cumulative CO2 flux

r_text_size = 12;
axis_font_size = 13;

plot_filename = ['Figure 8_Cumulative 2100 CO2 flux' plot_ver];

p_col = 3;
p_row = 1;

clf
set(gcf, 'units', 'inches')
paper_w = 14; paper_h =5;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h



% y axis variable choices
seas_amplitude_list = [  2 2 2 ]; % 0 is off, 1 is on, 2 is other
dissic_vert_gradient=0;

y_sv2 = {'out_monthly' 'out_monthly' 'out_monthly'};
% %% only applies if seas_amplitude is off
tests = {'norm_error';'correlation' ; 'ratio'};
test_names = {'normalized error'; 'correlation' ; 'amplitude ratio'};

% tt = 2;
% test_list = [ 1 2 3 1 1];

% x-axis variable choices
alt_x_list=[3 3 3 3 3]; % 0: x axis is one individual month for variable sv
% 1: x axis is ratio of max to min
% 2: x axis is seasonal amplitude of sv
% 3: choose a test
% dd = 12;
test_list_2 = [1 3 3];

wmo_on = 0; % takes precedence over alt_x

% x_sv = [4 1 9 10 10];
x_sv = {'tos' 'tos' 'dissic'};
mon_list = [ nan nan nan nan nan];


subplot_num = 0;
for ss = 1:length(seas_amplitude_list)
    temp_array =[];
    temp_names = {};
    legend_names = {};
    sc_h = [];
    mon = mon_list(ss);

    seas_amplitude = seas_amplitude_list(ss);
    alt_x = alt_x_list(ss);
    % tt = test_list(ss);
    tt_x = test_list_2(ss);

    subplot_num = subplot_num+1;
    subplot(p_row,p_col,subplot_num);
    hold on
    grid on
    if wmo_on==0
        v = find(strncmp(x_sv{ss}, variables, 4));
        if length(v)>1 % cludge since dissic and dissic_yr were getting confused
            v = strmatch(x_sv{ss}, variables, 'exact');
        end
    else
        v=10;
    end

    sv2_name = y_sv2{ss}; % 4 - DIC, 6 - spco2
    if strcmp(sv2_name, 'out_monthly') || strcmp(sv2_name, 'out_monthly_35S')
        v2_name = 'fgco2';
    else
        v2_name = seas_comp_vars{sv2};
        sv2 = find(strncmp(seas_comp_vars, sv2_name,6));

    end
     
    v2 = find(strncmp(v2_name, variables, 4));
    if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
        v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
    end

    for m = 1:length(cmip_names.(variables{v}))
        mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});

        % if sum(mod_match)>0
        % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
            plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);

            model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};

            %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
            temp_name = cmip_names.(variables{v}){m};
            temp_name = strrep(temp_name, '_', '-');
            temp_name = strrep(temp_name, '-6', ' (6)');
            %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])



            if seas_amplitude ==1
                var_2 = max(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) - min(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) ;
            elseif seas_amplitude==2
                cumulative_flux = cumsum(CMIP.fgco2.(sv2_name)(mod_match,:))./1000;

                var_2 = cumulative_flux(end);
                if isnan(var_2)
                    var_2 = cumulative_flux(end-13);
                end
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
                elseif alt_x==1
                    var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
                elseif alt_x==2
                    var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
                elseif alt_x==3
                    var_1 = obs.(variables{v}).(tests{tt_x})(m);
                end
            end
            if isnan(var_1) || isnan(var_2)
                continue
            end

            sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
                'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
            legend_names{end+1,1} = temp_name;

            if alt_x==1 && var_1>20
                disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
                plot(var_1,	var_2 , 'marker', 'o', 'color', ...
                    'k', 'markerfacecolor', 'none','markersize', 24, 'linestyle', 'none');
                continue
            elseif alt_x==3 && strcmp(y_sv2{ss}, 'fgco2_mol_C_m2_yr') && var_2>4
                disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
                plot(var_1,	var_2 , 'marker', 'o', 'color', ...
                    'k', 'markerfacecolor', 'none','markersize', 24, 'linestyle', 'none');
                continue

            elseif strcmp(sv2_name, 'out_monthly') && (var_2>0 || var_2<-1e2)
                disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
                plot(var_1,	var_2 , 'marker', 'o', 'color', ...
                    'k', 'markerfacecolor', 'none','markersize', 22, 'linestyle', 'none');
                continue
            end

            temp_names{end+1,1} = cmip_names.(variables{v}){m};
            temp_array(end+1,1) = var_1;
            temp_array(end,2) = var_2;
        % end
        % end

    end

    % if seas_amplitude~=1 && tt~=1 % if plotting correlation or ratio, "obs" equals 1.
    %     obs_y = 1;
    % elseif seas_amplitude~=1 % if plotting normalized error, "obs" equals 0
    %     obs_y=0;
    % elseif seas_amplitude==1
    %     if v2==1
    %         obs_y = max(obs.(variables{v2}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,1)) - ...
    %             min(obs.(variables{v2}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,1));
    %     else
    %         obs_y = max(obs.(variables{v2}).out_seasonal(:,1)) - min(obs.(variables{v2}).out_seasonal(:,1));
    %     end
    % end


    if seas_amplitude==2

        comp_label = 'Cumulative PFAZ flux in 2100 (Pg C)';
    else
        var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);

        if sum(var_label_index>0)
            if seas_amplitude==1
                comp_label = [var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ') seasonal amplitude'];
            else
                comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
            end

        else
            if seas_amplitude==1
                comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
            else
                comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
            end

        end
    end
    var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
    if dissic_vert_gradient==1
        x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
    elseif wmo_on==1
        x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
    else
        if alt_x==0
            x_label = [month_names{mon} ' ' var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ')'];
        elseif alt_x==1
            x_label = [var_plot_names{var_label_index,2} ' max divided by min'];
        elseif alt_x==2
            x_label = [var_plot_names{var_label_index,2} ' amp. (' var_plot_names{var_label_index,3} ')'];
        elseif alt_x==3
            x_label = [var_plot_names{var_label_index,2} ' ' test_names{tt_x}];
        else
            x_label = ' ';
        end
    end
    xlabel( x_label)
    ylabel(comp_label)

    [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
    x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
    y_plot = m.*x_plot+b;
    x_lim = get(gca, 'xlim');
    y_lim = get(gca, 'ylim');

    if subplot_num~=5
        plot(x_plot, y_plot, 'k-')
        text(x_lim(2)- diff(x_lim)*.25, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
    end
    % title(['r= ' num2str(r,2)])
    % if subplot_num==2
    %     l2 = legend(sc_h, legend_names, 'location', 'south', 'fontsize', 10, 'numcolumns', 2);
    %     l2_pos = get(l2, 'Position');
    %     set(l2, 'Position', l2_pos+[0 -.5 0 0])
    % 
    % end
    y = 106;
    if subplot_num==1
        text(.05, y, 'a.', 'fontsize', axis_font_size)
    elseif subplot_num==2
        text(.6, y, 'b.', 'fontsize', axis_font_size)
    elseif subplot_num==3
        text(.08, y, 'c.', 'fontsize', axis_font_size)
    end
    set(gca, 'fontsize', axis_font_size)
    % pause
end
% annotation('textbox', [0.05, 0.05, 1, 0], 'String', [script_name ': ' plot_filename], 'EdgeColor', 'none', 'interpreter', 'none');
print(gcf, '-dpdf', [fig_dir plot_filename '.pdf'], '-r300')

%% Figure 8v2 - Flux intensity by 2100

r_text_size = 12;
axis_font_size = 13;

plot_filename = ['Figure 8v2_2100 CO2 flux intensity' plot_ver];

p_col = 3;
p_row = 1;

clf
set(gcf, 'units', 'inches')
paper_w = 14; paper_h =5;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h



% y axis variable choices
seas_amplitude_list = [  2 2 2 ]; % 0 is off, 1 is on, 2 is other
dissic_vert_gradient=0;

y_sv2 = {'out_monthly' 'out_monthly' 'out_monthly'};
% %% only applies if seas_amplitude is off
tests = {'norm_error';'correlation' ; 'ratio'};
test_names = {'normalized error'; 'correlation' ; 'amplitude ratio'};

% tt = 2;
% test_list = [ 1 2 3 1 1];

% x-axis variable choices
alt_x_list=[3 3 3 3 3]; % 0: x axis is one individual month for variable sv
% 1: x axis is ratio of max to min
% 2: x axis is seasonal amplitude of sv
% 3: choose a test
% dd = 12;
test_list_2 = [1 3 3];

wmo_on = 0; % takes precedence over alt_x

% x_sv = [4 1 9 10 10];
x_sv = {'tos' 'tos' 'dissic'};
mon_list = [ nan nan nan nan nan];

% set state estimates to 0 for 2100
CMIP.fgco2.out_monthly_mol_C_m2_yr(43:45,:) = nan;

subplot_num = 0;
for ss = 1:length(seas_amplitude_list)
    temp_array =[];
    temp_names = {};
    legend_names = {};
    sc_h = [];
    mon = mon_list(ss);

    seas_amplitude = seas_amplitude_list(ss);
    alt_x = alt_x_list(ss);
    % tt = test_list(ss);
    tt_x = test_list_2(ss);

    subplot_num = subplot_num+1;
    subplot(p_row,p_col,subplot_num);
    hold on
    grid on
    if wmo_on==0
        v = find(strncmp(x_sv{ss}, variables, 4));
        if length(v)>1 % cludge since dissic and dissic_yr were getting confused
            v = strmatch(x_sv{ss}, variables, 'exact');
        end
    else
        v=10;
    end

    sv2_name = y_sv2{ss}; % 4 - DIC, 6 - spco2
    if strcmp(sv2_name, 'out_monthly')
        v2_name = 'fgco2';
    else
        v2_name = seas_comp_vars{sv2};
        sv2 = find(strncmp(seas_comp_vars, sv2_name,6));

    end
     
    v2 = find(strncmp(v2_name, variables, 4));
    if length(v2)>1 % cludge since dissic and dissic_yr were getting confused
        v2 = strmatch(seas_comp_vars{sv2}, variables, 'exact');
    end

    for m = 1:length(cmip_names.(variables{v}))
        mod_match = strcmp(cmip_names.(variables{v2}), cmip_names.(variables{v}){m});
        disp(cmip_names.(variables{v}){m})
        disp(cmip_names.(variables{v2}){mod_match})
        % if sum(mod_match)>0
        % if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
            plot_color = cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:);

            model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};

            %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
            temp_name = cmip_names.(variables{v}){m};
            temp_name = strrep(temp_name, '_', '-');
            temp_name = strrep(temp_name, '-6', ' (6)');
            %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])



            if seas_amplitude==1
                var_2 = max(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) - min(CMIP.(variables{v2}).out_seasonal(mod_match,:,1)) ;
            elseif seas_amplitude==2
                % cumulative_flux = cumsum(CMIP.fgco2.(sv2_name)(mod_match,:))./1000;
                % var_2 = cumulative_flux(end);

                flux_intensity_2100 = mean(CMIP.fgco2.out_monthly_mol_C_m2_yr(mod_match,end-11:end),'omitnan'); 
                % try flux intensity instead of cumulative flux:
                var_2 = flux_intensity_2100;

                if isnan(var_2)
                    % for those that end a year too early:
                    
                    % var_2 = cumulative_flux(end-13);
                    flux_intensity_2100 = mean(CMIP.fgco2.out_monthly_mol_C_m2_yr(mod_match,end-23:end),'omitnan');

                    var_2 = flux_intensity_2100;

                end
            else
                var_2 = obs.(variables{v2}).(tests{tt})(mod_match);

            end
            disp(var_2)
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
                elseif alt_x==1
                    var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1))./min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
                elseif alt_x==2
                    var_1 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;
                elseif alt_x==3
                    var_1 = obs.(variables{v}).(tests{tt_x})(m);
                end
            end
            if isnan(var_1) || isnan(var_2)
                continue
            end
            
            disp([temp_name ' ' num2str(var_1) ' ' num2str(var_2)])
            sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
                'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
            legend_names{end+1,1} = temp_name;

            if alt_x==1 && var_1>20
                disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
                plot(var_1,	var_2 , 'marker', 'o', 'color', ...
                    'k', 'markerfacecolor', 'none','markersize', 24, 'linestyle', 'none');
                continue
            elseif alt_x==3 && strcmp(y_sv2{ss}, 'fgco2_mol_C_m2_yr') && var_2>4
                disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
                plot(var_1,	var_2 , 'marker', 'o', 'color', ...
                    'k', 'markerfacecolor', 'none','markersize', 24, 'linestyle', 'none');
                continue

            elseif strcmp(sv2_name, 'out_monthly') && (var_2>0 || var_2<-1e2)
                disp(['withholding ' cmip_names.(variables{v}){m} ' from regression'])
                plot(var_1,	var_2 , 'marker', 'o', 'color', ...
                    'k', 'markerfacecolor', 'none','markersize', 22, 'linestyle', 'none');
                continue
            end

            temp_names{end+1,1} = cmip_names.(variables{v}){m};
            temp_array(end+1,1) = var_1;
            temp_array(end,2) = var_2;
        % end
        % end

    end

    % if seas_amplitude~=1 && tt~=1 % if plotting correlation or ratio, "obs" equals 1.
    %     obs_y = 1;
    % elseif seas_amplitude~=1 % if plotting normalized error, "obs" equals 0
    %     obs_y=0;
    % elseif seas_amplitude==1
    %     if v2==1
    %         obs_y = max(obs.(variables{v2}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,1)) - ...
    %             min(obs.(variables{v2}).Combined.(p_year).SOCCOM_SOCAT.out_seasonal(:,1));
    %     else
    %         obs_y = max(obs.(variables{v2}).out_seasonal(:,1)) - min(obs.(variables{v2}).out_seasonal(:,1));
    %     end
    % end


    if seas_amplitude==2

        comp_label = 'Cumulative PFAZ flux in 2100 (Pg C)';
    else
        var_label_index = strncmp(seas_comp_vars{sv2}, var_plot_names(:,1), 4);

        if sum(var_label_index>0)
            if seas_amplitude==1
                comp_label = [var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ') seasonal amplitude'];
            else
                comp_label = [var_plot_names{var_label_index,2} ' ' test_names{tt}];
            end

        else
            if seas_amplitude==1
                comp_label = [seas_comp_vars{sv2} ' seasonal amplitude'];
            else
                comp_label = [seas_comp_vars{sv2} ' ' tests{tt}];
            end

        end
    end
    var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
    if dissic_vert_gradient==1
        x_label = ['dissic vert gradient ' num2str(obs.dissic.depth_levs(dd))];
    elseif wmo_on==1
        x_label = [variables{v} ' value from Month= ' num2str(mon) ' and depth ' num2str(CMIP.wmo.CMCC_CESM.depth(dd))];
    else
        if alt_x==0
            x_label = [month_names{mon} ' ' var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ')'];
        elseif alt_x==1
            x_label = [var_plot_names{var_label_index,2} ' max divided by min'];
        elseif alt_x==2
            x_label = [var_plot_names{var_label_index,2} ' amp. (' var_plot_names{var_label_index,3} ')'];
        elseif alt_x==3
            x_label = [var_plot_names{var_label_index,2} ' ' test_names{tt_x}];
        else
            x_label = ' ';
        end
    end
    xlabel( x_label)
    ylabel(comp_label)

    [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
    x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
    y_plot = m.*x_plot+b;
    x_lim = get(gca, 'xlim');
    y_lim = get(gca, 'ylim');

    if subplot_num~=5
        plot(x_plot, y_plot, 'k-')
        text(x_lim(2)- diff(x_lim)*.25, y_lim(1)+diff(y_lim)*.1, ['R^2: ' num2str(r^2,2)], 'fontsize', r_text_size)
    end
    % title(['r= ' num2str(r,2)])
    % if subplot_num==2
    %     l2 = legend(sc_h, legend_names, 'location', 'south', 'fontsize', 10, 'numcolumns', 2);
    %     l2_pos = get(l2, 'Position');
    %     set(l2, 'Position', l2_pos+[0 -.5 0 0])
    % 
    % end
    y = 106;
    if subplot_num==1
        text(.05, y, 'a.', 'fontsize', axis_font_size)
    elseif subplot_num==2
        text(.6, y, 'b.', 'fontsize', axis_font_size)
    elseif subplot_num==3
        text(.08, y, 'c.', 'fontsize', axis_font_size)
    end
    set(gca, 'fontsize', axis_font_size)
    % pause
end
% annotation('textbox', [0.05, 0.05, 1, 0], 'String', [script_name ': ' plot_filename], 'EdgeColor', 'none', 'interpreter', 'none');
print(gcf, '-dpdf', [fig_dir plot_filename '.pdf'], '-r300')

%% Figure 9
plot_filename = ['Figure 9_Cumulative 2100 CO2 flux by adjustment color_temp_area_corrected_model_color' plot_ver];
model_types = fieldnames(model_group_names);

p_col = 3;
p_row = 1;

clf
set(gcf, 'units', 'inches')
paper_w = 8; paper_h =4;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h

d1 = subplot(2,1,1); hold on; grid on; title('a. PFAZ')
d2 = subplot(2,1,2);hold on; grid on; title('b. South of 35\circS')

l_l = NaN(6,1);

global_area = C_input.Combined.(p_year).area';


% want to loop by model group,
for mg = [3 4 5 6 2 1]
    fgco2_list = CMIP.fgco2.model_groups.(model_types{mg});

    for mod = 1:length(fgco2_list)
        m = fgco2_list(mod);
        
        theta_match = strcmp(cmip_names.thetao, cmip_names.fgco2{m});

        plot_color = model_group_colors(color_model{strcmp(cmip_names.fgco2{m}, color_model(:,1)),3},:);

        plot_color = cmap(strcmp(cmip_names.fgco2{m}, color_model(:,1)),:);

        % 
        temp_area = global_area;
        % try
        total_area = sum(temp_area(CMIP.thetao.(cmip_names.thetao{theta_match}).SAF_S_mask), 'omitnan');
        p1 = plot(d1, CMIP.fgco2.ACCESS_ESM1_5_6.GMT_Matlab, cumsum(CMIP.fgco2.out_monthly(m,:))./1e3, 'color', plot_color, 'linewidth', 2);

        p2 = plot(d2, CMIP.fgco2.ACCESS_ESM1_5_6.GMT_Matlab,  cumsum(CMIP.fgco2.out_monthly_35S(m,:)./1e3),  'color', plot_color, 'linewidth', 2);
        

        model_marker = color_model{strcmp(cmip_names.fgco2{m}, color_model(:,1)),4};

        final_flux = cumsum(CMIP.fgco2.out_monthly_35S(m,:)./1e3);

        p3 = plot(d2, CMIP.fgco2.ACCESS_ESM1_5_6.GMT_Matlab(end)+60,  final_flux(end),  'marker', model_marker, 'color', ...
                'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');

        % catch
        % end
    end
end
datetick(d1)
datetick(d2)
xlabel(d2, 'Year')
ylabel(d1, 'Pg C')
ylabel(d2, 'Pg C')
x_lims = get(d1, 'xlim');
model_types_for_legend = {};

for m = 1:length(model_types)
    l_l(m) = plot([0 1],[0 0], '-', 'color', model_group_colors(m,:), 'linewidth', 2);
    model_types_for_legend{end+1} = strrep(model_types{m}, '_', ' ');
end

set(d1, 'xlim', x_lims, 'TitleHorizontalAlignment', 'left')
set(d2, 'xlim', x_lims, 'TitleHorizontalAlignment', 'left')
legend(d2, l_l, model_types_for_legend, 'interpreter', 'none', 'location', 'southwest', 'fontsize', 8);

print(gcf, '-dpdf', [fig_dir plot_filename '.pdf'], '-r300')

%% Temporary code for Matt Mazloff to try optimization:
% 
% clear obs_out CMIP_out cmip_names_out
% obs_out.spco2 = obs.spco2.Combined.y2023.SOCCOM_SOCAT.out_seasonal(:,:);
% obs_out.dissic = obs.dissic.out_seasonal(:,:,1);
% obs_out.talk = obs.talk.out_seasonal(:,:,1);
% obs_out.tos = obs.tos.out_seasonal;
% obs_out.sos = obs.sos.out_seasonal;
% 
% var_out = {'spco2'; 'dissic'; 'talk';'tos';'sos'};
% for v = 1:length(var_out)
% 
%     CMIP_out.(var_out{v}) = CMIP.(var_out{v}).out_seasonal;
%     cmip_names_out.(var_out{v}) = cmip_names.(var_out{v});
% end
% 
% save([fig_dir '../data/out_for_MM.mat'], 'obs_out', 'CMIP_out', 'cmip_names_out')
