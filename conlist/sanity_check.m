 load('eventlist_ps1.mat','event');
 prob = 0;
 instance_old = {''};
 for ii = 2:length(event)
     instance = num2str(event{ii}.faultcomp);
     if strcmp(instance,instance_old)
         continue
     end
     if event{ii}.leaf == 1
         if event{ii}.level == 1
%              Fault1 = event{ii}.faultcomp
%              Prob1 = event{ii}.prob
            prob = prob + event{ii}.prob;
         elseif event{ii}.level == 2
%              Fault1 = event{event{ii}.base}.faultcomp
%              Prob1 = event{event{ii}.base}.prob
%              Fault2 = event{ii}.faultcomp
%              Prob2 = event{ii}.prob
             prob = prob + (event{ii}.prob)*(event{event{ii}.base}.prob);
         end
     end
     instance_old = instance;
 end