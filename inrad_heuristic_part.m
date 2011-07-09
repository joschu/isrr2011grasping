function [r,inds_k] = inrad_heuristic_part(x_np,K,c_p,t_kp,Q,heur,parts,sels,goodinds,badinds)

N = size(x_np,1);

switch Q
    case 'hull'
        inrad_fn = @inrad_hull_approx;
    case 'mink'
        inrad_fn = @inrad_mink_approx;
end

inds_k = goodinds;

for i_part = 1:length(parts)

    sels_left = sels(i_part) - length(intersect(parts{i_part},goodinds));
    if sels_left == 0, continue; end
    cands = setdiff(parts{i_part},badinds);
    
    [~,chosen_cand_inds] = inrad_heuristic(x_np(cands,:),sels_left,c_p,t_kp,Q,heur);
    
    inds_k = [inds_k,cands(chosen_cand_inds)];
end
    
    
r = inrad_fn(x_np(inds_k,:),c_p,t_kp);

end