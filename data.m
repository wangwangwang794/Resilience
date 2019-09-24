Bus.con = [ ... 
% Bus  Vb   Vguess  DeltaGuess  Area#   Region#
   1   13.8   1          0         4       1;   
   2   6.9    1          0         5       1;
   3   6.9    1          0         3       1;
   4   13.8   1          0         2       1;
   5   13.8   1          0         2       1;
   6   13.8   1          0         2       1;
   7   13.8   1          0         4       1;
 ];

Line.con = [ ... 
% Fr  To  Sb  Vb   Freq  Null  Ratio     r      x      b    FixR  Fixth  Imax   Pmax   Smax    U    
  1   4  100  13.8  60    0      0    0.0113  0.225  0.0065  0      0     1.5    1.5    1.5    1;
  1   5  100  13.8  60    0      0    0.0053  0.105  0.0045  0      0     1.5    1.5    1.5    1;
  1   6  100  13.8  60    0      0    0.0108  0.215  0.0055  0      0     1.5    1.5    1.5    1;
  2   4  100  6.9   60    0     0.5   0.0018  0.035     0    0      0      2      2      2     1;    % Change ToBus from 4 to 6 to convert PS1 to PS2
  3   5  100  6.9   60    0     0.5   0.0021  0.042     0    0      0      2      2      2     1;    % Change ToBus element from 5 to 6 to convert PS1 to PS3
  4   6  100  13.8  60    0      0    0.0063  0.125  0.0035  0      0     1.5    1.5    1.5    1;
  5   6  100  13.8  60    0      0    0.0087  0.175   0.03   0      0     1.5    1.5    1.5    1;
  1   7  100  13.8  60    0      0    0.005   0.155   0.02   0      0     1.5    1.5    1.5    1;
 ];

SW.con = [ ... 
% Bus  Sb   Vb   Vpu  RefDelta  Qmax  Qmin  Vmax  Vmin  PGuess  Gamma  RefBus  U 
% Gamma = load participation
  7   100  13.8   1       0      1.5    0    1.05   0.95   1      1       1    1;
 ];

PV.con = [ ... 
% Bus  Sb   Vb    P   Vpu    Qmax   Qmin   Vmax  Vmin  Gamma  U       
% Gamma = load participation
  2    100  6.9  1.5   1       1      0    1.05   0.95    1    1;
  3    100  6.9   1    1       1      0    1.05   0.95    1    1;
 ];

PQ.con = [ ... 
% Bus  Sb    Vb    P       Q    Vmax  Vmin  PQ2Z  U
   4   100  13.8   0.8    0.08    1.05   0.95   1   1;
   5   100  13.8   0.9    0.09    1.05   0.95   1   1;
   6   100  13.8    1     0.10    1.05   0.95   1   1;
   1   100  13.8   0.5    0.05    1.05   0.95   1   1;
 ];

Syn.con = [ ... 
% Bus  Sb   Vb  Freq  Order   xl   ra    xd  x'd  x''d  T'd0  T''d0  xq  x'q  x''q  T'q0  T''q0   M     D    Kw  Kp  GammaP  GammaQ  Taa S1 S2  nCOI  U
  7   100  13.8  60     2     0   0.02   0   0.2    0    0      0    0   0     0     0      0   39.25   45   0  0      1      1      0  0  0   1     1;
  2   100  6.9   60     2     0   0.015  0  0.15    0    0      0    0   0     0     0      0    7.77   45   0  0      1      1      0  0  0   1     1;
  3   100  6.9   60     2     0   0.025  0  0.25    0    0      0    0   0     0     0      0     10    45   0  0      1      1      0  0  0   1     1;
 ];

% Fault.con = [1	100	13.8	60	0.5	0.53  0	0];
% Breaker.con = [8 1	100	13.8	60	0.5  0.53 1000];
% Breaker.con = [1 1	100	13.8	60	0.5  0.53 1000;2 1	100	13.8	60	0.5  0.53 1000;7 1	100	13.8	60	0.5  0.53 10000];

