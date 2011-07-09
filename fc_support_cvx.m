function [cvx_optval,fn,ft] = fc_support_cvx(y,Gn,Gt,Mu)
% Gt: tangential force -> object wrench
% Gn: normal force -> object wrench
y = vec(y);
k = size(Gt,2); % # frictional components
A = inv(Mu);

cvx_begin
variable ft(k)
variable fn(1)
maximize(y' * [Gt Gn] * [ft; fn])
subject to 
fn >= 0
fn <= 1
norm(A * ft) <= fn
cvx_end

end