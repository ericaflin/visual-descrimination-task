function synthData = synthData_generator(data)

synthData = mean(data,'all') + std(data,0,'all')*randn(size(data));