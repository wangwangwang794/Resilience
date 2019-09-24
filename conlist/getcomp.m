function [buses,nislands] = getcomp()

global Bus Line PQ PV SW Syn

U = Line.u;
nb = Bus.n;
Fr = Line.fr;
To = Line.to;

connect_mat = ...
sparse(Fr,Fr,1,nb,nb) + ...
sparse(Fr,To,U,nb,nb) + ...
sparse(To,To,1,nb,nb) + ...
sparse(To,Fr,U,nb,nb);

G = graph(full(connect_mat));
[bins] = conncomp(G,'OutputForm','cell');
buses = bins;
nislands = length(bins);