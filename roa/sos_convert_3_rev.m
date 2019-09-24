% equilibrium state (del and w separately) and the ref, M, Pm, D, Yred E shall be the argument of the
% calling function
% for data file 'data01.m'

n = length(M);  % n is the nos of generators in network, n = 1 must correspond to the ref generator
dim = 3*(n - 1);
vdim = n - 1;
ref = find(M == max(M));

if ~(ref==n)
    [M,Pm,E,D,w,delta,Yred] = update_order(M,Pm,E,D,w,delta,Yred,n,ref);
end

Y = abs(Yred); th = angle(Yred);

delref = delta(n);
for i = 1:n-1
    del(i) = delta(i) - delref;
    w(i) = w(i) - w(n);
end

w = w(1:end-1);

for i = 1:2*vdim
    if rem(i,2) ~= 0
        x0(i) = del(ceil(i/2));
    else
        x0(i) = w(ceil(i/2));
    end
end

get_exp

syms z1 z2 z3 z4 z5 z6       %to be updated
z = [z1; z2; z3; z4; z5; z6];        %to be updated

for ii = 1:vdim
    f(3*(ii-1)+1,1) = (1 - z(ii*3-1))*z(ii*3);
    f(3*(ii-1)+2,1) = z(3*ii-2)*z(3*ii-1);
    ch1 = children(expand(f1(2*ii)));
    for j = 1:length(ch1)        
        check_condtns
        ch2(j,1) = subs(ch1(j));
        get_exp
        ch1 = children(expand(f1(2*ii)));
    end
    f(3*(ii-1)+3,1) = ones(1,length(ch1))*ch2;    
end

f = vpa(expand(f),6);

for i = 1:vdim
    ch = children(f(3*i));
    ch(end) = [];
    f(3*i) = ch*ones(length(ch),1);
end

for i = 1:vdim
    g(i,1) = z(3*(i - 1) + 1)^2 + z(3*(i - 1) + 2)^2 - 2*z(3*(i - 1) + 2);
end

check_roa




