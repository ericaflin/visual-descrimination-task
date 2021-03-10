function spikes = selectClusters(index1,index2,nsubj,neural,type)

spikes = struct;
if strcmp(type,'pca')==1
    spikes.VISpTimes = {};
    spikes.MOsTimes = {};
end
for isubj = 1:nsubj
    nclusters = length(index1{:,isubj});
    ind1 = index1{:,isubj};
    temp = [];
    for i = 1:nclusters
        if strcmp(type,'pca')==1 && isubj == 17
            spikes.VISpTimes{i} = neural(isubj).times(find(neural(isubj).clusters==ind1(i)));
        else
            temp = [temp;find(neural(isubj).clusters==ind1(i))];
        end
    end
    if strcmp(type,'pca')~=1
        spikes(isubj).VISpTimes = neural(isubj).times(temp);
    end
    nclusters = length(index2{:,isubj});
    ind2 = index2{:,isubj};
    temp = [];
    for i = 1:nclusters
        if strcmp(type,'pca')==1 && isubj == 17
            spikes.MOsTimes{i} = neural(isubj).times(find(neural(isubj).clusters==ind2(i)));
        else
            temp = [temp;find(neural(isubj).clusters==ind2(i))];
        end
    end
    if strcmp(type,'pca')~=1
        spikes(isubj).MOsTimes = neural(isubj).times(temp);
    end
end