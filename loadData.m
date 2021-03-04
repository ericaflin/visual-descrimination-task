%% script to load in the files for the final project
%output - beh - behavioral data for the project. Contains fields

function [beh,eye] = loadData(subjects,nsubj,projDir)

npy_path = [pwd,'/npy-matlab-master/npy-matlab'];
addpath(npy_path);

beh = struct;
eye = struct;

for isubj = 1:nsubj
    beh(isubj).goCue = readNPY([projDir,'/sorted_data/beh/times/',subjects{isubj},'trials.goCue_times.npy']);
    beh(isubj).respTimes = readNPY([projDir,'/sorted_data/beh/times/',subjects{isubj},'trials.response_times.npy']);
    beh(isubj).stimTimes = readNPY([projDir,'/sorted_data/beh/times/',subjects{isubj},'trials.visualStim_times.npy']);
    beh(isubj).contrastLeft = readNPY([projDir,'/sorted_data/beh/stimuli/',subjects{isubj},'trials.visualStim_contrastLeft.npy']);
    beh(isubj).contrastRight = readNPY([projDir,'/sorted_data/beh/stimuli/',subjects{isubj},'trials.visualStim_contrastRight.npy']);
    beh(isubj).resp = readNPY([projDir,'/sorted_data/beh/resp/',subjects{isubj},'trials.response_choice.npy']);
    beh(isubj).wheelMove = readNPY([projDir,'/sorted_data/beh/resp/',subjects{isubj},'wheelMoves.type.npy']);
    beh(isubj).wheelPos = readNPY([projDir,'/sorted_data/beh/resp/',subjects{isubj},'wheel.position.npy']);
    beh(isubj).wheelTime = readNPY([projDir,'/sorted_data/beh/resp/',subjects{isubj},'wheel.timestamps.npy']);
    eye(isubj).area = readNPY([projDir,'/sorted_data/eye/',subjects{isubj},'eye.area.npy']);
    eye(isubj).xypos = readNPY([projDir,'/sorted_data/eye/',subjects{isubj},'eye.xypos.npy']);
    eye(isubj).times = readNPY([projDir,'/sorted_data/eye/',subjects{isubj},'eye.timestamps.npy']);
end

rmpath(npy_path);
