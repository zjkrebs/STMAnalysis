% integrate the input matrix minput
% x is the first column of minput
% x has to be symmetric about 0, so it's length is even

function mout = integrate_yuanbo(minput)

x = minput(:,1);

length = size(x);

[length, width] = size(minput)

mout = minput*0;
mout(:,1)=x;

for i=2:width,
    y = minput(:,i);
    inty = y*0;
    inty(length/2) = -abs(x(length/2))*y(length/2);
    inty(length/2+1) = abs(x(length/2+1))*y(length/2+1);    
    for j=2:length/2,
        % for the positive part
        inty(length/2+j) = inty(length/2+j-1) + abs(x(length/2+j)-x(length/2+j-1))*(y(length/2+j)+y(length/2+j-1))/2;
        % for the negative part
        inty(length/2-j+1) = inty(length/2-j+2) - abs(x(length/2-j+1)-x(length/2-j+2))*(y(length/2-j+1)+y(length/2-j+2))/2;
    end
    mout(:,i) = inty;
end