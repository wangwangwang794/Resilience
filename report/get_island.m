function island_id = get_island(pivot)

global event

island_id = pivot;

if event{pivot}.island == 1
    islnd_tmp = pivot;
    while(1)
        islnd_tmp = islnd_tmp + 1;
        if islnd_tmp <= length(event)
            if event{islnd_tmp}.island>1 
                island_id = [island_id islnd_tmp];
            else
                break
            end
        else
            break
        end
    end
end