function dataout = val_translate(datain)

dataout = {};
for i = 1:length(datain)
    if isinf(datain(i))
        dataout{i,1} = 'Inf';
    elseif datain(i) == 50000
        dataout{i,1} = 'n/a';
    elseif datain(i) == 10000
        dataout{i,1} = 'Inf';
    elseif datain(i) == -1
        dataout{i,1} = 'n/a';
    else
        dataout{i,1} = datain(i);
    end
end