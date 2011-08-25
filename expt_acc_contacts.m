%% fef
% fname = '/home/joschu/Proj/code/grasping/blend/brain.obj';
% fname = '/home/joschu/Data/grasping/obj/m161.obj';
wobj = read_wobj(fname);
[verts_v3,faces_f3,normals_f3] = wobj_verts_faces(wobj);
[~,cents_f3,~] = get_contact_wrenches3d(verts_v3,faces_f3,normals_f3);

%% fef
VTK = vtkinit();
vtkplotmesh(gcvtk, verts_v3, faces_f3, 'representation','surface','opacity',.5,'backgroundColor',[1 1 1])

pointSize = (max(verts_v3(:,1))-min(verts_v3(:,1)))/150;
vtkplotpoints(gcvtk, cents_f3(1:size(faces_f3,1),:),'pointSize',pointSize,'color',[0 0   1 0.6]);

%%
lengths1 = norms(verts_v3(faces_f3(:,1),:) - verts_v3(faces_f3(:,2),:),2,2);
lengths2 = norms(verts_v3(faces_f3(:,1),:) - verts_v3(faces_f3(:,3),:),2,2);
lengths3 = norms(verts_v3(faces_f3(:,2),:) - verts_v3(faces_f3(:,3),:),2,2);
lengths = [lengths1;lengths2;lengths3];
R = quantile(lengths,1)/(2*sqrt(3));

%%

goodinds = [];
badinds = [];
for ind = 1:size(faces_f3,1);
    if finger_intersection_check(verts_v3,cents_f3(ind,:)+1.2*R*normals_f3(ind,:),R,+normals_f3(ind,:))
        goodinds = [goodinds,ind];
    else
        badinds = [badinds,ind];
    end
end
fprintf('%i good inds, %i bad inds\n',numel(goodinds),numel(badinds))



%%
inds = goodinds
K = numel(inds);
linepts = zeros(2*K,3);
for i=1:K
   linepts(2*i-1,:) = cents_f3(inds(i),:);
   linepts(2*i,:) = linepts(2*i-1,:) + normals_f3(inds(i),:)*pointSize*8;
end
vtkplotlines(gcvtk, linepts,(1:2:2*K)','lineWidth',3.5,'color',[1 0   0 1])
% for i=1:n_contacts
%     pt = cents_f3(inds(i),:);
%     vtkannotate(pt,num2str(i),'textFontSize',20)
% end


inds = badinds
K = numel(inds);
linepts = zeros(2*K,3);
for i=1:K
   linepts(2*i-1,:) = cents_f3(inds(i),:);
   linepts(2*i,:) = linepts(2*i-1,:) + normals_f3(inds(i),:)*pointSize*8;
end
vtkplotlines(gcvtk, linepts,(1:2:2*K)','lineWidth',3.5,'color',[0 1   0 1])