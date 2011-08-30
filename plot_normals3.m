
function plot_normals3(verts_v3,faces_f3,normals_f3,cents_f3,inds)

% load vertex data

% calculate normals and get wrench matrix
% coordinate transformation
% subsample to get candidate grasp points
% use brute force search on severely subsampled points to get best solution
% in hull case
% use saturate


% vtkdestroy;
VTK = vtkinit()
vtkplotmesh(gcvtk, verts_v3, faces_f3, 'representation','surface','opacity',1,'backgroundColor',[1 1 1])

pointSize = (max(verts_v3(:,1))-min(verts_v3(:,1)))/75;

vtkplotpoints(gcvtk, cents_f3(inds,:),'pointSize',pointSize,'color',[0 0   1 0.6]);

K = numel(inds);
linepts = zeros(2*K,3);
for i=1:K
   linepts(2*i-1,:) = cents_f3(inds(i),:);
   linepts(2*i,:) = linepts(2*i-1,:) + normals_f3(inds(i),:)*pointSize*8;
end
vtkplotlines(gcvtk, linepts,(1:2:2*K)','lineWidth',3.5,'color',[0 0   1 0.6])
% for i=1:n_contacts
%     pt = cents_f3(inds(i),:);
%     vtkannotate(pt,num2str(i),'textFontSize',20)
% end
end
