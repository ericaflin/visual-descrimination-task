%% plots number of inaccurate trials vs length of delay time

fprintf('plot number of inaccurate responses for each delay time. Error calculated by subtracting real data from SD of means of bootstrapped data, then binning. CIs shown by red and yellow edges.')
figure;
delaysIncorrectTrials = [];
for isubj = 1:nsesh
    %-1 is right, +1 is left
    %set response labels
    leftTrial = beh(isubj).contrastLeft>beh(isubj).contrastRight;
    rightTrial = beh(isubj).contrastLeft<beh(isubj).contrastRight;
    rightTrial = rightTrial*-1;
    correctResps = rightTrial+leftTrial;
    %find the incorrect trials
    incorrectTrials = find(correctResps~=beh(isubj).resp);
    %get delay times
    delay = beh(isubj).goCue-beh(isubj).stimTimes;
    %get delays on incorrect trials
    delaysIncorrectTrials = [delaysIncorrectTrials;delay(incorrectTrials)];
end
%plot
[bins,edges] = histcounts(delaysIncorrectTrials,'BinWidth',.050);%,'FaceColor','k','FaceAlpha',0.8);
histogram('BinCounts',bins,'BinEdges',edges);
ylabel('# trials incorrect');
xlabel('delay length (s)');
title('distribution of incorrect responses sorted by delay length');
hold on;
%make error bars using bootstrapped data
for i = 1:100
    resampData = bootstrap(bins,100);
    delayError(i) = mean(resampData);
end
delayError = std(delayError);
%plot error
histogram('BinCounts',bins+delayError,'BinEdges',edges,'FaceColor','none','EdgeColor','r');
histogram('BinCounts',bins-delayError,'BinEdges',edges,'FaceColor','none','EdgeColor','y');
xlim([0.35,1.25]);


fprintf('there seems to be less incorrect responses with longer delays')
