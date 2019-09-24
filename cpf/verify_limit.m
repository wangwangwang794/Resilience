function [done,within_limit] = verify_limit(v, q, i, vstack, qstack, istack, done)

vv = 0;
qq = 0;
ii = 0;
within_limit = 0;

if all(v <= vstack(:,2))
    if all(v >= vstack(:,3))
%         fprintf('V within limit\n')
        vv = 1;
    end
end

if all(i <= istack(:))
%     fprintf('I within limit\n')
    ii = 1;
end

if all(q <= qstack(:,2))
    if all(q >= qstack(:,3))
%         fprintf('Q within limit\n')
        qq = 1;
    end
end

if qq && vv && ii
    within_limit = 1;
    if done == 10 
        done = 1;
    end
end