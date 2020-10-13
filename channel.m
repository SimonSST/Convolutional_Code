function [receive,a] = channel(reflect,scene,variance)
%复数电平信道模块
%reflect为经编码、调制阶段后的复电平信号
%scene为对应的信道场景
    switch  scene
        case 1
            b = 0;
            rho = 0;
        case 2
            b = 0.1;
           rho = 0.1;
        case 3
            b = 0.5;
            rho = 0.95;
        otherwise
            b =1;
            rho = 1;
    end
    len = length(reflect);
    
    %生成均值为0，方差为variance的高斯白噪声
    n_real = randn(size(reflect));
    n_real = (n_real-mean(n_real))/std(n_real);
    n_real = n_real*sqrt(variance);
    
    n_imag = randn(size(reflect));
    n_imag = (n_imag-mean(n_imag))/std(n_imag);
    n_imag = n_imag*sqrt(variance);
    
    n = n_real+1i*n_imag;
    
    %生成系数z，均值为0，方差为0.5
    z_real = randn(size(reflect));
    z_real = (z_real-mean(z_real))/std(z_real);
    z_real = z_real*sqrt(0.5);
    
    z_imag = randn(size(reflect));
    z_imag = (z_imag-mean(z_imag))/std(z_imag);
    z_imag = z_imag*sqrt(0.5);
    
    z = z_real+1i*z_imag;
    
    %生成系数beta，均值为0，方差为0.5
    beta(1) = n(1); %n(1)没有被使用，所以可以被赋予beta(1)，并不违反要求的独立性
    for m = 2:len
        beta(m) = rho*beta(m-1)+sqrt(1-rho^2)*z(m);
    end
   
    %噪声叠加
    a = sqrt(1-b^2)+b*beta;
    receive = a.*reflect+n;     
        
end

