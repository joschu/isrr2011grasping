function [inds,optval] = mysfo_greedy_k_inc(f,allinds,K,useinds)

inds = useinds;

if numel(inds) == K
    optval = f(inds);
end

for k=length(inds)+1:K
    outinds = setdiff(allinds,inds);
    fvals = arrayfun(@(i) f([inds i]),outinds);
    [optval,i] = max(fvals);
    inds = [inds outinds(i)];
end