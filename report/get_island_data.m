function [tsmcctlsmrm, lsm_tot] = get_island_data(island_id)

global event

len = length(island_id);
tsm = [];
lsm = [];
cct = [];
rm = [];
lsm_tot = 0;

for i = 1:3
    if i>len
        lsm = [lsm 50000];
        tsm = [tsm 50000];
        cct = [cct 50000];
        rm = [rm 50000];
    else
        lbase = sum(event{island_id(i)}.pq(:,4)) + 1j*sum(event{island_id(i)}.pq(:,5));
        lsm_cur = lbase*max(0,event{island_id(i)}.gamma_max);
        lsm_tot = lsm_tot + lsm_cur;
        lsm = [lsm abs(lsm_cur)];
%         lsm = [lsm event{island_id(i)}.gamma_max];
        tsm = [tsm event{island_id(i)}.roa_vol];
        if strcmp(event{island_id(i)}.faulttype,'gen') 
            cct = [cct 50000];
        else
            cct = [cct event{island_id(i)}.tcr];
        end
        rm = [rm event{island_id(i)}.RM];
    end
end    

tsmcctlsmrm = [tsm cct lsm rm];
lsm_tot = abs(lsm_tot);