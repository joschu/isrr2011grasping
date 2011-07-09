% generate triangle
% generate candidate contact points
% use brute force search to find best solution in hull case
% use brute force search to find best solution in mink case
% use saturate to find best solution for 4,5,6 contacts
% plot all these solutions

%%
verts_2v = [0,0; 1.3,0; .4,.7]';
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
t_kp = sphere_samples(50000,3);


%%
[r_hull_brute,inds_hull_brute] = inrad_hull_k_brute(G_3k',4,c_3');
[r_hull_sat_approx4,inds_hull_sat4] = inrad_hull_k_sat(G_3k',4,c_3',t_kp);
r_hull_sat_exact4 = inrad_hull(G_3k(:,inds_hull_sat4)',c_3');

[r_hull_sat_approx5,inds_hull_sat5] = inrad_hull_k_sat(G_3k',5,c_3',t_kp);
r_hull_sat_exact5 = inrad_hull(G_3k(:,inds_hull_sat5)',c_3');

[r_hull_sat_approx6,inds_hull_sat6] = inrad_hull_k_sat(G_3k',6,c_3',t_kp);
r_hull_sat_exact6 = inrad_hull(G_3k(:,inds_hull_sat6)',c_3');

hso = plotlabels('****',cont_2k(:,inds_hull_brute)',[-.01,-.03],...
    'FontSize',20,'Color','y');
hs4 = plotlabels('1234',cont_2k(:,inds_hull_sat4)',[.02,0],...
    'FontSize',20,'Color','r');
hs5 = plotlabels('12345',cont_2k(:,inds_hull_sat5)',[-.01,.05],...
    'FontSize',20,'Color','b');
hs6 = plotlabels('123456',cont_2k(:,inds_hull_sat6)',[-.05,0],...
    'FontSize',20,'Color','g');

th=title('Q_1')
set(th,'FontSize',20)
set(gca,'XTick',[],'YTick',[])

%%
figure(2); clf; hold on;
plotverts(cont_2k,'k.','MarkerSize',20)
plotverts(verts_2v,'k-','LineWidth',2)

[r_mink_brute,inds_mink_brute] = inrad_mink_k_brute(G_3k',4,c_3',t_kp);
[r_mink_sat_approx4,inds_mink_sat4] = inrad_mink_k_sat(G_3k',4,c_3',t_kp);

[r_mink_sat_approx5,inds_mink_sat5] = inrad_mink_k_sat(G_3k',5,c_3',t_kp);

[r_mink_sat_approx6,inds_mink_sat6] = inrad_mink_k_sat(G_3k',6,c_3',t_kp);

hso = plotlabels('xxxx',cont_2k(:,inds_mink_brute)',[0,.03],...
    'FontSize',20,'Color','m');
hs4 = plotlabels('1234',cont_2k(:,inds_mink_sat4)',[.03,0],...
    'FontSize',20,'Color','r');
hs5 = plotlabels('12345',cont_2k(:,inds_mink_sat5)',[0,-.03],...
    'FontSize',20,'Color','b');
hs6 = plotlabels('123456',cont_2k(:,inds_mink_sat6)',[-.03,0],...
    'FontSize',20,'Color','g');

th=title('Q_{\infty}')
set(th,'FontSize',20)
set(gca,'XTick',[],'YTick',[])