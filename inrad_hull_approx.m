function [r,k,err] = inrad_hull_approx(pts_np,c_p,t_kp)
pts_np = bsxfun(@minus,pts_np,c_p);
dots_nk = pts_np*t_kp';
[r,k] = min(max(dots_nk,[],1));

if nargout > 2
    [K,P] = size(t_kp);
    m = (K/(2*P))^(1/(P-1)); % grid resolution
    [~,n] = max(dots_nk(:,k));
    normv = norm(pts_np(n,:));
    a = acos(r/normv);
    err = normv * sin(a) * sqrt(P)/m;
end

end