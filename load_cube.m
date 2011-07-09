function [faces_f3,verts_v3,labels_v] = load_cube

verts_v3 = double(binvecs(3));
verts_v3 = verts_v3 + randn(size(verts_v3))*.01;
faces_f3 = convhulln(verts_v3); 
labels_v = [1,1,2,2,3,3,4,4];

end
