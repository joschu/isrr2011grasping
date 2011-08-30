%%

current_object_info
% fname, desc


wobj = read_wobj(fname);
[verts_v3,faces_f3,normals_f3] = wobj_verts_faces(wobj);
[wrenches_f6,cents_f3,] = get_contact_wrenches3d(verts_v3,faces_f3,normals_f3);

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


%%
K = 20
areas = tri_area2(verts_v3(faces_f3(:,1),:),verts_v3(faces_f3(:,2),:),verts_v3(faces_f3(:,3),:))
% areas(badinds) = -inf
% [~,sortinds] = sort(areas)
cand_inds = random_subset(goodinds,100);
% cand_inds = sortinds(end-100:end);

cents_3f = cents_f3';
wrenches_6f = wrenches_f6';
wrenches1_6f = bsxfun(@plus,wrenches_6f,[0,0,0,0,0,0]');
[A_66,c_6] = min_vol_ellips(wrenches1_6f(:,cand_inds));
G_6f = A_66 * wrenches_6f;
t_k6 = sphere_samples(10000,6);

[r,opt_inds] = inrad_mink_k_sat(G_6f(:,cand_inds)',K,c_6',t_k6);
talk_check_vtk

%%
talk_export_animation(wobj,cand_inds(opt_inds),sprintf('blend/%s_info.txt',desc),1,.01,1)