% load vertex data

% calculate normals and get wrench matrix
% coordinate transformation
% subsample to get candidate grasp points
% use brute force search on severely subsampled points to get best solution
% in hull case
% use saturate

%%
% [faces_f3,verts_v3,labels_v] = load_cube;
[faces_f3,verts_v3,labels_v] = load_heart;
% [faces_f3,verts_v3,labels_v,normals_f3] = load_organ('liver');
% [faces_f3,verts_v3,labels_v] = load_snazzy_plane;
ptp_3 = ptp(verts_v3);
verts_v3 = verts_v3 / max(ptp_3);


%%




%%
pointColors = [1, 1, 0, 0;
    10, 0, 1, 0;
    50, 0, 0, 1;
    100, 1, 1, 1];

meshOpacity = 1;



%%
[wrenches_f6,cents_f3,normals_f3] = get_contact_wrenches3d(verts_v3,faces_f3);
F = size(wrenches_f6,1);
cand_inds = 1:ceil(F/100):F;
wrenches_f6 = wrenches_f6(cand_inds,:);

wrenches_6f = wrenches_f6';
cents_3f = cents_f3';
[A_66,c_6] = min_vol_ellips(bsxfun(@plus,wrenches_6f,[0 0 0 0 0 0]'));
G_6f = A_66 * wrenches_6f;
t_k6 = sphere_samples(10000,6);
%%
results = [];
for n_contacts = 10:5:40
    vtkdestroy;
    VTK = vtkinit()
    vtkplotmesh(gcvtk, verts_v3, faces_f3, labels_v', pointColors, ...
        'representation','surface','opacity',.5,'backgroundColor',[1 1 1])
    
    
    
    % [r_hull_sat_approx4,inds_hull_sat4] = inrad_hull_k_sat(G_6f',n_contacts,c_6',t_k6);
    % r_hull_sat_exact4 = inrad_hull(G_6f(:,inds_hull_sat4)',c_6');
    
    tic
    [r,inds_mink_sat4] = inrad_mink_k_sat(G_6f',n_contacts,c_6',t_k6);
    t = toc;
    results(end+1).r = r;
    results(end+1).t = t;
    
    pointSize = (max(verts_v3(:,1))-min(verts_v3(:,1)))/25;
    
    inds = cand_inds(inds_mink_sat4);
    vtkplotpoints(gcvtk, cents_f3(inds,:),'pointSize',pointSize,'color',[0 0   1 0.6]);
    
    if find(n_contacts == [10,20,40])
        vtksave(sprintf('/home/joschu/Proj/grasping/2011_ISRR_grasping/heart%i.png',n_contacts))
    end
    
    K = numel(inds);
    linepts = zeros(2*K,3);
    for i=1:K
        linepts(2*i-1,:) = cents_f3(inds(i),:);
        linepts(2*i,:) = linepts(2*i-1,:) - normals_f3(inds(i),:)*pointSize*8;
    end
    % vtkplotlines(gcvtk, linepts,(1:2:2*K)','lineWidth',3.5,'color',[0 0   1 0.6])
    % for i=1:n_contacts
    %     pt = cents_f3(inds(i),:);
    %     vtkannotate(pt,num2str(i),'textFontSize',20)
    % end
end

%%
clf
hold on
[ax,h1,h2]=plotyy(10:5:40,1./[results.r],10:5:40,[results.t]);
% plotyy(.04*,'k-','LineWidth',2)
th=title('SATURATE for contact point selection on 3D object')
set(th,'FontSize',20)
xlh = xlabel('number of contacts');
set(xlh,'FontSize',20)
set(gca,'Ytick',[],'Xtick',[])


set(get(ax(1),'Ylabel'),'String','Worst-case contact force','FontSize',20)

set(get(ax(2),'Ylabel'),'String','Algorithm running time (seconds)','FontSize',20) 
set(ax(2),'FontSize',20)