function out = tri_area2(a,b,c)
out = .5 * norms(cross(a-b,a-c),2,2);
end