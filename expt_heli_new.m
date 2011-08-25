%%

n_heli = 8;
mass = 6;
xmass = 4;
rot = 0;
r_heli = 9;
r_xy = 8;
spacing = 2;
BOXSIZE = 2.1;


[xs,ys] = meshgrid(-r_xy:spacing:r_xy,-r_xy:spacing:r_xy);
zs = sqrt(r_heli^2-xs.^2-ys.^2);
circinds = find(xs.^2+ys.^2 <= r_xy.^2);
% surf(xs,ys,zs)
xyz_n3 = [xs(circinds),ys(circinds),zs(circinds)];

% tie points
pts_r3 = BOXSIZE*[1,1,1; -1,1,1; -1,-1,1; 1,-1,1];
center_13 = [0,0,0];

r = size(pts_r3,1);
N = size(xyz_n3,1);
R = N*r

G_6rn = zeros(6,r,N);

for i_n=1:N
    for i_r = 1:r

        vec = xyz_n3(i_n,:) - pts_r3(i_r,:);
        force_3 = normr(vec);
        torque_3 = cross(force_3,pts_r3(i_r,:) - center_13);
        wrench_6 = [force_3 torque_3];
        G_6rn(:,i_r,i_n) = wrench_6;
    end
end

G_6R = reshape(G_6rn,6,R);
C_3R = G_6R(1:3,:);




c_6 = [0,xmass,mass,0,0,rot];
t_q6 = sphere_samples(10000,6);



%%

K=n_heli;
[a,inds] = inrad_mink_mag(G_6R,C_3R,N,K,c_6,t_q6)
% [inds2,r2] = inrad_mink_k_sat(G_6R',K,c_6,t_q6)
% [inds,r] = inrad_mink_multi(G_6nr,n_heli,c_6,t_q6)
% [inds,r] = inrad_mink_k_sat(Gt_6m(1:3,:)',10,-c_6(1:3),t_q3);
%%
% vtkdestroy
% if exist('VTK','var'), vtkdestroy; end
VTK = VTKinit()

pointSize = .6
[verts_v3,faces_f3] = wobj_verts_faces(load('~/Data/grasping/obj/metal_box.mat'));
vtkplotmesh(gcvtk, verts_v3, faces_f3, ...
        'representation','surface','opacity',1,'backgroundColor',[1 1 1]);
vtkplotpoints(gcvtk, xyz_n3(inds,:),'pointSize',pointSize,'color',[.5 .5 .5 0.6]);
% vtkplotpoints(gcvtk, xyz_n3(setdiff(1:N,inds),:),'pointSize',pointSize*.1,'color',[.8 .8 .8]);

linepts = zeros(r*n_heli,3);
count = 0
for i=inds
    for i_r=1:r
        count = count + 1;
        linepts(count,:) = xyz_n3(i,:);
        count = count+1;
        linepts(count,:) = pts_r3(i_r,:);
    end
    vtkplotlines(gcvtk, linepts,(1:2:count)','lineWidth',1,'color',[0 0 0 0.4])
end

vtkview(90,0)
vtkview(0,-90)
vtkview(90,0)
vtkview(30,0)
vtkview(0,45)
