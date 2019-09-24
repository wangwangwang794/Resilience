function gen_report(filedir)

% clear all
% clc

% load('U:\Uploaded_data\PHD\Research\Resilience of PS\MATLAB Codes\Sensitivity\Conlist_23rd Sep\test_1.mat','event');

global event RT RT_lab RES cct_hat rm_const

w = [1 1 1 1 1];
RT = [10 4 48 24];
RT_lab = {'line' 'bus' 'gen' 'trafo'};
cct_hat = 1000;
rm_const = 2;
roavols = [1 1 1 1]*event{1}.roa_vol;

tot_load = event{1}.load;

conset{1} = [];
conset{2} = [];

for gi = 1:length(event)
    if event{gi}.level == 2 && event{gi}.island <= 1
        conset{2} = [conset{2},gi];
    end
    if event{gi}.level == 1 && event{gi}.island <= 1
        conset{1} = [conset{1},gi];
    end
end

for dep = 1:2
    event_seq = {};
    res = [];
%     for gcon = 6:6 
    for gcon = 1:length(conset{dep})        
        con_id = conset{dep}(gcon);
        
        if dep == 2
            con_id1 = con_id;
            con_id2 = event{con_id}.base;
            if length(event{con_id1}.faultcomp) == 2
                event2 = strcat(abbrev(event{con_id1}.faulttype),num2str(event{con_id1}.faultcomp(1)),num2str(event{con_id1}.faultcomp(2)));
            else
                event2 = strcat(abbrev(event{con_id1}.faulttype),num2str(event{con_id1}.faultcomp));
            end
            p2 = event{con_id1}.prob;
            if length(event{con_id2}.faultcomp) == 2
                event1 = strcat(abbrev(event{con_id2}.faulttype),num2str(event{con_id2}.faultcomp(1)),num2str(event{con_id2}.faultcomp(2)));
            else
                event1 = strcat(abbrev(event{con_id2}.faulttype),num2str(event{con_id2}.faultcomp));
            end
            p1 = event{con_id2}.prob;
            p = p1*p2;
            island_id1 = get_island(con_id1);
            island_id2 = get_island(con_id2);
            [tsmcctlsmrm1,lsm_tot1] = get_island_data(island_id1);         
            [tsmcctlsmrm2, lsm_tot2] = get_island_data(island_id2);
            ntsmcctlsmrm1 = get_normalized(island_id1,tsmcctlsmrm1,roavols,tot_load);
            ntsmcctlsmrm2 = get_normalized(island_id2,tsmcctlsmrm2,roavols,tot_load);
            loss = get_loadloss(island_id1);
            lbase = 0;
            lbase = sum(event{1}.pq(:,4)) + 1j*sum(event{1}.pq(:,5));                       
            lsm_hat = lsm_tot1/abs(lbase);

%             lsm_hat = sum(setdiff(ntsmcctlsm1(end-2:end),50000))/event{1}.gamma_max;
            tsm_hat = min(min(ntsmcctlsmrm1(1:3)),min(ntsmcctlsmrm2(1:3)));
            rm_hat = min(min(ntsmcctlsmrm1(10:12)),min(ntsmcctlsmrm2(10:12)));
            if strcmp(event{con_id1}.faulttype,'gen')&&strcmp(event{con_id2}.faulttype,'gen')
                cct_fin = 1;
            else
                cct_fin = min([min(setdiff(ntsmcctlsmrm1(4:6),50000)),min(setdiff(ntsmcctlsmrm2(4:6),50000))]);
                if isinf(cct_fin) 
                    cct_fin = 1;
                end
            end               
%             rt = get_rt(con_id1,con_id2);
            metric = [lsm_hat tsm_hat rm_hat cct_fin (1-loss)];
            idx = w*metric'/norm(w,1);
            tsmcctrm2 = [tsmcctlsmrm2(1:3) tsmcctlsmrm2(4:6) tsmcctlsmrm2(10:12)];
            tsmcctrmlsm1 = [tsmcctlsmrm1(1:3) tsmcctlsmrm1(4:6) tsmcctlsmrm1(10:12) tsmcctlsmrm1(7:9)];
            res = [res; gcon p tsmcctrm2 tsmcctrmlsm1 tsm_hat cct_fin rm_hat lsm_hat loss idx];
            event_seq{gcon,1} = strcat(event1,' -->',event2);
        else
            if length(event{con_id}.faultcomp) == 2
                event_seq{gcon,1} = strcat(abbrev(event{con_id}.faulttype),num2str(event{con_id}.faultcomp(1)),num2str(event{con_id}.faultcomp(2)));
            else
                event_seq{gcon,1} = strcat(abbrev(event{con_id}.faulttype),num2str(event{con_id}.faultcomp));
            end
            p = event{con_id}.prob;
            island_id1 = get_island(con_id);
            [tsmcctlsmrm1, lsm_tot1] = get_island_data(island_id1);
            ntsmcctlsmrm1 = get_normalized(island_id1,tsmcctlsmrm1,roavols,tot_load);
            loss = get_loadloss(island_id1);
            lbase = sum(event{island_id1(1)}.pq(:,4)) + 1j*sum(event{island_id1(1)}.pq(:,5));
            lsm_hat = lsm_tot1/abs(lbase);
%             lsm_hat = sum(setdiff(ntsmcctlsm1(end-2:end),50000))/event{1}.gamma_max;
            tsm_hat = min(ntsmcctlsmrm1(1:3));
            rm_hat = min(ntsmcctlsmrm1(10:12));
            if strcmp(event{con_id}.faulttype,'gen')
                cct_fin = 1;
            else
                cct_fin = min(setdiff(ntsmcctlsmrm1(4:6),50000));
                if isinf(cct_fin)
                    cct_fin = 1;
                end
            end 
            metric = [lsm_hat tsm_hat rm_hat cct_fin (1-loss)];
            idx = w*metric'/norm(w,1);
            tsmcctrmlsm1 = [tsmcctlsmrm1(1:3) tsmcctlsmrm1(4:6) tsmcctlsmrm1(10:12) tsmcctlsmrm1(7:9)];
            res = [res; gcon p tsmcctrmlsm1 tsm_hat cct_fin rm_hat lsm_hat loss idx];
        end        
    end
    RES{dep}.event_seq = event_seq;
    RES{dep}.data = round(res,4);
    RES{dep}.idx = round(res(:,2)'*res(:,end),4);    
end
gen_excel(filedir);