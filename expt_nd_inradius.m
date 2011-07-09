%%
% frictionless situation
% for each trial:
% generate a set of 6d points (candidate contact wrenches)
P = 6; % dimensionality of wrench space
Q = P+1; % number of contact points to find with brute force
N = 15; % number of candidate contacts
x_np = randn(N,P);
c_p = zeros(1,P); % center
% calculate the inradius of inradius of the convex hull of all of them
t_mp = sphere_samples(100000,P);
r_hull_all= inrad_hull(x_np,c_p);
if r_hull_all > 0
    % calculate the maximum inradius of 7 using brute force
    [r_hull_brute,inds_hull_brute] = inrad_hull_k_brute(x_np,Q,c_p);
    % calculate the maximum inradius of 7 using saturate algorithm with sampled
    % points
    [r_hull_sat_approx,inds_hull_sat] = inrad_hull_k_sat(x_np,Q,c_p,t_mp);
    [r_hull_sat_approx1,inds_hull_sat1] = inrad_hull_k_sat(x_np,Q+1,c_p,t_mp);
    [r_hull_sat_approx2,inds_hull_sat2] = inrad_hull_k_sat(x_np,Q+2,c_p,t_mp);

    % calculate the exact inradius using selected contacts (should be a little
    % bigger)
    r_hull_sat_exact = inrad_hull(x_np(inds_hull_sat,:),c_p);
    r_hull_sat_exact1 = inrad_hull(x_np(inds_hull_sat1,:),c_p);
    r_hull_sat_exact2 = inrad_hull(x_np(inds_hull_sat2,:),c_p);

end

%%

    
% calculate the maximum minkowski inradius of 7 using brute force
[r_mink_brute,inds_mink_brute] = inrad_mink_k_brute(x_np,Q,c_p,t_mp);
% (maybe...)
% calculate the minkowski inradius using saturate algorithm
[r_mink_sat_approx,inds_mink_sat] = inrad_mink_k_sat(x_np,Q,c_p,t_mp);
[r_mink_sat_approx1,inds_mink_sat1] = inrad_mink_k_sat(x_np,Q+1,c_p,t_mp);
[r_mink_sat_approx2,inds_mink_sat2] = inrad_mink_k_sat(x_np,Q+2,c_p,t_mp);
