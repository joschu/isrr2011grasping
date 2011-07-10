function [inds_k,r] = inrad_mink_multi(G_pnr,K,c_p,t_qp)

[P,N,R] = size(G_pnr);
Q = size(t_qp,1);

sups_qnr = zeros(Q,N,R);

for r=1:R
   sups_qnr(:,:,r) = t_qp * squeeze(G_pnr(:,:,r));
end

sups_qn = max(max(sups_qnr,[],3),0);
sups_nq = sups_qn';
csups_q = c_p * t_qp';
[inds_k,r] = mysfo_saturate(@(inds) sum(sups_nq(inds,:),1)-csups_q,1:N,K);
end