function y = random_subset(x,k)
n = length(x);
p = randperm(n);
sp = sort(p(1:k));
y = x(sp);
end