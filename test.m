clear,clc,close all
%% 模拟信号
%% initialize parameters
samplerate=500; % in Hz
N=1024; % data length
%% raw time course prepare
t=[1:N]/samplerate;
% freq component
x1=sin(2*pi*15*t + pi) ;
x2=cos(2*pi*40*t);
% SNR
SNR=-2; % in dB
% sim data
signal_sim = 2*x1+2*x2;
% add white noise
signal_sim = awgn(signal_sim,SNR);
%% 相位随机
[ signal_sim_randphased, faxis, PS ]  = randphase(signal_sim,samplerate, 'o');
signal_sim_randphased = signal_sim_randphased(:,:,1);
%% corr check
time_compare = corr(signal_sim', signal_sim_randphased);
figure,
% raw
subplot(2,1,1),plot(t,signal_sim),xlim([t(1) t(round(N/4))]),ylim([-6 6])
title([ 'Raw Simulated Data'])
subplot(2,1,2),plot(t,signal_sim_randphased'),xlim([t(1) t(round(N/4))]),ylim([-6 6])
title([ 'Rephased Simulated Data'])

figure
%% 频率成分对比
%% Origin
[ raw_freq, nfft, faxis, PS ] = fixfft(signal_sim, N, samplerate,  'o' );
[ rph_freq, nfft, faxis, PS ] = fixfft(signal_sim_randphased, N, samplerate,  'o' );

subplot(2,1,1), plot(faxis,20*log10(PS(1:nfft/2+1))),ylim([-120 0]) % represented by dB
title('Spectral Analysis (FFT) - RAW')
xlabel('Frequency (Hz)')
ylabel('Power Spectrum (dB)')
subplot(2,1,2),plot(faxis,20*log10(PS(1:nfft/2+1))),ylim([-120 0]) % represented by dB
title('Spectral Analysis (FFT) - REPHASED')
xlabel('Frequency (Hz)')
ylabel('Power Spectrum (dB)')
%% Welch method
[ raw_freq, nfft, faxis, PS ] = fixfft(signal_sim, N, samplerate,  'w' );
[ rph_freq, nfft, faxis, PS ] = fixfft(signal_sim_randphased, N, samplerate,  'w' );

figure,
subplot(2,1,1),plot(faxis,20*log10(PS))  % represented by dB
title('Spectral Analysis (FFT with Welch method) - RAW')
xlabel('Frequency (Hz)')
ylabel('Power Spectrum (dB)')
subplot(2,1,2),plot(faxis,20*log10(PS))  % represented by dB
title('Spectral Analysis (FFT with Welch method)- REPASED' )
xlabel('Frequency (Hz)')
ylabel('Power Spectrum (dB)')

%% corr check
corr(raw_freq', rph_freq);