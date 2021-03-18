%% train autoencoder

function [autoencoder,testdata] = makeAutoencoder(condSpikeCounts,ndims)

nneurons = size(condSpikeCounts,3);
reshapedSpikes = reshape(condSpikeCounts,[150*3,nneurons]);
normSpikes = reshapedSpikes./((max(reshapedSpikes)-min(reshapedSpikes))+0.02);
autoencoder = trainAutoencoder(normSpikes,ndims);
testdata = normSpikes;
