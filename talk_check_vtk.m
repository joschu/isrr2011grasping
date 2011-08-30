%% fef
VTK = vtkinit();
vtkplotmesh(gcvtk, verts_v3, faces_f3, 'representation','surface','opacity',.5,'backgroundColor',[1 1 1])

pointSize = (max(verts_v3(:,1))-min(verts_v3(:,1)))/150;
vtkplotpoints(gcvtk, cents_f3(cand_inds,:),'pointSize',pointSize,'color',[0 0   1 0.6]);

plot_inds = cand_inds(opt_inds);
K = numel(plot_inds);
linepts = zeros(2*K,3);
for i=1:K
   linepts(2*i-1,:) = cents_f3(plot_inds(i),:);
   linepts(2*i,:) = linepts(2*i-1,:) + normals_f3(plot_inds(i),:)*pointSize*8;
end
vtkplotlines(gcvtk, linepts,(1:2:2*K)','lineWidth',3.5,'color',[0 0 0 1])
% for i=1:n_contacts
%     pt = cents_f3(inds(i),:);
%     vtkannotate(pt,num2str(i),'textFontSize',20)
% end