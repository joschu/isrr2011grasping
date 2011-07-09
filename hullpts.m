function y_mp = hullpts(x_np)
facets = convhulln(x_np);
inds = unique(facets);
y_mp = x_np(inds,:);
end