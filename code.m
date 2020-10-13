function [code] = code(signal,mode_code,tail)
% 编码模块
% signal为输入序列
% mode_code为1代表效率为1/2，mode为2代表效率为1/3
% tail为0代表不收尾，为1代表收尾，为2代表咬尾
% code为编码后的输出序列
    if tail==0
        signal = [0 0 0 signal];
    elseif tail==1
        signal = [0 0 0 signal 0 0 0];
    else
        signal = [signal(end-2) signal(end-1) signal(end) signal];
    end
    
    len = length(signal);
    code = [];
    
    if mode_code==1   %1/2编码
        A0 = [1,1];
        A1 = [1,1];
        A2 = [0,1];
        A3 = [1,1];

        for m = 1:len-3
            y1 = mod(signal(m+3)*A0(1)+signal(m+2)*A1(1)+signal(m+1)*A2(1)+signal(m)*A3(1),2);
            y2 = mod(signal(m+3)*A0(2)+signal(m+2)*A1(2)+signal(m+1)*A2(2)+signal(m)*A3(2),2);
            code = [code y1 y2];
        end
    else    %1/3编码
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

