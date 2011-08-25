function [h_nk,t_rnk] = heli_support_cvx(G_pR,C_mR,y_pk,N)

% calculate a support function of all helicopters for a given disturbance


% p dimensionality of wrench space
% P N*p
% m dimensionality of constraints
% M N*m
% r number of ropes per heli
% R N*r

[p,R] = size(G_pR);
[m,~] = size(C_mR);
P = N*p;
M = N*m;
r = R/N;

k = size(y_pk,2);

G_pr_n = mat2cell(G_pR,p,ones(N,1)*r);
C_mr_n = mat2cell(C_mR,m,ones(N,1)*r);

G_PR = blkdiag(G_pr_n{:});
C_MR = blkdiag(C_mr_n{:});

y_Pk = repmat(y_pk,N,1);

cvx_begin quiet

    variable t_Rk(R,k); % tension
    q_Mk = C_MR * t_Rk;
    q_mnk = reshape(q_Mk,m,N,k);
    q_nk = squeeze(norms(q_mnk,2,1));
    f_Pk = G_PR * t_Rk;
    maximize(sum(vec(f_Pk .* y_Pk)))
    subject to 
        q_nk <= 1;
        t_Rk >= 0;    

cvx_end

t_rnk = reshape(t_Rk,r,N,k);
f_Pk = G_PR * t_Rk;
f_pnk = reshape(f_Pk,p,N,k);
for i_k=1:k
    h_nk(:,i_k) =  y_pk(:,i_k)'*f_pnk(:,:,i_k);
end