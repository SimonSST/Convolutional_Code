function [receive,a] = channel(reflect,scene,variance)
%������ƽ�ŵ�ģ��
%reflectΪ�����롢���ƽ׶κ�ĸ���ƽ�ź�
%sceneΪ��Ӧ���ŵ�����
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
    
    %���ɾ�ֵΪ0������Ϊvariance�ĸ�˹������
    n_real = randn(size(reflect));
    n_real = (n_real-mean(n_real))/std(n_real);
    n_real = n_real*sqrt(variance);
    
    n_imag = randn(size(reflect));
    n_imag = (n_imag-mean(n_imag))/std(n_imag);
    n_imag = n_imag*sqrt(variance);
    
    n = n_real+1i*n_imag;
    
    %����ϵ��z����ֵΪ0������Ϊ0.5
    z_real = randn(size(reflect));
    z_real = (z_real-mean(z_real))/std(z_real);
    z_real = z_real*sqrt(0.5);
    
    z_imag = randn(size(reflect));
    z_imag = (z_imag-mean(z_imag))/std(z_imag);
    z_imag = z_imag*sqrt(0.5);
    
    z = z_real+1i*z_imag;
    
    %����ϵ��beta����ֵΪ0������Ϊ0.5
    beta(1) = n(1); %n(1)û�б�ʹ�ã����Կ��Ա�����beta(1)������Υ��Ҫ��Ķ�����
    for m = 2:len
        beta(m) = rho*beta(m-1)+sqrt(1-rho^2)*z(m);
    end
   
    %��������
    a = sqrt(1-b^2)+b*beta;
    receive = a.*reflect+n;     
        
end

