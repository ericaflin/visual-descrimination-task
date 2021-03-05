function [] = spike_train_variability(beh, spikes)
%Find the Fano Factor for MOs's spike count 
%50 ms before audio go-cue, 50 ms after stimulus,
%50 ms before visual go-cue, and 50 ms after go-cue,
%50 ms before response, and 50 ms after response.
%This is for subject 1.


fprintf("Find the Fano Factor of 50 ms before audio go-cue, 50 ms after audio go-cue, 50 ms before visual go-cue, and 50 ms after visual go-cue.")

subject1_beh = beh(1);
subject1_spikes_MOs = spikes(1).MOsTimes;

% MOs, 50 ms before stimulus
num_trials = 214;
num_spikes_before_stimulus = 0;
for trial_index = 1:num_trials
    stim_time = subject1_beh.stimTimes(trial_index);
    num_spikes = subject1_spikes_MOs(subject1_spikes_MOs >= stim_time - 0.050 & subject1_spikes_MOs <= stim_time);
    num_spikes_before_stimulus = [num_spikes_before_stimulus ; num_spikes];
end

% MOs, 50 ms after stimulus
num_trials = 214;
num_spikes_after_stimulus = 0;
for trial_index = 1:num_trials
    stim_time = subject1_beh.stimTimes(trial_index);
    num_spikes = subject1_spikes_MOs(subject1_spikes_MOs >= stim_time & subject1_spikes_MOs <= stim_time + 0.050);
    num_spikes_after_stimulus = [num_spikes_after_stimulus ; num_spikes];
end

% MOs, 50 ms before go cue
num_trials = 214;
num_spikes_before_go_cue = 0;
for trial_index = 1:num_trials
    stim_time = subject1_beh.goCue(trial_index);
    num_spikes = subject1_spikes_MOs(subject1_spikes_MOs >= stim_time - 0.050 & subject1_spikes_MOs <= stim_time);
    num_spikes_before_go_cue = [num_spikes_before_go_cue ; num_spikes];
end

% MOs, 50 ms after go cue
num_trials = 214;
num_spikes_after_go_cue = 0;
for trial_index = 1:num_trials
    stim_time = subject1_beh.goCue(trial_index);
    num_spikes = subject1_spikes_MOs(subject1_spikes_MOs >= stim_time & subject1_spikes_MOs <= stim_time + 0.050);
    num_spikes_after_go_cue = [num_spikes_after_go_cue ; num_spikes];
end

% MOs, 50 ms before response
num_trials = 214;
num_spikes_before_response = 0;
for trial_index = 1:num_trials
    stim_time = subject1_beh.respTimes(trial_index);
    num_spikes = subject1_spikes_MOs(subject1_spikes_MOs >= stim_time - 0.050 & subject1_spikes_MOs <= stim_time);
    num_spikes_before_response = [num_spikes_before_response ; num_spikes];
end

% MOs, 50 ms after response
num_trials = 214;
num_spikes_after_response = 0;
for trial_index = 1:num_trials
    stim_time = subject1_beh.respTimes(trial_index);
    num_spikes = subject1_spikes_MOs(subject1_spikes_MOs >= stim_time & subject1_spikes_MOs <= stim_time + 0.050);
    num_spikes_after_response = [num_spikes_after_response ; num_spikes];
end

% Fano Factors
fprintf("MOs Fano Factor for spike count 50 ms before stimulus")
var(num_spikes_before_stimulus) / mean(num_spikes_before_stimulus)
fprintf("MOs Fano Factor for spike count 50 ms after stimulus")
var(num_spikes_after_stimulus) / mean(num_spikes_after_stimulus)
fprintf("MOs Fano Factor for spike count 50 ms before go cue")
var(num_spikes_before_stimulus) / mean(num_spikes_before_go_cue)
fprintf("MOs Fano Factor for spike count 50 ms after go cue")
var(num_spikes_after_stimulus) / mean(num_spikes_after_go_cue)
fprintf("MOs Fano Factor for spike count 50 ms before response")
var(num_spikes_before_stimulus) / mean(num_spikes_before_response)
fprintf("MOs Fano Factor for spike count 50 ms after response")
var(num_spikes_after_stimulus) / mean(num_spikes_after_response)

% Interpretation
fprintf("Fano Factor of spike count in MOs is always higher " + ... 
    "(relatively higher spike count variability)" + ...
    "after stimulus / go cue / response than before.")
fprintf("\nFano Factor of spike count in MOs is lowest overall after response -- " + ...
    "there is relatively lower spike count variability after response.")

end

