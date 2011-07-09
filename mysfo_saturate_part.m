function [bestinds,bestval] = mysfo_saturate_part(fs,N,parts,sels,goodinds,badinds)

if nargin == 4
    goodinds = [];
    badinds = [];
end
    
K = sum(sels);
minthresh = min(fs(1));
maxthresh = min(fs(1:N));
bestinds = [];
bestval = -inf;

for i = 1:10
   dprint('bounds [%.2f %.2f]\n',minthresh,maxthresh)
   trythresh = (minthresh+maxthresh)/2';
   dprint('trying %.2f\n',trythresh)
   f = @(inds) mean(min(fs(inds),trythresh));
   [inds,val] = mysfo_greedy_k_part(f,N,parts,sels,goodinds,badinds);
   minf_result = min(fs(inds));
   if all( minf_result > trythresh)
       dprint('succeeded\n')
       minthresh = trythresh;
       bestinds = inds;
       bestval = minf_result;
   else
       dprint('failed: %.6f < %.6f\n',minf_result,trythresh)
       maxthresh = trythresh;
   end
end

% assert(numel(bestinds)==K || isempty(bestinds))
if numel(bestinds) < K
    bestinds = []
    bestval = -inf
    % This should not happen! Check partitioning
end

end