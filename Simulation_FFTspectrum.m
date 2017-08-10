%% Author: Lu, Chia-Feng 2013.11.01
clear, close all

%% initialize parameters
samplerate=1000; % in Hz
N=1024; % data length

sinefreq1=50; % in Hz
sinefreq2=200; % in Hz
SNR=-7; % in dB

windowlength=128;  % in data points
%% generate simulated signals 
t=[1:N]/samplerate;
sig1=sin(2*pi*sinefreq1*t);
sig2=sin(2*pi*sinefreq2*t);

data=awgn(sig1+sig2,SNR);  % add white noise to signal according to a specific SNR

figure, 
subplot(3,1,1),plot(t,sig1),xlim([t(1) t(round(N/4))])
title([num2str(sinefreq1) '-Hz Sine Wave'])
subplot(3,1,2),plot(t,sig2),xlim([t(1) t(round(N/4))])
title([num2str(sinefreq2) '-Hz Sine Wave'])
subplot(3,1,3),plot(t,data),xlim([t(1) t(round(N/4))])
title(['Simulated Signal of Mixed Sine Waves With White Noise, SNR = ' num2str(SNR) ' dB'])
xlabel('Time (s)')

%% Spectral analysis (FFT)
nfft = 2^nextpow2(N); % Next power of 2 from length of y
data_freq=fft(data,nfft);
PS=abs(data_freq).^2;
PS=PS/max(PS);
faxis=samplerate/2*linspace(0,1,nfft/2+1);

figure,

plot(faxis,20*log10(PS(1:nfft/2+1))) % represented by dB
title('Spectral Analysis (FFT)')
xlabel('Frequency (Hz)')
ylabel('Power Spectrum (dB)')

%% Spectral analysis (FFT with Welch method)
[PS_W,faxis_W] = pwelch(data,hamming(windowlength),[],windowlength,samplerate);  % power spectrum analysis using Welch method
PS_W=PS_W/max(PS_W);

figure,
plot(faxis_W,20*log10(PS_W))  % represented by dB
title('Spectral Analysis (FFT with Welch method)')
xlabel('Frequency (Hz)')
ylabel('Power Spectrum (dB)')

