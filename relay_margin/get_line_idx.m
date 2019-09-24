function line_idx = get_line_idx(parent, child)

% line_idx = find((parent(:,7)== 0)&(parent(:,end)== 1)&(parent(:,9)>0.01));
line_idx = find((parent(:,7)== 0)&(parent(:,end)== 1));

found = 0;
del = 0;
tmp = line_idx;
for i = 1:length(line_idx)
    for j = 1:length(child(:,1))
        if all(parent(line_idx(i),1:2)==child(j,1:2))
            found = 1;
            break
        end
    end
    if found == 0
        tmp(i - del) = [];
        del = del + 1;
    end
    found = 0;
end
line_idx = tmp;
       