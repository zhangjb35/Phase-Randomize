function [ signal_surrogate, faxis, PS ] = randphase( signal,samplerate, method)
%将输入信号进行相位随机之后输出随机后时域波形
%   input : 原始信号
% process : fft 转换到频域; angle 检查当前相位; 生成随机相位;写入相位;ifft转回时域
% output : 替代信号
% Get parameters
[n_time, n_frame] = size(signal);
if n_frame > n_time
    temp = n_frame;
    n_frame = n_time;
    n_time = temp;
    signal = signal';
end
% 解决FFT输出对称性问题
[ fixfft_signal, nfft, faxis, PS ] = fixfft( signal, n_time,samplerate, method );
signal_surrogate = zeros(n_time,n_frame);
rand_phase = rand([nfft, 1])*2*pi;
rand_phase_matrix = repmat(exp( 2*pi*1i*rand_phase),1,n_frame);
signal_surrogate_matrix = fixfft_signal .* rand_phase_matrix;
for k = 1:n_frame
    signal_surrogate(:,:,k)= real(ifft(signal_surrogate_matrix(:,k), n_time))';
end
end

