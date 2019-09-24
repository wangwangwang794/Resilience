clear
clc

global roa cpf tcr event im psatpath

p = [0.05 0.75 0.1 0.1];   % Set probability of fault (bus, line, generator, transformer)
con_length = 2;     % Set contingency length

cd(fileparts(which('main.m')));
addpath(strcat(pwd,'\conlist'));
addpath(strcat(pwd,'\roa'));
addpath(strcat(pwd,'\cpf'));
addpath(strcat(pwd,'\report'));
addpath(strcat(pwd,'\relay_margin'));
addpath(strcat(pwd,'\tcr'));
addpath(strcat(pwd,'\others'));

conlist(pwd, p, con_length);
load('eventlist','event');

roa = 0;
tcr = 0;
cpf = 0;
uniqlst = [];
freq = 60;
unique = 0;
duplct = 0;
gens_tcr = [];
 
for im = 1:length(event)  
    im = im
    if im>1
        for jm = 1:im-1
            if (all(size(event{im}.bus) == size(event{jm}.bus)))&&(all(size(event{im}.line) == size(event{jm}.line)))&&(all(size(event{im}.syn) == size(event{jm}.syn)))
                if (all(all(event{im}.bus == event{jm}.bus)))&&(all(all(event{im}.line == event{jm}.line)))&&(all(all(event{im}.syn == event{jm}.syn)))                
                    duplct = 1;
                    break
                end
            end
        end
    end
    if duplct == 1
        event{im}.roa_vol = event{jm}.roa_vol;
        event{im}.gamma_max = event{jm}.gamma_max;
        event{im}.load_loss = event{jm}.load_loss;
        event{im}.load = event{jm}.load;

        if ~(event{im}.roa_vol == Inf)            
            event{im}.V = event{jm}.V;
            event{im}.c = event{jm}.c;
        end
        
        if isfield(event{jm},'tcr')
            event{im}.tcr = event{jm}.tcr;
            event{im}.tcr_set = event{jm}.tcr_set;            
        else
            get_tcr
            gens_tcr = [gens_tcr im];
        end
        get_RM(im, pwd);
        duplct = 0;
        continue
    else
        unique = unique + 1;
        uniqlst = [uniqlst im];
        roa_dispatch 
        cpfcheck
        get_tcr
        get_RM(im, pwd);
    end
    duplct = 0;
end

gen_report(pwd)