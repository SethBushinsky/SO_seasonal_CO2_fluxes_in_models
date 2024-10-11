% function distance=taylor_dist(correlation,amplitude_ratio,ind)
%
% construct a Taylor diagram from vectors of correlations and amplitude
% ratios
%
% The amplitude_ratio can be defined either
% as rms(y)/rms(x) or std(y)/std(x) and gives slightly
% different results depending on the size of the bias.
% NOTE that complex_corr uses std(x)/std(y)
%
% plots each point in polar coordinates (r,theta):
% 1) r = amplitude ratio of prediction to observation
% 2) theta = arccos(rho)
% array ind gives the symbol to use in plotting:
% 1 - dot
% 2 - circle
%
% returns the distance from correlation=1.0 and ratio=1.0,
% which is the rms error as a fraction of observation amplitude
%
% Suzanne Dickinson, March 2009
% Kathie Kelly, April 2009
%
function distance=taylor_dist_smb_for_manuscript(correlation,amplitude_ratio,~, names, color_model, cmap, legend_on, rms_cutoff_for_good, out_of_phase_corr_cutoff, max_rel_amp)


% filter inputs to remove anything without a correlation (will prevent
% names in the legend that aren't plotted)

corr_filt = correlation(~isnan(correlation));
ampl_filt = amplitude_ratio(~isnan(correlation));
names_filt = names(~isnan(correlation));

% plot diagram & compute distance
npts=length(corr_filt);
% compute theta, rr, normalized error (distance)
theta=acos(corr_filt);    % compute correlation angle
rr=ampl_filt;
xx=rr.*cos(theta);
yy=rr.*sin(theta);
distance=sqrt((xx-1).^2+yy.^2);


% % plot data points
%         if ind(j)==1
%         plot(xx,yy,'k.','Markersize',15);hold on
%         elseif ind(j)==2
%         plot(xx,yy,'ko','Markersize',6);hold on
%         end
%     end
% plot circles & axes
for j=0:2:max_rel_amp*4
    rr=j*0.25;
    for k=1:1800
        xc(k)=rr*cos((k/10)/180*pi);
        yc(k)=rr*sin((k/10)/180*pi);
    end
    plot(xc,yc,'k','linewidth',0.5);hold on
    if rr==1
        plot(xc,yc,'k','linewidth',2)
    end
end

axis([-max_rel_amp max_rel_amp 0 max_rel_amp]);
% axis('square');
set(gca,'xtick',[-6 -4  -2  -1  1  2 3 4 6])
set(gca,'ytick',[0.25 0.5 0.75 1 1.25])
set(gca,'yticklabel',[])
%
% % plot a partial circle for the "large mag, good phase" cutoff:
% clear xc yc
% for j=12
%     rr=j*0.25;
%     for k=1:1800
%         xc(k)=rr*cos((k/10)/180*pi);
%         yc(k)=rr*sin((k/10)/180*pi);
%
%         if cos(atan(yc(k)/xc(k)))<0.5 || xc(k) <0
%             xc(k) = nan;
%         end
%     end
%     plot(xc,yc,'b','linewidth',2);hold on
% %     if rr==1
% %         plot(xc,yc,'k','linewidth',2)
% %     end
% end



% plot radial lines for the correlation
rr=max_rel_amp;
% rhobin=[-.99 -.95 -.9 -.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.95 0.99];
% rhobin=[-.99 -.9:.2:.9 .99];
rhobin=[-.9:.1:.9];

thetabin=acos(rhobin);
xp=rr*cos(thetabin);
yp=rr*sin(thetabin);
for k=1:length(xp)
    plot([0 xp(k)],[0 yp(k)],'k--')
    if k>=10
        textstr=sprintf('%4.2f',rhobin(k));
    else
        textstr=sprintf('%3.1f',rhobin(k));
    end
    if abs(round(rhobin(k)*10)/10)==0.99 || abs(round(rhobin(k)*10)/10)==0.9 || abs(round(rhobin(k)*10)/10)==.5

        if rhobin(k)<0
            text(xp(k)*1.1,yp(k)*1.04,textstr, clipping='on') %+0.005*(1+abs(rhobin(k))) , +0.3*(1+rhobin(size(rhobin,2)-k+1))

        else

            text(xp(k)*1.04,yp(k)*1.04,textstr, clipping='on') %+0.005*(1+abs(rhobin(k))) , +0.3*(1+rhobin(size(rhobin,2)-k+1))
        end
        %         disp(textstr)
    end
end
% text(2,3.5,'Correlation','fontsize',14,'fontw','bold')
% xlabel('Relative Amplitude','fontsize',14,'fontw','bold')

if ~isempty(out_of_phase_corr_cutoff)
    % plot lines at correlation cutoffs
    rr=max_rel_amp;
    rhobin=[out_of_phase_corr_cutoff];
    thetabin=acos(rhobin);
    xp=rr*cos(thetabin);
    yp=rr*sin(thetabin);
    for k=1:length(xp)
        plot([0 xp(k)],[0 yp(k)],'b-', 'linewidth', 2)
        %     if k>=10
        %         textstr=sprintf('%4.2f',rhobin(k));
        %     else
        %         textstr=sprintf('%3.1f',rhobin(k));
        %     end
        %     text(xp(k)+0.005*(1+rhobin(k)),yp(k)+0.015*(1+rhobin(size(rhobin,2)-k+1)),textstr)
    end
end
% text(2,3.5,'Correlation','fontsize',14,'fontw','bold')
% xlabel('Relative Amplitude','fontsize',14,'fontw','bold')

% plot circle at perfection
plot(1,0,'ko','Markersize',8);box off
% set(gca, 'ycolor', 'white')
if ~isempty(rms_cutoff_for_good)
    % calculating xx and yy coord at a distance of 1 from correlation of 1, amplitude of 1.
    clear yc xc

    xc = NaN(1800,1);
    yc = NaN(1800,1);

    for k = 1:1800
        %         xc(k)=1*cos((k/10)/180*pi);

        yc(k) = rms_cutoff_for_good*sin((k/10)/180*pi);
        if k<=900
            xc(k) = 1 + (rms_cutoff_for_good.^2-yc(k).^2).^0.5;
        else
            xc(k) = 1 - ( rms_cutoff_for_good.^2- yc(k).^2).^0.5;
        end

    end
    plot(xc, yc, 'b--', 'linewidth', 2)
    % xc(901:1800) = xc(901:1800).*-1;
end

%

% large, bolder labels
% set(gca,'fontname','times','fontsize',14)

% plot data points
%     for j=1:npts
%         if ind(j)==1; p1 = plot(xx(j),yy(j),'r.','Markersize',25);end
%         if ind(j)==2; p2 = plot(xx(j),yy(j),'b.','Markersize',25);end
%         if ind(j)==3; p3 = plot(xx(j),yy(j),'g.','Markersize',25);end
%         if ind(j)==4; p4 = plot(xx(j),yy(j),'c.','Markersize',25);end
%         if ind(j)==5; p5 = plot(xx(j),yy(j),'m.','Markersize',25);end
%     end
p3 = NaN(size(xx,1),1);

for j=1:size(xx,1)
    p3(j) = plot(xx(j,:), yy(j,:),'marker', 'none', 'color', cmap(strmatch(names_filt{j}, color_model(:,1), 'exact'),:),'linewidth', 2);

    for k = 1:size(xx,2)
        if k==1
            marker_color = cmap(strmatch(names_filt{j}, color_model(:,1), 'exact'),:);
        else
            marker_color = 'none';
        end
        if k==1
%             p3(j) = plot(xx(j,k), yy(j,k), 'markersize', 10, 'color', [cmap(strmatch(names_filt{j}, color_model(:,1), 'exact'),:) .5], 'markerfacecolor', marker_color, 'linewidth', 2, ...
%                 'marker', color_model{strmatch(names_filt{j}, color_model(:,1), 'exact'),4});
         % sc1= scatter(xx(j,k), yy(j,k), 80, 'color', 'k', 'markerfacecolor', marker_color, 'linewidth', 2, 'markeredgecolor', marker_color,...
         %        'marker', color_model{strmatch(names_filt{j}, color_model(:,1), 'exact'),4}, 'MarkerFaceAlpha', 0.7, 'MarkerEdgeAlpha', 1);
         sc1= scatter(xx(j,k), yy(j,k), 80, 'markeredgecolor', 'k','markerfacecolor', marker_color,...
             'marker', color_model{strmatch(names_filt{j}, color_model(:,1), 'exact'),4},'MarkerFaceAlpha', 0.7, 'MarkerEdgeAlpha', 1);
        else
            plot(xx(j,k), yy(j,k), 'markersize', 10, 'color', 'k', 'markerfacecolor', marker_color, 'linewidth', 1,...
                'marker', color_model{strmatch(names_filt{j}, color_model(:,1), 'exact'),4});
%             sc1 = scatter(xx(j,k), yy(j,k), 40, 40, 'markersize', 10, 'color', [cmap(strmatch(names_filt{j}, color_model(:,1), 'exact'),:) .5], 'markerfacecolor', marker_color, 'linewidth', 2,...
%                 'marker', color_model{strmatch(names_filt{j}, color_model(:,1), 'exact'),4});

        end
    end

end
if legend_on==1
    legend(p3, names_filt, 'interpreter', 'none', 'location', 'northwest', 'fontsize', 9)
end
%     if npts==2,
%         legend([p1 p2], names_filt);
%     end
set(gca, 'YColor', 'none')

end

