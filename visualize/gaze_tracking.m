%% helper to plot gaze position after stimulus appearance

fprintf('plot gaze position for subject 1 for 500 ms after stimulus apppears')
figure;
for isubj = 1:1
    ntrials = length(beh(isubj).stimTimes);
    x = [];
    y = [];
    for itrial = 1:ntrials
        %lock to stimulus appearance
        startTimeBeh = beh(isubj).stimTimes(itrial);
        %find closest timestamp (they have 0.01 s resolution)
        startInd = find(abs(eye(isubj).times(:,2)-startTimeBeh)<0.01,1);
        %get timestamps from eye data
        startTime = eye(isubj).times(startInd,2);
        endTime = startTime(1) + 0.5;
        %find closest timestamp to end
        endInd = find(abs(eye(isubj).times(:,2)-endTime)<0.01,1);
        %add to array
        x = [x,eye(isubj).xypos(startInd:endInd,1)];
        y = [y,eye(isubj).xypos(startInd:endInd,2)];  
    end
    %select out left vs right trials
    leftTrial = find(beh(isubj).contrastLeft>beh(isubj).contrastRight);
    rightTrial = find(beh(isubj).contrastLeft<beh(isubj).contrastRight);
    %plot
    plot(mean(x(:,leftTrial),2),mean(y(:,leftTrial),2),'color','r');
    hold on;
    plot(mean(x(:,rightTrial),2),mean(y(:,rightTrial),2),'color','b');
    xlabel('x coordinate');
    ylabel('y coordinate');
    legend('leftTrial','rightTrial','Location','SouthEast');
    title('eye position during left and right conditions');
end

fprintf('we see that the mouses gaze seems to be drawn toward the side of the screen with the higher contrast stimulus')