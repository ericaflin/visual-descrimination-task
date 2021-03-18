%% test the encoder

function error = testAutoencoder(autoencoder,testdata)

reconstructed = predict(autoencoder,testdata);
error = mse(testdata-reconstructed);