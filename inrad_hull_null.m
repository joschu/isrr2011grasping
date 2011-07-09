function [r,inds_p,y_kp] = inrad_hull_null(x_np,c_p)
[N,P] = size(x_np);
if nargin >= 2, x_np = bsxfun(@minus,x_np,c_p); end

    
i_kp = convhulln(x_np);
K = size(i_kp,1);



% now let's check if the origin lies inside the convex hull. if not, then
% we're done
% pts_kpp = cell2mat(reshape(pts_p,1,1,P));
% dets_k = arrayfun(@(k) det(squeeze(pts_kpp(k,:,:))),1:K);


if min(norms(x_np,2,2)) == 0 || any(unique(convhulln([x_np; zeros(1,P)]))==N+1) % origin not in convex hull 
    r = 0;
    inds_p = zeros(1,P);
    y_kp = [];
    return
end

d_k = inf(1,K);
for k=1:K
    verts_pp = x_np(i_kp(k,:),:);
    diffs_rp = diff(verts_pp);
    proj = null(diffs_rp);
    if size(proj,2)==1, d_k(k) = verts_pp(1,:)*proj; end
end

[r,i] = min(abs(d_k));
inds_p = i_kp(i,:);

assert(r>0);

end

function out_n = rowdot(x_np,y_np)
out_n = sum(x_np .* y_np, 2);
end

function y_np = projout(x_np,u_np)
% project x_np onto unit vectors u_np, then subtract them out
P = size(x_np,2);
proj_n = rowdot(x_np,u_np);
y_np = x_np - proj_n(:,ones(1,P)) .* u_np;
end