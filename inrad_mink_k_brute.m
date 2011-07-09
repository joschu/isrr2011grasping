function [d,inds_p] = inrad_mink_k_brute(x_np,K,c_p,t_qp)
[N,P] = size(x_np);
combs = nchoosek(1:N,K);
ncombs = size(combs,1);
rs = zeros(ncombs,1);
for icomb = 1:ncombs
    if mod(icomb,100)==0, fprintf('%i/%i\n',icomb,ncombs); end
    inds = combs(icomb,:);
    rs(icomb) = inrad_mink_approx(x_np(inds,:),c_p,t_qp);
end
[d,i] = max(rs);
inds_p = combs(i,:);