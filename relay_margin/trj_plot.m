
figure(1)
hold on 

set(gca,'FontSize',19,'TickLabelInterpreter', 'latex','FontSize',16)

plot(R(1:11,5),X(1:11,5),'k*')    
plot(R(11:14,5),X(11:14,5),'k:')
plot(R(15:length(time),5),X(15:length(time),5),'k-')

xc = Line.con(5,8)*0.8*0.5;
yc = Line.con(5,9)*0.8*0.5;
a = sqrt(xc^2 + yc^2);
th = 0:pi/50:2*pi;
xunit = a * cos(th) + xc;
yunit = a * sin(th) + yc;
plot(xunit, yunit,'k--');

xc = Line.con(5,8)*1.2*0.5;
yc = Line.con(5,9)*1.2*0.5;
a = sqrt(xc^2 + yc^2);
th = 0:pi/50:2*pi;
xunit = a * cos(th) + xc;
yunit = a * sin(th) + yc;
plot(xunit, yunit,'k--');

xc = Line.con(5,8)*2.0*0.5;
yc = Line.con(5,9)*2.0*0.5;
a = sqrt(xc^2 + yc^2);
th = 0:pi/50:2*pi;
xunit = a * cos(th) + xc;
yunit = a * sin(th) + yc;
plot(xunit, yunit,'k--');

% x = linspace(0,2.5*Line.con(1,8),5);
% y = linspace(0,2.5*Line.con(1,9),5);
% plot(x,y,'k--o')
h4=legend('Pre-fault equilibrium','During fault','Post-clearance','Relay operating circles')
set(h4, 'Interpreter', 'latex');
% legend('Pre-fault equilibrium','During fault','Post-clearance','Relay operating circles','Interpreter','latex')
xlabel('Resistance','Interpreter','latex')
ylabel('Reactance','Interpreter','latex')
text(0.18,0,'RM','Interpreter','latex','FontSize',16,'Color','k')

hold off

figure(2)
hold on
set(gca,'FontSize',19,'TickLabelInterpreter', 'latex','FontSize',15)
plot(time(15:end)-1.03, abs(R(15:end,5) +1j*X(15:end,5)),'k:');
plot(time(15:end)-1, phase(R(15:end,5) +1j*X(15:end,5)),'k');
h4=legend('Impedance magnitude (pu)','Imedance phase (rad)')
set(h4, 'Interpreter', 'latex');
xlabel('time(sec)','Interpreter','latex')
% plot(time, delta(:,3)-delta(:,1));
hold off