function paper_run_alg(modelnum,alg,K,runstr,force)
if nargin < 5, force=0; end


objdir = '/home/joschu/Data/grasping/obj'
outdir = sprintf('/home/joschu/Data/grasping/results%s',runstr)
if ~exist(outdir,'dir'), mkdir(outdir); end
objfname = sprintf('%s/m%i.obj',objdir,modelnum)
% c = clock;
% outname = sprintf('%s/m%i_%i_sat_%i-%i-%i-%i.mat',outdir,modelnum,K,c(3),c(4),c(5),floor(c(6)))
outname = sprintf('%s/m%i_%i_%s.mat',outdir,modelnum,K,alg);

if exist(outname,'file') && ~force, 
disp('already did it--skipping')
return
end


N = 100; % candidate contacts


wobj = read_wobj(objfname);
[verts_v3,faces_f3,normals_f3] = wobj_verts_faces(wobj);
Ftotal = size(faces_f3,1);
face_areas = arrayfun(...
    @(f) tri_area(verts_v3(faces_f3(f,1),:), ...
                  verts_v3(faces_f3(f,2),:), ...
                  verts_v3(faces_f3(f,3),:)), ...
                  1:length(faces_f3));
              
% [~,inds_sorted_area] = sort(face_areas)
% inds_big_area = inds_sorted_area(.5*end:end);
% cand_inds = random_subset(inds_big_area,N);
seedrng
cand_inds = random_subset(1:Ftotal,N);



[wrenches_f6,cents_f3] = get_contact_wrenches3d(verts_v3,faces_f3(cand_inds,:),normals_f3(cand_inds,:));
cents_3f = cents_f3';
wrenches_6f = wrenches_f6';
[A_66,c_6] = min_vol_ellips(wrenches_6f);
G_6f = A_66 * wrenches_6f;
t_k6 = sphere_samples(10000,6);

tic

switch alg
    case 'sat'
        [r,inds] = inrad_mink_k_sat(G_6f',K,c_6',t_k6);
    case 'bb'
        [r,inds] = inrad_bb(G_6f',K,c_6',t_k6,'mink');
    case 'bb1'
        [r,inds] = inrad_bb1(G_6f',K,c_6',t_k6,'mink');        
    case 'rand'
        [r,inds] = inrad_heuristic(G_6f',K,c_6',t_k6,'mink','rand');
    case 'unif'
        [r,inds] = inrad_heuristic(G_6f',K,c_6',t_k6,'mink','unif');
    otherwise
        error('nonsense alg')
end

t_elapsed = toc;
chosen_inds = cand_inds(inds);

save(outname,'t_elapsed','r','cand_inds','chosen_inds','inds','N','K','objfname')

end