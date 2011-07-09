function [verts_v3, faces_f3,normals_f3] = wobj_verts_faces(wobj)
verts_v3 = wobj.vertices(:,1:3);
faces_f3 = zeros(0,3);
norm_f3 = zeros(0,3);
for obj = wobj.objects
    if same(obj.type,'f')
        faces_f3 = [faces_f3; obj.data.vertices];
        norm_f3 = [norm_f3; obj.data.normal];
    end
end

vnormals = wobj.vertices_normal;
normals_f3 = normr(...
    vnormals(norm_f3(:,1),:)+...
    vnormals(norm_f3(:,2),:)+...
    vnormals(norm_f3(:,3),:));

end