%% Finds optimal weights using least squares formula
% Honestly I'm shocked matlab doesn't have this built in but here we are
%input - X - observations. Assumes linear independence between rows.
%               (each row is a different observation)
%      - y - labels for each observation.
%output - w - weight vector that minimizes difference between actual and
%             predicted labels

function [w] = LeastSquaresW(X,y)

w = inv(X.'*X)*X.'*y;