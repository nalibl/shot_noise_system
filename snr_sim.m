figure;
n_sample=100;
r1=linspace(0,10,n_sample); % r1 is the ratio between the thermal + readout variance and the mean of measurements {x}
r2=linspace(0.5,2,n_sample); % r2 is the ratio between the measurement of interes x_i and the mean of measurements {x}
[R1,R2]=meshgrid(r1,r2);
for N=3:100
    gain=(N-1)^2*(R1+R2)./((2*N-3)*R1+(2*N^2-4*N)+(3-N)*R2); % ratio of SNR between new and old schemes
    gain(gain<1)=0; % no improvement - not interesting
    imagesc(r1,r2,sqrt(gain));
    title(['SNR gain, N=', num2str(N)]);
    xlabel('$\sigma_{0}^2 / \langle x \rangle$','Interpreter','latex');
    ylabel('$x/ \langle x \rangle$','Interpreter','latex');
    colorbar;
    pause(0.3);
end