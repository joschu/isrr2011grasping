% only works for a beam centered at 0,0 in the x direction
%% 
wobj = read_wobj('/home/joschu/Data/blend/beam1.obj');
[verts_v3,faces_f3,normals_f3] = wobj_verts_faces(wobj);
normals_f3 = normals_f3 + 0*randn(size(normals_f3));
[wrenches_f6,cents_f3,normals_f3] = get_contact_wrenches3d(verts_v3,faces_f3,normals_f3);

STRESS = .1;

% faces_f3 = faces_f3(1:3:end,:);
% normals_f3 = normals_f3(1:3:end,:);


wrenches_6f = wrenches_f6';
cents_3f = cents_f3';
% [A_66,c_6] = min_vol_ellips(bsxfun(@plus,wrenches_6f,[0 0 0 0 0 0]')); %gravity
% G_6f = A_66 * wrenches_6f;


xs =  linspace(-9,9,3);
n_surf = length(xs);
fss = cell(1,n_surf);
for i_surf = 1:n_surf
    x = xs(i_surf);
    faces_left = find(cents_f3(:,1) <= x);
    faces_right = find(cents_f3(:,1) > x);
    Fl = length(faces_left);
    Fr = length(faces_right);
    wcont_12n = [wrenches_6f(:,faces_right),          zeros(6,Fl);
                 zeros(6,Fr),           wrenches_6f(:,faces_left)];
             % wrenches due to contacts

    wsurf_12p = STRESS*[eye(6), -eye(6);...
                       -eye(6) eye(6)];

    wres_12q = [wcont_12n,wsurf_12p];
             
%     [A_1212,c_12] = min_vol_ellips(bsxfun(@plus,wcont_12n,zeros(12,1)));
    c_12 = mean(wcont_12n',1);
    A_1212 = sqrtm(cov(wcont_12n'))^-1;
    
%     G_12q = A_1212 * wres_12q;
    G_12p = A_1212*wsurf_12p;
    G_12n = A_1212*wcont_12n;
    
%     t_12k = sphere_samples(2,12)';
    t_12k = blkdiag(sphere_samples(10000,6)',sphere_samples(10000,6)');
    
             

    cdots_k = c_12 * t_12k;
    pdots_nk = max(G_12n'*t_12k,0);
    pdots_pk = max(G_12p'*t_12k,0);
    spdots_k = sum(pdots_pk,1);
    fss{i_surf} = @(inds) sum(pdots_nk(inds,:),1) +spdots_k - cdots_k;
    
end

fs = @(inds) cell2mat(cellfun(@(f) f(inds), fss,'UniformOutput',false));
F = size(faces_f3,1);
K = 20;
[inds,r] = mysfo_saturate(fs,1:F,K);

%%
% inds = 1:F

% vtkdestroy;
VTK = vtkinit()
vtkplotmesh(gcvtk, verts_v3, faces_f3, ...
    'representation','surface','opacity',.5,'backgroundColor',[1 1 1])
pointSize = (max(verts_v3(:,1))-min(verts_v3(:,1)))/75;
vtkplotpoints(gcvtk, cents_f3(inds,:),'pointSize',pointSize,'color',[0 0   1 0.6]);

K = numel(inds);
linepts = zeros(2*K,3);
for i=1:K
   linepts(2*i-1,:) = cents_f3(inds(i),:);
   linepts(2*i,:) = linepts(2*i-1,:) + normals_f3(inds(i),:)*pointSize*8;
end
vtkplotlines(gcvtk, linepts,(1:2:2*K)','lineWidth',3.5,'color',[0 0   1 0.6])