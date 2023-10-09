%% bootstrap estimate of power for Aim 2
%{
Null hypothesis: stim seizures are different from spontaneous seizures
Alt hypothesis: stim seizures are drawn from same distribution as
spontaneous seizures

Assume I can measure a metric for any seizure. Assume the metric follows a
normal distribution with a std of 1. Assume the mean for the metric for
spontaneous seizures is 0, and the mean for stim seizures could be 0 (alt
hypothesis) or non-zero (null hypothesis)
%}


clear
close all

%% Parameters
nb = 1e3; % number bootstrap iterations
delta = 1; % minimal effect size to declare significant difference between stim and spontaneous (note this is large!)
obs_delta = 0; % Assume this is the observed effect size - assume I find no difference between the stim and spontaneous seizures
alpha = 0.05;

% Load the stim seizure information file
T = readtable('../data/stim_seizure_information.xlsx');

% get n patients and n szs per patient
[n_patients,n_sz_per_pt] = get_n_pts_and_szs(T); % 32 and 8, respectively

% re-derive the mean for the stim seizures given delta
stim_mean = delta; % z = (stim-mean(spon))/std(spon)
stim_mean_actual = obs_delta;

% first, loop over potential STUDIES I would do
one_p_all = nan(nb,1);

for ib = 1:nb

    % Make fake observed data
    spon_obs = randn(n_patients,n_sz_per_pt); % observed spontaneous
    stim_obs = randn(n_patients,1)+stim_mean_actual; % observed stim
    
    spon_mean = mean(spon_obs,2);
    spon_std = std(spon_obs,[],2);
    
    % get abs z score representing abs difference between stim and
    % spontaeous seizures (one for each patient)
    z_abs_obs = abs((stim_obs-spon_mean)./spon_std);
    
    % now generate distribution you would see under null model
    z_abs_null = nan(nb,n_patients);
    
    for jb = 1:nb
            
        stim_null = randn(n_patients,1)+stim_mean; % null stim

        % calculate the abs z score for each stim seizure
        z_abs_null(jb,:) = abs((stim_null-spon_mean)./spon_std);
    
    end
    
    % Take average across patients
    z_abs_avg_null = mean(z_abs_null,2);
    z_abs_avg_obs = mean(z_abs_obs);
    
    % one sided p value
    one_p = (sum(z_abs_avg_null <= z_abs_avg_obs)+1)/(nb+1);
    one_p_all(ib) = one_p;
    
    % plot
    if 0
        figure
        plot(sort(z_abs_avg_null),'o')
        hold on
        plot(xlim,[z_abs_avg_obs z_abs_avg_obs])
        legend({'Null','Observed'})
        title(sprintf('one-sided p = %1.3f',one_p))
        xlabel('Bootstrap iterations')
        ylabel('|z|')
        pause
        close gcf
    end

end

% I think I need to multiply the p-value by 2 to make this a two-sided
% p-value, because the metric could be higher or lower.
two_p_all = one_p_all * 2;

% Power is the proportion of studies in which I would find a significant
% result
power = (sum(two_p_all<alpha))/nb;

figure
plot(sort(two_p_all),'o')
hold on
plot(xlim,[alpha alpha])
title(sprintf('Power = %1.2f',power))
xlabel('Bootstrap iterations')
ylabel('One-sided p-value')

