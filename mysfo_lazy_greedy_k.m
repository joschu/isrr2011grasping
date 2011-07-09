function [inds,optval] = mysfo_lazy_greedy_k(f,allinds,K)

inds = [];

old_imp = inf(1,length(allinds));
isused = zeros(1,length(allinds),'uint8');

v_prev = -inf;

notskipped =0;
skipped = 0;

for k=1:K
        
    fvals = -inf(size(allinds));
    
    imp_best = -inf;
    [~,sortinds] = sort(old_imp,'ascend');
    for i=allinds(sortinds)
        if old_imp(i) >= imp_best && ~isused(i)
            v =  f([inds i]);
            fvals(i) = v;
            imp = v-v_prev;
            old_imp(i) = imp;
            imp_best = max(imp,imp_best);
            notskipped = notskipped+1;
        else
            skipped = skipped+1;
        end
    end
    
    [v_prev,i_best] = max(fvals);
    inds = [inds i_best];
    isused(i_best) = 1;
end

fprintf('%i notskipped, %i skipped\n',notskipped,skipped)

optval = v_prev;