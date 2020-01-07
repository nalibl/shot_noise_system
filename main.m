close all
% Number of signals to be estimated
n_sample = 100;
% Shot noise coefficient
alpha = 0.01;
% Independant Gaussian noise STD
sigma_0 = 5;
% Generate PDF from sample image
example_img = imread('cameraman.tif');
hist = histcounts(example_img(:),0:256,'Normalization','probability');
% Randomize measured signal
x = randpdf(hist,0:255,[n_sample,1]);
% Define signal mixing matrix
M = 1-eye(n_sample);
Mx = M*x;
N = randn(size(Mx,1),1).*sqrt(sigma_0^2+alpha*Mx);
% Only positive values - measurement of "counts"
y = max(Mx+N,0);
x_hat  = M\y ; 
noise = M\N;
SNR = mean(abs((x_hat-noise)./noise));
figure; plot(x);title('$x$','Interpreter','latex');
figure; plot(x_hat);title('$\hat{x}$','Interpreter','latex');
figure; plot(x_hat-x);title('$\hat{x}-x$','Interpreter','latex');
figure; plot(Mx);title('$M \cdot x$','Interpreter','latex');
figure; plot(ifft(fft(x).*conj(fft(x_hat))));title('$x \star \hat{x}$','Interpreter','latex');
disp(['SNR=' num2str(SNR)])
