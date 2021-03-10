function [] = encoding_response_time(beh, spikes)
% Linear regression for response time on MOs spike rate
%50 ms before audio go-cue, 50 ms after stimulus,
%50 ms before visual go-cue, and 50 ms after go-cue,
%50 ms before response, and 50 ms after response.
%This is for subject 1.

fprintf("Linear regression for response time on MOs spike rate " + ...
    "50 ms before audio go-cue, 50 ms after stimulus " + ...
    "50 ms before visual go-cue, and 50 ms after go-cue " + ...
    "50 ms before response, and 50 ms after response.")

subject1_beh = beh(17);
subject1_spikes_MOs = spikes(17).MOsTimes;

% MOs, 50 ms before stimulus
num_trials = length(subject1_beh.goCue);
num_spikes_before_stimulus = 0;
for trial_index = 1:num_trials
    stim_time = subject1_beh.stimTimes(trial_index);
    num_spikes = length(subject1_spikes_MOs(subject1_spikes_MOs >= stim_time - 0.050 & subject1_spikes_MOs <= stim_time));
    num_spikes_before_stimulus = [num_spikes_before_stimulus ; num_spikes];
end
spike_rates_before_stimulus = num_spikes_before_stimulus(2:end) / 0.050; % spikes / s

% MOs, 50 ms after stimulus
num_spikes_after_stimulus = 0;
for trial_index = 1:num_trials
    stim_time = subject1_beh.stimTimes(trial_index);
    num_spikes = length(subject1_spikes_MOs(subject1_spikes_MOs >= stim_time & subject1_spikes_MOs <= stim_time + 0.050));
    num_spikes_after_stimulus = [num_spikes_after_stimulus ; num_spikes];
end
spike_rates_after_stimulus = num_spikes_after_stimulus(2:end) / 0.050; % spikes / s

% MOs, 50 ms before go cue
num_spikes_before_go_cue = 0;
for trial_index = 1:num_trials
    stim_time = subject1_beh.goCue(trial_index);
    num_spikes = length(subject1_spikes_MOs(subject1_spikes_MOs >= stim_time - 0.050 & subject1_spikes_MOs <= stim_time));
    num_spikes_before_go_cue = [num_spikes_before_go_cue ; num_spikes];
end
spike_rates_before_go_cue = num_spikes_before_go_cue(2:end) / 0.050; % spikes / s

% MOs, 50 ms after go cue
num_spikes_after_go_cue = 0;
for trial_index = 1:num_trials
    stim_time = subject1_beh.goCue(trial_index);
    num_spikes = length(subject1_spikes_MOs(subject1_spikes_MOs >= stim_time & subject1_spikes_MOs <= stim_time + 0.050));
    num_spikes_after_go_cue = [num_spikes_after_go_cue ; num_spikes];
end
spike_rates_after_go_cue = num_spikes_after_go_cue(2:end) / 0.050; % spikes / s

% MOs, 50 ms before response
num_spikes_before_response = 0;
for trial_index = 1:num_trials
    stim_time = subject1_beh.respTimes(trial_index);
    num_spikes = length(subject1_spikes_MOs(subject1_spikes_MOs >= stim_time - 0.050 & subject1_spikes_MOs <= stim_time));
    num_spikes_before_response = [num_spikes_before_response ; num_spikes];
end
spike_rates_before_response = num_spikes_before_response(2:end) / 0.050; % spikes / s

% MOs, 50 ms after response
num_spikes_after_response = 0;
for trial_index = 1:num_trials
    stim_time = subject1_beh.respTimes(trial_index);
    num_spikes = length(subject1_spikes_MOs(subject1_spikes_MOs >= stim_time & subject1_spikes_MOs <= stim_time + 0.050));
    num_spikes_after_response = [num_spikes_after_response ; num_spikes];
end
spike_rates_after_response = num_spikes_after_response(2:end) / 0.050; % spikes / s

% Linear regression
response_times = subject1_beh.respTimes - subject1_beh.stimTimes;
predictors = horzcat(spike_rates_before_stimulus, spike_rates_after_stimulus, spike_rates_before_go_cue, spike_rates_after_go_cue, spike_rates_before_response, spike_rates_after_response);
mdl = fitlm(predictors, response_times);
model_coeffs = mdl.Coefficients
model_summary = anova(mdl,'summary')

% Interpretation
fprintf("The model has quite a low p-value (0.02).")
fprintf("The coefficients all have a high p-value, except for that of the spike rate of MOs prior to response (p = 0.005).")
fprintf("The coefficient for spike rate prior to response is -0.0013, which tells us that a higher MOs spike rate prior to response corresponds very slightly to a lower response time.")

end

