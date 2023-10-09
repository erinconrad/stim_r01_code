
%{
Wieser, H. G., et al. "Comparative value of spontaneous and chemically
and electrically induced seizures in establishing the lateralization of 
temporal lobe seizures." Epilepsia 20.1 (1979): 47-59.

- Looked at 133 patients with TLE who underwent bilateral SEEG.
- Variable stim parameters, but used bipolar stim. 
- Underwent bilateral symmetric electrical sitm
- 39 patients who had both a spontaneous seizure and electrically induced
seiuzre
- Of these, 77% concordant laterality, 13% discordant, 10% unclear
- I think it is reasonable to exclude the unclear patients

- They unfortunately don't report how many left and how many right. They
note that no spontaneous seizures were bilateral. Looking at their
pre-implant designations of seizure laterality, it was 55% right and 45%
left. I think this justifies assuming 50/50.

https://www.ncss.com/wp-content/themes/ncss/pdf/Procedures/PASS/Fishers_Exact_Test_for_Two_Proportions.pdf

%}

%% Numbers from paper
n_total = 39;
perc_unclear = 0.1;
perc_discordant = 0.13;
perc_concordant = 0.77;
perc_left = 0.5; % assumption!

%% Math to get numbers in each category
n_unclear = round(n_total*perc_unclear);
n_discordant = round(n_total*perc_discordant);
n_concordant = round(n_total*perc_concordant);
n_remaining = n_total - n_unclear;
assert(n_discordant+n_concordant == n_remaining)

%% Build 2x2 table
n_spont_left_stim_left = round(n_concordant*perc_left);
n_spont_left_stim_right = round(n_discordant*perc_left);
n_spont_right_stim_left = round(n_discordant*(1-perc_left));
n_spont_right_stim_right = round(n_concordant*(1-perc_left));
T = [n_spont_left_stim_left,n_spont_left_stim_right;...
    n_spont_right_stim_left,n_spont_right_stim_right];
OR = T(1,1)*T(2,2)/((T(1,2)*T(2,1)));

%% Estimate binomial proportions
p1 = T(1,1)/(T(1,1)+T(1,2));
p2 = T(2,1)/(T(2,2)+T(2,2));

%{ 
 When I put these into power.fisher.test in r, I find that sample sizes of
 8 and 8 (8 patients with Left SOZ and 8 with Right SOZ), I get an 80%
 power to detect this effect size, assuming alpha = 0.05

How many patients can I reasonably expect?

Looks like we started doing mostly stereo with HUP127, November 2016. Going
5 years out, this would take us up to Nov 2021, or HUP226. There are 57
between hUP127 and HUP224, which is as far as I processed. HUP225 did not
have bilateral MT, but HUP226 did. So 58 over 5 years. 11.6/year. 23 in 2
years. However, 37% of these were bilateral. So only 14.5 unilateral in 2
years.......this would be underpowered.

Ok what if I only look at 2018 and 2019 (the last two normal years, 
assuming 2020 and 2021 screwed up due to COVID). This gives me HUP159-199 
+ 2 stragglers (HUP140 and 143). 
Then I get 29 bilateral MT implants, 9 of whom had bilateral SOZ (31%). 
So then I can estimate 20 unilateral patients with bilateral MT implants, 
which gets 90% power.

%}

