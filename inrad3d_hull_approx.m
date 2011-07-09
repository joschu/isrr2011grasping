function [d,t] = inradius_approx(pts_n3)
% t_k3 = sphere_samples(10000);
t_k3 = normr(randn(10000,3));
dots_nk = pts_n3*t_k3';
[d,i] = min(max(dots_nk));
t = t_k3(i,:);
end