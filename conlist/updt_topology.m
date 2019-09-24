fprintf('\n I am in updt_topology\n')
dlt = 0;
for jj = 1:length(buscon(:,1))
    if isempty(intersect(buscon(jj - dlt,1),buses{ii}))
        buscon(jj - dlt,:) = [];
        dlt = dlt + 1;
    end
end       
dlt = 0;
for jj = 1:length(linecon(:,1))
    if length(intersect(linecon(jj - dlt,1:2),buses{ii})) ~= 2
        linecon(jj - dlt,:) = [];
        dlt = dlt + 1;
    end
end
dlt = 0;
for jj = 1:length(pqcon(:,1))
    if isempty(intersect(pqcon(jj - dlt,1),buses{ii}))
        pqcon(jj - dlt,:) = [];
        dlt = dlt + 1;
    end
end
dlt = 0;
for jj = 1:length(swcon(:,1))
    if isempty(intersect(swcon(jj - dlt,1),buses{ii}))
        swcon(jj - dlt,:) = [];
        dlt = dlt + 1;
    end
end
dlt = 0;
for jj = 1:length(syncon(:,1))
    if isempty(intersect(syncon(jj - dlt,1),buses{ii}))
        syncon(jj - dlt,:) = [];
        dlt = dlt + 1;
    end
end
dlt = 0;
for jj = 1:length(pvcon(:,1))
    if isempty(intersect(pvcon(jj - dlt,1),buses{ii}))
        pvcon(jj - dlt,:) = [];
        dlt = dlt + 1;
    end
end
