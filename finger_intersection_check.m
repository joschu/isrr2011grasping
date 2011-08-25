function safe = finger_intersection_check(verts_n3,center_3,r,ray_3)
verts_n3 = bsxfun(@minus,verts_n3,center_3);
ray_3 = normr(ray_3);
rsquared_n = sum(verts_n3.^2,2);
verts_in_sphere = rsquared_n < r^2;

rayproj_n = verts_n3*ray_3';
verts_in_cyl = (rayproj_n > 0) & (rsquared_n - rayproj_n.^2 < r^2);

safe = ~any(verts_in_cyl | verts_in_sphere);

end