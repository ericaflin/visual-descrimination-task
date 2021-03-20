%% script to perform linear dimensionality reduction

function dimensionalityReduction(condSpikeCounts)
fprintf('reduce dimensionality and examine what low d state best captures the activity of the neurons in MOp')
%set constants
k = 10;
nneurons = size(condSpikeCounts,3);
reshapedSpikes = reshape(condSpikeCounts,[30*3,nneurons]);
c = cvpartition(90,"KFold",k);
normSpikes = reshapedSpikes./((max(reshapedSpikes)-min(reshapedSpikes))+0.02);
toDelete = [];
for i = 1:nneurons
    if sum(normSpikes(:,i))==0
        toDelete = [toDelete,i];
    end
end
normSpikes(:,toDelete) = [];
nneurons = size(normSpikes,2);
pcsToTest = [1:nneurons];
resvar = zeros([k,nneurons,length(pcsToTest)]);
for i = 1:k
    %crossvalidate
    testind = test(c,i);
    trainind = training(c,i);
    %run pca
    coeff = pca(normSpikes(trainind,:));
    %get mean
    mu = mean(normSpikes(trainind,:),2);
    %select which neuron to test on
    for testneuron = 1:nneurons
        if testneuron == 1
            ind = [2:nneurons];
        elseif testneuron == nneurons
            ind = [1:(nneurons-1)]; 
        else
            ind = [1:(testneuron-1),(testneuron+1):nneurons];
        end
        %test different number of pcs
        for ipc = 1:length(pcsToTest)
            pc = pcsToTest(ipc);
            %estimate X
            xhat = LeastSquaresW(coeff(ind,1:pc),normSpikes(testind,ind)');
            %reconstruct held out data
            reconstructed = (coeff(testneuron,1:pc)+mu(1:pc)')*(xhat);
            %compare test to reconstructed data
            testdata = normSpikes(testind,testneuron)';
            resvar(i,testneuron,ipc) = nansum(mean(testdata-reconstructed).^2)/nansum(testdata.^2);
            if resvar(i,testneuron,ipc)==Inf
                resvar(i,testneuron,ipc) = 0;
            end
        end
    end
end
figure;
plot([1:length(pcsToTest)],squeeze(nanmean(nanmean(resvar,2),1)));
xticks([1,10,20,30,40,50,55,70,80,90]);
xticklabels([1,10,20,30,40,50,55,70,80,90]);
xlabel('number of dimensions');
ylabel('error');
xlim([1,55]);
title('error of low dimensional state in time near response');
fprintf('error grows after 80')