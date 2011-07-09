N = 19;
x_n3 = randn(N,3);
fprintf('inradius hull of of all points: %.2f\n',inradius_hull(x_n3));


%% conv hull: brute force
disp('finding best 4 contacts using brute force search')
combs = nchoosek(1:N,4);
ncombs = size(combs,1);
optvals = zeros(ncombs,1);
for icomb = 1:ncombs
   if mod(icomb,100)==0, fprintf('%i/%i\n',icomb,ncombs); end    
   x_43 = x_n3(combs(icomb,:),:);
   optvals(icomb) = inradius_hull(x_43);
end
r_hull_opt = max(optvals);
fprintf('optimal inradius for 4 contacts: %.2f\n',r_hull_opt)



%% conv hull: SATURATE
disp('now using saturate algorithm')
t_k3 = sphere_samples(10000);
dots_nk = x_n3 * t_k3';

[inds_hull_sat4,r_hull_sat4] = mysfo_saturate(@(inds) max(dots_nk(inds,:),[],1),1:N,4);
fprintf('inradius from saturate with 4 contacts: %.2f\n',r_hull_sat4)

[inds_hull_sat5,r_hull_sat5] = mysfo_saturate(@(inds) max(dots_nk(inds,:),[],1),1:N,5);
fprintf('inradius from saturate with 5 contacts: %.2f\n',r_hull_sat5)

[inds_hull_sat6,r_hull_sat6] = mysfo_saturate(@(inds) max(dots_nk(inds,:),[],1),1:N,7);
fprintf('inradius from saturate with 6 contacts: %.2f\n',r_hull_sat6)



%% minkowski: brute force
y_n3 = minkowski_sum(x_n3);
optvals = zeros(ncombs,1);
for icomb = 1:ncombs
   if mod(icomb,100)==0, fprintf('%i/%i\n',icomb,ncombs); end    
   x_43 = x_n3(combs(icomb,:),:);
   optvals(icomb) = inradius_minkowski_approx(x_43);
end
r_mink_opt = max(optvals);
fprintf('optimal inradius of minkowski sum for 4 contacts: %.2f\n',r_mink_opt)

%% minkowski: SATURATE
disp('now using saturate algorithm')
t_k3 = sphere_samples(10000);
dots_nk = x_n3 * t_k3';
pdots_nk = max(dots_nk,0);

[inds_mink_sat,r_mink_sat4] = mysfo_saturate(@(inds) sum(pdots_nk(inds,:),1),1:N,4);
fprintf('inradius from saturate with 4 contacts: %.2f\n',r_mink_sat4)

[inds_mink_sat,r_mink_sat5] = mysfo_saturate(@(inds) sum(pdots_nk(inds,:),1),1:N,5);
fprintf('inradius from saturate with 5 contacts: %.2f\n',r_mink_sat5)

[inds_mink_sat,r_mink_sat6] = mysfo_saturate(@(inds) sum(pdots_nk(inds,:),1),1:N,6);
fprintf('inradius from saturate with 6 contacts: %.2f\n',r_mink_sat6)
