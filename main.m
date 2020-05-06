close all
showPlots = false;
% Number of signals to be estimated
n_sample = 0.5e4;
% Generate PDF from sample image
example_img = imread('cameraman.tif');
hist = histcounts(example_img(:),0:256,'Normalization','probability');
% Independant Gaussian noise STD - chosen as mean of input signal
sigma_0 = double(max(example_img(:)));
% Randomize measured signal
x = randpdf(hist,0:255,[n_sample,1]);
% Define signal mixing matrix
if n_sample~=1
    M = 1-eye(n_sample);
else
    M = 1;
end
% M = eye(n_sample);
% Mix signals
Mx = M*x;
% Add constant and shot noise - for weak signals the constant noise
% dominates while for strong ones the shot noise dominates, but the SNR
% is improved
N = randn(size(Mx,1),1).*sqrt(sigma_0^2+Mx);
% Only positive values - measurement of "counts"
y = max(Mx+N,0);
% Linear estimator
x_hat = max(M\y, 0);
SNR = mean(x)./std(x_hat-x);
% Comparison with regular scheme
M = eye(n_sample);
Mx = M*x;
N = randn(size(Mx,1),1).*sqrt(sigma_0^2+Mx);
y = max(Mx+N,0);
x_hat = max(M\y, 0);
SNR_ref = mean(x)./std(x_hat-x);
if showPlots
    figure; plot(x);title('$x$','Interpreter','latex');
    figure; plot(x_hat);title('$\hat{x}$','Interpreter','latex');
    figure; plot(x_hat-x);title('$\hat{x}-x$','Interpreter','latex');
    figure; plot(Mx);title('$M \cdot x$','Interpreter','latex');
end
% figure; plot(ifft(fft(x).*conj(fft(x_hat))));title('$x \star \hat{x}$','Interpreter','latex');
disp(['SNR=' num2str(SNR)])
