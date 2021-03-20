function [fanoFactor_stim,fanoFactor_goCue,fanoFactor_resp] = spike_train_variability(beh, spikes)
%Find the Fano Factor for MOs's spike count 
%50 ms before audio go-cue, 50 ms after stimulus,
%50 ms before visual go-cue, and 50 ms after go-cue,
%50 ms before response, and 50 ms after response.
%This is for subject 1.


fprintf("Find the Fano Factor of 50 ms before audio go-cue, 50 ms after audio go-cue, 50 ms before visual go-cue, and 50 ms after visual go-cue.")

subject1_beh = beh(17);
nunits = length(spikes.MOsTimes);
num_trials = length(subject1_beh.goCue);
startTime = -50;
endTime = 200;
window = 10;
startTime_windows = [startTime:window:endTime-window];
endTime_windows = [startTime+window:window:endTime];
nwindows = length(startTime_windows);
spikeCounts_stim = zeros([nunits,num_trials,nwindows]);
spikeCounts_cue = zeros([nunits,num_trials,nwindows]);
spikeCounts_resp = zeros([nunits,num_trials,nwindows]);

for iunit = 1:nunits
    unitTimes = spikes.MOsTimes{iunit};
    for trial_index = 1:num_trials
        stimTime = subject1_beh.stimTimes(trial_index);
        goCue = subject1_beh.goCue(trial_index);
        respTime = subject1_beh.respTimes(trial_index);
        for iwin = 1:nwindows
            spikeCounts_stim(iunit,trial_index,iwin) = sum(unitTimes-stimTime<endTime_windows(iwin) & unitTimes-stimTime>startTime_windows(iwin));
            spikeCounts_cue(iunit,trial_index,iwin) = sum(unitTimes-goCue<endTime_windows(iwin) & unitTimes-goCue>startTime_windows(iwin));
            spikeCounts_resp(iunit,trial_index,iwin) = sum(unitTimes-respTime<endTime_windows(iwin) & unitTimes-respTime>startTime_windows(iwin));
        end
    end
end

%convert to rate
spikeRates_stim = spikeCounts_stim./window;
spikeRates_cue = spikeCounts_cue./window;
spikeRates_resp = spikeCounts_resp./window;

%find fano factor of each neuron for each condition
leftTrial = find(beh(17).contrastLeft>beh(17).contrastRight);
rightTrial = find(beh(17).contrastLeft<beh(17).contrastRight);
neutralTrial = find(beh(17).contrastLeft==beh(17).contrastRight);
fanoFactor_stim(:,1,:) = var(spikeRates_stim(:,leftTrial,:),0,2)./mean(spikeRates_stim(:,leftTrial,:),2);
fanoFactor_stim(:,2,:) = var(spikeRates_stim(:,rightTrial,:),0,2)./mean(spikeRates_stim(:,rightTrial,:),2);
fanoFactor_stim(:,3,:) = var(spikeRates_stim(:,neutralTrial,:),0,2)./mean(spikeRates_stim(:,neutralTrial,:),2);
fanoFactor_goCue(:,1,:) = var(spikeRates_cue(:,leftTrial,:),0,2)./mean(spikeRates_cue(:,leftTrial,:),2);
fanoFactor_goCue(:,2,:) = var(spikeRates_cue(:,rightTrial,:),0,2)./mean(spikeRates_cue(:,rightTrial,:),2);
fanoFactor_goCue(:,3,:) = var(spikeRates_cue(:,neutralTrial,:),0,2)./mean(spikeRates_cue(:,neutralTrial,:),2);
fanoFactor_resp(:,1,:) = var(spikeRates_resp(:,leftTrial,:),0,2)./mean(spikeRates_resp(:,leftTrial,:),2);
fanoFactor_resp(:,2,:) = var(spikeRates_resp(:,rightTrial,:),0,2)./mean(spikeRates_resp(:,rightTrial,:),2);
fanoFactor_resp(:,3,:) = var(spikeRates_resp(:,neutralTrial,:),0,2)./mean(spikeRates_resp(:,neutralTrial,:),2); 

%get tuned neurons
tunedUnits_stim = find_tuned_neurons(spikeRates_stim,beh,1);
tunedUnits_goCue = find_tuned_neurons(spikeRates_cue,beh,1);
tunedUnits_resp = find_tuned_neurons(spikeRates_resp,beh,1);

% generate synthetic data to test pvalues
fakeFF_stim = synthData_generator(fanoFactor_stim);
fakeFF_goCue = synthData_generator(fanoFactor_goCue);
fakeFF_resp = synthData_generator(fanoFactor_resp);

%plot FF for each condition for example neuron
figure;
color1 = ['b';'r';'g'];
%plot fano factor in from -50 to 200 ms of stim time
subplot(3,1,1);
hold on;
for iunit = 1:1
    for i = 1:2
        plot([1:nwindows],squeeze(fanoFactor_stim(44,i,:)),'color',color1(i));
    end
end
legend({'left','right'});
xticks([1:5:nwindows]);
xticklabels([-50:50:200]);
title('fano factor in response to stimulus presentation - neuron 44');
xlabel('milliseconds after stimulus');
ylabel('fano factor');
p = pval(reshape(fanoFactor_stim(44,:,:),[numel(fanoFactor_stim(44,:,:)),1]),reshape(fakeFF_stim(44,:,:),[numel(fanoFactor_stim(44,:,:)),1]))

subplot(3,1,2);
hold on;
for iunit = 1:1
    for i = 1:2
        plot([1:nwindows],squeeze(fanoFactor_goCue(44,i,:)),'color',color1(i));
    end
end
legend({'left','right'});
xticks([1:5:nwindows]);
xticklabels([-50:50:200]);
xlabel('milliseconds after stimulus');
ylabel('fano factor');
title('fano factor in response to go cue presentation - neuron 44');
p = pval(reshape(fanoFactor_goCue(44,:,:),[numel(fanoFactor_goCue(44,:,:)),1]),reshape(fakeFF_goCue(44,:,:),[numel(fakeFF_goCue(44,:,:)),1]))

subplot(3,1,3);
hold on;
for iunit = 1:1
    for i = 1:2
        plot([1:nwindows],squeeze(fanoFactor_resp(44,i,:)),'color',color1(i));
    end
end
legend({'left','right'});
xticks([1:5:nwindows]);
xlabel('milliseconds after stimulus');
ylabel('fano factor');
xticklabels([-50:50:200]);
title('fano factor in response to response - neuron 44');
p = pval(reshape(fanoFactor_resp(44,:,:),[numel(fanoFactor_resp(44,:,:)),1]),reshape(fakeFF_resp(44,:,:),[numel(fanoFactor_resp(44,:,:)),1]))

%plot ff of each condition averaged across neurons
color2 = ['cyan','magenta'];
figure;
subplot(3,1,1);
hold on;
for i = 1:2
    plot([1:nwindows],mean(squeeze(fanoFactor_stim(tunedUnits_stim.stim==1,i,:)),1),'color',color1(i));
    plot([1:nwindows],mean(squeeze(fanoFactor_stim(tunedUnits_stim.stim==-1,i,:)),1),'color',color2(i));
end
legend({'left tuned-left stim','right tuned-left stim','left tuned-right stim','right tuned-right stim'});
xticks([1:5:nwindows]);
xticklabels([-50:50:200]);
xlabel('milliseconds after stimulus');
ylabel('fano factor');
title('fano factor in response to stimulus-averaged');
p = pval(reshape(fanoFactor_stim(tunedUnits_stim.index,:,:),[numel(fanoFactor_stim(tunedUnits_stim.index,:,:)),1]),reshape(fakeFF_stim(tunedUnits_stim.index,:,:),[numel(fanoFactor_stim(tunedUnits_stim.index,:,:)),1]))

subplot(3,1,2);
hold on;
for i = 1:2
    plot([1:nwindows],mean(squeeze(fanoFactor_goCue(tunedUnits_goCue.stim==1,i,:)),1),'color',color1(i));
    plot([1:nwindows],mean(squeeze(fanoFactor_goCue(tunedUnits_goCue.stim==-1,i,:)),1),'color',color2(i));
end
legend({'left tuned-left stim','right tuned-left stim','left tuned-right stim','right tuned-right stim'});
xticks([1:5:nwindows]);
xticklabels([-50:50:200]);
xlabel('milliseconds after stimulus');
ylabel('fano factor');
title('fano factor in response to go cue-averaged');
p = pval(reshape(fanoFactor_goCue(tunedUnits_goCue.index,:,:),[numel(fanoFactor_goCue(tunedUnits_goCue.index,:,:)),1]),reshape(fakeFF_goCue(tunedUnits_goCue.index,:,:),[numel(fanoFactor_goCue(tunedUnits_goCue.index,:,:)),1]))

subplot(3,1,3);
hold on;
for i = 1:2
    plot([1:nwindows],mean(squeeze(fanoFactor_resp(tunedUnits_resp.stim==1,i,:)),1),'color',color1(i));
    plot([1:nwindows],mean(squeeze(fanoFactor_resp(tunedUnits_resp.stim==-1,i,:)),1),'color',color2(i));
end
legend({'left tuned-left stim','right tuned-left stim','left tuned-right stim','right tuned-right stim'});
xticks([1:5:nwindows]);
xticklabels([-50:50:200]);
xlabel('milliseconds after stimulus');
ylabel('fano factor');
title('fano factor in response to response-averaged');
p = pval(reshape(fanoFactor_resp(tunedUnits_resp.index,:,:),[numel(fanoFactor_resp(tunedUnits_resp.index,:,:)),1]),reshape(fakeFF_resp(tunedUnits_resp.index,:,:),[numel(fanoFactor_resp(tunedUnits_resp.index,:,:)),1]))




% fake_data_before_stimulus = mean(num_spikes_before_stimulus)+std(num_spikes_before_stimulus)*randn(size(num_spikes_before_stimulus));
% fake_data_after_stimulus = mean(num_spikes_after_stimulus)+std(num_spikes_after_stimulus)*randn(size(num_spikes_after_stimulus));
% fake_data_before_goCue = mean(num_spikes_before_go_cue)+std(num_spikes_before_go_cue)*randn(size(num_spikes_before_go_cue));
% fake_data_after_goCue = mean(num_spikes_after_go_cue)+std(num_spikes_after_go_cue)*randn(size(num_spikes_after_go_cue));
% fake_data_before_resp = mean(num_spikes_before_response)+std(num_spikes_before_response)*randn(size(num_spikes_before_response));
% fake_data_after_resp = mean(num_spikes_after_response)+std(num_spikes_after_response)*randn(size(num_spikes_after_response));
% Fano Factors
% fprintf("MOs Fano Factor for spike count 50 ms before stimulus")
% var(num_spikes_before_stimulus) / mean(num_spikes_before_stimulus)
% p = pval(num_spikes_before_stimulus,fake_data_before_stimulus)
% fprintf("MOs Fano Factor for spike count 50 ms after stimulus")
% var(num_spikes_after_stimulus) / mean(num_spikes_after_stimulus)
% p = pval(num_spikes_after_stimulus,fake_data_after_stimulus)
% fprintf("MOs Fano Factor for spike count 50 ms before go cue")
% var(num_spikes_before_go_cue) / mean(num_spikes_before_go_cue)
% p = pval(num_spikes_before_go_cue,fake_data_before_goCue)
% fprintf("MOs Fano Factor for spike count 50 ms after go cue")
% var(num_spikes_after_go_cue) / mean(num_spikes_after_go_cue)
% p = pval(num_spikes_after_go_cue,fake_data_after_goCue)
% fprintf("MOs Fano Factor for spike count 50 ms before response")
% var(num_spikes_before_response) / mean(num_spikes_before_response)
% p = pval(num_spikes_before_response,fake_data_before_resp)
% fprintf("MOs Fano Factor for spike count 50 ms after response")
% var(num_spikes_after_response) / mean(num_spikes_after_response)
% p = pval(num_spikes_after_response,fake_data_after_resp)

% Interpretation
fprintf("Fano Factor of spike count in MOs is always higher " + ... 
    "(relatively higher spike count variability)" + ...
    "after stimulus / go cue / response than before.")
fprintf("\nFano Factor of spike count in MOs is lowest overall after response -- " + ...
    "there is relatively lower spike count variability after response.")

end

