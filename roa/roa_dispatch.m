global buscon linecon pqcon swcon syncon pvcon roa tcr cpf
global event psatpath

buscon = event{im}.bus;
linecon = event{im}.line;
pqcon = event{im}.pq;
swcon = event{im}.sw;
syncon = event{im}.syn;
pvcon = event{im}.pv;

if isempty(swcon)
    set_sw
end  

roa = 1;

addpath(psatpath)
initpsat;
runpsat_rev('data.m',pwd,'data');
runpsat_rev('pf');

U = Line.u;
nb = Bus.n;
Fr = Line.fr;
To = Line.to;

connect_mat = ...
sparse(Fr,Fr,1,nb,nb) + ...
sparse(Fr,To,U,nb,nb) + ...
sparse(To,To,1,nb,nb) + ...
sparse(To,Fr,U,nb,nb);

G = graph(full(connect_mat));
bins = conncomp(G);
island_no = max(bins);
Line = build_y(Line);
islands(Line);
fm_flows('connectivity','verbose');

Vm = DAE.y(Bus.n + 1:2*Bus.n);
Yred = gety_red(Vm);
delta = DAE.x(Syn.delta)'; 
ref = 3;
w = DAE.x(Syn.omega)';
D = Syn.con(:,19)';
M = Syn.con(:,18)/(2*pi*freq);    
Pm = DAE.y(Syn.pm)';   
E = DAE.y(Syn.vf)';

rmpath(psatpath)

roa = 0;

if length(syncon(:,1)) == 3
    sos_convert_3
    V_track(end)
    c_track(end)
    get_vol    
    event{im}.roa_vol = vol;
    z2x
    event{im}.V = matlabFunction(V1);
    event{im}.c = c_track(end);
elseif length(syncon(:,1)) == 2
    sos_convert_2
    get_vol    
    event{im}.roa_vol = vol;
    z2x
    event{im}.V = matlabFunction(V1);
    event{im}.c = c_track(end);
elseif length(syncon(:,1)) == 1
    event{im}.roa_vol = Inf;
end 
    


