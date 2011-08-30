% ih = impoly;

% verts_2v = [0 7 5 1; 0 0 -5 -5];

 verts_2v =          [0.16475      0.72661;...
      0.47339      0.67303;...
      0.77535      0.78801;...
        0.697      0.35819;...
      0.27304      0.36404]';

%%


% seedrng

[wrenches_3k,cont_2k] = get_contact_wrenches(verts_2v,5,0);
wrenches_3k = -wrenches_3k
% wrenches_3k = wrenches_3k + randn(size(wrenches_3k))*.01;

% [A_33,c_3] = min_vol_ellips(wrenches_3k);
% G_3k = A_33 * wrenches_3k; % wrench matrix in natural coordinates

%%
% t_kp = sphere_samples(50000,3);


%%
% figure(2)
% x = wrenches_3k(1,:)
% y = wrenches_3k(2,:)
% z = wrenches_3k(3,:)
% plot3(x,y,z,'.')


%%
% [opt_r,opt_inds] = inrad_mink_k_sat(G_3k',K,c_3',t_kp);
% good_inds = [1 5 8 13 18]
% bad_inds = [1 5 6 10 18]
good_inds = [1 3 4 5]
bad_inds = [1 2 3 5]

%%

figure(1); clf; hold on;
plotverts(cont_2k,'k.','MarkerSize',60)
plotverts(verts_2v,'k-','LineWidth',10)

plot(cont_2k(1,good_inds),cont_2k(2,good_inds),'rx','MarkerSize',30,'LineWidth',10)

set(gca,'XTick',[],'YTick',[])
axis off
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [4 4]);
saveas(1,'~/Proj/grasping/isrr_talk/m_trap_good.png')

%%
figure(2); clf; hold on;
plotverts(cont_2k,'k.','MarkerSize',60)
plotverts(verts_2v,'k-','LineWidth',10)

plot(cont_2k(1,bad_inds),cont_2k(2,bad_inds),'rx','MarkerSize',30,'LineWidth',10)

set(gca,'XTick',[],'YTick',[])
axis off
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [4 4]);
saveas(2,'~/Proj/grasping/isrr_talk/m_trap_bad.png')


%%
figure(3); clf; hold on;
pts = minkowski_sum(wrenches_3k(1:2,good_inds)')

r_good = inrad_hull(pts)
K = convhulln(pts)
xy = pts(K([1:end,1],1),:)
% z = pts(:,3)

fill(xy(:,1),xy(:,2),[.8,.8,.8])
for ind = good_inds
    plot([0 wrenches_3k(1,ind)],[0,wrenches_3k(2,ind)],'r-','LineWidth',10)
end

plot(xy(:,1),xy(:,2),'k-','LineWidth',10)
 axis equal
 
hx=xlabel('f_x')
hy=ylabel('f_y')
set(hx,'FontSize',60)
set(hy,'FontSize',60,'Rotation',0)


 
%  set(gcf, 'PaperUnits', 'inches');
% set(gcf, 'PaperSize', [4 4]);

ax1 = axis
% axescenter
set(gca,'XTick',[],'YTick',[])

saveas(3,'~/Proj/grasping/isrr_talk/m_ws_good.png')
circle([0,0],r_good,1000,'Color',[0 .5 0],'LineWidth',10)
saveas(3,'~/Proj/grasping/isrr_talk/m_ws_good2.png')


%%
figure(4); clf; hold on
pts = minkowski_sum(wrenches_3k(1:2,bad_inds)')
r_bad = inrad_hull(pts);
K = convhulln(pts)
xy = pts(K([1:end,1],1),:)
% y = pts(K([1:end]),2)
fill(xy(:,1),xy(:,2),[.8 .8 .8])
for ind = bad_inds
    plot([0 wrenches_3k(1,ind)],[0,wrenches_3k(2,ind)],'r-','LineWidth',10)
end

% z = pts(:,3)
plot(xy(:,1),xy(:,2),'k-','LineWidth',10)
axis equal

hx=xlabel('f_x')
hy=ylabel('f_y')
set(hx,'FontSize',60)
set(hy,'FontSize',60,'Rotation',0)
% set(gcf, 'PaperUnits', 'inches');
% set(gcf, 'PaperSize', [4 4]);
axis(ax1)
% axescenter
set(gca,'XTick',[],'YTick',[])

saveas(4,'~/Proj/grasping/isrr_talk/m_ws_bad.png')
circle([0,0],r_bad,1000,'Color',[0 .5 0],'LineWidth',10)
saveas(4,'~/Proj/grasping/isrr_talk/m_ws_bad2.png')


