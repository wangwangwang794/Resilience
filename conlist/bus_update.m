global buses
wrng = 0;

bus_tot = [];
for bsi = 1:nislands
    bus_tot = [bus_tot buses{bsi}];
end

bus_tot = sort(bus_tot)

if ~issorted(buscon(:,1))||~(length(buscon(:,1)) == length(bus_tot))
    wrng = 1;
    wrngid = [wrngid top_no];
else
    wrng = 0;
end

if wrng == 0
    for bsi = 1:nislands
        for bsj = 1:length(buses{bsi})
            idbs = find(bus_tot == buses{bsi}(bsj));
            buses{bsi}(bsj) = buscon(idbs,1);
        end
    end
end
    