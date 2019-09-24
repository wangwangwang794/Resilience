function [Ybf] = gety_red(Vm)
global Line Syn Bus PQ

nl = Line.con(:,1); 
nr = Line.con(:,2);
nbus = max(max(nl), max(nr));

% add = length(Line.con(:,1)) - length(Line_org.con(:,1));
linedata = Line.con;
% linedata(:,end) = config(1:(length(Line.con(:,1))-add),event);
idx = find(linedata(:,end) == 1);
linedata = linedata(idx,[1,2,8,9,10]);
active = length(linedata(:,1));

for ii = 1:Syn.n
    linedata = [linedata;[nbus+ii, Syn.con(ii,1), Syn.con(ii,8), Syn.con(ii,9) 0]];
end

nl = linedata(:,1); nr = linedata(:,2); R = linedata(:,3);
X = linedata(:,4); Bc = j*linedata(:,5);

nbr=length(linedata(:,1));

bus_nos = Bus.con(:,1);
bus_nos = union(bus_nos,nbus+1:nbus+Syn.n);
nbus = length(bus_nos);
nbus1 = nbus - Syn.n;

idl = [];
idr = [];
for p = 1:nbr
    idl = [idl;find(bus_nos == nl(p))];
    idr = [idr;find(bus_nos == nr(p))];
end
    
Z = R + j*X; y= ones(nbr,1)./Z;  %branch admittance
for n = 1:nbr
    Ybus=zeros(nbus,nbus);    
               % formation of the off diagonal elements
    for k=1:nbr;
       Ybus(idl(k),idr(k))=Ybus(idl(k),idr(k))-y(k);%it will just take a 
       Ybus(idr(k),idl(k))=Ybus(idl(k),idr(k));%from the  data, for non transformer be the line data  a=1 no effect, so i can only modufy a for transformer line not=1 if i want
    end
end
              % formation of the diagonal elements
for  n=1:nbus
     for k=1:nbr
         if idl(k)==n
         Ybus(n,n) = Ybus(n,n)+ y(k) + Bc(k);%parallel admittance are added
         elseif idr(k)==n
         Ybus(n,n) = Ybus(n,n)+y(k) +Bc(k);
         else, end
     end
end

for k=1:nbus%only add the load to main diagonal    
    if ~isempty(find(PQ.con(:,1) == bus_nos(k)))
        p = find(PQ.con(:,1) == bus_nos(k));
        q = find(Bus.con(:,1) == bus_nos(k));
        Ybus(k,k)=Ybus(k,k)+((PQ.con(p,4) - j*PQ.con(p,5))/(Bus.con(q,3)^2));%Ybus includes all 6+3 buse+loads
    end
end
YLL=Ybus(1:nbus1, 1:nbus1);
YGG = Ybus(nbus1+1:nbus, nbus1+1:nbus);
YLG = Ybus(1:nbus1, nbus1+1:nbus);
Ybf=YGG-YLG.'*inv(YLL)*YLG;
