function get_RM(im, datadir)

global dist line_out fault_time fault_dur maxbus flt_type
global buscon linecon pqcon swcon syncon pvcon event psatpath

global Line time R X

if im == 1
    return
% elseif ~strcmp(event{im}.faulttype,'line')
%     event{im}.RM = Inf;
%     return
% elseif isempty(find((event{im}.line(:,7)== 0)&(event{im}.line(:,end)== 1)))
% elseif isempty(find((event{im}.line(:,7)== 0)&(event{im}.line(:,end)== 1)&(event{im}.line(:,9)>0.01)))
%     event{im}.RM = Inf;
%     return
end

% get_sep_tcr
buscon = event{event{im}.base}.bus;
linecon = event{event{im}.base}.line;
pqcon = event{event{im}.base}.pq;
swcon = event{event{im}.base}.sw;
syncon = event{event{im}.base}.syn;
pvcon = event{event{im}.base}.pv;

if strcmp(event{im}.faulttype,'line')
    flt_id = find((linecon(:,1) == event{im}.faultcomp(1))&(linecon(:,2) == event{im}.faultcomp(2)));
%     if linecon(flt_id,9)<=0.01
%         event{im}.RM = Inf;
%         return
%     end 
end

nB = length(buscon(:,1));

line_out = event{im}.faultcomp;
flt_type = event{im}.faulttype;

if isempty(swcon)
    set_sw
end

% synid = [];
% syncon_new = event{im}.syn;
% 
% j = 1;
% for i = 1:length(syncon(:,1))
%     if syncon(i,1) == syncon_new(j,1)
%         synid = [synid, i];
%         j = j + 1;
%         if j > length(syncon_new(:,1))
%             break
%         end
%     end
% end

fault_dur = 0.03;
fault_time = 1;

addpath(psatpath)
initpsat;
runpsat('data.m',datadir,'data');

dist = 0.5;
runpsat_rm('pf');
clpsat.refresh = 0;
Settings.tf = 10;
runpsat_rm('td');

[~,Q_s,P_r,Q_r,fr_bus,to_bus] = fm_flows('bus');
line_idx = get_line_idx(Line.con,event{im}.line);
if isempty(line_idx)
    event{im}.RM = Inf;
    return
end
Z_line = Line.con(line_idx,8) + 1j*Line.con(line_idx,9);
fr_bus = fr_bus(line_idx);
to_bus = to_bus(line_idx);

[R,X,time,delta] = get_rxtd(nB, fr_bus, to_bus, Z_line);

% trj_plot

for i = 1:2*length(line_idx)    
    [start,stop] = get_range(time, R, X, i)
%     if isinf(start)
%         event{im}.RM = 0;
%         return
%     end
    if i <= length(line_idx)
        j = i;
    else
        j = i - length(line_idx);
    end
   
    [stp, min_dist(i)] = get_nearest([R(start:stop, i)';X(start:stop, i)'],line_idx(j))
    if isinf(stp)
        break
    end
    
end

event{im}.RM = min(min_dist);

% figure(1)
% hold on
% for i = 2:11    
%     plot(R(i-1:i,4),X(i-1:i,4),'k')
%     pause(0.1)
% end
% hold off


% Check the following plots in im = 2 (given in paper)
% figure(1)
% 
% hold on 
% 
% set(gca,'FontSize',19,'TickLabelInterpreter', 'latex','FontSize',16)
% 
% plot(R(1:11,2)*0.06,X(1:11,2)*0.06,'k*')    
% plot(R(11:14,2)*0.06,X(11:14,2)*0.06,'k:')
% plot(R(15:length(time),2)*0.06,X(15:length(time),2)*0.06,'k-')
% 
% xc = Line.con(1,8)*0.8;
% yc = Line.con(1,9)*0.8;
% a = sqrt(xc^2 + yc^2);
% th = 0:pi/50:2*pi;
% xunit = a * cos(th) + xc;
% yunit = a * sin(th) + yc;
% plot(xunit, yunit,'k--');
% 
% xc = Line.con(1,8)*1.2;
% yc = Line.con(1,9)*1.2;
% a = sqrt(xc^2 + yc^2);
% th = 0:pi/50:2*pi;
% xunit = a * cos(th) + xc;
% yunit = a * sin(th) + yc;
% plot(xunit, yunit,'k--');
% 
% xc = Line.con(1,8)*2.0;
% yc = Line.con(1,9)*2.0;
% a = sqrt(xc^2 + yc^2);
% th = 0:pi/50:2*pi;
% xunit = a * cos(th) + xc;
% yunit = a * sin(th) + yc;
% plot(xunit, yunit,'k--');
% 
% % x = linspace(0,2.5*Line.con(1,8),5);
% % y = linspace(0,2.5*Line.con(1,9),5);
% % plot(x,y,'k--o')
% h4=legend('Pre-fault equilibrium','During fault','Post-clearance','Relay operating circles')
% set(h4, 'Interpreter', 'latex');
% % legend('Pre-fault equilibrium','During fault','Post-clearance','Relay operating circles','Interpreter','latex')
% xlabel('Resistance','Interpreter','latex')
% ylabel('Reactance','Interpreter','latex')
% text(0.27,0.15,'RM','Interpreter','latex','FontSize',16,'Color','k')
% 
% % x = [0.4+0.20891,0.4+0.3033];
% % y = [0.4+0.13078,0.4+0.0906];
% % a = annotation('doublearrow',x,y);
% 
% hold off
% 
% figure(2)
% hold on
% set(gca,'FontSize',19,'TickLabelInterpreter', 'latex','FontSize',15)
% plot(time(15:end)-1.03, abs(R(15:end,2) +1j*X(15:end,2))*0.06,'k:');
% plot(time(15:end)-1, phase(R(15:end,2) +1j*X(15:end,2)),'k');
% h4=legend('Impedance magnitude (pu)','Impedance phase (rad)')
% set(h4, 'Interpreter', 'latex');
% xlabel('time(sec)','Interpreter','latex')
% % plot(time, delta(:,3)-delta(:,1));
% hold off
% 
% rmpath('U:\Uploaded_data\PHD\Research\Resilience of PS\MATLAB Codes\Sensitivity\Conlist_23rd Sep\psat_original')