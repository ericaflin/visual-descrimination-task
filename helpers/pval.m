%% generate p value
%input - float truedata - observed metric
%      - vector sythdist - fake distribution to measure under
%output - float p - one tailed pvalue; area under the curve from the truedata to
%                   infinity
%       - int tail - which tail the truedata falls under. 1 for upper, 0 for
%                    lower
function [p,tail] = pval(truedata,synthdist)

%if truedata is in the upper half of the dist
if truedata>=mean(synthdist)
    %calculate area under curve from truedata to infinity
    p = sum(synthdist>truedata)/length(synthdist);
    tail = 1; %upper tail
%if truedata is in the lower half of the ditribution
else
    %count number of occurances below the observed median and divide by
    %length of synthdata to get percentage
    p = sum(synthdist<truedata)/length(synthdist);
    tail = 0; %lower tail
end
