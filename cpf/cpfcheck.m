global buscon linecon pqcon swcon syncon pvcon roa done ld_par 
global Varout nL nB cpf event psatpath

buscon = event{im}.bus;
linecon = event{im}.line;
pqcon = event{im}.pq;
swcon = event{im}.sw;
syncon = event{im}.syn;
pvcon = event{im}.pv;

if isempty(swcon)
    set_sw
end  

done = 10;
ld_par = 1;
ld_step = 0.01;
roa = 1;
cpf = 1;
count_no = 0;

addpath(psatpath)
initpsat;
runpsat_rev('data.m',pwd,'data');
Settings.init = 0;
runpsat_rev('pf');
CPF.vlim = 1;
CPF.ilim = 1;
CPF.qlim = 1;
CPF.type = 3;
CPF.linit = 1;
CPF.show = 0;
CPF.step = 0.1;
CPF.nump = 250;

nL = length(Line.con(:,1));
nB = length(Bus.con(:,1));

Varname.idx = [[DAE.n + Bus.n + 1:DAE.n + 2*Bus.n]';[DAE.n + DAE.m + Bus.n ...
    + 1:DAE.n + DAE.m + 2*Bus.n]';[(DAE.n + DAE.m + 2*Bus.n + 4*nL + 1):...
    (DAE.n + DAE.m + 2*Bus.n + 5*nL)]'];

while(done == 10)
    count_no = count_no + 1;
    runpsat('cpf');
    Settings.init = 0;
    SM = get_limit(); 
    ld_par_old = ld_par;    
    if ld_par <= 0
        ld_par = 0;
        SM = 0;
        break
    end
    ld_par = ld_par - ld_step;
end


if ld_par_old == 1
    event{im}.gamma_max = abs(SM*(sum(pqcon(:,4)) + 1i*sum(pqcon(:,5))))/abs(sum(event{1}.pq(:,4)) + 1i*sum(event{1}.pq(:,5)));
    event{im}.load_loss = 0;
else
    event{im}.gamma_max = 0;
    event{im}.load_loss = (1-ld_par_old)*(sum(pqcon(:,4)) + 1i*sum(pqcon(:,5)));
end
event{im}.load = sum(pqcon(:,4)) + 1i*sum(pqcon(:,5)) - event{im}.load_loss;

% event{im}.load_loss = event{im}.load_loss + ((1-ld_par_old)*(sum(pqcon(:,4)) + 1i*sum(pqcon(:,5))));

roa = 0;
cpf = 0;

rmpath(psatpath)