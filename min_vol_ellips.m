function [A_pp,b_p] = min_vol_ellips(x_pn)
x_pn = hullpts(x_pn')';
[P,N] = size(x_pn)
cvx_begin
    variable A_pp(P,P)
    variable b_p(P)
    minimize( det_inv(A_pp)) 
    subject to 
        norms(A_pp * x_pn-b_p*ones(1,N),2,1) <= 1
cvx_end

end