function talk_export_animation(wobj,inds,outfile,length,r,backup)
% write a file that tells blender parameters for animation
[verts_v3,faces_f3,normals_f3] = wobj_verts_faces(wobj);
[~,cents_f3,~] = get_contact_wrenches3d(verts_v3,faces_f3,normals_f3);

shape_center = (max(verts_v3) + min(verts_v3))/2

Mt = [1 0 0; 0 0 -1; 0 1 0]';
save_vars(outfile,'rays',normals_f3(inds,:)*Mt,'centers',cents_f3(inds,:)*Mt,'r',r,'backup',backup,'length',length,'all_centers',cents_f3*Mt,'shape_center',shape_center*Mt)

end