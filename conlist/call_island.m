fprintf('\nI am in call island\n')

island_to_vst = 0;

buscon = event{island_id}.bus;
linecon = event{island_id}.line;
pqcon = event{island_id}.pq;
pvcon = event{island_id}.pv;
swcon = event{island_id}.sw;
syncon = event{island_id}.syn;
faultcomp_tot = event{island_id}.faultcomp_tot;
faulttype_tot = event{island_id}.faulttype_tot;
k = event{island_id}.k;
level = event{island_id}.level;
base = island_id;

load_island = 1;
