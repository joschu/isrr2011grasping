function assert_almost_equal(x,y,tol)
% function assert_almost_equal(x,y,tol)
% tol is optional
if nargin < 3, tol = 1e-5; end
bools =abs(x - y) < tol;
assert(all(bools(:)))
end