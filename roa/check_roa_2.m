%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Define System and Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q = 10^-3*sum(z.*z);

r = sum(z.*z);

beta = 0.3;
up_limit = 0.1;

cmaxg = up_limit;
cming = 0;
gmaxg = up_limit;
gming = 0;

eps = 0.0001;
eps_p = eps*1;

delta_p = eps + 1;
delta_g = eps + 1;

p = -1.5*z1*z4 - 0.5*z2*z5;
for i = 1:dim
    p = p + z(i)^2;
end
% p = sum(z.*z);

ch = children(p);
for i = 1:length(ch)
    pc(i) = coeffs(ch(i));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Initializing SOSP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prog = sosprogram(z);

[prog,V] = sospolyvar(prog,monomials(z,[1,2]));
[prog,s2] = sospolyvar(prog,monomials(z,[0 1 2]));
[prog,v1] = sospolymatrixvar(prog,monomials(z,[0 1 2]),[1,vdim]);
[prog,v3] = sospolymatrixvar(prog,monomials(z,[0 1 2]),[1,vdim]);

[prog,ss1] = sospolyvar(prog,monomials(z,[0 1]));
[prog,ss2] = sospolyvar(prog,monomials(z,[0 1]));
[prog,ss3] = sospolyvar(prog,monomials(z,[0 1]));
[prog,ss4] = sospolyvar(prog,monomials(z,[0 1]));

Vdot = (jacobian(V,z)*f); 

prog = sosineq(prog,s2);
prog = sosineq(prog,ss1);
prog = sosineq(prog,ss2);
prog = sosineq(prog,ss3);
prog = sosineq(prog,ss4);

prog = sosineq(prog, V - v1*g - q*ss3 - ss4);
prog = sosineq(prog,-s2*(beta - r) - Vdot - v3*g - q*ss1 - ss2);

solver_opt.solver = 'sedumi';

evalc('[prog,info] = sossolve(prog,solver_opt)');
% [prog,info] = sossolve(prog,solver_opt);

check_feas = ~(info.feasratio<0.95)&~info.pinf&~info.dinf;
if ~check_feas
    fprintf('The defined system and its equilibrium does not correspond to stability\n')
    fprintf('Recursive sum of squares problem cannot be initialized. Aborting...\n')
%     return
end
V = sosgetsol(prog,V);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Start main SOSP Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

g_track = [0];
c_track = [0];
vol_track = [];
p_track = [max(abs(pc))];
V_track = [V];
brk = 0;
iter_c = 0;
iter_g = 0;
iter_out = 0;
skp = 0;
delta_c = eps*2;
delta_g = eps*2;
delta_p = eps_p*2;
gamma = 0;

while(1)
% while(delta_g >= eps || delta_c >= eps || delta_p >= eps_p)
    c_old = cming;
    c = cmaxg;
    while (1) 
        c = c
        prog = sosprogram(z);
        [prog,s1] = sospolyvar(prog,monomials(z,[0 1]));
        [prog,s2] = sospolyvar(prog,monomials(z,[0 1 2]));
        [prog,s3] = sospolyvar(prog,monomials(z,[0 1 2]));
        [prog,v2] = sospolymatrixvar(prog,monomials(z,[0 1]),[1,vdim]);
        [prog,v3] = sospolymatrixvar(prog,monomials(z,[0 1 2]),[1,vdim]);
        [prog,ss1] = sospolyvar(prog,monomials(z,[0]));
        [prog,ss2] = sospolyvar(prog,monomials(z,[0]));
        [prog,ss3] = sospolyvar(prog,monomials(z,[0]));
        [prog,ss4] = sospolyvar(prog,monomials(z,[0]));
%         [prog,ss5] = sospolyvar(prog,monomials(z,[0]));
%         [prog,ss6] = sospolyvar(prog,monomials(z,[0]));
%         [prog,ss7] = sospolyvar(prog,monomials(z,[0]));

        Vdot = (jacobian(V,z)*f);

        prog = sosineq(prog,s1);
        prog = sosineq(prog,s2);
        prog = sosineq(prog,s3);
        prog = sosineq(prog,ss1);
        prog = sosineq(prog,ss2);
        prog = sosineq(prog,ss3);
        prog = sosineq(prog,ss4);
%         prog = sosineq(prog,ss5);
%         prog = sosineq(prog,ss6);
%         prog = sosineq(prog,ss7);
%         prog = sosineq(prog,-s2*(c - V) - s3*Vdot - v3*g - ss1*q - ss3 - ss5*(c - V)*Vdot - ss6*(c - V)*q);  
%         prog = sosineq(prog, -s1*(gamma - p) - v2*g - ss2*(V - c) - ss4 - ss7*(V - c)*(gamma - p));     
        prog = sosineq(prog,-s2*(c - V) - s3*Vdot - v3*g - q*ss1 - ss2);  
        prog = sosineq(prog, -s1*(gamma - p) - v2*g - (V - c)*ss3 - ss4); 
        
        solver_opt.solver = 'sedumi';
        evalc('[prog,info] = sossolve(prog,solver_opt)');
%         [prog,info] = sossolve(prog,solver_opt)
                                          
        check_feas = ~info.numerr&~info.pinf&~info.dinf;
        
        iter_c = iter_c + 1
        
        if check_feas
            if c == cming
                skp = 1;                           
            end
            cming = c;
            s2_old = sosgetsol(prog,s2);
            s3_old = sosgetsol(prog,s3);
            if c == cmaxg
                cmaxg = cmaxg*2;
                c_old = c;
                c = cmaxg;
            else
                s2 = s2_old;
                s3 = s3_old;
                break
            end
        else
            cmaxg = c;
            c_old = c;
            c = (cming + c)/2;
        end
        
        if cmaxg - cming<=eps
            c = cming;
            s2 = s2_old;
            s3 = s3_old;
            break
        end
    end
    c_old;
    c;
    cming = cming;
    cmaxg = cmaxg;
    gamma = gmaxg;
    gamma_old = gming;
    while(1)
        if skp == 1
            break
        end
        gamma = gamma          
        prog = sosprogram(z);

        [prog,V] = sospolyvar(prog,monomials(z,[1,2]));
        [prog,s1] = sospolyvar(prog,monomials(z,[0 1]));
        [prog,v2] = sospolymatrixvar(prog,monomials(z,[0 1]),[1,vdim]);
        [prog,v3] = sospolymatrixvar(prog,monomials(z,[0 1 2]),[1,vdim]);
        [prog,ss1] = sospolyvar(prog,monomials(z,[0]));
        [prog,ss2] = sospolyvar(prog,monomials(z,[0]));
        [prog,ss3] = sospolyvar(prog,monomials(z,[0]));

        Vdot = (jacobian(V,z)*f); 

        prog = sosineq(prog,s1);
        prog = sosineq(prog,ss1);
        prog = sosineq(prog,ss2);
        prog = sosineq(prog,ss3);
        prog = sosineq(prog, -s1*(gamma - p) - v2*g - (V - c) - ss1);
        prog = sosineq(prog, -s2*(c - V) - s3*Vdot - v3*g - q*ss2 - ss3);

        solver_opt.solver = 'sedumi';
        evalc('[prog,info] = sossolve(prog,solver_opt)');
%         [prog,info] = sossolve(prog,solver_opt)

        check_feas = ~info.numerr&~info.pinf&~info.dinf;
        
        iter_g = iter_g + 1
        
        if check_feas
            gming = gamma; 
            
            V_old = sosgetsol(prog,V);
            if gamma == gmaxg
                gmaxg = gmaxg*2;
                gamma_old = gamma;
                gamma = gmaxg;
            else
                V = V_old;
                break
            end
        else
            gmaxg = gamma;
            gamma_old = gamma;
            gamma = (gming + gamma)/2;
        end        
        if gmaxg - gming<=eps
            V = V_old;
            gamma =gming;
            break
        end
    end
    gming = gming;
    gmaxg = gmaxg;
    g_track = [g_track;gamma]
    c_track = [c_track;c]
%     z2x
    get_vol
    if ~isempty(vol_track)
        eps_vol = vol - vol_track(end);
        if eps_vol <= eps*100
            brk = 1;
        end
    end
    vol_track = [vol_track;vol]
    p = V;   
    ch = children(p);
    for i = 1:length(ch)
        pc(i) = coeffs(ch(i));
    end
    delta_p = max(abs(pc)) - p_track(end);
    delta_c = c_track(end) - c_track(end-1);
    delta_g = g_track(end) - g_track(end-1);
    p_track = [p_track;max(abs(pc))] 
    V_track = [V_track;V]
    iter_out = iter_out + 1   
    if length(c_track)>=2
        cmaxg = cming + abs(c_track(end) - c_track(end - 1));
        gmaxg = gming + abs(g_track(end) - g_track(end - 1));
    else
        cmaxg = up_limit;
        gmaxg = up_limit;
    end
    if brk == 1
        break
    end
end

%---------------Obtain largest inscribing circle-------------------------

% radmin = 0;
% rad = 15;
% delta_rad = rad - radmin;
% rad_old = [];
% circ = sum(z.*z);
% iter_rad = 0;
% while(1)
%     prog = sosprogram(z);
%     [prog,s4] = sospolyvar(prog,monomials(z,[0,1,2]));
%     prog = sosineq(prog,s4);
%     prog = sosineq(prog, -s4*(rad - circ) - (V - c));
%     solver_opt.solver = 'sedumi';
%     evalc('[prog,info] = sossolve(prog,solver_opt)');
% %     [prog,info] = sossolve(prog,solver_opt)
%     check_feas = ~info.numerr&~info.pinf&~info.dinf;
%     iter_rad = iter_rad + 1
%     delta_rad = rad - radmin;
%     if check_feas
%         radmin = rad;
%         if isempty(rad_old)
%             rad = 2*rad;
%         else
%             rad = rad_old;
%         end
%     else
%         if delta_rad < eps
%             break
%         end
%         rad_old = rad;
%         rad = (radmin + rad)*0.5;
%     end    
% end