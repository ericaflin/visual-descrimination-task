function [] = psth_avg_spike_count(beh, spikes)
%RASTER Provide PSTH for subject 1's average spike counts in visual and
%       motor neurons for -0.1 to 0.5 s relative to stimuli times 

fprintf("PSTH for average spike counts during stimulus times for motor and and visual neurons. CI's shown by red and yellow edges.")

subject1_beh = beh(1);
subject1_spikes_VISp = spikes(1).VISpTimes;
subject1_spikes_MOs = spikes(1).MOsTimes;

% VISp response spike counts
num_trials = 214;
spikes_pooled = [];
for trial_index = 1:num_trials
    stim_time = subject1_beh.stimTimes(trial_index);
    spikes_s = subject1_spikes_VISp(subject1_spikes_VISp >= stim_time - 0.1 & subject1_spikes_VISp <= stim_time + 0.5);
    spikes_s = spikes_s - stim_time; % Align data to stim_time
    spikes_ms = spikes_s * 1000;
    spikes_pooled = [spikes_pooled; spikes_ms];
end
[spike_counts_total,edges] = histcounts(spikes_pooled,-100:10:500);
spike_counts_avg = spike_counts_total / num_trials;
for i = 1:10
    fake_pool = bootstrap(spikes_pooled,1000);
    [fake_counts_total,fake_edges] = histcounts(fake_pool,-100:10:500);
    fake_avg(i) = mean(fake_counts_total/num_trials);
end
CI = std(fake_avg);

figure
title({'VISp avg spike counts at -100ms to 500ms', 'relative to stimuli time (for subject 1)'},'fontsize',18)
xlabel('Time relative to stimuli (ms)','FontSize',14)
ylabel('Spike count','FontSize',14)
hold on 
histogram('BinEdges',edges,'BinCounts',spike_counts_avg)
histogram('BinEdges',edges,'BinCounts',spike_counts_avg+CI,'FaceColor','none','EdgeColor','r')
histogram('BinEdges',edges,'BinCounts',spike_counts_avg-CI,'FaceColor','none','EdgeColor','y')
hold off

% MOs response spike counts
num_trials = 214;
spikes_pooled = [];
for trial_index = 1:num_trials
    stim_time = subject1_beh.stimTimes(trial_index);
    spikes_s = subject1_spikes_MOs(subject1_spikes_MOs >= stim_time - 0.1 & subject1_spikes_MOs <= stim_time + 0.5);
    spikes_s = spikes_s - stim_time; % Align data to stim_time
    spikes_ms = spikes_s * 1000;
    spikes_pooled = [spikes_pooled; spikes_ms];
end
[spike_counts_total,edges] = histcounts(spikes_pooled,-100:10:500);
spike_counts_avg = spike_counts_total / num_trials;
for i = 1:10
    fake_pool = bootstrap(spikes_pooled,1000);
    [fake_counts_total,fake_edges] = histcounts(fake_pool,-100:10:500);
    fake_avg(i) = mean(fake_counts_total/num_trials);
end
CI = 3*std(fake_avg);

figure
title({'MOs avg spike counts at -100ms to 500ms', 'relative to stimuli time (for subject 1)'},'fontsize',18)
xlabel('Time relative to stimuli (ms)','FontSize',14)
ylabel('Spike count','FontSize',14)
hold on 
histogram('BinEdges',edges,'BinCounts',spike_counts_avg)
histogram('BinEdges',edges,'BinCounts',spike_counts_avg+CI,'FaceColor','none','EdgeColor','r')
histogram('BinEdges',edges,'BinCounts',spike_counts_avg-CI,'FaceColor','none','EdgeColor','y')
hold off

fprintf("Overall, there is higher spike count for the visual neurons compared to the motor neurons. The motor neurons peak slightly before the visual neurons.")

end