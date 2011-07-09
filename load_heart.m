function [faces_f3,verts_v3,labels_v] = load_heart
mat = load('~/lib/matVTK1.0/matlab/data/faceVertex.mat');
faces_f3 = double(mat.T);
vz = max(mat.P(:,3));
verts_v3 = double([mat.P(:,2) mat.P(:,1) vz-mat.P(:,3)]);

numVerts = size(verts_v3,1 );
labels_v = 1:numVerts;
labels_v(1:500) = 1;
labels_v(501:1000) = 2;
labels_v(1001:1500) = 3;
labels_v(1501:2000) = 4;

end