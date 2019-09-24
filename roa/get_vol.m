clear terms
clear chh
clear Coe

syms z1 z2 z3 z4 z5 z6         % to be updated
z = [z1 z2 z3 z4 z5 z6];       % to be updated

dim = 6; % to be updated

terms = monomials(z,2);
chh = children(V);

for kk = 1:length(terms)
    for pp = 1:length(chh)
        if has(chh(pp),terms(kk))
            Coe(kk) = coeffs(chh(pp));
            break
        elseif pp == length(chh)
            Coe(kk) = 0;
        end
    end
end

idx = 1;
A = zeros(length(z),length(z));
b = zeros(length(z),1);
c_opt = -c_track(end);

for kk  = 1:length(z)
    for pp = 1:length(chh)
        if has(chh(pp),z(kk))
            b(kk) = 0.5*coeffs(chh(pp));
            break
        elseif pp == length(chh)
            b(kk) = 0;
        end
    end
end
    
for ii = 1:dim
    A(ii,ii) = Coe(idx);
    idx = idx + 1;
    if idx <= length(Coe)
        for jj = 1:ii
            A(jj,ii+1) = Coe(idx)*0.5;
            A(ii+1,jj) = A(jj,ii+1);
            idx = idx + 1;
        end
    end
end

% Reduce dimension to the subspace of sin(delta) i.e. the 2D space formed
% by z1 and z4
% to be updated
% A(2,:) = [];
% A(:,2) = [];
% A(2,:) = [];
% A(:,2) = [];
% A(3,:) = [];
% A(:,3) = [];
% A(3,:) = [];
% A(:,3) = [];
% b(2) = [];
% b(2) = [];
% b(3) = [];
% b(3) = [];
% 
% dim = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cvx_begin quiet

variable B(dim, dim) symmetric
variable d(dim)
variable gamma_opt

K = [...
    (-gamma_opt - c_opt + b'*inv(A)*b)              zeros(1,dim)               (d + inv(A)*b)';
            zeros(dim,1)                  gamma_opt*eye(dim,dim)                 B;
           (d + inv(A)*b)                          B                          inv(A)];

minimize(det_inv(B));

subject to
    K == semidefinite(2*dim + 1);
cvx_end

vol = det(B);
        