function [] = isi_subject1_contrast(beh, spikes)
%RASTER Provide ISI for subject 1's visual neurons
%       -0.1 to 0.5 s relative to stimuli times to difference in left/right contrast 
%       (high for difference of 1, medium for difference of 0.5,
%       no contrast for difference of 0)

fprintf("VISp neuron activity during stimulus of high, medium, and no difference between right and left:")

subject1_beh = beh(1);
subject1_spikes = spikes(1).VISpTimes;

% VISp response to high difference (1) between left and right contrasts
high_diff_trial_indices = find(abs(subject1_beh.contrastLeft - subject1_beh.contrastRight) == 1);
num_high_diff_trials = length(high_diff_trial_indices);
interspike_intervals_pooled = [];
for cur_array_idx = 1:num_high_diff_trials
    trial_index = high_diff_trial_indices(cur_array_idx);
    stim_time = subject1_beh.stimTimes(trial_index);
    spikes_s = subject1_spikes(subject1_spikes >= stim_time - 0.1 & subject1_spikes <= stim_time + 0.5);
    spikes_s = spikes_s - stim_time; % Align data to stim_time
    spikes_ms = spikes_s * 1000;
    interspike_intervals_ms = diff(spikes_ms);
    interspike_intervals_pooled = [interspike_intervals_pooled; interspike_intervals_ms];
end

interspike_intervals_pooled = interspike_intervals_pooled(interspike_intervals_pooled > 0);
figure
title({'VISp neuron activity at -100ms to 500ms]', 'relative to high contrast stimuli time (for subject 1)'},'fontsize',18)
xlabel('ISI time (ms)','FontSize',14)
ylabel('Frequency (Normalized proportion)','FontSize',14)
hold on 
histogram(interspike_intervals_pooled,'Normalization','probability');   
hold off
print('contrastHigh_ISI','-dpng');

% VISp response to medium difference (0.5) between left and right contrasts
medium_diff_trial_indices = find(abs(subject1_beh.contrastLeft - subject1_beh.contrastRight) == 0.5);
num_medium_diff_trials = length(medium_diff_trial_indices);
interspike_intervals_pooled = [];
for cur_array_idx = 1:num_medium_diff_trials
    trial_index = medium_diff_trial_indices(cur_array_idx);
    stim_time = subject1_beh.stimTimes(trial_index);
    spikes_s = subject1_spikes(subject1_spikes >= stim_time - 0.1 & subject1_spikes <= stim_time + 0.5);
    spikes_s = spikes_s - stim_time; % Align data to stim_time
    spikes_ms = spikes_s * 1000;
    interspike_intervals_ms = diff(spikes_ms);
    interspike_intervals_pooled = [interspike_intervals_pooled; interspike_intervals_ms];
end
interspike_intervals_pooled = interspike_intervals_pooled(interspike_intervals_pooled > 0);
figure
title({'VISp neuron activity at -100ms to 500ms','relative to medium contrast stimuli time (for subject 1)'},'fontsize',18)
xlabel('ISI time (ms)','FontSize',14)
ylabel('Frequency (Normalized proportion)','FontSize',14)
hold on 
histogram(interspike_intervals_pooled,'Normalization','probability');   
hold off
print('contrastMed_ISI','-dpng');

% VISp response to no difference (0) between left and right contrasts
no_diff_trial_indices = find(abs(subject1_beh.contrastLeft - subject1_beh.contrastRight) == 0);
num_no_diff_trials = length(no_diff_trial_indices);
interspike_intervals_pooled = [];
for cur_array_idx = 1:num_no_diff_trials
    trial_index = no_diff_trial_indices(cur_array_idx);
    stim_time = subject1_beh.stimTimes(trial_index);
    spikes_s = subject1_spikes(subject1_spikes >= stim_time - 0.1 & subject1_spikes <= stim_time + 0.5);
    spikes_s = spikes_s - stim_time; % Align data to stim_time
    spikes_ms = spikes_s * 1000;
    interspike_intervals_ms = diff(spikes_ms);
    interspike_intervals_pooled = [interspike_intervals_pooled; interspike_intervals_ms];
end
interspike_intervals_pooled = interspike_intervals_pooled(interspike_intervals_pooled > 0);
figure
title({'VISp neuron activity at -100ms to 500ms','relative to no contrast stimuli time (for subject 1)'},'fontsize',18)
xlabel('ISI time (ms)','FontSize',14)
ylabel('Frequency (Normalized proportion)','FontSize',14)
hold on 
histogram(interspike_intervals_pooled,'Normalization','probability');   
hold off
print('contrastLow_ISI','-dpng');

fprintf("The ISI for high and medium differences between left/right are very similar. When there is no difference between left/right, there are relatively more interspike intervals on the shorter side -- there is more frequent spiking of the visual neuron when there is no difference between left/right.")

end