function [r,inds_k] = inrad_heuristic(x_np,K,c_p,t_kp,Q,heur)

N = size(x_np,1);

switch Q
    case 'hull'
        inrad_fn = @inrad_hull_approx;
    case 'mink'
        inrad_fn = @inrad_mink_approx;
end

switch heur
    case 'rand'
        perm = randperm(N);
        inds_k = perm(1:K);
    case 'unif'
        dists_nn = squareform(pdist(x_np,'euclidean'));
        inds_k = randi(K);
        for k=2:K
            dists_kn = dists_nn(inds_k,:);
            mindists_n = min(dists_kn,[],1);
            [~,i_best] = max(mindists_n);
            inds_k = [inds_k, i_best];
        end

end

r = inrad_fn(x_np(inds_k,:),c_p,t_kp);

end