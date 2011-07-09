%%
V = 4;
verts_2v = [sin(2*pi*(1:V)/V);cos(2*pi*(1:V)/V)];
%%


seedrng

[wrenches_3k,cont_2k] = get_contact_wrenches(verts_2v,5,0);
wrenches_3k = wrenches_3k + randn(size(wrenches_3k))*.01;

[A_33,c_3] = min_vol_ellips(wrenches_3k);
G_3k = A_33 * wrenches_3k; % wrench matrix in natural coordinates

figure(1); clf; hold on;
plotverts(cont_2k,'k.')
plotverts(verts_2v)
t_kp = sphere_samples(10000,3);

%%

K = 7

% [r_hull_brute,inds_hull_brute] = inrad_hull_k_brute_approx(G_3k',K,c_3',t_kp);
[r_mink_sat_approx,inds_mink_sat] = inrad_mink_k_sat(G_3k',K,c_3',t_kp);
[r_mink_rand,inds_mink_rand] = inrad_heuristic(G_3k',K,c_3',t_kp,'mink','rand');
[r_mink_unif,inds_mink_unif] = inrad_heuristic(G_3k',K,c_3',t_kp,'mink','unif');

[r_mink_bb1,inds_mink_bb1,t1] = inrad_bb(G_3k',K,c_3',t_kp,'mink',1,'sat');
[r_mink_bb2,inds_mink_bb2,t2] = inrad_bb(G_3k',K,c_3',t_kp,'mink',1,'rand');
[r_mink_bb3,inds_mink_bb3,t3] = inrad_bb(G_3k',K,c_3',t_kp,'mink',1,'unif');

fprintf('sat: %i. rand: %i. unif: %i\n',length(t1),length(t2),length(t3))