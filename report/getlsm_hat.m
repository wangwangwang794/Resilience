function lsm_hat = getlsm_hat(island_id,lsm)

global event

island_id = island_id(~(lsm == 50000));
lsm = setdiff(lsm,50000);

load_inc = 0;

for i = 1:length(island_id)
    load_inc = load_inc + lsm(i)*event{island_id(i)}.load;
end

lsm_hat = abs(load_inc)/abs(event{1}.gamma_max * event{1}.load);

