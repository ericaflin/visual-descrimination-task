function [] = encoding_response_time(beh, spikes)
%Response time to left stimuli 
%encoded by left-tuned neuron spike rate 
%50 ms before audio go-cue, 50 ms after stimulus,
%50 ms before visual go-cue, and 50 ms after go-cue,
%50 ms before response, and 50 ms after response.
%This is for subject 1.

fprintf("Response time to left stimuli encoded by left-tuned MOs neuron spike rate " + ...
    "50 ms before audio go-cue, 50 ms after stimulus " + ...
    "50 ms before visual go-cue, and 50 ms after go-cue " + ...
    "50 ms before response, and 50 ms after response.")

% Get tuned neurons
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
    unitTimes = spikes.MOsTimes(iunit);
    for trial_index = 1:num_trials
        stimTime = subject1_beh.stimTimes(trial_index);
        goCue = subject1_beh.goCue(trial_index);
        respTime = subject1_beh.respTimes(trial_index);
        for iwin = 1:nwindows
            spikeCounts_stim(iunit,trial_index,iwin) = sum(spikes.MOsTimes{iunit}-stimTime<endTime_windows(iwin) & spikes.MOsTimes{iunit}-stimTime>startTime_windows(iwin));
            spikeCounts_cue(iunit,trial_index,iwin) = sum(spikes.MOsTimes{iunit}-goCue<endTime_windows(iwin) & spikes.MOsTimes{iunit}-goCue>startTime_windows(iwin));
            spikeCounts_resp(iunit,trial_index,iwin) = sum(spikes.MOsTimes{iunit}-respTime<endTime_windows(iwin) & spikes.MOsTimes{iunit}-respTime>startTime_windows(iwin));
        end
    end
end
leftTrial = find(beh(17).contrastLeft>beh(17).contrastRight);
tunedUnits_stim = find_tuned_neurons(spikeCounts_stim,beh,2);
tunedUnits_cue = find_tuned_neurons(spikeCounts_cue,beh,2);
tunedUnits_resp = find_tuned_neurons(spikeCounts_resp,beh,2);

% MOs, 50 ms before stimulus
num_spikes_before_stimulus = 0;
for trial_index = 1:length(leftTrial)
    stim_time = subject1_beh.stimTimes(trial_index);
    num_spikes = length(tunedUnits_stim(tunedUnits_stim >= stim_time - 0.050 & tunedUnits_stim <= stim_time));
    num_spikes_before_stimulus = [num_spikes_before_stimulus ; num_spikes];
end
spike_rates_before_stimulus = num_spikes_before_stimulus(2:end) / 0.050; % spikes / s

% MOs, 50 ms after stimulus
num_spikes_after_stimulus = 0;
for trial_index = 1:length(leftTrial)
    stim_time = subject1_beh.stimTimes(trial_index);
    num_spikes = length(tunedUnits_stim(tunedUnits_stim >= stim_time & tunedUnits_stim <= stim_time + 0.050));
    num_spikes_after_stimulus = [num_spikes_after_stimulus ; num_spikes];
end
spike_rates_after_stimulus = num_spikes_after_stimulus(2:end) / 0.050; % spikes / s

% MOs, 50 ms before go cue
num_spikes_before_go_cue = 0;
for trial_index = 1:length(leftTrial)
    stim_time = subject1_beh.goCue(trial_index);
    num_spikes = length(tunedUnits_cue(tunedUnits_cue >= stim_time - 0.050 & tunedUnits_cue <= stim_time));
    num_spikes_before_go_cue = [num_spikes_before_go_cue ; num_spikes];
end
spike_rates_before_go_cue = num_spikes_before_go_cue(2:end) / 0.050; % spikes / s

% MOs, 50 ms after go cue
num_spikes_after_go_cue = 0;
for trial_index = 1:length(leftTrial)
    stim_time = subject1_beh.goCue(trial_index);
    num_spikes = length(tunedUnits_cue(tunedUnits_cue >= stim_time & tunedUnits_cue <= stim_time + 0.050));
    num_spikes_after_go_cue = [num_spikes_after_go_cue ; num_spikes];
end
spike_rates_after_go_cue = num_spikes_after_go_cue(2:end) / 0.050; % spikes / s

% MOs, 50 ms before response
num_spikes_before_response = 0;
for trial_index = 1:length(leftTrial)
    stim_time = subject1_beh.respTimes(trial_index);
    num_spikes = length(tunedUnits_resp(tunedUnits_resp >= stim_time - 0.050 & tunedUnits_resp <= stim_time));
    num_spikes_before_response = [num_spikes_before_response ; num_spikes];
end
spike_rates_before_response = num_spikes_before_response(2:end) / 0.050; % spikes / s

% MOs, 50 ms after response
num_spikes_after_response = 0;
for trial_index = 1:length(leftTrial)
    stim_time = subject1_beh.respTimes(trial_index);
    num_spikes = length(tunedUnits_resp(tunedUnits_resp >= stim_time & tunedUnits_resp <= stim_time + 0.050));
    num_spikes_after_response = [num_spikes_after_response ; num_spikes];
end
spike_rates_after_response = num_spikes_after_response(2:end) / 0.050; % spikes / s

% Linear regression
response_times = subject1_beh.respTimes - subject1_beh.stimTimes;
left_response_times = response_times(leftTrial)
predictors = horzcat(spike_rates_before_stimulus, spike_rates_after_stimulus, spike_rates_before_go_cue, spike_rates_after_go_cue, spike_rates_before_response, spike_rates_after_response)
mdl = fitlm(predictors, left_response_times);
model_coeffs = mdl.Coefficients
model_summary = anova(mdl,'summary')

% Interpretation
fprintf("The model is not a great fit. The P-values are high.")
end

