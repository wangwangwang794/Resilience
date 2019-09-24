function fm_call(flag)


%FM_CALL calls component equations
%
%FM_CALL(CASE)
%  CASE '1'  algebraic equations
%  CASE 'pq' load algebraic equations
%  CASE '3'  differential equations
%  CASE '1r' algebraic equations for Rosenbrock method
%  CASE '4'  state Jacobians
%  CASE '0'  initialization
%  CASE 'l'  full set of equations and Jacobians
%  CASE 'kg' as "L" option but for distributed slack bus
%  CASE 'n'  algebraic equations and Jacobians
%  CASE 'i'  set initial point
%  CASE '5'  non-windup limits
%
%see also FM_WCALL

fm_var

switch flag


 case 'gen'

  Line = gcall(Line);
  gcall(PQ)
  gcall(Fault)

 case 'load'

  gcall(PQ)
  gcall(Fault)
  gisland(Bus)

 case 'gen0'

  Line = gcall(Line);
  gcall(PQ)
  gcall(Fault)

 case 'load0'

  gcall(PQ)
  gcall(Fault)
  gisland(Bus)

 case '3'

  fcall(Syn)

 case '1r'

  Line = gcall(Line);
  gcall(PQ)
  gcall(Fault)
  Syn = gcall(Syn);
  PV = gcall(PV);
  SW = gcall(SW);
  gisland(Bus)

 case 'series'

  Line = gcall(Line);
  gisland(Bus)

 case '4'

  DAE.Fx = sparse(DAE.n,DAE.n);
  DAE.Fy = sparse(DAE.n,DAE.m);
  DAE.Gx = sparse(DAE.m,DAE.n);
  Fxcall(Syn)

 case '0'

  Syn = setx0(Syn);

 case 'fdpf'

  Line = gcall(Line);
  gcall(PQ)
  gcall(Fault)
  PV = gcall(PV);
  SW = gcall(SW);
  gisland(Bus)

 case 'l'

  Line = gcall(Line);
  gcall(PQ)
  gcall(Fault)
  PV = gcall(PV);
  SW = gcall(SW);
  gisland(Bus)
  Gycall(Line)
  Gycall(PQ)
  Gycall(Fault)
  Gycall(PV)
  Gycall(SW)
  Gyisland(Bus)


  
  DAE.Fx = sparse(DAE.n,DAE.n);
  DAE.Fy = sparse(DAE.n,DAE.m);
  DAE.Gx = sparse(DAE.m,DAE.n);
  Fxcall(PV)
  Fxcall(SW)

 case 'kg'

  Line = gcall(Line);
  gcall(PQ)
  gcall(Fault)
  Syn = gcall(Syn);
  gisland(Bus)
  Gycall(Line)
  Gycall(PQ)
  Gycall(Fault)
  Syn = Gycall(Syn);
  Gyisland(Bus)


  fcall(Syn)

  DAE.Fx = sparse(DAE.n,DAE.n);
  DAE.Fy = sparse(DAE.n,DAE.m);
  DAE.Gx = sparse(DAE.m,DAE.n);
  Fxcall(Syn)

 case 'kgpf'

  global PV SW
  Line = gcall(Line);
  gcall(PQ)
  gcall(Fault)
  PV = gcall(PV);
  greactive(SW)
  glambda(SW,1,DAE.kg)
  gisland(Bus)
  Gycall(Line)
  Gycall(PQ)
  Gycall(Fault)
  Gycall(PV)
  Gyreactive(SW)
  Gyisland(Bus)


  
  DAE.Fx = sparse(DAE.n,DAE.n);
  DAE.Fy = sparse(DAE.n,DAE.m);
  DAE.Gx = sparse(DAE.m,DAE.n);
  
 case 'n'

  Line = gcall(Line);
  gcall(PQ)
  gcall(Fault)
  Syn = gcall(Syn);
  PV = gcall(PV);
  SW = gcall(SW);
  gisland(Bus)
  Gycall(Line)
  Gycall(PQ)
  Gycall(Fault)
  Syn = Gycall(Syn);
  Gycall(PV)
  Gycall(SW)
  Gyisland(Bus)


 case 'i'

  Line = gcall(Line);
  gcall(PQ)
  gcall(Fault)
  Syn = gcall(Syn);
  PV = gcall(PV);
  SW = gcall(SW);
  gisland(Bus)
  Gycall(Line)
  Gycall(PQ)
  Gycall(Fault)
  Syn = Gycall(Syn);
  Gycall(PV)
  Gycall(SW)
  Gyisland(Bus)


  fcall(Syn)

  if DAE.n > 0
  DAE.Fx = sparse(DAE.n,DAE.n);
  DAE.Fy = sparse(DAE.n,DAE.m);
  DAE.Gx = sparse(DAE.m,DAE.n);
  end 

  Fxcall(Syn)
  Fxcall(PV)
  Fxcall(SW)

 case '5'

  
end
