function [faces,normals] = double_normals(faces,normals,inds)
faces = [faces(inds,:); faces];
normals = [-normals(inds,:); normals];
end