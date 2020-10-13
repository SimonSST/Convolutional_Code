function info = viterbi_soft(receive)
effic = 3;%编码效率
info_num = length(receive);%译码长度
state = 0:7;%8个状态
y1 = [1 0 1 1];
y2 = [1 1 0 1];
y3 = [1 1 1 1];
state_num = length(state);%状态数，2^3
road = zeros(state_num,info_num);%保存路径
measure = zeros(2,state_num)+12*(state>0);%初始化度量值，0状态以外设高防止选择,两行交替使用
for m = 1:info_num
    level = receive(m);%当前状态对应复电平
    for n = 1:state_num
        state_bin = (str2num((dec2bin(state(n),3))'))';%当前状态的二进制表示
        state_pre1 = [state_bin(2:end),0];
        state_pre2 = [state_bin(2:end),1];%之前可能的两个状态
        line1 = [state_bin(1),state_pre1];
        line2 = [state_bin(1),state_pre2];
        out1 = mod([line1*y1',line1*y2',line1*y3'],2);
        out2 = mod([line2*y1',line2*y2',line2*y3'],2);%之前两个状态到此状态的输出
        std1 = PSK8(out1,3);
        std2 = PSK8(out2,3);%标准电平
        distance1 = sqrt((real(level) - real(std1))^2 + (imag(level) - imag(std1))^2);
        distance2 = sqrt((real(level) - real(std2))^2 + (imag(level) - imag(std2))^2);%计算欧式距离
        state_pre1 = bin2dec(num2str(state_pre1));%转换为10进制
        state_pre2 = bin2dec(num2str(state_pre2));
        if(measure(1+mod(m+1,2),state_pre1+1)+distance1 < measure(1+mod(m+1,2),state_pre2+1)+distance2)
            measure(1+mod(m,2),n) = measure(1+mod(m+1,2),state_pre1+1) + distance1;
            road(n,m) = state_pre1+1;
        else
            measure(1+mod(m,2),n) = measure(1+mod(m+1,2),state_pre2+1) + distance2;
            road(n,m) = state_pre2+1;            
        end
    end
end
%反推得到结果
which = 1+mod(info_num,2);%measure的哪一行是结果
[whatever,where] = min(measure(which,:));
info = zeros(1,info_num);%结果
state_decode = where;%反推解码的当前状态
state_decode_bin = str2num((dec2bin(state_decode-1,3))');%二进制形式
info(info_num) = state_decode_bin(1);%第一位即为输入
for m = 1:info_num - 1
    state_decode = road(state_decode,info_num - m + 1);%根据road矩阵找到上一个状态
    state_decode_bin = str2num((dec2bin(state_decode-1,3))');%二进制形式
    info(info_num - m) = state_decode_bin(1);
end
info = info(1:end-3);
end

function reflect=PSK8(code,A)
code=code.*2-1;%0，1变为-1，1
k=1:3:length(code);%三个一组编码
reflect((k+2)/3)=sqrt(A)*code(k).*cos(pi/4-code(k+2)*pi/8)...
    +sqrt(A)*1j*code(k+1).*sin(pi/4-code(k+2)*pi/8);
end

