fprintf('\nI am in call parent\n')

if base~=0
    while(isempty(event{base}.faultcomp_tot))
        base = event{base}.base;
        if base == 0
            checkisland = 1;
            break
        end
    end
else
    checkisland = 1;
end

if checkisland == 0
    buscon = event{base}.bus;
    linecon = event{base}.line;
    pqcon = event{base}.pq;
    pvcon = event{base}.pv;
    swcon = event{base}.sw;
    syncon = event{base}.syn;
    faultcomp_tot = event{base}.faultcomp_tot;
    faulttype_tot = event{base}.faulttype_tot;
    k = event{base}.k;
    level = event{base}.level;

    load_parent = 1;
end
