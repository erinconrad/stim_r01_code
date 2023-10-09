
%% CCEP power analysis
%{
I am doing this from looking at Eli's paper and looking at figure 5A (the
partial residuals of the N1 and N2 responses controlling for distance and
location) for in-SOZ vs out-SOZ. I am obtaining the estimate for
each patient for in and out and calculating the Cohen's d for a paired comparison of in vs
out across patients.
%}
%{
in_out_soz_n1 = [...
    2.4 2.7;... %HUP211
    1.1 1.15;... %213
    1.05 1.05;... %214
    1.8 1.85;... %218
    1.5 1.6;... %219
    1.5 1.5;... %220
    1.5 1.6;... %222
    1.5 1.6;... %223
    1.6 1.5;... %224
    1.7 1.8]; % 225

in_out_soz_n2 = [...
    1.9 2.1;... %HUP211
    1.0 1.0;... %213
    1.2 1.25;... %214
    1.6 1.55;... %218
    1.0 1.05;... %219
    1.1 1.15;... %220
    1.2 1.2;... %222
    1.5 1.5;... %223
    1.2 1.15;... %224
    1.2 1.3]; % 225
%}

Tn1 = readtable('CCEPvsSOZPartialResidualsMeanAcrossCCEPsN1.csv');
Tn2 = readtable('CCEPvsSOZPartialResidualsMeanAcrossCCEPsN2.csv');

inside_n1 = strcmp(Tn1.SOZ,'Inside');
outside_n1 = strcmp(Tn1.SOZ,'Outside');
inside_n2 = strcmp(Tn2.SOZ,'Inside');
outside_n2 = strcmp(Tn2.SOZ,'Outside');

in_out_soz_n1 = [Tn1.PartialResiduals(inside_n1),Tn1.PartialResiduals(outside_n1)];
in_out_soz_n2 = [Tn2.PartialResiduals(inside_n2),Tn2.PartialResiduals(outside_n2)];

%ensure theyre paired
assert(isequal(Tn1.Patient(inside_n1),Tn1.Patient(outside_n1)))
assert(isequal(Tn2.Patient(inside_n2),Tn2.Patient(outside_n2)))

[~,pn1] = ttest(in_out_soz_n1(:,1),in_out_soz_n1(:,2))
[~,pn2] = ttest(in_out_soz_n2(:,1),in_out_soz_n2(:,2))

dn1 = (mean(in_out_soz_n1(:,1))-mean(in_out_soz_n1(:,2)))/...
    std(in_out_soz_n1(:,1)-in_out_soz_n1(:,2))
n1_diff_means = mean(in_out_soz_n1(:,1))-mean(in_out_soz_n1(:,2))
n1_sd = std(in_out_soz_n1(:,1)-in_out_soz_n1(:,2))
dn2 = (mean(in_out_soz_n2(:,1))-mean(in_out_soz_n2(:,2)))/...
    std(in_out_soz_n2(:,1)-in_out_soz_n2(:,2))