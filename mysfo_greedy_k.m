function [inds,optval] = mysfo_greedy_k(f,allinds,K)

inds=[];

for k=length(inds)+1:K
    outinds = setdiff(allinds,inds);
    fvals = arrayfun(@(i) f([inds i]),outinds);
    [optval,i] = max(fvals);
    inds = [inds outinds(i)];
end