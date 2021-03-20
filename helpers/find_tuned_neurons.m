function tunedUnits = find_tuned_neurons(spikeCounts,beh,thresh)

tunedUnits = struct;

leftTrial = find(beh(17).contrastLeft>beh(17).contrastRight);
rightTrial = find(beh(17).contrastLeft<beh(17).contrastRight);
neutralTrial = find(beh(17).contrastLeft==beh(17).contrastRight);

leftCondSpikes = squeeze(mean(mean(spikeCounts(:,leftTrial,:),2),3));
rightCondSpikes = squeeze(mean(mean(spikeCounts(:,rightTrial,:),2),3));

tunedUnits.index = find(abs(leftCondSpikes - rightCondSpikes)>=thresh);
leftTuned = (leftCondSpikes - rightCondSpikes)>=thresh;
rightTuned = ((rightCondSpikes - leftCondSpikes)>=thresh)*-1;
tunedUnits.stim = leftTuned+rightTuned;