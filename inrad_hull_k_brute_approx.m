function [d,inds_p] = inrad_hull_k_brute_approx(x_np,K,c_p,t_kp)
% hullinds = unique(convhulln(x_np));
hullinds = 1:size(x_np,1);
x_np = x_np(hullinds,:);
[N,P] = size(x_np);

if nargin >= 3, x_np = bsxfun(@minus,x_np,c_p); end
combs = nchoosek(1:N,K);
ncombs = size(combs,1);
rs = zeros(ncombs,1);
for icomb = 1:ncombs
    if mod(icomb,100)==0, fprintf('%i/%i\n',icomb,ncombs); end
    inds = combs(icomb,:);
    rs(icomb) = inrad_hull_approx(x_np(inds,:),c_p,t_kp);
end
[d,i] = max(rs);
inds_p = hullinds(combs(i,:));