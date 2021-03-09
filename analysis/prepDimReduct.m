%% Script to put data in a format for dimensionality reduction

function condSpikeCounts = prepDimReduct(beh,spike_pca)
ntrials = length(beh(end).goCue);
nunits = length(spike_pca.MOsTimes);
condSpikeCounts = zeros([150,3,nunits]);
startTime = -500;
endTime = 1000;
for itrial = 1:ntrials
    stimTime = beh(end).goCue(itrial)*1000;
    for iunit = 1:nunits
        unitActivity = spike_pca.MOsTimes(iunit);
        spikeCounts(:,itrial,iunit) = histcounts(cell2mat(unitActivity)*1000-stimTime,[startTime:10:endTime]);
    end
end
%gaussian smooth data with 20ms SD
flitData = gaussFilt1(spikeCounts,2);
%index trial conditions
leftTrial = find(beh(end).contrastLeft>beh(end).contrastRight);
rightTrial = find(beh(end).contrastLeft<beh(end).contrastRight);
neutralTrial = find(beh(end).contrastLeft==beh(end).contrastRight);
%average within condition
condSpikeCounts(:,1,:) = mean(flitData(:,rightTrial,:),2);
condSpikeCounts(:,2,:) = mean(flitData(:,leftTrial,:),2);
condSpikeCounts(:,3,:) = mean(flitData(:,neutralTrial,:),2);