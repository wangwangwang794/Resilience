fprintf('\n I am in check_leaf\n')
leaf = 0;
if isempty(pqcon(:,1))    
    [ntemp, actb, actl, actt, actg] = getactive();
    k = k + ntemp;
    fprintf('No load\n')
    leaf = 1
    blckout = 1;
end
if isempty(swcon(:,1))
    if isempty(pvcon(:,1))
        [ntemp, actb, actl, actt, actg] = getactive();
        k = k + ntemp;
        fprintf('No generation\n')
        leaf = 1
        blckout = 1;
        load_loss = load_loss + (sum(pqcon(:,4)) + 1i*sum(pqcon(:,5)));
    else
        set_sw        
    end
end

[ntemp, actb, actl, actt, actg] = getactive();

act = [length(actb) length(actl(:,1)) length(actt(:,1)) length(actg)];

if (blckout == 0) && (inisland == 1)
    actb_tot = actb_tot + length(actb);
    actl_tot = actl_tot + length(actl(:,1));
    actt_tot = actt_tot + length(actt(:,1));
    actg_tot = actg_tot + length(actg);
    act_tot = [actb_tot actl_tot actt_tot actg_tot];
end

if blckout == 1
    faultcomp_tot = {};
    faulttype_tot = {};
end

if level == con_depth
    fprintf('Con depth reached\n')
    leaf = 1
end


