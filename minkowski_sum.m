function y_np = minkowski_sum(x_np)

[N,P] = size(x_np);
assert(N >= P+1);

bv = binvecs(P+1);
Q = size(bv,1);
pts = bv * x_np(1:(P+1),:);

inds = unique(convhulln(pts));
y_np = pts(inds,:);

for i=(P+2):N
    pts = [y_np; bsxfun(@plus, y_np, x_np(i,:))];
    inds = unique(convhulln(pts));
    y_np = pts(inds,:);
end

end