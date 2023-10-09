%% This script finds how many patients with stim had different sampling frequencies

%{
The script pulls from a local copy of the Patient availability table, which
I need to update manually on the google drive in order to add more cceps
patients as they are done.
%}
clear

%% Load the pt availability table
T = readtable('Patient availability.xlsx','Sheet','All HUP patients with stim');

%% Get patient names
names = T.Var1;

%% Add path to ieeg toolbox and log in info
ieeg_folder = '/Users/erinconrad/Desktop/research/spike_locations/scripts/tools/ieeg-matlab-1.13.2';
ieeg_pw_file = '/Users/erinconrad/Desktop/research/spike_locations/scripts/tools/eri_ieeglogin.bin';
eeg_login = 'erinconr';
addpath(genpath(ieeg_folder))

%% Loop over patients and try to find them and get fs
npts = length(names);
all_fs = nan(npts,1);
for ip = 1:npts

    fprintf('\nDoing %s\n',names{ip});

    % Get base name
    base_ieeg_name = sprintf('%s_phaseII',names{ip});

    % Try to get ieeg file with just the base name
    ieeg_name = base_ieeg_name;

    try
        session = IEEGSession(ieeg_name,eeg_login,ieeg_pw_file);
    catch
            
        fprintf('\nDid not find %s, adding an appendage\n',ieeg_name);
        if exist('session','var') ~= 0
            session.delete;
        end

        ieeg_name = [base_ieeg_name,'_D01'];

        try
            session = IEEGSession(ieeg_name,eeg_login,ieeg_pw_file); 

        catch

            fprintf('\nDid not find %s, trying the ccep file\n',ieeg_name);
            if exist('session','var') ~= 0
                session.delete;
            end

            ieeg_name = strrep(base_ieeg_name,'_phaseII','_CCEP');
            session = IEEGSession(ieeg_name,eeg_login,ieeg_pw_file); % if this fails, fail it all

        end


    end

    fs = session.data.sampleRate;
    all_fs(ip) = fs;

    if exist('session','var') ~= 0
        session.delete;
    end

end