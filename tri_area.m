function out = tri_area(a,b,c)
out = .5 * norm(cross(a-b,a-c));
end