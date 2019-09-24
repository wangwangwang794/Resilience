function [start,stop] = get_range(time, R, X, id)

global fault_time fault_dur

start = find(time == fault_time + fault_dur);

check = 3;
dec_now = 0;
inc_now = 0;
for stop = start+1:length(time)
    dec_old = dec_now;
    inc_old = inc_now;
    z_last = abs(R(stop-1,id)+1j*X(stop-1,id));
    z_cur = abs(R(stop,id)+1j*X(stop,id));
    if abs(z_cur - z_last) <=0.00001
        break
    end
    if z_cur > z_last
        inc_now = 1;
        dec_now = 0;
    elseif z_cur < z_last
        inc_now = 0;
        dec_now = 1;
    end
    if (dec_now ~= dec_old)||(inc_now ~= inc_old)
        check = check - 1;
    end  
    if check == 0
        break
    end
end

stop = stop - 1;