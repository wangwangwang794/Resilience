global xx0 xy0 dist nos line_out fault_time fault_dur 
global buscon linecon pqcon swcon syncon pvcon tcr
global Vr1 C synid roa cpf event ref_bus psatpath

if im == 1
    return
elseif strcmp(event{im}.faulttype,'gen')
    return
end

if event{im}.roa_vol == Inf
    event{im}.tcr = Inf;
    event{im}.tcr_set = Inf;
    return
end

get_sep_tcr  % to be deleted finally, already taken care in get_sep module
    
buscon = event{event{im}.base}.bus;
linecon = event{event{im}.base}.line;
pqcon = event{event{im}.base}.pq;
swcon = event{event{im}.base}.sw;
syncon = event{event{im}.base}.syn;
pvcon = event{event{im}.base}.pv;

if isempty(swcon)
    set_sw
end 

synid = [];
syncon_new = event{im}.syn;

j = 1;
for i = 1:length(syncon(:,1))
    if syncon(i,1) == syncon_new(j,1)
        synid = [synid, i];
        j = j + 1;
        if j > length(syncon_new(:,1))
            break
        end
    end
end

tcr = 1;
fault_dur = 1;      % shall be set to a reasonably higher value as compared to the guessed tcr
fault_time = 1;
settle_time = 5;
total_pnt = 20; 
tcr_set = [];
dist_max = 0.9;
dist_min = 0.1;

addpath(psatpath)
initpsat;
runpsat_rev('data.m',pwd,'data');

Vr1 = event{im}.V;
C = event{im}.c;
line_out = event{im}.faultcomp;     
dist = linspace(dist_min,dist_max,total_pnt);
xx0 = event{im}.delta0;
xy0 = event{im}.omega0;
ref_bus_id = find(event{im}.syn(:,18) == max(event{im}.syn(:,18)));
ref_bus = find(event{im}.bus(:,1) == event{im}.syn(ref_bus_id,1))

switch event{im}.faulttype
    case 'line'
        for nos = 1:length(dist)
            distance = dist(nos);
            runpsat_rev('pf');
            Settings.fixt = 1;
            Settings.tstep = 0.2;          
            Settings.tf = fault_time + fault_dur + settle_time;
            clpsat.refresh = 0;
            runpsat_rev('td');
            tcr_set = [tcr_set Varout.t(end)];
        end
    case 'bus'
        for nos = 1
            distance = dist(nos);
            runpsat_rev('pf');
            Settings.fixt = 1;
            Settings.tstep = 0.2;          
            Settings.tf = fault_time + fault_dur + settle_time;
            clpsat.refresh = 0;
            runpsat_rev('td');
            tcr_set = [tcr_set Varout.t(end)];
        end
    case 'trafo'
        tmp_trafo = line_out;        
        for nos = [1,2]
            distance = dist(nos);
            line_out = tmp_trafo(nos);
            runpsat_rev('pf');
            Settings.fixt = 1;
            Settings.tstep = 0.2;          
            Settings.tf = fault_time + fault_dur + settle_time;
            clpsat.refresh = 0;
            runpsat_rev('td');
            tcr_set = [tcr_set Varout.t(end)];
        end
end
event{im}.tcr = min(tcr_set-fault_time);
event{im}.tcr_set = tcr_set-fault_time;        
   
rmpath(psatpath)
tcr = 0;