function [r,inds_k] = inrad_hull_k_sat(x_np,K,c_p,t_kp)
x_np = bsxfun(@minus,x_np,c_p);
dots_nk = x_np * t_kp';
[inds_k,r] = mysfo_saturate(@(inds) max(dots_nk(inds,:),[],1),1:size(x_np,1),K);
