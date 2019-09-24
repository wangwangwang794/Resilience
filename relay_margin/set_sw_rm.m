function set_sw_rm(id)

global swcon pvcon event

syncon = event{id}.syn;
idxp = find(syncon(:,18) == max(syncon(:,18)));
pivot = syncon(idxp,1);

if pivot ~=swcon(1)||isempty(swcon)
    idxpv = find(pvcon(:,1) == pivot);
    pvtosw = pvcon(idxpv,:);
    if ~isempty(swcon)
        pvcon(idxpv,:) = [swcon(1:3) swcon(10) swcon(4) swcon(6:9) swcon(11) swcon(13)];
    else
        pvcon(idxpv,:) = [];
    end

    pvtosw(4) = [];
    swcon = [pvtosw(1:4) 0 pvtosw(5:8) 1 pvtosw(9) 1 pvtosw(10)]
end