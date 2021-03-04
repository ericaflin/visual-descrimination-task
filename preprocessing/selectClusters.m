spikes = struct;
for isubj = 1:nsubj
    nclusters = length(index1{:,isubj});
    ind1 = index1{:,isubj};
    temp = [];
    for i = 1:nclusters
        temp = [temp;find(neural(isubj).spikes==ind1(i))];
    end
    spikes(isubj).VISpTimes = neural(isubj).times(temp);
    nclusters = length(index2{:,isubj});
    ind2 = index2{:,isubj};
    temp = [];
    for i = 1:nclusters
        temp = [temp;find(neural(isubj).spikes==ind2(i))];
    end
    spikes(isubj).MOsTimes = neural(isubj).times(temp);
end