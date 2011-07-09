function [d,ijk] = inrad3d_hull(pts_n3)
n = size(pts_n3,1);
i_n3 = convhulln(pts_n3);
pts1 = pts_n3(i_n3(:,1),:);
pts2 = pts_n3(i_n3(:,2),:);
pts3 = pts_n3(i_n3(:,3),:);
normals = normr(cross(pts2-pts1,pts3-pts1));

% ctrs = (pts1+pts2+pts3)/3;

% dots1 = sum(pts1 .* (pts1 - ctrs),2);
% dots2 = sum(pts2 .* (pts2 - ctrs),2);
% dots3 = sum(pts3 .* (pts3 - ctrs),2);
% 
% facing = (dots1 > 0) & (dots2 > 0) & (dots3 > 0);

d_n = sum(normals .* pts1, 2);
d_n = d_n*sign(d_n(1));


if all(d_n > 0)
%     d_n(~facing) = inf;
   [d,i] = min(d_n);
   ijk = i_n3(i,:);       

else
   d = 0;
   ijk = [0,0,0];
end
