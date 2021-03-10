%% script to perform linear dimensionality reduction

function dimensionalityReduction(condSpikeCounts)
fprintf('reduce dimensionality and examine what low d state best captures the activity of the neurons in MOs')
%set constants
k = 10;
nneurons = size(condSpikeCounts,3);
reshapedSpikes = reshape(condSpikeCounts,[150*3,nneurons]);
c = cvpartition(450,"KFold",k);
normSpikes = reshapedSpikes./((max(reshapedSpikes)-min(reshapedSpikes))+0.2);
pcsToTest = [1,5,10,25,50,100];
resvar = zeros([k,length(pcsToTest)]);
for i = 1:k
    %crossvalidate
    testind = test(c,i);
    trainind = training(c,i);
    %run pca
    coeff = pca(normSpikes(trainind,:));
    %get mean
    mu = mean(normSpikes(trainind,:),2);
    %select which neuron to test on
    testneuron = randi(nneurons,1);
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
        resvar(i,ipc) = nansum(mean(testdata-reconstructed).^2)/nansum(testdata.^2);
        if resvar(i,ipc)==Inf
            resvar(i,ipc) = 0;
        end
    end
end
figure;
plot([1:length(pcsToTest)],nanmean(resvar,1));
xticks([1,2,3,4,5,6]);
xticklabels(pcsToTest);
xlabel('number of dimensions');
ylabel('error');
title('error of low dimensional state in time after go cue');
fprintf('error grows with more dimensions. It may be the secondary motor area isnt very modulated in this task')