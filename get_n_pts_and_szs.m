function [npatients,median_nszs] = get_n_pts_and_szs(T)

patients = T.Patient;
ieegname = T.IEEGname;
type = T.stim;

unique_patients = unique(patients);
unique_patients(cellfun(@isempty,unique_patients)) = [];
npatients = length(unique_patients);
nszs = nan(npatients,1);

for i = 1:npatients
    curr_pt = unique_patients{i};
    curr_rows = contains(ieegname,curr_pt);

    % find spontaneous seizure for that patient
    nszs(i) = sum(type(curr_rows)==0);
end

median_nszs = median(nszs);

end