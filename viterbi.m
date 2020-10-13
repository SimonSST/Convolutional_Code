function info = viterbi(recode)
effic = 3;%编码效率
info_num = length(recode)/effic;%译码长度
state = 0:7;%8个状态
y1 = [1 0 1 1];
y2 = [1 1 0 1];
y3 = [1 1 1 1];
state_num = length(state);%状态数，2^3
road = zeros(state_num,info_num);%保存路径
measure = zeros(2,state_num)+12*(state>0);%初始化度量值，0状态以外设高防止选择,两行交替使用
for m = 1:info_num
    code_conv = double(recode(effic*(m-1)+1:effic*m));%当前状态对应卷积码
    for n = 1:state_num
        state_bin = (str2num((dec2bin(state(n),3))'))';%当前状态的二进制表示
        state_pre1 = [state_bin(2:end),0];
        state_pre2 = [state_bin(2:end),1];%之前可能的两个状态
        line1 = [state_bin(1),state_pre1];
        line2 = [state_bin(1),state_pre2];
        out1 = mod([line1*y1',line1*y2',line1*y3'],2);
        out2 = mod([line2*y1',line2*y2',line2*y3'],2);%之前两个状态到此状态的输出
        ham1 = sum(code_conv ~= out1);
        ham2 = sum(code_conv ~= out2);%计算汉明距离
        state_pre1 = bin2dec(num2str(state_pre1));%转换为10进制
        state_pre2 = bin2dec(num2str(state_pre2));
        if(measure(1+mod(m+1,2),state_pre1+1)+ham1 < measure(1+mod(m+1,2),state_pre2+1)+ham2)
            measure(1+mod(m,2),n) = measure(1+mod(m+1,2),state_pre1+1) + ham1;
            road(n,m) = state_pre1+1;
        else
            measure(1+mod(m,2),n) = measure(1+mod(m+1,2),state_pre2+1) + ham2;
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
info = info(1:end-3);%去掉收尾的3个0
end

