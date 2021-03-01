%% script to load in the files for the final project
%output - beh - behavioral data for the project. Contains fields

function [beh,eye,neural] = loadData(subjects,nsubj)

beh = struct;
eye = struct;
neural = struct;

for isubj = 1:nsubj
    beh(isubj).goCue = readNPY(['/sorted_data/beh/times/',subjects{isubj},'trials.goCue_times.npy']);
    beh(isubj).respTimes = readNPY(['/sorted_data/beh/times/',subjects{isubj},'trials.response_times.npy']);
    beh(isubj).stimTimes = readNPY(['/sorted_data/beh/times/',subjects{isubj},'trials.visualStim_times.npy']);
    beh(isubj).contrastLeft = readNPY(['/sorted_data/beh/stimuli/',subjects{isubj},'trials.visualStim_contrastLeft.npy']);
    beh(isubj).contrastRight = readNPY(['/sorted_data/beh/stimuli/',subjects{isubj},'trials.visualStim_contrastRight.npy']);
    beh(isubj).resp = readNPY(['/sorted_data/beh/resp/',subjects{isubj},'trials.response_choice.npy']);
    beh(isubj).wheelMove = readNPY(['/sorted_data/beh/resp/',subjects{isubj},'wheelMoves.types.npy']);
    beh(isubj).wheelPos = readNPY(['/sorted_data/beh/resp/',subjects{isubj},'wheel.position.npy']);
    eye(isubj).area = readNPY(['/sorted_data/eye/',subjects{isubj},'eye.area.npy']);
    eye(isubj).xypos = readNPY(['/sorted_data/eye/',subjects{isubj},'eye.xypos.npy']);
    eye(isubj).times = readNPY(['/sorted_data/eye/',subjects{isubj},'eye.timestamps.npy']);
    neural(isubj).times = readNPY(['/sorted_data/neural/',subjects{isubj},'spikes.times.npy']);
    neural(isubj).spikes = readNPY(['/sorted_data/neural/',subjects{isubj},'spikes.clusters.npy']);
end