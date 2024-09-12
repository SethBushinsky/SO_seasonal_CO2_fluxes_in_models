function [CI_slope_95, CI_y_hat_95, R_2, significant] = Sokal_Rohlf_regression_significance(X, Y)
% from Sokal, R. R., and F. J. Rohlf. 2003. Biometry, Third Edit. W. H. Freeman and Company.
% Chapter 14, Table 14.1, Box 14.1, Box 14.3, etc..
% SMB - January 26, 2016
% updated, September 11, 2024

% calculate the sum of the square differences in x (days since start of the
% deployment 
% X = dates(fit_index_avg);
% Y = Air_comparison.Upper_Optode.air_averages.filter_percent_diff((fit_index_avg),1);

%averages
X_bar = mean(X);
Y_bar = mean(Y);

% difference from mean
x_small = X - X_bar;
y_small = Y - Y_bar;

% sum of the square differences in x
sum_x_2 = sum(x_small.^2);

% multiple the differences from mean to get x_y
x_y = x_small.*y_small;


sum_x_y = sum(x_y);

% regression coefficient b_y_x (slope of the regression)
b_y_x = sum_x_y./sum_x_2;


% Y - intercept 
a = Y_bar - b_y_x.*X_bar;

% predicted Y based on regression
Y_hat = b_y_x.*X + a;

% explained variance:
sum_y_small_hat2 = sum((Y_hat - Y_bar).^2);

% total variance
sum_y_small2 = sum((Y - Y_bar).^2);

% coefficient of determination:
R_2 = sum_y_small_hat2/sum_y_small2;

% unexplained sum of squares:
d_2_y_x = sum((Y - Y_hat).^2);

% unexplained variance:
dof = (length(Y) - 2);
s_2_y_x = d_2_y_x./dof;

% standard error of the regression coefficient
sb = (s_2_y_x./sum_x_2).^.5;

% is the regression significantly different from zero?
t_s = (b_y_x - 0)/sb;

% confidence limits for the regression coefficient. 
% 95% limit, assuming 60 degrees of freedom.  Similar to Table B of Rohlf
% and Sokal, but using matlab t lookup table
alpha = .05;
alphaup = 1-alpha./2;
t_95per = tinv(alphaup,dof);

% if the absolute value of t_s is greater than t_95per, then the regression
% is significant at a 95% level. 
if abs(t_s)>t_95per
    significant = 1;
else
    significant = 0;
end

CI_b_y_x_95(1) =b_y_x - t_95per.*sb;
CI_b_y_x_95(2) =b_y_x + t_95per.*sb;
CI_slope_95 = CI_b_y_x_95;

% alpha = .32;
% alphaup = 1-alpha./2;
% t_68per = tinv(alphaup,dof);
% 
% CI_b_y_x_68(1) =b_y_x - t_68per.*sb;
% CI_b_y_x_68(2) =b_y_x + t_68per.*sb;
% CI_slope_68 = CI_b_y_x_68;

% standard error of Y_hat for a given value of X (every value)
s_y_hat = (s_2_y_x.*(1/length(Y) + ((X-X_bar).^2)./sum_x_2)).^0.5;

CI_y_hat_95 = NaN(length(Y),2);
CI_y_hat_95(:,1) = Y_hat - t_95per.*s_y_hat;
CI_y_hat_95(:,2) = Y_hat + t_95per.*s_y_hat;

% CI_y_hat_68 = NaN(length(Y),2);
% CI_y_hat_68(:,1) = Y_hat - t_68per.*s_y_hat;
% CI_y_hat_68(:,2) = Y_hat + t_68per.*s_y_hat;

end