function [d,inds] = inradius_minkowski(pts_n3)
[d,inds] = inradius_hull(minkowski_sum(pts_n3));
end