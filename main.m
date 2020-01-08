close all
showPlots = false;
% Number of signals to be estimated
n_sample = 1000;
% Generate PDF from sample image
example_img = imread('cameraman.tif');
hist = histcounts(example_img(:),0:256,'Normalization','probability');
% Shot noise coefficient
alpha = 1e-3;
% Independant Gaussian noise STD - chosen as mean of input signal
sigma_0 = sqrt(mean(example_img(:)));
% Randomize measured signal
x = randpdf(hist,0:255,[n_sample,1]);
% Define signal mixing matrix
% M = 1-eye(n_sample);
M = eye(n_sample);
% Mix signals
Mx = M*x;
% Add constant and shot noise - for weak signals the constant noise
% dominates while for strong ones the shot noise dominated, but the the SNR
% is improved
N = randn(size(Mx,1),1).*sqrt(sigma_0^2+alpha*Mx);
% Only positive values - measurement of "counts"
y = max(Mx+N,0);
% Linear estimator
x_hat  = M\y ; 
SNR = mean(x)./sqrt(mean((x_hat-x).^2));
if showPlots
    figure; plot(x);title('$x$','Interpreter','latex');
    figure; plot(x_hat);title('$\hat{x}$','Interpreter','latex');
    figure; plot(x_hat-x);title('$\hat{x}-x$','Interpreter','latex');
    figure; plot(Mx);title('$M \cdot x$','Interpreter','latex');
end
% figure; plot(ifft(fft(x).*conj(fft(x_hat))));title('$x \star \hat{x}$','Interpreter','latex');
disp(['SNR=' num2str(SNR)])
