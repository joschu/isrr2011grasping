function [Gn_3k,Gt_3k,conts_2k] = get_fric_wrenches(verts_2v,per_side,noise)

if nargin < 2, per_side = 5; end
if nargin < 3, noise = .1; end

center = mean(verts_2v,2);

conts_2k = get_side_contacts(verts_2v,per_side);

wverts = wraparound(verts_2v);
sides_2v = wverts(:,1:end-1)-wverts(:,2:end);

fsides_2v = normc(perp(sides_2v));
ffric_2v = normc(sides_2v);
fconts_2k = repeatcols(fsides_2v,per_side);
ffric_2k = repeatcols(ffric_2v,per_side);

K = size(fconts_2k,2);

fconts_2k = normc(fconts_2k + randn(size(fconts_2k))*noise);
ffric_2k = normc(ffric_2k + randn(size(ffric_2k))*noise);

rs_2k = bsxfun(@minus, conts_2k,center);

normtorques_k = sum(perp(rs_2k) .* fconts_2k, 1);
frictorques_k = sum(perp(rs_2k) .* ffric_2k, 1);

Gn_3k = [fconts_2k; normtorques_k];
Gt_3k = [ffric_2k; frictorques_k];

end

function out = wraparound(x)
out = [x, x(:,1)];
end

function out = perp(x)
out = [x(2,:); -x(1,:)];
end

function out = repeatcols(x,k)
n = size(x,2);
indmat = repmat(1:n,k,1);
indvec = indmat(:);
out = x(:,indvec);
end