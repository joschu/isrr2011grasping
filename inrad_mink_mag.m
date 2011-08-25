function [r,inds_k] = inrad_mink_mag(G_pR,C_mR,N,K,c_p,t_qp)

global CACHE
CACHE
if isfield(CACHE,'sups_nq')
    disp('using cache')
    sups_nq = CACHE.sups_nq;
else    
    disp('not using cache')
    sups_nq = heli_support_cvx_big(G_pR,C_mR,t_qp',N);
    CACHE.sups_nq = sups_nq;
end

psups_nq = max(sups_nq,0);
csups_q = c_p * t_qp';



[inds_k,r] = mysfo_saturate(...
    @(inds) sum(psups_nq(inds,:),1)-csups_q,...
    1:N,K);

end