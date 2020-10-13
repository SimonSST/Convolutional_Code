clear all;close all;clc;
source = unidrnd(2,1,1000)-1;
code = code(source,2,1);
reflect = PSK(code);
snr = -20:1:20;
error = zeros(1,length(snr));
for m = 1:length(snr)
    A = 0.5*10^(snr(m)/10);
    ref = sqrt(A)*reflect;
    [receive,a] = channel(ref,1,0.5);
    recode = inv_PSK(receive);
    info = viterbi(recode);
    error(m) = sum(info~=source);
end
plot(snr,error/length(source));

