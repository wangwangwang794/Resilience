function SM = get_limit()
global Varout done nL nB
global buscon linecon pqcon swcon syncon pvcon

[vstack,qstack,istack,qids] = set_limit();
SM = 0;
lambda = Varout.t;

v = Varout.vars(1,1:nB)';
i = Varout.vars(1,2*nB + 1:2*nB + nL)';
q = Varout.vars(1,nB + 1:2*nB)';
q = q(qids);
[done,within_limit] = verify_limit(v, q, i, vstack, qstack, istack, done);
if done ~= 1
    return
end

SM = lambda(end - 1) - 1;



