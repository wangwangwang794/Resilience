function ntsmcctlsmrm = get_normalized(island_id,tsmcctlsm, roavols, tot_load)

global event cct_hat rm_const

tsm = tsmcctlsm(1:3);
cct = tsmcctlsm(4:6);
lsm = tsmcctlsm(7:9);
rm = tsmcctlsm(10:12)

ncct = cct;
nlsm = lsm;
ntsm = tsm;
nrm = rm;


for i = 1:3
    if tsm(i)<50000
        ntsm(i) = tsm(i)/event{1}.roa_vol;
%         synid = event{island_id(i)}.syn(:,1);
%         switch norm(synid,1)
%             case 12
%                 ntsm(i) = ntsm(i)/roavols(1);
%             case 5
%                 ntsm(i) = ntsm(i)/roavols(2);
%             case 10
%                 ntsm(i) = ntsm(i)/roavols(3);
%             case 9
%                 ntsm(i) = ntsm(i)/roavols(4);
%         end
    end
    if rm(i) <50000
        nrm(i) = rm(i)/rm_const;
    end
end

% num = 0;
% den = 0;
% 
% for j = 1:length(island_id)
%     self_load = tot_load - event{island_id(j)}.load_loss;
%     num = num + self_load*(1+lsm(j));
%     den = den + self_load;    
% end
% lsm = abs(num)/abs(den);
% nlsm = (lsm - 1)/event{1}.gamma_max;

ntsmcctlsmrm = [ntsm ncct nlsm nrm];