fprintf('\n I am in get_sep\n')
if blckout == 0
    if isempty(swcon)
        set_sw
    end 
    initpsat
    datadir
    runpsat('data.m',datadir,'data')
    runpsat_rev_con('pf')
    delta0 = DAE.x(Syn.delta);
    omega0 = DAE.x(Syn.omega);
else
    delta0 = [];
    omega0 = [];
end
