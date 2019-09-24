function rt = get_rt(con_id1,con_id2)

global RT RT_lab rt_hat event

for i = 1:4
    if strcmp(RT_lab{i},event{con_id1}.faulttype)
        break
    end
end
rt_tot = RT(i);

if ~isempty(con_id2)
    for i = 1:4
        if strcmp(RT_lab{i},event{con_id2}.faulttype)
            break
        end
    end
    rt_tot = rt_tot + RT(i);
end

rt = rt_tot/rt_hat;

