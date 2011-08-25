%%
clf
ih = impoly;
verts_2v = ih.getPosition';
%%


seedrng

[wrenches_3k,cont_2k] = get_contact_wrenches(verts_2v,5,0);
wrenches_3k = wrenches_3k + randn(size(wrenches_3k))*.01;

[A_33,c_3] = min_vol_ellips(wrenches_3k);
G_3k = A_33 * wrenches_3k; % wrench matrix in natural coordinates

%%
figure(1); clf; hold on;
plotverts(cont_2k,'k.','MarkerSize',30)
plotverts(verts_2v,'LineWidth',3)
t_kp = sphere_samples(50000,3);

set(gca,'XTick',[],'YTick',[])

%%
figure(2)
x = wrenches_3k(1,:)
y = wrenches_3k(2,:)
z = wrenches_3k(3,:)
plot3(x,y,z,'.')

%%
pts = minkowski_sum(wrenches_3k')
x = pts(:,1)
y = pts(:,2)
z = pts(:,3)
% plot3(x,y,z,'.')

%%
K=6
[opt_r,opt_inds] = inrad_mink_k_sat(G_3k',K,c_3',t_kp);

%%
figure(1)
plot(cont_2k(1,opt_inds),cont_2k(2,opt_inds),'rx','MarkerSize',30,'LineWidth',3)

%%
figure(2)
pts = minkowski_sum(G_3k(:,opt_inds)')
K = convhulln(pts)
x = pts(:,1)
y = pts(:,2)
z = pts(:,3)
% plot3(x,y,z,'.')


%%
% vtkdestroy;
VTK = vtkinit()
vtkplotmesh(gcvtk, pts, K, 'representation','surface','opacity',.5,'backgroundColor',[1 1 1])
vtkplotpoints(gcvtk,c_3','pointSize',opt_r,'color',[0,0,1])


%%

