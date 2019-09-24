global wrngid

level = level + 1;

faultcomp = faultcomp_tot{1}
faultcomp_tot{1} = {};
faulttype = faulttype_tot{1};
faulttype_tot{1} = {};
faultcomp_tot = faultcomp_tot(~cellfun('isempty',faultcomp_tot));
faulttype_tot = faulttype_tot(~cellfun('isempty',faulttype_tot));

if load_parent == 1
    base = base
    load_parent = 0;
    event{base}.faultcomp_tot = faultcomp_tot;
    event{base}.faulttype_tot = faulttype_tot;
    actb_tot = event{base}.act_tot(1);
    actl_tot = event{base}.act_tot(2);
    actt_tot = event{base}.act_tot(3);
    actg_tot = event{base}.act_tot(4);
elseif load_island == 1
    load_island = 0;
    event{island_id}.faultcomp_tot = faultcomp_tot;
    event{island_id}.faulttype_tot = faulttype_tot;
    actb_tot = event{island_id}.act_tot(1);
    actl_tot = event{island_id}.act_tot(2);
    actt_tot = event{island_id}.act_tot(3);
    actg_tot = event{island_id}.act_tot(4);
else
    event{top_no}.faultcomp_tot = faultcomp_tot;
    event{top_no}.faulttype_tot = faulttype_tot;
    base = top_no;
    actb_tot = event{top_no}.act_tot(1);
    actl_tot = event{top_no}.act_tot(2);
    actt_tot = event{top_no}.act_tot(3);
    actg_tot = event{top_no}.act_tot(4);
end

[n, actb, actl, actt, actg] = getactive();  

buscon_actual = buscon;
buscon(:,1)'
switch faulttype
    case 'bus'
        prob = p(1)/(length(actb) +  actb_tot);
        idx = find(buscon_actual(:,1) == faultcomp);
        buscon_actual(idx) = [];
%         k = k + 1;        
        idx = find((linecon(:,1) == faultcomp) | (linecon(:,2) == faultcomp));
        linecon(idx,:) = [];
        k = k + length(idx);
        swidx = find(syncon(:,1) == faultcomp);
        syncon(swidx,:) = [];
        k = k + length(swidx);
        if ~isempty(pvcon)
            idx = find(pvcon(:,1) == faultcomp);
            if ~isempty(idx)
                pvcon(idx,:) = [];
            end
        end
        if ~isempty(swcon)
            idx = find(swcon(:,1) == faultcomp);
            if ~isempty(idx)
                swcon(idx,:) = [];
            end
        end
    case 'line'
        prob = p(2)/(length(actl) +  actl_tot)
        k = k + 1;
        idx = find((linecon(:,1) == faultcomp(1)) & (linecon(:,2) == faultcomp(2)));
        linecon(idx,:) = [];
    case 'trafo'
        prob = p(3)/(length(actt) + actt_tot);
        k = k + 1;
        idx = find((linecon(:,1) == faultcomp(1)) & (linecon(:,2) == faultcomp(2)));
        linecon(idx,:) = [];
    case 'gen'
        prob = p(4)/(length(actg) + actg_tot);
        k = k + 1;
        swidx = find(syncon(:,1) == faultcomp);
        syncon(swidx,:) = [];
        if ~isempty(pvcon)
            idx = find(pvcon(:,1) == faultcomp);
            if ~isempty(idx)
                pvcon(idx,:) = [];
            end
        end
        if ~isempty(swcon)
            idx = find(swcon(:,1) == faultcomp);
            if ~isempty(idx)
                swcon(idx,:) = [];
            end
        end
end

top_no = top_no + 1;   

initpsat
runpsat('data.m',datadir,'data')
runpsat_rev_con('pf')
[buses,nislands] = getcomp();

bus_update