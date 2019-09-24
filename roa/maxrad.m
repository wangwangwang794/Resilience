c = c_track(end);
syms x1 x2 x3 x4
x = [x1 x2 x3 x4];

for i = 1:vdim
    f_red(3*i - 2) = sin(x(2*i - 1));
    f_red(3*i - 1) = 1 - cos(x(2*i - 1));
    f_red(3*i) = x(2*i);
end
z1 = f_red(1);z2 = f_red(2);z3 = f_red(3);z4 = f_red(4);z5 = f_red(5);z6 = f_red(6);
temp_V = eval(V);
V1 = eval(temp_V);
x2 = 0;x4 = 0;
V2 = eval(temp_V);

% x = [x1 x2 x3 x4];
% Vx = taylor(V,x,'Order',7);
% 
% radmin = 0;
% radmax = up_limit;
% rad = radmax;
% delta_rad = rad - radmin;
% circ = sum(x.*x);
% iter_rad = 0;
% 
% while(1)
%     prog = sosprogram(x);
%     [prog,s] = sospolyvar(prog,monomials(x,[0 1 2 3 4]));
%     prog = sosineq(prog,s);
%     prog = sosineq(prog, -s*(rad - circ) - (Vx - c));
%     solver_opt.solver = 'sedumi';
%     evalc('[prog,info] = sossolve(prog,solver_opt)');
% %     [prog,info] = sossolve(prog,solver_opt)
%     check_feas = ~info.numerr&~info.pinf&~info.dinf;
%     iter_rad = iter_rad + 1
%     delta_rad = rad - radmin;
%     if check_feas
%         radmin = rad;  
%         rad = (radmin + radmax)*0.5;
%     else
%         if delta_rad < eps
%             break
%         end
%         radmax = rad;
%         rad = (radmin + radmax)*0.5;
%     end    
% end