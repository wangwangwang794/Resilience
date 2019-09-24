idxp = find(syncon(:,18) == max(syncon(:,18)));
pivot = syncon(idxp,1);

idxpv = find(pvcon(:,1) == pivot);
pvtosw = pvcon(idxpv,:);
pvcon(idxpv,:) = [];

pvtosw(4) = [];
swcon = [pvtosw(1:4) 0 pvtosw(5:8) 1 pvtosw(9) 1 pvtosw(10)];