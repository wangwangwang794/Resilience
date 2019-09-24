global event psatpath
fprintf('\n I am in get_sep_tcr\n')

buscon = event{im}.bus;
linecon = event{im}.line;
pqcon = event{im}.pq;
swcon = event{im}.sw;
syncon = event{im}.syn;
pvcon = event{im}.pv;

if isempty(swcon)
    set_sw
end 

addpath(psatpath)
initpsat
runpsat('data_sens.m',pwd,'data')
runpsat_rev_con('pf')
event{im}.delta0 = DAE.x(Syn.delta);
event{im}.omega0 = DAE.x(Syn.omega);
rmpath(psatpath)
