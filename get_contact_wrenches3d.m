function [wrenches_f6,cents_f3,forces_f3] = get_contact_wrenches3d(verts_v3,faces_f3,normals_f3)

pts_3 = arrayfun(@(p) verts_v3(faces_f3(:,p),:), 1:3, 'UniformOutput', false);
cents_f3 = (pts_3{1} + pts_3{2} + pts_3{3})/3;
rads_f3 = bsxfun(@minus,cents_f3,mean(cents_f3,1)); % estimate center of mass using faces

if nargin < 3
    disp('guessing normals')
    forces_f3 = normr(cross(pts_3{1} - pts_3{2}, pts_3{1} - pts_3{3}));
    dots_f = sum(forces_f3 .* rads_f3,2);
    forces_f3 = bsxfun(@times,forces_f3,-sign(dots_f));
else
    disp('not guessing normals')
    forces_f3 = normr(normals_f3);
end




torques_f3 = cross(rads_f3, forces_f3);
wrenches_f6 = [forces_f3,torques_f3];