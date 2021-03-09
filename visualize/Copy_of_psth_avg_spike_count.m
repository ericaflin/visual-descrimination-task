function [] = Copy_of_psth_avg_spike_count(beh, spikes)
%RASTER Provide PSTH for subject 1's average spike counts in visual and
%       motor neurons for -0.1 to 0.5 s relative to stimuli times 

fprintf("PSTH for average spike counts during stimulus times for motor and and visual neurons")

nneurons = size(spikes,3);
subject1_beh = beh(1);
subject1_spikes_MOs = reshape(spikes,[150*3*nneurons,1]);

% MOs response spike counts
[spike_counts_total,edges] = histcounts(subject1_spikes_MOs,-500:10:1000);
spike_counts_avg = spike_counts_total / 214;

figure
title({'MOs avg spike counts at -100ms to 500ms', 'relative to stimuli time (for subject 1)'},'fontsize',18)
xlabel('Time relative to stimuli (ms)','FontSize',14)
ylabel('Spike count','FontSize',14)
hold on 
histogram('BinEdges',edges,'BinCounts',spike_counts_avg)
hold off

fprintf("Overall, there is higher spike count for the visual neurons compared to the motor neurons. The motor neurons peak slightly before the visual neurons.")