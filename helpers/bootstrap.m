%% runs a bootstrap analysis
% resamples data with replacement
%input - vector data - data to be bootstrapped
%      - int resampleRate - how many times to resample the data
%output - vector resampDist - mean of the resampled distributions. Same size and
%                             shape as data

function resampDist = bootstrap(data,resampleRate)
datasize = numel(data);
%create vector to store data in before we take the mean
runningresampDist = zeros(size(data),'double');
for i = 1:resampleRate
    %randomly choose data points to include in new sample
    rng('default');
    index = randi(datasize,[datasize,1]);
    resampData = data(index);
    %add the resampled data to the running total
    runningresampDist = runningresampDist + resampData;
end
resampDist = runningresampDist./(resampleRate*1.0);