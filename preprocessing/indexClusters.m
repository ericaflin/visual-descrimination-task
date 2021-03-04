%% Select which clusters to use based on which were in areas of interest

function [index1,index2] = indexClusters(subjects,nsubj,NOI)

index1 = {};
index2 = {};
dataDir = 'D:/comp_neuro/';
addpath(dataDir);
for isubj = 1:nsubj
    %get brain regions
    t = readtable([dataDir,subjects{isubj},'channels.brainLocation.tsv'],'FileType', 'text', 'Delimiter', '\t');
    ontology = t.allen_ontology;
    %find regions of intterest
    node1 = find(strcmp(ontology,NOI{1}));
    node2 = find(strcmp(ontology,NOI{2}));
    %get channel ids for clusters
    cn = readNPY([dataDir,subjects{isubj},'clusters.peakChannel.npy']);
    %select which clusters are on channels of interest
    Tindex1 = [];
    for i = 1:length(node1)
        Tindex1 = [Tindex1;find(cn==node1(i))];
    end
    index1{isubj} = Tindex1;
    Tindex2 = [];
    for i = 1:length(node2)
        Tindex2 = [Tindex2;find(cn==node2(i))];
    end
    index2{isubj} = Tindex2;
end
