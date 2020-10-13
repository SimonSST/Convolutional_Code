function [code] = code(signal,mode_code,tail)
% ����ģ��
% signalΪ��������
% mode_codeΪ1����Ч��Ϊ1/2��modeΪ2����Ч��Ϊ1/3
% tailΪ0������β��Ϊ1������β��Ϊ2����ҧβ
% codeΪ�������������
    if tail==0
        signal = [0 0 0 signal];
    elseif tail==1
        signal = [0 0 0 signal 0 0 0];
    else
        signal = [signal(end-2) signal(end-1) signal(end) signal];
    end
    
    len = length(signal);
    code = [];
    
    if mode_code==1   %1/2����
        A0 = [1,1];
        A1 = [1,1];
        A2 = [0,1];
        A3 = [1,1];

        for m = 1:len-3
            y1 = mod(signal(m+3)*A0(1)+signal(m+2)*A1(1)+signal(m+1)*A2(1)+signal(m)*A3(1),2);
            y2 = mod(signal(m+3)*A0(2)+signal(m+2)*A1(2)+signal(m+1)*A2(2)+signal(m)*A3(2),2);
            code = [code y1 y2];
        end
    else    %1/3����
        A0 = [1,1,1];
        A1 = [0,1,1];
        A2 = [1,0,1];
        A3 = [1,1,1];
        
        for m = 1:len-3
            y1 = mod(signal(m+3)*A0(1)+signal(m+2)*A1(1)+signal(m+1)*A2(1)+signal(m)*A3(1),2);
            y2 = mod(signal(m+3)*A0(2)+signal(m+2)*A1(2)+signal(m+1)*A2(2)+signal(m)*A3(2),2);
            y3 = mod(signal(m+3)*A0(3)+signal(m+2)*A1(3)+signal(m+1)*A2(3)+signal(m)*A3(3),2);
            code = [code y1 y2 y3];
        end
    end
end

