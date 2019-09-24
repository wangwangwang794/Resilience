function [R,X,time,delta] = get_rxtd(nB, fr_bus, to_bus, Z_line)

global Varout Syn DAE

time = Varout.t;
delta = Varout.vars(:,Syn.delta);

fr_bus;

to_bus;

R = [];
X = [];

for i = 1:length(time)
    Theta = Varout.vars(i,DAE.n+1:DAE.n+nB)';   
    V = Varout.vars(i,DAE.n+nB+2:DAE.n+2*nB+1)';    
    V_fr = V(fr_bus).*(cos(Theta(fr_bus)) + 1j*sin(Theta(fr_bus)));  
    V_to = V(to_bus).*(cos(Theta(to_bus)) + 1j*sin(Theta(to_bus)));    
    I_fr = (V_fr - V_to)./Z_line;    
    I_to = -I_fr;
    Z_fr = V_fr./I_fr;
    Z_to = V_to./I_to;
    R = [R; real(Z_fr)' real(Z_to)'];
    X = [X; imag(Z_fr)' imag(Z_to)'];
end