function [h,fn,ft] = fc_support_fast(y,Gn,Gt,Mu)
% Gt: tangential force -> object wrench
% Gn: normal force -> object wrench
y = vec(y);
h = max(y'*Gn + norm(y'*Gt*Mu),0);
end