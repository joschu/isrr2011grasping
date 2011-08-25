function plot_normals2(verts_v3,faces_f3,normals_f3,chosen_inds)



inds = 1:size(faces_f3,1);

[~,cents_f3,~] = get_contact_wrenches3d(verts_v3,faces_f3,normals_f3);

% vtkdestroy;
VTK = vtkinit()
vtkplotmesh(gcvtk, verts_v3, faces_f3, 'representation','surface','opacity',.75,'backgroundColor',[1 1 1])

pointSize = (max(verts_v3(:,1))-min(verts_v3(:,1)))/75;

vtkplotpoints(gcvtk, cents_f3(inds,:),'pointSize',pointSize,'color',[0 0   1 0.6]);

K = numel(chosen_inds);
linepts = zeros(2*K,3);
for i=1:K
   linepts(2*i-1,:) = cents_f3(chosen_inds(i),:);
   linepts(2*i,:) = linepts(2*i-1,:) + normals_f3(chosen_inds(i),:)*pointSize*8;
end
% vtkplotlines(gcvtk, linepts,(1:2:2*K)','lineWidth',5,'color',[1 0   0 0.6])
vtkplotpoints(gcvtk, cents_f3(chosen_inds,:),'pointSize',pointSize*3,'color',[1 0   0 0.6]);

% for i=1:K
%     pt = cents_f3(chosen_inds(i),:);
%     vtkannotate(pt,num2str(i),'textFontSize',20)
% end
end