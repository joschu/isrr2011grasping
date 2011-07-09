function [r,t] = inrad3d_approx(pts_n3,n_samples)
if nargin < 2, n_samples = 10000; end
t_k3 = sphere_samples(n_samples);
dots_nk = pts_n3*t_k3';
[r,i] = min(max(dots_nk));
t = t_k3(i,:);
end