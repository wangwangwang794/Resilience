function loss = get_loadloss(island_id)

global event

load = 0;

for i = 1:length(island_id)
    island_id(i)
    load = load + event{island_id(i)}.load;
end
% init_load = sum(event{1}.pq(:,4)) + 1i*sum(event{1}.pq(:,5));
loss = abs(event{1}.load - load)/abs(event{1}.load);
