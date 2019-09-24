function [n, actb, actl, actt, actg] = getactive()

global buscon linecon pqcon pvcon swcon syncon faultcomp_tot faulttype_tot

discl = find(linecon(:,end) == 0);
linecon(discl,:) = [];
discg = find(syncon(:,end) == 0);
syncon(discg,:) = [];

actb = setdiff(buscon(:,1),syncon(:,1));
nb = length(actb);
idxl = find(linecon(:,7) == 0);
actl = linecon(idxl,[1,2]);
nl = length(idxl);
idxt = find(linecon(:,7) ~= 0);
actt = linecon(idxt,[1,2]);
nt = length(idxt);
actg = syncon(:,1);
ng = length(actg);

n = nb + nl + nt + ng;

faultcomp_tot = {};
faulttype_tot = {};

for zz = 1:nl
    faultcomp_tot{zz} = actl(zz,:);
    faulttype_tot{zz} = 'line';
end

for zz = nl + 1:nl + nt
    faultcomp_tot{zz} = actt(zz - nl,:);
    faulttype_tot{zz} = 'trafo';
end

for zz = nl + nt + 1:nl + nt + ng
    faultcomp_tot{zz} = actg(zz - nl - nt);
    faulttype_tot{zz} = 'gen';
end

for zz = nl + nt + ng + 1:nl + nt + ng + nb
    faultcomp_tot{zz} = actb(zz - nl - nt - ng);
    faulttype_tot{zz} = 'bus';
end
