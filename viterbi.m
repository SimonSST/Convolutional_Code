function info = viterbi(recode)
effic = 3;%����Ч��
info_num = length(recode)/effic;%���볤��
state = 0:7;%8��״̬
y1 = [1 0 1 1];
y2 = [1 1 0 1];
y3 = [1 1 1 1];
state_num = length(state);%״̬����2^3
road = zeros(state_num,info_num);%����·��
measure = zeros(2,state_num)+12*(state>0);%��ʼ������ֵ��0״̬������߷�ֹѡ��,���н���ʹ��
for m = 1:info_num
    code_conv = double(recode(effic*(m-1)+1:effic*m));%��ǰ״̬��Ӧ�����
    for n = 1:state_num
        state_bin = (str2num((dec2bin(state(n),3))'))';%��ǰ״̬�Ķ����Ʊ�ʾ
        state_pre1 = [state_bin(2:end),0];
        state_pre2 = [state_bin(2:end),1];%֮ǰ���ܵ�����״̬
        line1 = [state_bin(1),state_pre1];
        line2 = [state_bin(1),state_pre2];
        out1 = mod([line1*y1',line1*y2',line1*y3'],2);
        out2 = mod([line2*y1',line2*y2',line2*y3'],2);%֮ǰ����״̬����״̬�����
        ham1 = sum(code_conv ~= out1);
        ham2 = sum(code_conv ~= out2);%���㺺������
        state_pre1 = bin2dec(num2str(state_pre1));%ת��Ϊ10����
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
%���Ƶõ����
which = 1+mod(info_num,2);%measure����һ���ǽ��
[whatever,where] = min(measure(which,:));
info = zeros(1,info_num);%���
state_decode = where;%���ƽ���ĵ�ǰ״̬
state_decode_bin = str2num((dec2bin(state_decode-1,3))');%��������ʽ
info(info_num) = state_decode_bin(1);%��һλ��Ϊ����
for m = 1:info_num - 1
    state_decode = road(state_decode,info_num - m + 1);%����road�����ҵ���һ��״̬
    state_decode_bin = str2num((dec2bin(state_decode-1,3))');%��������ʽ
    info(info_num - m) = state_decode_bin(1);
end
info = info(1:end-3);%ȥ����β��3��0
end

