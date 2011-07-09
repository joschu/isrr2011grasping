function [r,inds_k] = inrad_hull_k_rollout(x_np,K,c_p,t_kp)
x_np = bsxfun(@minus,x_np,c_p);
dots_nk = x_np * t_kp';
N = size(x_np,1);

inds_k = [];

for k=1:K
    fvals = zeros(N,1);
    for n = 1:N
        if ismember(n,inds_k), fvals(n)=-inf;
        else [~,fvals(n)] = mysfo_saturate_inc(@(inds) max(dots_nk(inds,:),[],1),1:N,K,[inds_k n]);
        end
    end
    [r,i] = max(fvals);
    inds_k = [inds_k,i];
end

