%% train autoencoder

function [autoencoder,testdata] = makeAutoencoder(condSpikeCounts,ndims)

nneurons = size(condSpikeCounts,3);
reshapedSpikes = reshape(condSpikeCounts,[30*3,nneurons]);
ind = [1:90];
rows = randperm(90); %looked this up
trainingind = rows(1:18);
validationind1 = rows(19:36);
validationind2 = rows(37:54);
validationind3 = rows(55:72);
validationind = [validationind1;validationind2;validationind3];
testingind = rows(73:90);
normSpikes = reshapedSpikes./((max(reshapedSpikes)-min(reshapedSpikes))+0.02);
mse = 99999;
for i = 1:3
    ae = trainAutoencoder(normSpikes(trainingind,:),ndims);
    err = testAutoencoder(ae,normSpikes(validationind(i,:),:))
    if err<mse
        mse = err;
        autoencoder = ae;
    end        
end
testdata = normSpikes(testingind,:);
