function [] = response_times_contrast(beh, spikes)
%RASTER Show distribution of response times for subject 1
%       for differences in left/right contrast 
%       (high for difference of 1, medium for difference of 0.5,
%       no contrast for difference of 0)

fprintf("Response times for high, medium, and no difference between right and left:")

subject1_beh = beh(1);

% Response times for high difference (1) between left and right contrasts
high_diff_trial_indices = find(abs(subject1_beh.contrastLeft - subject1_beh.contrastRight) == 1);
high_diff_response_times = subject1_beh.respTimes(high_diff_trial_indices) - subject1_beh.goCue(high_diff_trial_indices);

figure
title({'Response times for', 'high difference in stimuli (for subject 1)'},'fontsize',18)
xlabel('Time (s)','FontSize',14)
ylabel('Frequency (Normalized proportion)','FontSize',14)
hold on 
histogram(high_diff_response_times,'Normalization','probability','BinWidth',.050); 
hold off
print('diffHigh_responseTime','-dpng');

% Response times for high difference (0.5) between left and right contrasts
med_diff_trial_indices = find(abs(subject1_beh.contrastLeft - subject1_beh.contrastRight) == 0.5);
med_diff_response_times = subject1_beh.respTimes(med_diff_trial_indices) - subject1_beh.goCue(med_diff_trial_indices);

figure
title({'Response times for', 'medium difference in stimuli (for subject 1)'},'fontsize',18)
xlabel('Time (s)','FontSize',14)
ylabel('Frequency (Normalized proportion)','FontSize',14)
hold on 
histogram(med_diff_response_times,'Normalization','probability','BinWidth',.050); 
hold off
print('diffMed_responseTime','-dpng');

% VISp response to no difference (0) between left and right contrasts
no_diff_trial_indices = find(abs(subject1_beh.contrastLeft - subject1_beh.contrastRight) == 0);
no_diff_response_times = subject1_beh.respTimes(no_diff_trial_indices) - subject1_beh.goCue(no_diff_trial_indices);

figure
title({'Response times for', 'no difference in stimuli (for subject 1)'},'fontsize',18)
xlabel('Time (s)','FontSize',14)
ylabel('Frequency (Normalized proportion)','FontSize',14)
hold on 
histogram(no_diff_response_times,'Normalization','probability','BinWidth',.050);   
hold off
print('diffNone_responseTime','-dpng');

fprintf("The mouse had relatively faster reaction speeds when there was higher difference between right/left stimuli. We can see that when there was no difference in left/right stimuli, the mouse had a far higher proportion of slow responses.")

end