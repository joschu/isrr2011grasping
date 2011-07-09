function [faces_f3,verts_v3,labels_v] = load_snazzy_plane

verts_v3 = load('~/Data/plane/nodes');
faces_f3 = load('~/Data/plane/elems');

% labels_v(1:end/4) = 1;
% labels_v(end/4:end/2)=2;
% labels_v(end/2:3*end/4)=3;
% labels_v(3*end/4:end)=4;
labels_v = 1:size(verts_v3,1);
labels_v(1:end) = 1;
end
