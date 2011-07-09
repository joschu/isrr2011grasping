%%
% frictionless situation
% for each trial:
% generate a set of 6d points (candidate contact wrenches)
clear

P = 3; % dimensionality of wrench space
Qs_sat = P+1:P+20; % number of contact points to find with brute force
Qs_brute = P+1:P+3;
N = 40; % number of candidate contacts

n_trials = 1;
t_mp = sphere_samples(10000,P);

res = [];

for i = 1:1
    
    
    x_np = normr(randn(N,P));
    c_p = zeros(1,P); % center
    % calculate the inradius of inradius of the convex hull of all of them
    r_hull_all= inrad_hull(x_np,c_p);
    if r_hull_all > 0
        % calculate the maximum inradius of 7 using brute force

        % calculate the maximum inradius of 7 using saturate algorithm with sampled
        % points
    
        for j=1:numel(Qs_sat)
            j
            [~,inds_hull_sat] = inrad_hull_k_sat(x_np,Qs_sat(j),c_p,t_mp);
            res(i).r_hull_sat(j) = inrad_hull(x_np(inds_hull_sat,:),c_p);
            res(i).r_hull_sat_approx(j) = inrad_hull_approx(x_np(inds_hull_sat,:),c_p,t_mp);            
            res(i).r_mink_sat(j) = inrad_mink_k_sat(x_np,Qs_sat(j),c_p,t_mp);
                                       
        end
        
        for j=1:numel(Qs_brute)
            res(i).r_hull_brute(j) = inrad_hull_k_brute(x_np,Qs_brute(j),c_p);
            res(i).r_mink_brute(j) = inrad_mink_k_brute(x_np,Qs_brute(j),c_p,t_mp);
        end
            
        
    end
    

    
    
end
res