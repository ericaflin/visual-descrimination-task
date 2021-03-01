%% Determine number and id of sessions
%input - string projDir - path to the master directory for the project
%ouput - string subjects - cell array of subject identifier strings
%      - int nsubj - number of subjects

function [subjects,nsubj] = getSubjectNames(projDir)

dinfo = dir(strcat(projDir,'/sorted_data/neural/','nicklab*.*'));
names = {dinfo.name};
nsubj = length(names)/2;
subjects = {};

for isubj = 1:nsubj
    subj = extractBefore(names{((isubj-1)*2)+1},'spikes');
    subjects{isubj} = subj;
end
