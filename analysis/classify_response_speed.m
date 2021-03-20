function [] = classify_response_speed(beh, spikes)
% Classify reaction speeds as fast (< 1 sec) or slow (> 2 sec)
% upon spike counts in MOs across 10ms bins 
% (from -100 to 400ms relative to
% reaction time)

fprintf("Classify reaction speeds as fast (< 1 sec) or slow (> 2 sec)")

subject1_beh = beh(17);
subject1_spikes_MOs = spikes(17).MOsTimes;

response_times = subject1_beh.respTimes - subject1_beh.stimTimes;
fast_response_indices = find(response_times <= 1);
slow_response_indices = find(response_times >= 2);
relevant_indices = [fast_response_indices ; slow_response_indices];

num_time_bins = 50;
num_trials = length(subject1_beh.goCue);
spikecounts_over_time = zeros(num_trials,num_time_bins);
for trial_index = 1:num_trials
    response_time = subject1_beh.respTimes(trial_index);
    spikes_in_frame_s = subject1_spikes_MOs(subject1_spikes_MOs >= response_time - 0.100 & subject1_spikes_MOs <= response_time + 0.400);
    spikes_in_frame_s = spikes_in_frame_s - response_time; % Align data to response_time
    spikes_over_time = histcounts(spikes_in_frame_s, [-0.100:0.010:0.400]);
    spikecounts_over_time(trial_index,:) = spikes_over_time;
end

% General Linear Model (GLM)
response_times_binomial = response_times;
response_times_binomial(fast_response_indices) = repelem(1, length(fast_response_indices));
response_times_binomial(slow_response_indices) = repelem(0, length(slow_response_indices));

glm_partition = cvpartition(relevant_indices,'KFold',10);
glm_validations = [1:10];
for k=1:10
    training_indices = relevant_indices(training(glm_partition, k));
    test_indices = relevant_indices(test(glm_partition, k));
    glm_training_X = spikecounts_over_time(training_indices,:);
    glm_training_Y = response_times_binomial(training_indices);
    glm_model = glmfit(glm_training_X, glm_training_Y, 'binomial');
    glm_yhat = uint8(glmval(glm_model,spikecounts_over_time(test_indices,:),'logit'));
    glm_y = response_times_binomial(test_indices);
    glm_validations(k) = 100 * sum(glm_yhat == glm_y) / length(glm_y);
end
glm_percentage_classified_correctly_final = mean(glm_validations);

fprintf("\nglm_percentage_classified_correctly = %3.2f%%", glm_percentage_classified_correctly_final)

% Lasso GLM
lasso_partition = cvpartition(relevant_indices,'KFold',10);
lasso_validations = [1:10];
for k=1:10
    training_indices = relevant_indices(training(lasso_partition, k));
    test_indices = relevant_indices(test(lasso_partition, k));
    lasso_training_X = spikecounts_over_time(training_indices,:);
    lasso_training_Y = response_times_binomial(training_indices);
    [lasso_model, lasso_fit_info] = lassoglm(lasso_training_X, lasso_training_Y, 'binomial',"Alpha",0.1,"CV",10);    
    
    idxLambdaMinDev = lasso_fit_info.IndexMinDeviance;
    mindevcoefs = lasso_model(:,idxLambdaMinDev);
    lasso_model_optimal = [lasso_fit_info.Intercept(idxLambdaMinDev) ; mindevcoefs];
    
    lasso_yhat = uint8(glmval(lasso_model_optimal,spikecounts_over_time(test_indices,:),'logit'));
    lasso_y = response_times_binomial(test_indices);
    lasso_validations(k) = 100 * sum(lasso_yhat == lasso_y) / length(lasso_y);
end
lasso_percentage_classified_correctly_final = mean(lasso_validations);
fprintf("\nlasso_percentage_classified_correctly = %3.2f%%", lasso_percentage_classified_correctly_final)


% SVM 
response_times_svm = response_times;
response_times_svm(fast_response_indices) = repelem(1, length(fast_response_indices));
response_times_svm(slow_response_indices) = repelem(-1, length(slow_response_indices));

for k=1:10
    svm_model = fitcsvm(spikecounts_over_time(relevant_indices), response_times_svm(relevant_indices));
    svm_crossval_model = crossval(svm_model);
    svm_validations = (1 - kfoldLoss(svm_crossval_model)) * 100;
end
svm_percentage_classified_correctly_final = mean(svm_validations);

fprintf("\nsvm_percentage_classified_correctly = %3.2f%%", svm_percentage_classified_correctly_final)

end