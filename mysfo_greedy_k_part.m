function [inds,optval] = mysfo_greedy_k_part(f,N,parts,sels,goodinds,badinds)


if nargin == 4
    goodinds = [];
    badinds = [];
end


K = sum(sels);
inds = goodinds;

if length(goodinds) == K
    optval = f(inds);
else

    part_inds = zeros(1,N,'int16');
    for i_part = 1:length(parts)
        part_inds(parts{i_part}) = i_part;
    end

    for k=length(goodinds)+1:K
        allinds = [parts{sels > 0}];
        outinds = setdiff(allinds,[inds,badinds]);
        fvals = arrayfun(@(i) f([inds i]),outinds);
        [optval,i_tmp] = max(fvals);
        i = outinds(i_tmp);
        inds = [inds i];   
        sels(part_inds(i)) = sels(part_inds(i))-1;

    end
end