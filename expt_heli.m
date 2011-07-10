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
circinds = find(xs.^2+ys.^2 <= r_xy.^2)
% surf(xs,ys,zs)
xyz_n3 = [xs(circinds),ys(circinds),zs(circinds)];

% tie points
pts_r3 = BOXSIZE*[1,1,1; -1,1,1; -1,-1,1; 1,-1,1];
center_13 = [0,0,0];
R = size(pts_r3,1);


N = size(xyz_n3,1);

G_6nr = zeros(6,N,R);

for n=1:N
    for r = 1:R

        vec = xyz_n3(n,:) - pts_r3(r,:);
        force_3 = normr(vec);
        torque_3 = cross(force_3,pts_r3(r,:) - center_13);
        wrench_6 = [force_3 torque_3];
        G_6nr(:,n,r) = wrench_6;
    end
end
%%

c_6 = [0,xmass,mass,0,0,rot];
t_q6 = sphere_samples(20000,6);
[inds,r] = inrad_mink_multi(G_6nr,n_heli,c_6,t_q6)
% [inds,r] = inrad_mink_k_sat(Gt_6m(1:3,:)',10,-c_6(1:3),t_q3);
%%
% vtkdestroy
% if exist('VTK','var'), vtkdestroy; end
VTK = VTKinit()

pointSize = 1
[verts_v3,faces_f3] = wobj_verts_faces(load('~/Data/grasping/obj/metal_box.mat'));
vtkplotmesh(gcvtk, verts_v3, faces_f3, ...
        'representation','surface','opacity',1,'backgroundColor',[1 1 1]);
vtkplotpoints(gcvtk, xyz_n3(inds,:),'pointSize',pointSize,'color',[.5 .5 .5 0.6]);
% vtkplotpoints(gcvtk, xyz_n3(setdiff(1:N,inds),:),'pointSize',pointSize*.1,'color',[.8 .8 .8]);

linepts = zeros(R*n_heli,3);
count = 0
for i=inds
    for r=1:R
        count = count + 1;
        linepts(count,:) = xyz_n3(i,:);
        count = count+1;
        linepts(count,:) = pts_r3(r,:);
    end
    vtkplotlines(gcvtk, linepts,(1:2:count)','lineWidth',1,'color',[0 0 0 0.4])
end

vtkview(90,0)
vtkview(0,-90)
vtkview(90,0)
vtkview(30,0)
vtkview(0,45)
