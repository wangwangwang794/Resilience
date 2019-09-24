function [start,min_dist] = get_nearest(points, line_id)

global Line

start = 1;
z_line = Line.con(line_id,8) + 1j*Line.con(line_id,9);
zone_z = 2*z_line;
mho_center = zone_z/2;
a = abs(zone_z/2);
c = [real(mho_center); imag(mho_center)];

for i = 1:length(points(1,:))
    p = points(:,i);
    if norm(p-c) <= a
        start = Inf;
        min_dist = 0;
        return
    end
    if isinf(p)
        dist(i) = Inf;
        continue
    end
    cvx_begin quiet
        variable x(2)
        minimize(norm(x-p));
        subject to 
            norm(x-c)<=a;
    cvx_end
    dist(i) = cvx_optval;
end

min_dist = min(dist);
