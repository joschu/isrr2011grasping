function [bestinds,bestval] = mysfo_saturate_inc(fs,allinds,K,useinds)

minthresh = min(fs(1));
maxthresh = min(fs(allinds));
bestinds = [];
bestval = -inf;

for i = 1:10
   dprint('bounds [%.2f %.2f]\n',minthresh,maxthresh)
   trythresh = (minthresh+maxthresh)/2';
   dprint('trying %.2f\n',trythresh)
   f = @(inds) mean(min(fs(inds),trythresh));
   [inds,val] = mysfo_greedy_k_inc(f,allinds,K,useinds);
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

assert(numel(bestinds)==K || isempty(bestinds))

end