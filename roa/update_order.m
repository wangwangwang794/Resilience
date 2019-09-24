function [tmpM,tmpPm,tmpE,tmpD,tmpw,tmpdelta,tmpYred] = update_order(M,Pm,E,D,w,delta,Yred,n,ref)

tmpM = M;
tmpPm = Pm;
tmpE = E;
tmpD = D;
tmpw = w;
tmpdelta = delta;
tmpYred = Yred;

tmpM(ref) = M(n);
tmpM(n) = M(ref);
tmpPm(ref) = Pm(n);
tmpPm(n) = Pm(ref);
tmpE(ref) = E(n);
tmpE(n) = E(ref);
tmpD(ref) = D(n);
tmpD(n) = D(ref);
tmpw(ref) = w(n);
tmpw(n) = w(ref);
tmpdelta(ref) = delta(n);
tmpdelta(n) = delta(ref);

for i = 1:n
    for j = 1:n
        if i == ref
            if j == ref
                tmpYred(i,j) = Yred(n,n);
            else
                tmpYred(i,j) = Yred(n,j);
            end
        elseif j == ref
            tmpYred(i,j) = Yred(i,n);
        end
        if i == n
            if j == n
                tmpYred(i,j) = Yred(ref,ref);
            else
                tmpYred(i,j) = Yred(ref,j);
            end
        elseif j == n
            tmpYred(i,j) = Yred(i,ref);
        end
    end
end