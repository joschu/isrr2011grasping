function [faces_f3,verts_v3,labels_v,normals_f3] = load_organ(name)
wobj = read_wobj(['~/Data/Organs/',name,'.poly.obj']);

[verts_v3,faces_f3,normals_f3] = wobj_verts_faces(wobj);
verts_v3 = verts_v3 + ptp(verts_v3(:))*randn(size(verts_v3))*.01;
labels_v = 1:size(verts_v3,1);

% labels_v(1:end/4) = 1;
% labels_v(end/4:end/2)=2;
% labels_v(end/2:3*end/4)=3;
% labels_v(3*end/4:end)=4;

labels_v(1:end) = 1;
end