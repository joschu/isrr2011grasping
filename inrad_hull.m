function [r,inds_p,y_kp] = inrad_hull(x_np,c_p)
[N,P] = size(x_np);
if nargin >= 2, x_np = bsxfun(@minus,x_np,c_p); end

    
i_kp = convhulln(x_np);
K = size(i_kp,1);

% each cell o is an array, containing the pth vertex of each facet
pts_p = arrayfun(@(p) x_np(i_kp(:,p),:), 1:P,'UniformOutput',false);


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



% difference vectors from first vertex to others
diffs_p = arrayfun(@(p) pts_p{1}-pts_p{p}, 2:P,'UniformOutput',false);

y_kp = pts_p{1};

for p=1:P-1
    for q = 1:p-1
        diffs_p{p} = projout(diffs_p{p},diffs_p{q});
    end
    diffs_p{p} = normr(diffs_p{p});
    
    y_kp = projout(y_kp,diffs_p{p});
end

y_kp = normr(y_kp);

% now we calculate the distance to each face by dotting the normal with the
% first vertex
d_n = abs(rowdot(pts_p{1},y_kp));

[r,i] = min(d_n);
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