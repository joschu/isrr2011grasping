function [r_best,inds_k,tree] = inrad_bb1(x_np,K,c_p,t_kp,Q,usekmeans,baseheur)

    if nargin < 6, usekmeans = 1; end
    if nargin < 7, baseheur = 'sat'; end
       

%     assert(strcmp(Q,'hull') || strcmp(Q,'mink'))
    assert(strcmp(Q,'mink'))
    
    N = size(x_np,1);
    
    [lb_best,lbinds] = inrad_mink_lb(x_np,K,c_p,t_kp,{1:N},K,[],[],baseheur);
    [ub,ubinds] = inrad_mink_ub(x_np,K,c_p,t_kp,{1:N},K,[],[]);
    badinds = find(ubinds==0);
    goodinds = find(ubinds==1);
    tree = struct('parts',{{1:N}},'sels',K,'lb',lb_best,'ub',ub,...
        'lbinds',lbinds,'ubinds',ubinds,'parent',0,'active',1,...
        'goodinds',goodinds,'badinds',badinds,'code',-1*ones(1,N,'int8'));
    
    
    skipped=0; notskipped = 0;
    while true
        inds_active = find([tree.active]==1);
        if isempty(inds_active), break; end
        
        i_expand = inds_active(1);
        tree(i_expand).active = 0;
        
        node = tree(i_expand);
        
        if node.ub - lb_best < .01
            skipped = skipped + 1;
            disp('no point in expanding node')
            tree(i_expand).active = -1;            
        else
            notskipped = notskipped+1;
            node = tree(i_expand);
            
            maybeinds = find(node.code==-1);
            n_branches = length(maybeinds);
            
            for i_branch = 1:n_branches
                    
                m = maybeinds(i_branch);
                newcode = node.code;
                newcode(m) = 1;
                newcode(maybeinds(1:i_branch-1)) = 0;
                oldgoodinds = find(newcode==1);
                oldbadinds = find(newcode==0);

                [ub,ubinds] = inrad_mink_ub(x_np,K,c_p,t_kp,{1:N},K,oldgoodinds,oldbadinds);
                if ub>0
                    badinds = find(abs(ubinds-0)<.01);
                    goodinds = find(abs(ubinds-1)<.01);
                    newcode(badinds) = 0;
                    newcode(goodinds) = 1;
    %                         if all(ubinds == 0 | ubinds == 1)
    %                             lbinds = ubinds;
    %                             lb = ub;
    %                         else
    %                             [lb,lbinds] = inrad_mink_lb(x_np,K,c_p,t_kp,newparts,newsels,goodinds,badinds);
    %                         end
    %                         if length(tree) == 11
    %                             1
    %                         end
                    [lb,lbinds] = inrad_mink_lb(x_np,K,c_p,t_kp,{1:N},K,goodinds,badinds,baseheur);




                    lb_best = max(lb_best,lb);

                    tree(end+1) = struct('parts',[],'sels',[],...
                        'lb',lb,'ub',ub,'lbinds',lbinds,'ubinds',ubinds,'parent',...
                        i_expand,'active',1,'goodinds',goodinds,'badinds',badinds,'code',newcode);
                    fprintf('tree size: %i. active: %i\n',length(tree),length(inds_active))
                end
            end
        end
        
        
        
        
    end
    
    % fields: partition sizes, selection sizes, lower, upper, parent
    [r_best,i_best] = max([tree.lb]);
    inds_k = tree(i_best).lbinds;
    
end


function [r,inds] = inrad_mink_lb(x_np,K,c_p,t_kp,parts,sels,goodinds,badinds,baseheur)

    if strcmp(baseheur,'sat')
        dots_nk = x_np * t_kp';
        pdots_nk = max(dots_nk,0);
        cdots_k = c_p * t_kp'; 
        N = size(x_np,1);
        [inds,r] = mysfo_saturate_part(@(inds) sum(pdots_nk(inds,:),1)-cdots_k,N,parts,sels,goodinds,badinds);
    else
        [r,inds] = inrad_heuristic_part(x_np,K,c_p,t_kp,'mink',baseheur,parts,sels,goodinds,badinds);
    end
    
end




function [val,weights] = inrad_mink_ub(x_np,K,c_p,t_kp,parts,sels,goodinds,badinds)
%     goodinds=[];
%     badinds=[];
    dots_nk = x_np * t_kp';  
    pdots_nk = max(dots_nk,0);
       cdots_k = c_p*t_kp';
    
    N = size(x_np,1);

    maybeinds = setdiff(1:N,[goodinds,badinds]);
    N1 = length(maybeinds);
    
    orig2maybe = zeros(1,N,'int16');
    orig2maybe(maybeinds) = 1:N1;
    parts1 = cellfun(@(part) orig2maybe(setdiff(part,[goodinds,badinds])), parts,'UniformOutput',false);
    sels1 = sels-cellfun(@(part) length(intersect(part,goodinds)), parts);
    
    
    
    if isempty(maybeinds)
        weights = zeros(1,N);
        weights(goodinds) = 1;
        val = min(weights*pdots_nk-cdots_k);
        return
    end
    
    good_support = sum(pdots_nk(goodinds,:),1);
    
    cvx_begin quiet

    variable w_n(1,N1)

    maximize( min(w_n * pdots_nk(maybeinds,:)+good_support - cdots_k) )

    subject to
    w_n >= 0;
    w_n <= 1;
    for i_part = 1:length(parts)
        sum(w_n(parts1{i_part})) == sels1(i_part);
    end
    cvx_end
    
    if isinf(cvx_optval)
        weights=[]
        val = -inf
    else
        weights = zeros(1,N);
        weights(maybeinds) = w_n;
        weights(goodinds) = 1;
        val = min(weights * pdots_nk - cdots_k);
    end

end