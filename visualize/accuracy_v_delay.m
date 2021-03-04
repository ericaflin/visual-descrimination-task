figure;
delaysIncorrectTrials = [];
for isubj = 1:nsesh
    %-1 is right, +1 is left
    leftTrial = beh(isubj).contrastLeft>beh(isubj).contrastRight;
    rightTrial = beh(isubj).contrastLeft<beh(isubj).contrastRight;
    rightTrial = rightTrial*-1;
    correctResps = rightTrial+leftTrial;
    incorrectTrials = find(correctResps~=beh(isubj).resp);
    delay = beh(isubj).goCue-beh(isubj).stimTimes;
    delaysIncorrectTrials = [delaysIncorrectTrials;delay(incorrectTrials)];
end
histogram(delaysIncorrectTrials,'BinWidth',.01);
ylabel('# trials incorrect');
xlabel('delay length (s)');
title('distribution of incorrect responses sorted by delay length');

