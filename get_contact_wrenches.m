function [wrenches_3k,conts_2k] = get_contact_wrenches(verts_2v,per_side,noise)

if nargin < 2, per_side = 5; end
if nargin < 3, noise = .1; end

center = mean(verts_2v,2);

conts_2k = get_side_contacts(verts_2v,per_side);

wverts = wraparound(verts_2v);
sides_2v = wverts(:,1:end-1)-wverts(:,2:end);

fsides_2v = normc(perp(sides_2v));
fconts_2k = repeatcols(fsides_2v,per_side);

fconts_2k = normc(fconts_2k + randn(size(fconts_2k))*noise);
rs_2k = bsxfun(@minus, conts_2k,center);

torques_k = sum(perp(rs_2k) .* fconts_2k, 1);
wrenches_3k = [fconts_2k;torques_k];

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