%% plots wheel position as a function of time

fprintf('show wheel position during the trial from stimulus presentation')
figure;
for isubj = 1:1
    ntrials = length(beh(isubj).stimTimes);
    npos = length(beh(isubj).wheelPos);
    wheelTimes = linspace(beh(isubj).wheelTime(1,2),beh(isubj).wheelTime(2,2),npos);
    wheelPos = [];
    for itrial = 1:ntrials
        startTime = beh(isubj).stimTimes(itrial)-0.5;
        endTime = beh(isubj).stimTimes(itrial)+1.5;
        startInd = find(startTime-wheelTimes<0,1);
        endInd = find(endTime-wheelTimes>0,1,'last');
        wheelPos = [wheelPos,beh(isubj).wheelPos(startInd:endInd)];
    end
    %convert to millimeters
    wheelPos = wheelPos*0.135;
    %select out left vs right trials
    leftTrial = find(beh(isubj).contrastLeft>beh(isubj).contrastRight);
    rightTrial = find(beh(isubj).contrastLeft<beh(isubj).contrastRight);
    %plot
    plot([1:length(wheelPos(:,leftTrial))],mean(wheelPos(:,leftTrial),2),'color','r');
    hold on;
    plot([1:length(wheelPos(:,rightTrial))],mean(wheelPos(:,rightTrial),2),'color','b');
    xlabel('time (s)');
    xticks([0,2500,5000]);
    xticklabels([0,1,2]);
    ylabel('position (mm)');
    legend('leftTrial','rightTrial');
    title('mean wheel position during trial for different stimulus conditions')
end

fprintf('wheel position decreases for rightward responses, and increases for leftward responses, which shows the animal was successfully manipulating the wheel')