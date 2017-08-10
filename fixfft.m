function [ data_freq, nfft, faxis, PS ] = fixfft( data, N, samplerate,  method )
%fixfft 经过对称修正后的FFT转换
%  输入为原始波形
%  输出为经过对称转换的频谱图
windowlength=128;  % in data points
nfft = 2^nextpow2(N); % Next power of 2 from length of y
data_freq=fft(data,nfft);
if strcmp(method, 'o')
    PS=abs(data_freq).^2;
    PS=PS/max(PS);
    faxis=samplerate/2*linspace(0,1,nfft/2+1);
elseif strcmp(method, 'w')
    [PS,faxis] = pwelch(data,hamming(windowlength),[],windowlength,samplerate);  % power spectrum analysis using Welch method
    PS=PS/max(PS);
end

