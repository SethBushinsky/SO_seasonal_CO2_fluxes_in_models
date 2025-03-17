% Code for Lionel's request

%% 1. Run Carbon_mapped_product_analysis

%% 2. Isolate tropical Pacific from 1990-2019
years = C_input.years;
product_names = C_input.product_names;
run_names = C_input.run_names;
runs = C_input.runs;
% regions = C_input.regions;

year_min = 1990;
year_max = 2019;
y = 2;
p = 1;
r = 1;
% q = 1;

date_index = C_input.(product_names{p}).(years{y}).date_vec(:,1)>= year_min & ...
    C_input.(product_names{p}).(years{y}).date_vec(:,1)<= year_max ;

temp_selected = C_input.(product_names{p}).(years{y}).(runs{r})
%% 3. Calculate anomaly w/o removing trend



%% 3. Calculate trend

%% 4. Calculate anomaly relative to detrended