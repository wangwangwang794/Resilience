function  fm_int
% FM_INT time domain integration routines:
%       1 - Forward Euler
%       2 - Trapezoidal Method
%
% FM_INT
%
%see also FM_TSTEP, FM_OUT and the Settings structure
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Update:    16-Jan-2003
%Update:    27-Feb-2003
%Update:    01-Aug-2003
%Update:    11-Sep-2003
%Version:   1.0.4
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2016 Federico Milano

global Fig Settings Snapshot Hdl
global Bus File DAE Theme OMIB
global SW PV PQ Fault Ind
global Varout Breaker Line Path clpsat

if ~autorun('Time Domain Simulation',1), return, end

tic
fprintf('I am original')
% check settings
% ------------------------------------------------------------------

iter_max = Settings.dynmit;
tol = Settings.dyntol;
Dn = 1;
if DAE.n, Dn = DAE.n; end
identica = speye(max(Dn,1));

if (Fault.n || Breaker.n) && PQ.n && ~Settings.pq2z
  if clpsat.init
    if clpsat.pq2z
      Settings.pq2z = 1;
    else
      Settings.pq2z = 0;
    end
  elseif ~Settings.donotask
    uiwait(fm_choice(['Convert (recommended) PQ loads to constant impedances?']))
    if Settings.ok
      Settings.pq2z = 1;
    else
      Settings.pq2z = 0;
    end
  end
end

% convert PQ loads to shunt admittances (if required)
PQ = pqshunt(PQ);

% set up variables
% ----------------------------------------------------------------

DAE.t = Settings.t0;
fm_call('i');
DAE.tn = DAE.f;
if isempty(DAE.tn), DAE.tn = 0; end

% ----------------------------------------------------------------
% initializations
% ----------------------------------------------------------------

t = Settings.t0;
k = 1;
h = fm_tstep(1,1,0,Settings.t0);
inc = zeros(Dn+DAE.m,1);
callpert = 1;

% get initial network connectivity
fm_flows('connectivity', 'verbose');

% output initialization
fm_out(0,0,0);
fm_out(2,Settings.t0,k);

% time vector of snapshots, faults and breaker events
fixed_times = [];

n_snap = length(Snapshot);
if n_snap > 1 && ~Settings.locksnap
  snap_times = zeros(n_snap-1,1);
  for i = 2:n_snap
    snap_times(i-1,1) = Snapshot(i).time;
  end
  fixed_times = [fixed_times; snap_times];
end

fixed_times = [fixed_times; gettimes(Fault); ...
               gettimes(Breaker); gettimes(Ind)];
fixed_times = sort(fixed_times);

% ================================================================
% ----------------------------------------------------------------
% Main loop
% ----------------------------------------------------------------
% ================================================================

inc = zeros(Dn+DAE.m,1);

while (t < Settings.tf) && (t + h > t)
  if (t + h > Settings.tf), h = Settings.tf - t; end
  actual_time = t + h;

  % check not to jump disturbances
  index_times = find(fixed_times > t & fixed_times < t+h);
  if ~isempty(index_times);
    actual_time = min(fixed_times(index_times));
    h = actual_time - t;
  end

  % set global time
  DAE.t = actual_time;

  % backup of actual variables
  xa = DAE.x;
  ya = DAE.y;

  % initialize NR loop
  iterazione = 1;
  inc(1) = 1;
  if isempty(DAE.f), DAE.f = 0; end
  fn = DAE.f;

  % applying faults, breaker interventions and perturbations
  if ~isempty(fixed_times)
    if ~isempty(find(fixed_times == actual_time))
      Fault = intervention(Fault,actual_time);
      Breaker = intervention(Breaker,actual_time);
    end
  end

  % Newton-Raphson loop
  Settings.error = tol+1;
  while Settings.error > tol
    if (iterazione > iter_max), break,  end
    % DAE equations
    fm_call('i');
    % complete Jacobian matrix DAE.Ac
    switch Settings.method
     case 1  % Forward Euler
      DAE.Ac = [identica - h*DAE.Fx, -h*DAE.Fy; DAE.Gx, DAE.Gy];
      DAE.tn = DAE.x - xa - h*DAE.f;
     case 2  % Trapezoidal Method
      DAE.Ac = [identica - h*0.5*DAE.Fx, -h*0.5*DAE.Fy; DAE.Gx, DAE.Gy];
      DAE.tn = DAE.x - xa - h*0.5*(DAE.f + fn);
    end

    inc = -DAE.Ac\[DAE.tn; DAE.g];
    DAE.x = DAE.x + inc(1:Dn);
    DAE.y = DAE.y + inc(1+Dn: DAE.m+Dn);
    iterazione = iterazione + 1;
    Settings.error = max(abs(inc));
  end

  if (iterazione > iter_max)
    h = fm_tstep(2,0,iterazione,t);
    DAE.x = xa;
    DAE.y = ya;
    DAE.f = fn;
  else
    h = fm_tstep(2,1,iterazione,t);
    t = actual_time;
    k = k+1;
    % extend output stack
    if k > length(Varout.t), fm_out(1,t,k); end
    % update output variables, snapshots and network visualisation
    fm_out(2,t,k);
  end
end

% resize output varibales & final settings
fm_out(3,t,k);