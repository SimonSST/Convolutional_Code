function reflect = PSK(code)
%编码到电平
code = code.*2-1;%0，1变为-1，1
k = 1:3:length(code);%三个一组编码
reflect((k+2)/3)=code(k).*cos(pi/4-code(k+2)*pi/8)...
    +1j*code(k+1).*sin(pi/4-code(k+2)*pi/8);
end