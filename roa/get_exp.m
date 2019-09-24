% syms x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 x20
% x = [x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 x20];

syms x1 x2 x3 x4 x5 x6
x = [x1 x2 x3 x4 x5 x6];

% syms x1 x2 x3 x4 x5 x6 x7 x8 x9 x10
% x = [x1 x2 x3 x4 x5 x6 x7 x8 x9 x10];

% syms y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16 y17 y18
% y = [y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16 y17 y18];

syms y1 y2 y3 y4
y = [y1 y2 y3 y4];

x(2*ref-1) = 0;
x(2*ref) = 0;

skp = 0;
for i = 1:2*n
    if (i == 2*ref)||(i == 2*ref - 1)
        skp = skp + 1;
    else
        x(i) = y(i-skp) + x0(i-skp);
    end
end

clear temp

for i = 1:n
    for j = 1:n
        temp(j,1) = E(i)*E(j)*Y(i, j)*cos(th(i, j)-x(2*i-1)+x(2*j-1));
    end
    Pe(i) = ones(1,n)*temp;
end

for i = 1:2*n
    if rem(i,2) ~= 0
        f1(i,1) = x(i+1);
    else
        j = i/2;
        f1(i,1) = (1/M(j))*(-D(j)*x(i) + (Pm(j) - Pe(j)));
    end    
end

f1(2*ref - 1) = [];
f1(2*ref - 1) = [];
x(2*ref - 1) = [];
x(2*ref - 1) = [];