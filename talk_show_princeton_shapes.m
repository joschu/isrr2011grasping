flip = [1 1 1 1 1]
models = {'shark','brain','cup','gun','plane'}
for i=1:5
    model = models{i};

    
    fname = sprintf('/home/joschu/Data/grasping/obj_fixed/%s.obj',model);
    
    wobj = read_wobj(fname);
    [verts_v3,faces_f3,normals_f3] = wobj_verts_faces(wobj);
    [wrenches_f6,cents_f3,] = get_contact_wrenches3d(verts_v3,faces_f3,normals_f3);
    normals_f3 = flip(i)*normals_f3;

    lengths1 = norms(verts_v3(faces_f3(:,1),:) - verts_v3(faces_f3(:,2),:),2,2);
    lengths2 = norms(verts_v3(faces_f3(:,1),:) - verts_v3(faces_f3(:,3),:),2,2);
    lengths3 = norms(verts_v3(faces_f3(:,2),:) - verts_v3(faces_f3(:,3),:),2,2);
    lengths = [lengths1;lengths2;lengths3];
    R = quantile(lengths,1)/(2*sqrt(3));
    goodinds = [];
    badinds = [];
    for ind = 1:size(faces_f3,1);
        if finger_intersection_check(verts_v3,cents_f3(ind,:)+1.2*R*normals_f3(ind,:),R,+normals_f3(ind,:))
            goodinds = [goodinds,ind];
        else
            badinds = [badinds,ind];
        end
    end
    fprintf('%i good inds, %i bad inds\n',numel(goodinds),numel(badinds))

    plot_normals3(verts_v3,faces_f3,normals_f3,cents_f3,random_subset(goodinds,200))
%     plot_normals3(verts_v3,faces_f3,normals_f3,cents_f3,1:size(normals_f3,1))
    vtksave(gcvtk,sprintf('/home/joschu/Proj/grasping/isrr_talk/princeton_%s.png',model))
end
