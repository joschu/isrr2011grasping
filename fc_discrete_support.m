function q = fc_discrete_support(y,G)
% maximize y'Gf subject to |Gf| <= 1
    [~,~,exitflag] = linprog([],[],[],G,y,0,[]);
    if exitflag == 1, q=1;
    elseif exitflag <0, q=max(max(y*G),0);
    else error('unrecognized exit flag');
    end
end