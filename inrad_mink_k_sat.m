function [r,inds_p] = inrad_mink_k_sat(x_np,K,c_p,t_kp)
[N,~] = size(x_np);

dots_nk = x_np * t_kp';
pdots_nk = max(dots_nk,0);
cdots_k = c_p * t_kp';

[inds_p,r] = mysfo_saturate(...
    @(inds) sum(pdots_nk(inds,:),1)-cdots_k,...
    1:N,K);
