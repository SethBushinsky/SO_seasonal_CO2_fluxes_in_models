% Plotting code for Bushinsky et al. CMIP SO Flux comparison paper (to be
% titled)

%% 
fig_dir = [home_dir 'Work/Manuscripts/2019_06 SO CMIP Comparison/figures/'];

% load processed data:
% seasonal_file = 'seasonal_cycles_w_model_type_matched_2023_10_23.mat';
seasonal_file = 'seasonal_cycles_w_model_type_matched_2023_11_07.mat';
load([fig_dir '../data/' seasonal_file])

%% matching variable names to names for printing:

var_plot_names = {'tos'  'SST' '\circC' ;
    'dissic' '[DIC]' '\mumol L^-^1';
    'spco2' 'pCO_2' '\muatm' ;
    'fgco2' 'CO_2 flux' 'mol C m^2 yr^-^1' ;
    'mlotst' 'MLD' 'm'};
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

plot_filename = ['Figure 2_v3 Obs model Seasonal ' anomaly_text ' fgco2 spco2 dic tos ' plot_ver];
clf
set(gcf, 'units', 'inches')
paper_w = 9; paper_h =11;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

plot_index = 0;
seas_comp_vars = fieldnames(obs);
d = NaN(8,1);
for sv = [8 6 4 1]

    v = find(strncmp(seas_comp_vars{sv}, variables, 4));
    if length(v)>1 % cludge since dissic and dissic_yr were getting confused
        v = strmatch(seas_comp_vars{sv}, variables, 'exact');
    end
    if sv==8 || sv==6
        max_rel_amp = 6;
    else
        max_rel_amp = 2.5;
    end
    plot_index = plot_index+1;
    
    d(plot_index) = subplot(4,2,plot_index);
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
            e1 = errorbar(1:12, obs.(seas_comp_vars{sv}).Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1)- ...
                nanmean( obs.(seas_comp_vars{sv}).Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1)), ...
                obs.(seas_comp_vars{sv}).Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 4, 'color', 'k', 'linestyle', '-.');
        else
            e1 = errorbar(1:12, obs.(seas_comp_vars{sv}).Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,1), ...
                obs.(seas_comp_vars{sv}).Combined.y2021.SOCCOM_SOCAT.out_seasonal(:,2), 'linewidth', 4, 'color', 'k', 'linestyle', '-.');
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

    if plot_index==7
        xlabel('Month')
    end
%     l1 = legend([legend_names ; 'Obs'], 'interpreter', 'none', 'location', 'eastoutside');
    set(gca, 'fontsize', 12, 'xlim', [1 12])
%     set(l1, 'fontsize', 9)

    plot_index = plot_index+1;

    % Plotting taylor diagrams
    subplot(4,2,plot_index)
    legend_on = 0;
    
    rms_cutoff_for_good = .75;
    out_of_phase_corr_cutoff = 0;
    
    if ~isempty(strfind(seas_comp_vars{sv}, 'fgco2'))
        DDD = taylor_dist_smb_for_manuscript(obs.(seas_comp_vars{sv}).correlation, obs.(seas_comp_vars{sv}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, ...
            rms_cutoff_for_good, out_of_phase_corr_cutoff, max_rel_amp);
    else
        DDD = taylor_dist_smb_for_manuscript(obs.(seas_comp_vars{sv}).correlation, obs.(seas_comp_vars{sv}).ratio, [], cmip_names.(variables{v}), color_model, cmap, legend_on, [], [], max_rel_amp);
    end
%     title('Fit to observations')
    set(gca, 'YColor', 'none')

    set(gca, 'fontsize', 12)
%     set(gca, 'ycolor', 'white')
    text(-max_rel_amp*1.3, max_rel_amp+.2, var_plot_names{var_label_index,2}, 'fontweight', 'bold')
    if plot_index==8
        text(2,max_rel_amp+.05,'Correlation','fontsize',14)
        xlabel(['Relative Amplitud' ...
            'e'])
    end
    clear paper_w paper_h legend_on
end

print(gcf, '-dpdf', '-r300', [fig_dir '/' plot_filename '.pdf'])
print(gcf, '-dpng', '-r300', [fig_dir '/' plot_filename '.png'])
%% Plotting a legend 
legend_names = {};
% use CO_2 flux, plot all at 0,0, and then make a legend that covers it -
% multiple columns if need be
clf
subplot(1,1,1); hold on
sv = 8;
v = find(strncmp(seas_comp_vars{sv}, variables, 4));

for m =  1:length(cmip_names.(variables{v}))
    plot(1:2, CMIP.(variables{v}).out_seasonal(m,1:2,1), 'color', [cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:) .5], 'linewidth', 3, ...
        'marker', color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4}, 'markersize', 10, 'markerfacecolor', [cmap(strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),:)]);

    temp_name = cmip_names.(variables{v}){m};
    temp_name = strrep(temp_name, '_', '-');
    temp_name = strrep(temp_name, '-6', ' (6)');
    legend_names{end+1,1} = temp_name;

end
e1 = plot(1:2, obs.dissic.out_seasonal(1:2,1), 'linewidth', 4, 'color', 'k', 'linestyle', '-.');
legend_names{end+1,1} = 'Observations';
legend(legend_names, 'fontsize', 25, 'numcolumns', 2)
set(gca, 'Xcolor', 'none', 'Ycolor', 'none', 'xlim', [-2 -1])
% print(gcf, '-dpng', [fig_dir '/' 'Model_Legend.png'])
print(gcf, '-dpdf', '-r300', [fig_dir '/' 'Model_Legend.pdf'])


%% Figure 4. Contour plots of pCO2 correlation against DISSIC amplitude and phase shifts with models overlaid 
set(gcf, 'colormap', brewermap(30, 'Spectral'))

v = 7;
main_var = 'dissic';

sub_v = 5;
sub_var_name = 'adjust_tos_amp_percent';

sub_var_3_name = 'adjust_talk_amp_percent';
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
dh = NaN(5,1);
l_h = NaN(5,1);
for ta = 5%1:length(adjust_vars.(sub_var_3_name))
    subplot_index = 0;
    clf
    set(gcf, 'units', 'inches')
    paper_w = 8; paper_h =10;
    set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]);

    plot_filename = ['Contour_correlation ' variables{v} ' subplots by ' variables{sub_v} ' and ' sub_var_3_name '_' num2str(adjust_vars.(sub_var_3_name)(ta))];

    if model_plot==1
        plot_filename = [plot_filename '_model_overlay'];
    end
    if pco2_corr_plot==0
        plot_filename = [plot_filename '_' plot_title_add];

    end
    
    for tt = 3:length(adjust_vars.(sub_var_name))
        legend_names = {};
        sc_h = [];
        sub_v_amp_percent=adjust_vars.(sub_var_name)(tt);
        sub_v_shift_days = 0;

        subplot_index = subplot_index+1;
        if tt==2
            subplot_index = subplot_index+1;
        end
        dh(subplot_index) = subplot(3,1,subplot_index);
        
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

        [C, h] = contourf( adjust_vars.(['adjust_' main_var '_phase_shift_days']), adjust_vars.(['adjust_' main_var '_amp_percent']),pCO2_grid, 'levellist', -1:0.05:1, 'linestyle', 'none'); 
        c_l = colorbar; 
        caxis([-1 1])
        hold on
        [C1, h1] = contour( adjust_vars.(['adjust_' main_var '_phase_shift_days']),adjust_vars.(['adjust_' main_var '_amp_percent']), pCO2_grid, 'levellist', [-0.5:0.5:0.5], 'linestyle', '-', 'linewidth', 2, 'color', 'k');
        clabel(C1, h1);
        ylabel(c_l, 'Model pCO_2 corr. to obs.')

        var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);

        xlabel([var_plot_names{var_label_index,2} ' Shift (days)'])
        ylabel([var_plot_names{var_label_index,2} ' Amplitude (% diff)'])

        sub_var_label_index = strncmp(variables{sub_v}, var_plot_names(:,1), 4);

        %         xlabel([variables{v} ' Shift (days)'])
        %         ylabel([variables{v} ' Amplitude (% diff)'])

        %         title([(variables{sub_v}) ' amplitude percent ' num2str(sub_v_amp_percent)]);
        title([var_plot_names{sub_var_label_index,2} ' amplitude range: ' num2str(sub_v_amp_percent-25) ' to ' num2str(sub_v_amp_percent+25) ' %'])
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
                model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};
                if isempty(var_phase_shift_days)
                    continue
                end

                if pco2_corr_plot==1

                    mod_pco2_corr = obs.spco2.correlation(m);

                    sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
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
%         pause
        l_h(subplot_index) = legend(sc_h, legend_names, 'location', 'eastoutside', 'fontsize', 10, 'numcolumns', 1);
        
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
    pause(.2)
    sub_pos = NaN(subplot_index,4);
    leg_pos = NaN(subplot_index,4);

    for sp = 1:size(sub_pos,1)
        sub_pos(sp,:) = get(dh(sp), 'Position');
    end

    for sp = 1:3
        set(dh(sp), 'position', [sub_pos(sp,1) sub_pos(sp,2) sub_pos(2,3)-.3 sub_pos(2,4)])
    end
    for sp = 1:size(sub_pos,1)

        leg_pos(sp,:) = get(l_h(sp), 'Position');
    end
    for sp = 1:3
        set(l_h(sp), 'position', [leg_pos(sp,1)+.13 leg_pos(sp,2) leg_pos(sp,3)+.0001 leg_pos(sp,4)])
    end
    print(gcf, '-dpdf', [fig_dir plot_filename plot_ver])
end

%% Figure 5 - SST plots

%  Trying to evaluate intpp magnitude vs. vars (rather than using taylor evaluation for intpp)
% want to be able to choose a set of plots for this i think
axis_font_size = 13;

plot_filename = 'Figure 5_Var_comparison SST and MLD relationships_multi panel option';

p_col = 3;
p_row = 2;

clf
set(gcf, 'units', 'inches')
paper_w = 15; paper_h =13;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h

subplot(p_row,p_col,1);
hold on

% y axis variable choices
seas_amplitude = 1;
dissic_vert_gradient=0;
sv2 = 1;
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
mon = 3;
dd = 12;

wmo_on = 0; % takes precedence over alt_x
if wmo_on==0
    sv = 9;
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
        if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
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
                    var_2 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;

                end
            end
            if isnan(var_1) || isnan(var_2)
                continue
            end

             sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
                'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
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
        x_label = [var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ') from month  ' num2str(mon)];
    else
        x_label = [variables{v} ' max divided by min'];
    end
end
xlabel( x_label, 'interpreter', 'none')
ylabel(comp_label)

[m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
y_plot = m.*x_plot+b;
plot(x_plot, y_plot, 'k-')
title(['r= ' num2str(r,2)])
legend(sc_h, legend_names, 'location', 'southoutside', 'fontsize', 10, 'numcolumns', 2);

set(gca, 'fontsize', axis_font_size)

%%%%%%%%% plotting SST Amp vs. Winter month:
subplot(p_row,p_col,2);
hold on

% y axis variable choices
seas_amplitude = 1;
dissic_vert_gradient=0;
sv2 = 1;
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
mon = 9;
dd = 12;

wmo_on = 0; % takes precedence over alt_x
if wmo_on==0
    sv = 9;
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
        if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
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
                    var_2 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;

                end
            end
            if isnan(var_1) || isnan(var_2)
                continue
            end

             sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
                'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');

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

    sc_h(end+1) =  plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10);
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
        x_label = [var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ') from month  ' num2str(mon)];
    else
        x_label = [variables{v} ' max divided by min'];
    end
end
xlabel( x_label, 'interpreter', 'none')
ylabel(comp_label)

[m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
y_plot = m.*x_plot+b;
plot(x_plot, y_plot, 'k-')
title(['r= ' num2str(r,2)])
legend(sc_h, legend_names, 'location', 'southoutside', 'fontsize', 10, 'numcolumns', 2);

set(gca, 'fontsize', axis_font_size)

%%%%%%%%% MLD Max/ Min
subplot(p_row,p_col,3);
hold on

% y axis variable choices
seas_amplitude = 1;
dissic_vert_gradient=0;
sv2 = 1;
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
    sv = 9;
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
        if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
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
                    var_2 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;

                end
            end
            if isnan(var_1) || isnan(var_2)
                continue
            end

             sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
                'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
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
        x_label = [var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ') from month  ' num2str(mon)];
    else
        x_label = [variables{v} ' max divided by min'];
    end
end
xlabel( x_label, 'interpreter', 'none')
ylabel(comp_label)

[m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
y_plot = m.*x_plot+b;
plot(x_plot, y_plot, 'k-')
title(['r= ' num2str(r,2)])
legend(sc_h, legend_names, 'location', 'southoutside', 'fontsize', 10, 'numcolumns', 2);

set(gca, 'fontsize', axis_font_size)

% plotting Taylor RMS vs each other
subplot(p_row,p_col,4)
% now also do the other comparisons (i.e. correlation vs. correlation)
filter_on=0;
if filter_on==1
    disp('Warning, some results filtered from regression analysis')
end
% example spco2 match vs. intpp
tests = {'norm_error';'correlation' ; 'ratio'};
test_names = {'normalized error'; 'correlation' ; 'amplitude ratio'};
% legend_on=0;
group_color = 2;
set(gcf, 'colormap', turbo)
v3 = 4; % variable for harmonic fit scatter color

harm_comp = 'offset';

for sv = 9% [1 2 3 4 5 6 8 9 10] %1:length(seas_comp_vars)

    for tt = 3%:length(tests)
        for qq = 1% 1:length(tests)
            %             if strcmp(variables{v}, 'wmo') || strcmp(variables{v}, 'psl') || strcmp(variables{v}, 'dissic_yr') || strcmp(variables{v}, 'talk_yr') || strcmp(variables{v}, 'thetao')
            %                 continue
            %             end

            % find matching v
            v = find(strncmp(seas_comp_vars{sv}, variables, 4));
            if length(v)>1 % cludge since dissic and dissic_yr were getting confused
                v = strmatch(seas_comp_vars{sv}, variables, 'exact');
            end

            plot_index = 0;

%             plot_filename = ['Taylor ' seas_comp_vars{sv} ' ' tests{qq} ' vs. ' tests{tt} ' other vars_model_groups=' num2str(group_color) ' filter ' num2str(filter_on)];
%             if group_color==2
%                 plot_filename = ['Taylor ' seas_comp_vars{sv} ' ' tests{qq} ' vs. ' tests{tt} ' other vars_model_groups=' num2str(group_color) '_' variables{v3} '_' ...
%                     harm_comp ' filter ' num2str(filter_on)];
% 
%             end
            for sv2 = 1%[1 2 3 4 5 6 8 9 10]
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

%                 subplot(3,3,plot_index)

                hold on
%                 grid on

                temp_array = [];
                temp_color = [];
                sc_h = [];
                legend_names = {};

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
                                    %                                     mod_pco2_corr = obs.spco2.correlation(m);
                                    model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};

                                    %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
                                    temp_name = cmip_names.(variables{v}){m};
                                    temp_name = strrep(temp_name, '_', '-');
                                    temp_name = strrep(temp_name, '-6', ' (6)');
                                    legend_names{end+1,1} = temp_name;
                                    %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])


                                    harm_diff = harm_mod.(variables{v3}).(harm_comp)(mod_match_2) - harm.(variables{v3}).(harm_comp); % difference in phase between model and obs

                                    sc_h(end+1) = scatter(obs.(variables{v}).(tests{qq})(m), obs.(variables{v2}).(tests{tt})(mod_match), 100, harm_diff, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
                                    c1 = colorbar;
                                    temp_color(end+1) = harm_diff;
                                else
                                    plot(obs.(variables{v}).(tests{qq})(m), obs.(variables{v2}).(tests{tt})(mod_match), 'o', 'color', ...
                                        'k', 'markersize', 7)
                                end
                                
                                var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
                                ylabel(c1, ['Model ' var_plot_names{var_label_index,2} ' ' harm_comp])
                                
                            end
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

                var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
                if sum(var_label_index>0)
                    xlabel( [var_plot_names{var_label_index,2} ' ' test_names{qq}], 'interpreter', 'none')
                else
                    xlabel( [variables{v} ' ' test_names{qq}], 'interpreter', 'none')
                end

                var_label_index = strncmp(variables{v2}, var_plot_names(:,1), 4);
                if sum(var_label_index>0)
                    ylabel([var_plot_names{var_label_index,2} ' ' test_names{tt}], 'interpreter', 'none')
                else
                    ylabel([variables{v2} ' ' test_names{tt}], 'interpreter', 'none')

                end
                if filter_on==1
                    temp_array(temp_array(:,1)>3,1)=nan;
                    temp_array = temp_array(~isnan(temp_array(:,1)),:);

                end

%                 [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
%                 x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
%                 y_plot = m.*x_plot+b;
%                 plot(x_plot, y_plot, 'k-')
%                 if filter_on==0
%                     title(['r= ' num2str(r,2)])
%                 else
%                     title(['filt r= ' num2str(r,2)])
%                 end
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

            %             end
%             print(gcf, '-dpng', [Plot_out_dir variables{v} '/' plot_filename '_v8_test.png'])
        end
    end
end
legend(sc_h, legend_names, 'location', 'southoutside', 'fontsize', 10, 'numcolumns', 2);

set(gca, 'fontsize', axis_font_size)

annotation('textbox', [0.05, 0.05, 1, 0], 'String', plot_filename, 'EdgeColor', 'none', 'interpreter', 'none');

print(gcf, '-dpng', [fig_dir plot_filename '.png'])

%% Figure 6 - DIC physical plots

%  Trying to evaluate intpp magnitude vs. vars (rather than using taylor evaluation for intpp)
% want to be able to choose a set of plots for this i think
axis_font_size = 13;

plot_filename = 'Figure 6_Var_comparison DIC and MLD relationships_multi panel option';

p_col = 3;
p_row = 2;

clf
set(gcf, 'units', 'inches')
paper_w = 15; paper_h =13;
set(gcf,'PaperSize',[paper_w paper_h],'PaperPosition', [0 0 paper_w paper_h]); clear paper_w paper_h

subplot(p_row,p_col,1);
hold on

% y axis variable choices
seas_amplitude = 1;
dissic_vert_gradient=0;
sv2 = 4; % 
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
mon = 3;
dd = 12;

wmo_on = 0; % takes precedence over alt_x
if wmo_on==0
    sv = 9;
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
        if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
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
                    var_2 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;

                end
            end
            if isnan(var_1) || isnan(var_2)
                continue
            end

             sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
                'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
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
        x_label = [var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ') from month  ' num2str(mon)];
    else
        x_label = [variables{v} ' max divided by min'];
    end
end
xlabel( x_label, 'interpreter', 'none')
ylabel(comp_label)

[m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
y_plot = m.*x_plot+b;
plot(x_plot, y_plot, 'k-')
title(['r= ' num2str(r,2)])
legend(sc_h, legend_names, 'location', 'southoutside', 'fontsize', 10, 'numcolumns', 2);

set(gca, 'fontsize', axis_font_size)

%%%%%%%%% plotting SST Amp vs. Winter month:
subplot(p_row,p_col,2);
hold on

% y axis variable choices
seas_amplitude = 1;
dissic_vert_gradient=0;
% sv2 = 1;
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
mon = 9;
dd = 12;

wmo_on = 0; % takes precedence over alt_x
if wmo_on==0
    sv = 9;
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
        if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
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
                    var_2 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;

                end
            end
            if isnan(var_1) || isnan(var_2)
                continue
            end

             sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
                'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
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
        x_label = [var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ') from month  ' num2str(mon)];
    else
        x_label = [variables{v} ' max divided by min'];
    end
end
xlabel( x_label, 'interpreter', 'none')
ylabel(comp_label)

[m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
y_plot = m.*x_plot+b;
plot(x_plot, y_plot, 'k-')
title(['r= ' num2str(r,2)])
legend(sc_h, legend_names, 'location', 'southoutside', 'fontsize', 10, 'numcolumns', 2);

set(gca, 'fontsize', axis_font_size)

%%%%%%%%% MLD Max/ Min
subplot(p_row,p_col,3);
hold on

% y axis variable choices
seas_amplitude = 1;
dissic_vert_gradient=0;
% sv2 = 1;
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
    sv = 9;
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
        if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
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
                    var_2 = max(CMIP.(variables{v}).out_seasonal(m,:,1)) - min(CMIP.(variables{v}).out_seasonal(m,:,1)) ;

                end
            end
            if isnan(var_1) || isnan(var_2)
                continue
            end

             sc_h(end+1) = plot(var_1,	var_2 , 'marker', model_marker, 'color', ...
                'k', 'markerfacecolor', plot_color','markersize', 12, 'linestyle', 'none');
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
        x_label = [var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ') from month  ' num2str(mon)];
    else
        x_label = [variables{v} ' max divided by min'];
    end
end
xlabel( x_label, 'interpreter', 'none')
ylabel(comp_label)

[m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
y_plot = m.*x_plot+b;
plot(x_plot, y_plot, 'k-')
title(['r= ' num2str(r,2)])
legend(sc_h, legend_names, 'location', 'southoutside', 'fontsize', 10, 'numcolumns', 2);

set(gca, 'fontsize', axis_font_size)


%%%%%% plotting Taylor RMS vs each other
subplot(p_row,p_col,4)
% now also do the other comparisons (i.e. correlation vs. correlation)
filter_on=0;
if filter_on==1
    disp('Warning, some results filtered from regression analysis')
end
% example spco2 match vs. intpp
tests = {'norm_error';'correlation' ; 'ratio'};
test_names = {'normalized error'; 'correlation' ; 'amplitude ratio'};
% legend_on=0;
group_color = 2;
set(gcf, 'colormap', turbo)
v3 = 4; % variable for harmonic fit scatter color

harm_comp = 'offset';

for sv = 9% [1 2 3 4 5 6 8 9 10] %1:length(seas_comp_vars)

    for tt = 3%:length(tests)
        for qq = 1% 1:length(tests)
            %             if strcmp(variables{v}, 'wmo') || strcmp(variables{v}, 'psl') || strcmp(variables{v}, 'dissic_yr') || strcmp(variables{v}, 'talk_yr') || strcmp(variables{v}, 'thetao')
            %                 continue
            %             end

            % find matching v
            v = find(strncmp(seas_comp_vars{sv}, variables, 4));
            if length(v)>1 % cludge since dissic and dissic_yr were getting confused
                v = strmatch(seas_comp_vars{sv}, variables, 'exact');
            end

            plot_index = 0;

%             plot_filename = ['Taylor ' seas_comp_vars{sv} ' ' tests{qq} ' vs. ' tests{tt} ' other vars_model_groups=' num2str(group_color) ' filter ' num2str(filter_on)];
%             if group_color==2
%                 plot_filename = ['Taylor ' seas_comp_vars{sv} ' ' tests{qq} ' vs. ' tests{tt} ' other vars_model_groups=' num2str(group_color) '_' variables{v3} '_' ...
%                     harm_comp ' filter ' num2str(filter_on)];
% 
%             end
            for sv2 = 4%[1 2 3 4 5 6 8 9 10]
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

%                 subplot(3,3,plot_index)

                hold on
%                 grid on

                temp_array = [];
                temp_color = [];
                sc_h = [];
                legend_names = {};

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
                                    %                                     mod_pco2_corr = obs.spco2.correlation(m);
                                    model_marker = color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),4};

                                    %                                     sc_h(end+1) = scatter(var_phase_shift_days, var_amp_per_diff, 90, mod_pco2_corr, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
                                    temp_name = cmip_names.(variables{v}){m};
                                    temp_name = strrep(temp_name, '_', '-');
                                    temp_name = strrep(temp_name, '-6', ' (6)');
                                    legend_names{end+1,1} = temp_name;
                                    %                                     disp([temp_name ' ' num2str(mod_pco2_corr)])


                                    harm_diff = harm_mod.(variables{v3}).(harm_comp)(mod_match_2) - harm.(variables{v3}).(harm_comp); % difference in phase between model and obs

                                    sc_h(end+1) = scatter(obs.(variables{v}).(tests{qq})(m), obs.(variables{v2}).(tests{tt})(mod_match), 100, harm_diff, 'filled', 'marker', model_marker, 'markeredgecolor', 'k');
                                    c1 = colorbar;
                                    temp_color(end+1) = harm_diff;
                                else
                                    plot(obs.(variables{v}).(tests{qq})(m), obs.(variables{v2}).(tests{tt})(mod_match), 'o', 'color', ...
                                        'k', 'markersize', 7)
                                end
                                
                                var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
                                ylabel(c1, ['Model ' var_plot_names{var_label_index,2} ' ' harm_comp])
                                
                            end
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

                var_label_index = strncmp(variables{v}, var_plot_names(:,1), 4);
                if sum(var_label_index>0)
                    xlabel( [var_plot_names{var_label_index,2} ' ' test_names{qq}], 'interpreter', 'none')
                else
                    xlabel( [variables{v} ' ' test_names{qq}], 'interpreter', 'none')
                end

                var_label_index = strncmp(variables{v2}, var_plot_names(:,1), 4);
                if sum(var_label_index>0)
                    ylabel([var_plot_names{var_label_index,2} ' ' test_names{tt}], 'interpreter', 'none')
                else
                    ylabel([variables{v2} ' ' test_names{tt}], 'interpreter', 'none')

                end
                if filter_on==1
                    temp_array(temp_array(:,1)>3,1)=nan;
                    temp_array = temp_array(~isnan(temp_array(:,1)),:);

                end

%                 [m,b,r,~,~]=lsqfitgm(temp_array(:,1),temp_array(:,2));
%                 x_plot = min(temp_array(:,1)):(max(temp_array(:,1))-min(temp_array(:,1)))./10 : max(temp_array(:,1));
%                 y_plot = m.*x_plot+b;
%                 plot(x_plot, y_plot, 'k-')
%                 if filter_on==0
%                     title(['r= ' num2str(r,2)])
%                 else
%                     title(['filt r= ' num2str(r,2)])
%                 end
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

            %             end
%             print(gcf, '-dpng', [Plot_out_dir variables{v} '/' plot_filename '_v8_test.png'])
        end
    end
end
legend(sc_h, legend_names, 'location', 'southoutside', 'fontsize', 10, 'numcolumns', 2);

set(gca, 'fontsize', axis_font_size)

%%%%%% DIC Amp vs. TOS Amp.
subplot(p_row,p_col,5);

hold on

% y axis variable choices
seas_amplitude = 1;
dissic_vert_gradient=0;
sv2 = 4; % 
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
    sv = 1;
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
        if ~isempty(color_model{strcmp(cmip_names.(variables{v}){m}, color_model(:,1)),3}) % skip models if they don't have a model group color - that would mean they don't have fgco2, so what's the point?
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
    elseif alt_x==2
        var_1_obs = max(obs.(variables{v}).out_seasonal(:,1)) - (min(obs.(variables{v}).out_seasonal(:,1)));

    end

    plot(var_1_obs, obs_y, 'xk', 'linewidth', 2, 'markersize', 10)
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
        x_label = [var_plot_names{var_label_index,2} ' (' var_plot_names{var_label_index,3} ') from month  ' num2str(mon)];
    elseif alt_x==2
        x_label = [var_plot_names{var_label_index,2} ' seasonal amplitude (' var_plot_names{var_label_index,3} ')'];

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
title(['r= ' num2str(r,2)])
legend(sc_h, legend_names, 'location', 'southoutside', 'fontsize', 10, 'numcolumns', 2);

set(gca, 'fontsize', axis_font_size)

annotation('textbox', [0.05, 0.05, 1, 0], 'String', plot_filename, 'EdgeColor', 'none', 'interpreter', 'none');

print(gcf, '-dpng', [fig_dir plot_filename '.png'])
