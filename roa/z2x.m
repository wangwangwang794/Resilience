syms x1 x2 x3 x4               % to be updated
x = [x1 x2 x3 x4];             % to be updated

for i = 1:vdim
    f_red(3*i - 2) = sin(x(2*i - 1));
    f_red(3*i - 1) = 1 - cos(x(2*i - 1));
    f_red(3*i) = x(2*i);
end

z1 = f_red(1); z2 = f_red(2); z3 = f_red(3); z4 = f_red(4); z5 = f_red(5); z6 = f_red(6); % to be updated

temp_V = eval(V);
V1 = eval(temp_V);
